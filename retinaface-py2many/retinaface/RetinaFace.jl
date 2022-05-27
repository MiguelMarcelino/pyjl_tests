import logging
import warnings
filterwarnings("ignore")

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
import numpy as np
import tensorflow as tf
import cv2
using retinaface.model: retinaface_model
using retinaface.commons: preprocess, postprocess
tf_version = parse(Int, split(tf.__version__, ".")[1])
if tf_version == 2
    setLevel(get_logger(tf), logging.ERROR)
end
function build_model()
    global model
    if !("model" ∈ globals())
        model = function_(
            tf,
            build_model(),
            (TensorSpec(tf, [nothing, nothing, nothing, 3], np.float32),),
        )
    end
    return model
end

function get_image(img_path)
    if type_(img_path) == str
        if !isfile(os.path, img_path)
            throw(ValueError("Input image file path (", img_path, ") does not exist."))
        end
        img = imread(img_path)
    elseif isa(img_path, np.ndarray)
        img = copy(img_path)
    else
        throw(ValueError("Invalid image input. Only file paths or a NumPy array accepted."))
    end
    if length(img.shape) != 3 || prod(np, img.shape) == 0
        throw(ValueError("Input image needs to have 3 channels at must not be empty."))
    end
    return img
end

function detect_faces(
    img_path,
    threshold = 0.9,
    model = nothing,
    allow_upscaling = true,
)::Union[Union[Union[Tuple, Dict], Tuple], Dict]
    #= 
        TODO: add function doc here
         =#
    img = get_image(img_path)
    if model === nothing
        model = build_model()
    end
    nms_threshold = 0.4
    decay4 = 0.5
    _feat_stride_fpn = [32, 16, 8]
    _anchors_fpn = Dict(
        "stride32" => array(
            np,
            [[-248.0, -248.0, 263.0, 263.0], [-120.0, -120.0, 135.0, 135.0]],
            np.float32,
        ),
        "stride16" => array(
            np,
            [[-56.0, -56.0, 71.0, 71.0], [-24.0, -24.0, 39.0, 39.0]],
            np.float32,
        ),
        "stride8" =>
            array(np, [[-8.0, -8.0, 23.0, 23.0], [0.0, 0.0, 15.0, 15.0]], np.float32),
    )
    _num_anchors = Dict("stride32" => 2, "stride16" => 2, "stride8" => 2)
    proposals_list = []
    scores_list = []
    landmarks_list = []
    im_tensor, im_info, im_scale = preprocess_image(img, allow_upscaling)
    net_out = model(im_tensor)
    net_out = [numpy(elt) for elt in net_out]
    sym_idx = 0
    for (_idx, s) in enumerate(_feat_stride_fpn)
        _key = "stride%s" % s
        scores = net_out[sym_idx+1]
        scores =
            scores[(begin:end, begin:end, begin:end, _num_anchors["stride%s"%s]+1:end)+1]
        bbox_deltas = net_out[sym_idx+2]
        height, width = (bbox_deltas.shape[2], bbox_deltas.shape[3])
        A = _num_anchors["stride%s"%s]
        K = height * width
        anchors_fpn = _anchors_fpn["stride%s"%s]
        anchors = anchors_plane(height, width, s, anchors_fpn)
        anchors = reshape(anchors, (K * A, 4))
        scores = reshape(scores, (-1, 1))
        bbox_stds = [1.0, 1.0, 1.0, 1.0]
        bbox_deltas = bbox_deltas
        bbox_pred_len = bbox_deltas.shape[4] ÷ A
        bbox_deltas = reshape(bbox_deltas, (-1, bbox_pred_len))
        bbox_deltas[(begin:end, end:4:1)+1] =
            bbox_deltas[(begin:end, end:4:1)+1] * bbox_stds[1]
        bbox_deltas[(begin:end, end:4:2)+1] =
            bbox_deltas[(begin:end, end:4:2)+1] * bbox_stds[2]
        bbox_deltas[(begin:end, end:4:3)+1] =
            bbox_deltas[(begin:end, end:4:3)+1] * bbox_stds[3]
        bbox_deltas[(begin:end, end:4:4)+1] =
            bbox_deltas[(begin:end, end:4:4)+1] * bbox_stds[4]
        proposals = bbox_pred(anchors, bbox_deltas)
        proposals = clip_boxes(proposals, im_info[begin:2])
        if s == 4 && decay4 < 1.0
            scores *= decay4
        end
        scores_ravel = ravel(scores)
        order = where(np, scores_ravel >= threshold)[1]
        proposals = proposals[(order, begin:end)+1]
        scores = scores[order+1]
        proposals[(begin:end, 1:4)+1] /= im_scale
        push!(proposals_list, proposals)
        push!(scores_list, scores)
        landmark_deltas = net_out[sym_idx+3]
        landmark_pred_len = landmark_deltas.shape[4] ÷ A
        landmark_deltas = reshape(landmark_deltas, (-1, 5, landmark_pred_len ÷ 5))
        landmarks = landmark_pred(anchors, landmark_deltas)
        landmarks = landmarks[(order, begin:end)+1]
        landmarks[(begin:end, begin:end, 1:2)+1] /= im_scale
        push!(landmarks_list, landmarks)
        sym_idx += 3
    end
    proposals = vstack(np, proposals_list)
    if proposals.shape[1] == 0
        landmarks = zeros(np, (0, 5, 2))
        return (zeros(np, (0, 5)), landmarks)
    end
    scores = vstack(np, scores_list)
    scores_ravel = ravel(scores)
    order = argsort(scores_ravel)[end:-1:begin]
    proposals = proposals[(order, begin:end)+1]
    scores = scores[order+1]
    landmarks = vstack(np, landmarks_list)
    landmarks = astype(landmarks[order+1], np.float32, false)
    pre_det = astype(hstack(np, (proposals[(begin:end, 1:4)+1], scores)), np.float32, false)
    keep = cpu_nms(pre_det, nms_threshold)
    det = hstack(np, (pre_det, proposals[(begin:end, 5:end)+1]))
    det = det[(keep, begin:end)+1]
    landmarks = landmarks[keep+1]
    resp = Dict()
    for (idx, face) in enumerate(det)
        label = "face_" * string(idx + 1)
        resp[label] = Dict()
        resp[label]["score"] = face[5]
        resp[label]["facial_area"] = collect(astype(face[1:4], int))
        resp[label]["landmarks"] = Dict()
        resp[label]["landmarks"]["right_eye"] = collect(landmarks[idx+1][1])
        resp[label]["landmarks"]["left_eye"] = collect(landmarks[idx+1][2])
        resp[label]["landmarks"]["nose"] = collect(landmarks[idx+1][3])
        resp[label]["landmarks"]["mouth_right"] = collect(landmarks[idx+1][4])
        resp[label]["landmarks"]["mouth_left"] = collect(landmarks[idx+1][5])
    end
    return resp
end

function extract_faces(
    img_path,
    threshold = 0.9,
    model = nothing,
    align = true,
    allow_upscaling = true,
)::Vector
    resp = []
    img = get_image(img_path)
    obj = detect_faces()
    if type_(obj) == dict
        for key in obj
            identity = obj[key+1]
            facial_area = identity["facial_area"]
            facial_img =
                img[(facial_area[2]+1:facial_area[4], facial_area[1]+1:facial_area[3])+1]
            if align == true
                landmarks = identity["landmarks"]
                left_eye = landmarks["left_eye"]
                right_eye = landmarks["right_eye"]
                nose = landmarks["nose"]
                mouth_right = landmarks["mouth_right"]
                mouth_left = landmarks["mouth_left"]
                facial_img = alignment_procedure(facial_img, right_eye, left_eye, nose)
            end
            push!(resp, facial_img[(begin:end, begin:end, end:-1:begin)+1])
        end
    end
    return resp
end
