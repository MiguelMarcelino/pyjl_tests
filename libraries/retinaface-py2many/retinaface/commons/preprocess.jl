
import cv2
function resize_image(img, scales, allow_upscaling)
    img_h, img_w = img.shape[1:2]
    target_size = scales[1]
    max_size = scales[2]
    if img_w > img_h
        im_size_min, im_size_max = (img_h, img_w)
    else
        im_size_min, im_size_max = (img_w, img_h)
    end
    im_scale = target_size / float(im_size_min)
    if !(allow_upscaling)
        im_scale = min(1.0, im_scale)
    end
    if round(np, digits = im_scale * im_size_max) > max_size
        im_scale = max_size / float(im_size_max)
    end
    if im_scale != 1.0
        img = cv2.resize(
            img,
            nothing,
            nothing,
            fx = im_scale,
            fy = im_scale,
            interpolation = cv2.INTER_LINEAR,
        )
    end
    return (img, im_scale)
end

function preprocess_image(img, allow_upscaling)::Tuple
    pixel_means = Vector{Float64}([0.0, 0.0, 0.0])
    pixel_stds = Vector{Float64}([1.0, 1.0, 1.0])
    pixel_scale = float(1.0)
    scales = [1024, 1980]
    img, im_scale = resize_image(img, scales, allow_upscaling)
    img = astype(img, np.float32)
    im_tensor = zeros(np.float32, (1, img.shape[1], img.shape[2], img.shape[3]))
    for i = 0:2
        im_tensor[(0, begin:end, begin:end, i)+1] =
            ((img[(begin:end, begin:end, 2 - i)+1] / pixel_scale) - pixel_means[2-i+1]) /
            pixel_stds[2-i+1]
    end
    return (im_tensor, img.shape[1:2], im_scale)
end
