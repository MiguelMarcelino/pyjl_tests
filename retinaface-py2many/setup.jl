import setuptools
open("README.md", "r") do fh
    long_description = read(fh)
end
setup(
    "retina-face",
    "0.0.13",
    "Sefik Ilkin Serengil",
    "serengil@gmail.com",
    "RetinaFace: Deep Face Detection Framework in TensorFlow for Python",
    long_description,
    "text/markdown",
    "https://github.com/serengil/retinaface",
    find_packages(),
    [
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    ">=3.5.5",
    [
        "numpy>=1.14.0",
        "gdown>=3.10.1",
        "Pillow>=5.2.0",
        "opencv-python>=3.4.4",
        "tensorflow>=1.9.0",
    ],
)
