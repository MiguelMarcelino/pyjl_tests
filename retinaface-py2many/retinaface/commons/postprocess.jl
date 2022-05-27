import numpy as np
using PIL: Image

import cv2
function findEuclideanDistance(source_representation, test_representation)::Any
    euclidean_distance = source_representation - test_representation
    euclidean_distance = sum(np, multiply(np, euclidean_distance, euclidean_distance))
    euclidean_distance = sqrt(np, euclidean_distance)
    return euclidean_distance
end

function alignment_procedure(img, left_eye, right_eye, nose)
    left_eye_x, left_eye_y = left_eye
    right_eye_x, right_eye_y = right_eye
    center_eyes = (Int((left_eye_x + right_eye_x) / 2), Int((left_eye_y + right_eye_y) / 2))
    if false
        img = circle(
            img,
            (parse(Int, left_eye[1]), parse(Int, left_eye[2])),
            2,
            (0, 255, 255),
            2,
        )
        img = circle(
            img,
            (parse(Int, right_eye[1]), parse(Int, right_eye[2])),
            2,
            (255, 0, 0),
            2,
        )
        img = circle(img, center_eyes, 2, (0, 0, 255), 2)
        img = circle(img, (parse(Int, nose[1]), parse(Int, nose[2])), 2, (255, 255, 255), 2)
    end
    if left_eye_y > right_eye_y
        point_3rd = (right_eye_x, left_eye_y)
        direction = -1
    else
        point_3rd = (left_eye_x, right_eye_y)
        direction = 1
    end
    a = findEuclideanDistance(array(np, left_eye), array(np, point_3rd))
    b = findEuclideanDistance(array(np, right_eye), array(np, point_3rd))
    c = findEuclideanDistance(array(np, right_eye), array(np, left_eye))
    if b != 0 && c != 0
        cos_a = ((b * b + c * c) - a * a) / 2 * b * c
        cos_a = min(1.0, max(-1.0, cos_a))
        angle = arccos(np, cos_a)
        angle = angle * 180 / math.pi
        if direction === -1
            angle = 90 - angle
        end
        img = fromarray(img)
        img = array(np, rotate(img, direction * angle))
        if center_eyes[2] > nose[2]
            img = fromarray(img)
            img = array(np, rotate(img, 180))
        end
    end
    return img
end

function bbox_pred(boxes, box_deltas)
    if boxes.shape[1] == 0
        return zeros(np, (0, box_deltas.shape[2]))
    end
    boxes = astype(boxes, np.float64, false)
    widths = (boxes[(begin:end, 2)+1] - boxes[(begin:end, 0)+1]) + 1.0
    heights = (boxes[(begin:end, 3)+1] - boxes[(begin:end, 1)+1]) + 1.0
    ctr_x = boxes[(begin:end, 0)+1] + 0.5 * (widths - 1.0)
    ctr_y = boxes[(begin:end, 1)+1] + 0.5 * (heights - 1.0)
    dx = box_deltas[(begin:end, 1:1)+1]
    dy = box_deltas[(begin:end, 2:2)+1]
    dw = box_deltas[(begin:end, 3:3)+1]
    dh = box_deltas[(begin:end, 4:4)+1]
    pred_ctr_x = dx * widths[(begin:end, np.newaxis)+1] + ctr_x[(begin:end, np.newaxis)+1]
    pred_ctr_y = dy * heights[(begin:end, np.newaxis)+1] + ctr_y[(begin:end, np.newaxis)+1]
    pred_w = exp(np, dw) * widths[(begin:end, np.newaxis)+1]
    pred_h = exp(np, dh) * heights[(begin:end, np.newaxis)+1]
    pred_boxes = zeros(np, box_deltas.shape)
    pred_boxes[(begin:end, 1:1)+1] = pred_ctr_x - 0.5 * (pred_w - 1.0)
    pred_boxes[(begin:end, 2:2)+1] = pred_ctr_y - 0.5 * (pred_h - 1.0)
    pred_boxes[(begin:end, 3:3)+1] = pred_ctr_x + 0.5 * (pred_w - 1.0)
    pred_boxes[(begin:end, 4:4)+1] = pred_ctr_y + 0.5 * (pred_h - 1.0)
    if box_deltas.shape[2] > 4
        pred_boxes[(begin:end, 5:end)+1] = box_deltas[(begin:end, 5:end)+1]
    end
    return pred_boxes
end

function landmark_pred(boxes, landmark_deltas)
    if boxes.shape[1] == 0
        return zeros(np, (0, landmark_deltas.shape[2]))
    end
    boxes = astype(boxes, np.float, false)
    widths = (boxes[(begin:end, 2)+1] - boxes[(begin:end, 0)+1]) + 1.0
    heights = (boxes[(begin:end, 3)+1] - boxes[(begin:end, 1)+1]) + 1.0
    ctr_x = boxes[(begin:end, 0)+1] + 0.5 * (widths - 1.0)
    ctr_y = boxes[(begin:end, 1)+1] + 0.5 * (heights - 1.0)
    pred = copy(landmark_deltas)
    for i = 0:4
        pred[(begin:end, i, 0)+1] = landmark_deltas[(begin:end, i, 0)+1] * widths + ctr_x
        pred[(begin:end, i, 1)+1] = landmark_deltas[(begin:end, i, 1)+1] * heights + ctr_y
    end
    return pred
end

function clip_boxes(boxes, im_shape)
    boxes[(begin:end, end:4:1)+1] =
        maximum(np, minimum(np, boxes[(begin:end, end:4:1)+1], im_shape[2] - 1), 0)
    boxes[(begin:end, end:4:2)+1] =
        maximum(np, minimum(np, boxes[(begin:end, end:4:2)+1], im_shape[1] - 1), 0)
    boxes[(begin:end, end:4:3)+1] =
        maximum(np, minimum(np, boxes[(begin:end, end:4:3)+1], im_shape[2] - 1), 0)
    boxes[(begin:end, end:4:4)+1] =
        maximum(np, minimum(np, boxes[(begin:end, end:4:4)+1], im_shape[1] - 1), 0)
    return boxes
end

function anchors_plane(height, width, stride, base_anchors)::Any
    A = base_anchors.shape[1]
    c_0_2 = tile(
        np,
        arange(np, 0, width)[(np.newaxis, begin:end, np.newaxis, np.newaxis)+1],
        (height, 1, A, 1),
    )
    c_1_3 = tile(
        np,
        arange(np, 0, height)[(begin:end, np.newaxis, np.newaxis, np.newaxis)+1],
        (1, width, A, 1),
    )
    all_anchors =
        concatenate(np, [c_0_2, c_1_3, c_0_2, c_1_3], -1) * stride + tile(
            np,
            base_anchors[(np.newaxis, np.newaxis, begin:end, begin:end)+1],
            (height, width, 1, 1),
        )
    return all_anchors
end

function cpu_nms(dets, threshold)::Vector
    x1 = dets[(begin:end, 0)+1]
    y1 = dets[(begin:end, 1)+1]
    x2 = dets[(begin:end, 2)+1]
    y2 = dets[(begin:end, 3)+1]
    scores = dets[(begin:end, 4)+1]
    areas = ((x2 - x1) + 1) * ((y2 - y1) + 1)
    order = argsort(scores)[end:-1:begin]
    ndets = dets.shape[1]
    suppressed = zeros(np, ndets, parse(Int, np))
    keep = []
    for _i = 0:ndets-1
        i = order[_i+1]
        if suppressed[i+1] == 1
            continue
        end
        push!(keep, i)
        ix1 = x1[i+1]
        iy1 = y1[i+1]
        ix2 = x2[i+1]
        iy2 = y2[i+1]
        iarea = areas[i+1]
        for _j = _i+1:ndets-1
            j = order[_j+1]
            if suppressed[j+1] == 1
                continue
            end
            xx1 = max(ix1, x1[j+1])
            yy1 = max(iy1, y1[j+1])
            xx2 = min(ix2, x2[j+1])
            yy2 = min(iy2, y2[j+1])
            w = max(0.0, (xx2 - xx1) + 1)
            h = max(0.0, (yy2 - yy1) + 1)
            inter = w * h
            ovr = inter / ((iarea + areas[j+1]) - inter)
            if ovr >= threshold
                suppressed[j+1] = 1
            end
        end
    end
    return keep
end
