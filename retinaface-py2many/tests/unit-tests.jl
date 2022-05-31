using retinaface: RetinaFace
import matplotlib.pyplot as plt
import cv2
img_path = "dataset/img3.jpg"
img = cv2.imread(img_path)
resp = RetinaFace.detect_faces(img_path, threshold = 0.1)
function int_tuple(t)::Tuple
    return tuple((parse(Int, x) for x in t)...)
end

for key in resp
    identity = resp[key+1]
    confidence = identity["score"]
    rectangle_color = (255, 255, 255)
    landmarks = identity["landmarks"]
    diameter = 1
    cv2.circle(img, int_tuple(landmarks["left_eye"]), diameter, (0, 0, 255), -1)
    cv2.circle(img, int_tuple(landmarks["right_eye"]), diameter, (0, 0, 255), -1)
    cv2.circle(img, int_tuple(landmarks["nose"]), diameter, (0, 0, 255), -1)
    cv2.circle(img, int_tuple(landmarks["mouth_left"]), diameter, (0, 0, 255), -1)
    cv2.circle(img, int_tuple(landmarks["mouth_right"]), diameter, (0, 0, 255), -1)
    facial_area = identity["facial_area"]
    cv2.rectangle(
        img,
        (facial_area[3], facial_area[4]),
        (facial_area[1], facial_area[2]),
        rectangle_color,
        1,
    )
end
imshow(plt, img[(begin:end, begin:end, end:-1:begin)+1])
axis(plt, "off")
show(plt)
cv2.imwrite("outputs/" + split(img_path, "/")[2], img)
img_paths =
    ["dataset/img11.jpg", "dataset/img4.jpg", "dataset/img5.jpg", "dataset/img6.jpg"]
for img_path in img_paths
    resp = RetinaFace.extract_faces(img_path = img_path, align = true)
    for img in resp
        imshow(plt, img)
        axis(plt, "off")
        show(plt)
        cv2.imwrite(
            "outputs/" + split(img_path, "/")[2],
            img[(begin:end, begin:end, end:-1:begin)+1],
        )
    end
end
