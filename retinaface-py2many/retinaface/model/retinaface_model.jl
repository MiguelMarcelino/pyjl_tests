using keras.models: Model
using keras.layers:
    Input,
    BatchNormalization,
    ZeroPadding2D,
    Conv2D,
    ReLU,
    MaxPool2D,
    Add,
    UpSampling2D,
    concatenate,
    Softmax
using tensorflow.keras.models: Model
using tensorflow.keras.layers:
    Input,
    BatchNormalization,
    ZeroPadding2D,
    Conv2D,
    ReLU,
    MaxPool2D,
    Add,
    UpSampling2D,
    concatenate,
    Softmax
import tensorflow as tf
import gdown
using pathlib: Path

tf_version = parse(Int, split(tf.__version__, ".")[1])
if tf_version == 1
end
function load_weights(model)
    home = string(getenv("DEEPFACE_HOME", home()))
    exact_file = home * "/.deepface/weights/retinaface.h5"
    url = "https://github.com/serengil/deepface_models/releases/download/v1.0/retinaface.h5"
    if !ispath(home * "/.deepface")
        mkdir(home * "/.deepface")
        println("Directory $(home)/.deepface created")
    end
    if !ispath(home * "/.deepface/weights")
        mkdir(home * "/.deepface/weights")
        println("Directory $(home)/.deepface/weights created")
    end
    if isfile(os.path, exact_file) != true
        println("retinaface.h5 will be downloaded from the url $(url)")
        download(url, exact_file, false)
    end
    if isfile(os.path, exact_file) != true
        throw(
            ValueError(
                "Pre-trained weight could not be loaded!" *
                " You might try to download the pre-trained weights from the url " *
                url *
                " and copy it to the ",
                exact_file,
                "manually.",
            ),
        )
    end
    load_weights(model)
    return model
end

function build_model()
    data = Input(tf.float32, (nothing, nothing, 3), "data")
    bn_data = BatchNormalization(1.9999999494757503e-05, "bn_data", false)(data)
    conv0_pad = ZeroPadding2D(tuple([3, 3]))(bn_data)
    conv0 = Conv2D(64, (7, 7), "conv0", [2, 2], "VALID", false)(conv0_pad)
    bn0 = BatchNormalization(1.9999999494757503e-05, "bn0", false)(conv0)
    relu0 = ReLU("relu0")(bn0)
    pooling0_pad = ZeroPadding2D(tuple([1, 1]))(relu0)
    pooling0 = MaxPool2D((3, 3), (2, 2), "VALID", "pooling0")(pooling0_pad)
    stage1_unit1_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit1_bn1", false)(pooling0)
    stage1_unit1_relu1 = ReLU("stage1_unit1_relu1")(stage1_unit1_bn1)
    stage1_unit1_conv1 =
        Conv2D(64, (1, 1), "stage1_unit1_conv1", [1, 1], "VALID", false)(stage1_unit1_relu1)
    stage1_unit1_sc =
        Conv2D(256, (1, 1), "stage1_unit1_sc", [1, 1], "VALID", false)(stage1_unit1_relu1)
    stage1_unit1_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit1_bn2", false)(
            stage1_unit1_conv1,
        )
    stage1_unit1_relu2 = ReLU("stage1_unit1_relu2")(stage1_unit1_bn2)
    stage1_unit1_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage1_unit1_relu2)
    stage1_unit1_conv2 = Conv2D(64, (3, 3), "stage1_unit1_conv2", [1, 1], "VALID", false)(
        stage1_unit1_conv2_pad,
    )
    stage1_unit1_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit1_bn3", false)(
            stage1_unit1_conv2,
        )
    stage1_unit1_relu3 = ReLU("stage1_unit1_relu3")(stage1_unit1_bn3)
    stage1_unit1_conv3 = Conv2D(256, (1, 1), "stage1_unit1_conv3", [1, 1], "VALID", false)(
        stage1_unit1_relu3,
    )
    plus0_v1 = Add()([stage1_unit1_conv3, stage1_unit1_sc])
    stage1_unit2_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit2_bn1", false)(plus0_v1)
    stage1_unit2_relu1 = ReLU("stage1_unit2_relu1")(stage1_unit2_bn1)
    stage1_unit2_conv1 =
        Conv2D(64, (1, 1), "stage1_unit2_conv1", [1, 1], "VALID", false)(stage1_unit2_relu1)
    stage1_unit2_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit2_bn2", false)(
            stage1_unit2_conv1,
        )
    stage1_unit2_relu2 = ReLU("stage1_unit2_relu2")(stage1_unit2_bn2)
    stage1_unit2_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage1_unit2_relu2)
    stage1_unit2_conv2 = Conv2D(64, (3, 3), "stage1_unit2_conv2", [1, 1], "VALID", false)(
        stage1_unit2_conv2_pad,
    )
    stage1_unit2_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit2_bn3", false)(
            stage1_unit2_conv2,
        )
    stage1_unit2_relu3 = ReLU("stage1_unit2_relu3")(stage1_unit2_bn3)
    stage1_unit2_conv3 = Conv2D(256, (1, 1), "stage1_unit2_conv3", [1, 1], "VALID", false)(
        stage1_unit2_relu3,
    )
    plus1_v2 = Add()([stage1_unit2_conv3, plus0_v1])
    stage1_unit3_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit3_bn1", false)(plus1_v2)
    stage1_unit3_relu1 = ReLU("stage1_unit3_relu1")(stage1_unit3_bn1)
    stage1_unit3_conv1 =
        Conv2D(64, (1, 1), "stage1_unit3_conv1", [1, 1], "VALID", false)(stage1_unit3_relu1)
    stage1_unit3_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit3_bn2", false)(
            stage1_unit3_conv1,
        )
    stage1_unit3_relu2 = ReLU("stage1_unit3_relu2")(stage1_unit3_bn2)
    stage1_unit3_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage1_unit3_relu2)
    stage1_unit3_conv2 = Conv2D(64, (3, 3), "stage1_unit3_conv2", [1, 1], "VALID", false)(
        stage1_unit3_conv2_pad,
    )
    stage1_unit3_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage1_unit3_bn3", false)(
            stage1_unit3_conv2,
        )
    stage1_unit3_relu3 = ReLU("stage1_unit3_relu3")(stage1_unit3_bn3)
    stage1_unit3_conv3 = Conv2D(256, (1, 1), "stage1_unit3_conv3", [1, 1], "VALID", false)(
        stage1_unit3_relu3,
    )
    plus2 = Add()([stage1_unit3_conv3, plus1_v2])
    stage2_unit1_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit1_bn1", false)(plus2)
    stage2_unit1_relu1 = ReLU("stage2_unit1_relu1")(stage2_unit1_bn1)
    stage2_unit1_conv1 = Conv2D(128, (1, 1), "stage2_unit1_conv1", [1, 1], "VALID", false)(
        stage2_unit1_relu1,
    )
    stage2_unit1_sc =
        Conv2D(512, (1, 1), "stage2_unit1_sc", [2, 2], "VALID", false)(stage2_unit1_relu1)
    stage2_unit1_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit1_bn2", false)(
            stage2_unit1_conv1,
        )
    stage2_unit1_relu2 = ReLU("stage2_unit1_relu2")(stage2_unit1_bn2)
    stage2_unit1_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage2_unit1_relu2)
    stage2_unit1_conv2 = Conv2D(128, (3, 3), "stage2_unit1_conv2", [2, 2], "VALID", false)(
        stage2_unit1_conv2_pad,
    )
    stage2_unit1_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit1_bn3", false)(
            stage2_unit1_conv2,
        )
    stage2_unit1_relu3 = ReLU("stage2_unit1_relu3")(stage2_unit1_bn3)
    stage2_unit1_conv3 = Conv2D(512, (1, 1), "stage2_unit1_conv3", [1, 1], "VALID", false)(
        stage2_unit1_relu3,
    )
    plus3 = Add()([stage2_unit1_conv3, stage2_unit1_sc])
    stage2_unit2_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit2_bn1", false)(plus3)
    stage2_unit2_relu1 = ReLU("stage2_unit2_relu1")(stage2_unit2_bn1)
    stage2_unit2_conv1 = Conv2D(128, (1, 1), "stage2_unit2_conv1", [1, 1], "VALID", false)(
        stage2_unit2_relu1,
    )
    stage2_unit2_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit2_bn2", false)(
            stage2_unit2_conv1,
        )
    stage2_unit2_relu2 = ReLU("stage2_unit2_relu2")(stage2_unit2_bn2)
    stage2_unit2_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage2_unit2_relu2)
    stage2_unit2_conv2 = Conv2D(128, (3, 3), "stage2_unit2_conv2", [1, 1], "VALID", false)(
        stage2_unit2_conv2_pad,
    )
    stage2_unit2_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit2_bn3", false)(
            stage2_unit2_conv2,
        )
    stage2_unit2_relu3 = ReLU("stage2_unit2_relu3")(stage2_unit2_bn3)
    stage2_unit2_conv3 = Conv2D(512, (1, 1), "stage2_unit2_conv3", [1, 1], "VALID", false)(
        stage2_unit2_relu3,
    )
    plus4 = Add()([stage2_unit2_conv3, plus3])
    stage2_unit3_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit3_bn1", false)(plus4)
    stage2_unit3_relu1 = ReLU("stage2_unit3_relu1")(stage2_unit3_bn1)
    stage2_unit3_conv1 = Conv2D(128, (1, 1), "stage2_unit3_conv1", [1, 1], "VALID", false)(
        stage2_unit3_relu1,
    )
    stage2_unit3_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit3_bn2", false)(
            stage2_unit3_conv1,
        )
    stage2_unit3_relu2 = ReLU("stage2_unit3_relu2")(stage2_unit3_bn2)
    stage2_unit3_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage2_unit3_relu2)
    stage2_unit3_conv2 = Conv2D(128, (3, 3), "stage2_unit3_conv2", [1, 1], "VALID", false)(
        stage2_unit3_conv2_pad,
    )
    stage2_unit3_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit3_bn3", false)(
            stage2_unit3_conv2,
        )
    stage2_unit3_relu3 = ReLU("stage2_unit3_relu3")(stage2_unit3_bn3)
    stage2_unit3_conv3 = Conv2D(512, (1, 1), "stage2_unit3_conv3", [1, 1], "VALID", false)(
        stage2_unit3_relu3,
    )
    plus5 = Add()([stage2_unit3_conv3, plus4])
    stage2_unit4_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit4_bn1", false)(plus5)
    stage2_unit4_relu1 = ReLU("stage2_unit4_relu1")(stage2_unit4_bn1)
    stage2_unit4_conv1 = Conv2D(128, (1, 1), "stage2_unit4_conv1", [1, 1], "VALID", false)(
        stage2_unit4_relu1,
    )
    stage2_unit4_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit4_bn2", false)(
            stage2_unit4_conv1,
        )
    stage2_unit4_relu2 = ReLU("stage2_unit4_relu2")(stage2_unit4_bn2)
    stage2_unit4_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage2_unit4_relu2)
    stage2_unit4_conv2 = Conv2D(128, (3, 3), "stage2_unit4_conv2", [1, 1], "VALID", false)(
        stage2_unit4_conv2_pad,
    )
    stage2_unit4_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage2_unit4_bn3", false)(
            stage2_unit4_conv2,
        )
    stage2_unit4_relu3 = ReLU("stage2_unit4_relu3")(stage2_unit4_bn3)
    stage2_unit4_conv3 = Conv2D(512, (1, 1), "stage2_unit4_conv3", [1, 1], "VALID", false)(
        stage2_unit4_relu3,
    )
    plus6 = Add()([stage2_unit4_conv3, plus5])
    stage3_unit1_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit1_bn1", false)(plus6)
    stage3_unit1_relu1 = ReLU("stage3_unit1_relu1")(stage3_unit1_bn1)
    stage3_unit1_conv1 = Conv2D(256, (1, 1), "stage3_unit1_conv1", [1, 1], "VALID", false)(
        stage3_unit1_relu1,
    )
    stage3_unit1_sc =
        Conv2D(1024, (1, 1), "stage3_unit1_sc", [2, 2], "VALID", false)(stage3_unit1_relu1)
    stage3_unit1_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit1_bn2", false)(
            stage3_unit1_conv1,
        )
    stage3_unit1_relu2 = ReLU("stage3_unit1_relu2")(stage3_unit1_bn2)
    stage3_unit1_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit1_relu2)
    stage3_unit1_conv2 = Conv2D(256, (3, 3), "stage3_unit1_conv2", [2, 2], "VALID", false)(
        stage3_unit1_conv2_pad,
    )
    ssh_m1_red_conv =
        Conv2D(256, (1, 1), "ssh_m1_red_conv", [1, 1], "VALID", true)(stage3_unit1_relu2)
    stage3_unit1_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit1_bn3", false)(
            stage3_unit1_conv2,
        )
    ssh_m1_red_conv_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_red_conv_bn", false)(
            ssh_m1_red_conv,
        )
    stage3_unit1_relu3 = ReLU("stage3_unit1_relu3")(stage3_unit1_bn3)
    ssh_m1_red_conv_relu = ReLU("ssh_m1_red_conv_relu")(ssh_m1_red_conv_bn)
    stage3_unit1_conv3 = Conv2D(1024, (1, 1), "stage3_unit1_conv3", [1, 1], "VALID", false)(
        stage3_unit1_relu3,
    )
    plus7 = Add()([stage3_unit1_conv3, stage3_unit1_sc])
    stage3_unit2_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit2_bn1", false)(plus7)
    stage3_unit2_relu1 = ReLU("stage3_unit2_relu1")(stage3_unit2_bn1)
    stage3_unit2_conv1 = Conv2D(256, (1, 1), "stage3_unit2_conv1", [1, 1], "VALID", false)(
        stage3_unit2_relu1,
    )
    stage3_unit2_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit2_bn2", false)(
            stage3_unit2_conv1,
        )
    stage3_unit2_relu2 = ReLU("stage3_unit2_relu2")(stage3_unit2_bn2)
    stage3_unit2_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit2_relu2)
    stage3_unit2_conv2 = Conv2D(256, (3, 3), "stage3_unit2_conv2", [1, 1], "VALID", false)(
        stage3_unit2_conv2_pad,
    )
    stage3_unit2_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit2_bn3", false)(
            stage3_unit2_conv2,
        )
    stage3_unit2_relu3 = ReLU("stage3_unit2_relu3")(stage3_unit2_bn3)
    stage3_unit2_conv3 = Conv2D(1024, (1, 1), "stage3_unit2_conv3", [1, 1], "VALID", false)(
        stage3_unit2_relu3,
    )
    plus8 = Add()([stage3_unit2_conv3, plus7])
    stage3_unit3_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit3_bn1", false)(plus8)
    stage3_unit3_relu1 = ReLU("stage3_unit3_relu1")(stage3_unit3_bn1)
    stage3_unit3_conv1 = Conv2D(256, (1, 1), "stage3_unit3_conv1", [1, 1], "VALID", false)(
        stage3_unit3_relu1,
    )
    stage3_unit3_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit3_bn2", false)(
            stage3_unit3_conv1,
        )
    stage3_unit3_relu2 = ReLU("stage3_unit3_relu2")(stage3_unit3_bn2)
    stage3_unit3_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit3_relu2)
    stage3_unit3_conv2 = Conv2D(256, (3, 3), "stage3_unit3_conv2", [1, 1], "VALID", false)(
        stage3_unit3_conv2_pad,
    )
    stage3_unit3_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit3_bn3", false)(
            stage3_unit3_conv2,
        )
    stage3_unit3_relu3 = ReLU("stage3_unit3_relu3")(stage3_unit3_bn3)
    stage3_unit3_conv3 = Conv2D(1024, (1, 1), "stage3_unit3_conv3", [1, 1], "VALID", false)(
        stage3_unit3_relu3,
    )
    plus9 = Add()([stage3_unit3_conv3, plus8])
    stage3_unit4_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit4_bn1", false)(plus9)
    stage3_unit4_relu1 = ReLU("stage3_unit4_relu1")(stage3_unit4_bn1)
    stage3_unit4_conv1 = Conv2D(256, (1, 1), "stage3_unit4_conv1", [1, 1], "VALID", false)(
        stage3_unit4_relu1,
    )
    stage3_unit4_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit4_bn2", false)(
            stage3_unit4_conv1,
        )
    stage3_unit4_relu2 = ReLU("stage3_unit4_relu2")(stage3_unit4_bn2)
    stage3_unit4_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit4_relu2)
    stage3_unit4_conv2 = Conv2D(256, (3, 3), "stage3_unit4_conv2", [1, 1], "VALID", false)(
        stage3_unit4_conv2_pad,
    )
    stage3_unit4_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit4_bn3", false)(
            stage3_unit4_conv2,
        )
    stage3_unit4_relu3 = ReLU("stage3_unit4_relu3")(stage3_unit4_bn3)
    stage3_unit4_conv3 = Conv2D(1024, (1, 1), "stage3_unit4_conv3", [1, 1], "VALID", false)(
        stage3_unit4_relu3,
    )
    plus10 = Add()([stage3_unit4_conv3, plus9])
    stage3_unit5_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit5_bn1", false)(plus10)
    stage3_unit5_relu1 = ReLU("stage3_unit5_relu1")(stage3_unit5_bn1)
    stage3_unit5_conv1 = Conv2D(256, (1, 1), "stage3_unit5_conv1", [1, 1], "VALID", false)(
        stage3_unit5_relu1,
    )
    stage3_unit5_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit5_bn2", false)(
            stage3_unit5_conv1,
        )
    stage3_unit5_relu2 = ReLU("stage3_unit5_relu2")(stage3_unit5_bn2)
    stage3_unit5_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit5_relu2)
    stage3_unit5_conv2 = Conv2D(256, (3, 3), "stage3_unit5_conv2", [1, 1], "VALID", false)(
        stage3_unit5_conv2_pad,
    )
    stage3_unit5_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit5_bn3", false)(
            stage3_unit5_conv2,
        )
    stage3_unit5_relu3 = ReLU("stage3_unit5_relu3")(stage3_unit5_bn3)
    stage3_unit5_conv3 = Conv2D(1024, (1, 1), "stage3_unit5_conv3", [1, 1], "VALID", false)(
        stage3_unit5_relu3,
    )
    plus11 = Add()([stage3_unit5_conv3, plus10])
    stage3_unit6_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit6_bn1", false)(plus11)
    stage3_unit6_relu1 = ReLU("stage3_unit6_relu1")(stage3_unit6_bn1)
    stage3_unit6_conv1 = Conv2D(256, (1, 1), "stage3_unit6_conv1", [1, 1], "VALID", false)(
        stage3_unit6_relu1,
    )
    stage3_unit6_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit6_bn2", false)(
            stage3_unit6_conv1,
        )
    stage3_unit6_relu2 = ReLU("stage3_unit6_relu2")(stage3_unit6_bn2)
    stage3_unit6_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage3_unit6_relu2)
    stage3_unit6_conv2 = Conv2D(256, (3, 3), "stage3_unit6_conv2", [1, 1], "VALID", false)(
        stage3_unit6_conv2_pad,
    )
    stage3_unit6_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage3_unit6_bn3", false)(
            stage3_unit6_conv2,
        )
    stage3_unit6_relu3 = ReLU("stage3_unit6_relu3")(stage3_unit6_bn3)
    stage3_unit6_conv3 = Conv2D(1024, (1, 1), "stage3_unit6_conv3", [1, 1], "VALID", false)(
        stage3_unit6_relu3,
    )
    plus12 = Add()([stage3_unit6_conv3, plus11])
    stage4_unit1_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit1_bn1", false)(plus12)
    stage4_unit1_relu1 = ReLU("stage4_unit1_relu1")(stage4_unit1_bn1)
    stage4_unit1_conv1 = Conv2D(512, (1, 1), "stage4_unit1_conv1", [1, 1], "VALID", false)(
        stage4_unit1_relu1,
    )
    stage4_unit1_sc =
        Conv2D(2048, (1, 1), "stage4_unit1_sc", [2, 2], "VALID", false)(stage4_unit1_relu1)
    stage4_unit1_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit1_bn2", false)(
            stage4_unit1_conv1,
        )
    stage4_unit1_relu2 = ReLU("stage4_unit1_relu2")(stage4_unit1_bn2)
    stage4_unit1_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage4_unit1_relu2)
    stage4_unit1_conv2 = Conv2D(512, (3, 3), "stage4_unit1_conv2", [2, 2], "VALID", false)(
        stage4_unit1_conv2_pad,
    )
    ssh_c2_lateral =
        Conv2D(256, (1, 1), "ssh_c2_lateral", [1, 1], "VALID", true)(stage4_unit1_relu2)
    stage4_unit1_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit1_bn3", false)(
            stage4_unit1_conv2,
        )
    ssh_c2_lateral_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_c2_lateral_bn", false)(
            ssh_c2_lateral,
        )
    stage4_unit1_relu3 = ReLU("stage4_unit1_relu3")(stage4_unit1_bn3)
    ssh_c2_lateral_relu = ReLU("ssh_c2_lateral_relu")(ssh_c2_lateral_bn)
    stage4_unit1_conv3 = Conv2D(2048, (1, 1), "stage4_unit1_conv3", [1, 1], "VALID", false)(
        stage4_unit1_relu3,
    )
    plus13 = Add()([stage4_unit1_conv3, stage4_unit1_sc])
    stage4_unit2_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit2_bn1", false)(plus13)
    stage4_unit2_relu1 = ReLU("stage4_unit2_relu1")(stage4_unit2_bn1)
    stage4_unit2_conv1 = Conv2D(512, (1, 1), "stage4_unit2_conv1", [1, 1], "VALID", false)(
        stage4_unit2_relu1,
    )
    stage4_unit2_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit2_bn2", false)(
            stage4_unit2_conv1,
        )
    stage4_unit2_relu2 = ReLU("stage4_unit2_relu2")(stage4_unit2_bn2)
    stage4_unit2_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage4_unit2_relu2)
    stage4_unit2_conv2 = Conv2D(512, (3, 3), "stage4_unit2_conv2", [1, 1], "VALID", false)(
        stage4_unit2_conv2_pad,
    )
    stage4_unit2_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit2_bn3", false)(
            stage4_unit2_conv2,
        )
    stage4_unit2_relu3 = ReLU("stage4_unit2_relu3")(stage4_unit2_bn3)
    stage4_unit2_conv3 = Conv2D(2048, (1, 1), "stage4_unit2_conv3", [1, 1], "VALID", false)(
        stage4_unit2_relu3,
    )
    plus14 = Add()([stage4_unit2_conv3, plus13])
    stage4_unit3_bn1 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit3_bn1", false)(plus14)
    stage4_unit3_relu1 = ReLU("stage4_unit3_relu1")(stage4_unit3_bn1)
    stage4_unit3_conv1 = Conv2D(512, (1, 1), "stage4_unit3_conv1", [1, 1], "VALID", false)(
        stage4_unit3_relu1,
    )
    stage4_unit3_bn2 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit3_bn2", false)(
            stage4_unit3_conv1,
        )
    stage4_unit3_relu2 = ReLU("stage4_unit3_relu2")(stage4_unit3_bn2)
    stage4_unit3_conv2_pad = ZeroPadding2D(tuple([1, 1]))(stage4_unit3_relu2)
    stage4_unit3_conv2 = Conv2D(512, (3, 3), "stage4_unit3_conv2", [1, 1], "VALID", false)(
        stage4_unit3_conv2_pad,
    )
    stage4_unit3_bn3 =
        BatchNormalization(1.9999999494757503e-05, "stage4_unit3_bn3", false)(
            stage4_unit3_conv2,
        )
    stage4_unit3_relu3 = ReLU("stage4_unit3_relu3")(stage4_unit3_bn3)
    stage4_unit3_conv3 = Conv2D(2048, (1, 1), "stage4_unit3_conv3", [1, 1], "VALID", false)(
        stage4_unit3_relu3,
    )
    plus15 = Add()([stage4_unit3_conv3, plus14])
    bn1 = BatchNormalization(1.9999999494757503e-05, "bn1", false)(plus15)
    relu1 = ReLU("relu1")(bn1)
    ssh_c3_lateral = Conv2D(256, (1, 1), "ssh_c3_lateral", [1, 1], "VALID", true)(relu1)
    ssh_c3_lateral_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_c3_lateral_bn", false)(
            ssh_c3_lateral,
        )
    ssh_c3_lateral_relu = ReLU("ssh_c3_lateral_relu")(ssh_c3_lateral_bn)
    ssh_m3_det_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c3_lateral_relu)
    ssh_m3_det_conv1 =
        Conv2D(256, (3, 3), "ssh_m3_det_conv1", [1, 1], "VALID", true)(ssh_m3_det_conv1_pad)
    ssh_m3_det_context_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c3_lateral_relu)
    ssh_m3_det_context_conv1 =
        Conv2D(128, (3, 3), "ssh_m3_det_context_conv1", [1, 1], "VALID", true)(
            ssh_m3_det_context_conv1_pad,
        )
    ssh_c3_up = UpSampling2D((2, 2), "nearest", "ssh_c3_up")(ssh_c3_lateral_relu)
    ssh_m3_det_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m3_det_conv1_bn", false)(
            ssh_m3_det_conv1,
        )
    ssh_m3_det_context_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m3_det_context_conv1_bn", false)(
            ssh_m3_det_context_conv1,
        )
    x1_shape = shape(tf, ssh_c3_up)
    x2_shape = shape(tf, ssh_c2_lateral_relu)
    offsets = [0, (x1_shape[2] - x2_shape[2]) ÷ 2, (x1_shape[3] - x2_shape[3]) ÷ 2, 0]
    size = [-1, x2_shape[2], x2_shape[3], -1]
    crop0 = (tf:ssh_c3_up)
    ssh_m3_det_context_conv1_relu =
        ReLU("ssh_m3_det_context_conv1_relu")(ssh_m3_det_context_conv1_bn)
    plus0_v2 = Add()([ssh_c2_lateral_relu, crop0])
    ssh_m3_det_context_conv2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m3_det_context_conv1_relu)
    ssh_m3_det_context_conv2 =
        Conv2D(128, (3, 3), "ssh_m3_det_context_conv2", [1, 1], "VALID", true)(
            ssh_m3_det_context_conv2_pad,
        )
    ssh_m3_det_context_conv3_1_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m3_det_context_conv1_relu)
    ssh_m3_det_context_conv3_1 =
        Conv2D(128, (3, 3), "ssh_m3_det_context_conv3_1", [1, 1], "VALID", true)(
            ssh_m3_det_context_conv3_1_pad,
        )
    ssh_c2_aggr_pad = ZeroPadding2D(tuple([1, 1]))(plus0_v2)
    ssh_c2_aggr = Conv2D(256, (3, 3), "ssh_c2_aggr", [1, 1], "VALID", true)(ssh_c2_aggr_pad)
    ssh_m3_det_context_conv2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m3_det_context_conv2_bn", false)(
            ssh_m3_det_context_conv2,
        )
    ssh_m3_det_context_conv3_1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m3_det_context_conv3_1_bn", false)(
            ssh_m3_det_context_conv3_1,
        )
    ssh_c2_aggr_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_c2_aggr_bn", false)(ssh_c2_aggr)
    ssh_m3_det_context_conv3_1_relu =
        ReLU("ssh_m3_det_context_conv3_1_relu")(ssh_m3_det_context_conv3_1_bn)
    ssh_c2_aggr_relu = ReLU("ssh_c2_aggr_relu")(ssh_c2_aggr_bn)
    ssh_m3_det_context_conv3_2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m3_det_context_conv3_1_relu)
    ssh_m3_det_context_conv3_2 =
        Conv2D(128, (3, 3), "ssh_m3_det_context_conv3_2", [1, 1], "VALID", true)(
            ssh_m3_det_context_conv3_2_pad,
        )
    ssh_m2_det_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c2_aggr_relu)
    ssh_m2_det_conv1 =
        Conv2D(256, (3, 3), "ssh_m2_det_conv1", [1, 1], "VALID", true)(ssh_m2_det_conv1_pad)
    ssh_m2_det_context_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c2_aggr_relu)
    ssh_m2_det_context_conv1 =
        Conv2D(128, (3, 3), "ssh_m2_det_context_conv1", [1, 1], "VALID", true)(
            ssh_m2_det_context_conv1_pad,
        )
    ssh_m2_red_up = UpSampling2D((2, 2), "nearest", "ssh_m2_red_up")(ssh_c2_aggr_relu)
    ssh_m3_det_context_conv3_2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m3_det_context_conv3_2_bn", false)(
            ssh_m3_det_context_conv3_2,
        )
    ssh_m2_det_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m2_det_conv1_bn", false)(
            ssh_m2_det_conv1,
        )
    ssh_m2_det_context_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m2_det_context_conv1_bn", false)(
            ssh_m2_det_context_conv1,
        )
    x1_shape = shape(tf, ssh_m2_red_up)
    x2_shape = shape(tf, ssh_m1_red_conv_relu)
    offsets = [0, (x1_shape[2] - x2_shape[2]) ÷ 2, (x1_shape[3] - x2_shape[3]) ÷ 2, 0]
    size = [-1, x2_shape[2], x2_shape[3], -1]
    crop1 = (tf:ssh_m2_red_up)
    ssh_m3_det_concat = concatenate(
        [ssh_m3_det_conv1_bn, ssh_m3_det_context_conv2_bn, ssh_m3_det_context_conv3_2_bn],
        3,
        "ssh_m3_det_concat",
    )
    ssh_m2_det_context_conv1_relu =
        ReLU("ssh_m2_det_context_conv1_relu")(ssh_m2_det_context_conv1_bn)
    plus1_v1 = Add()([ssh_m1_red_conv_relu, crop1])
    ssh_m3_det_concat_relu = ReLU("ssh_m3_det_concat_relu")(ssh_m3_det_concat)
    ssh_m2_det_context_conv2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m2_det_context_conv1_relu)
    ssh_m2_det_context_conv2 =
        Conv2D(128, (3, 3), "ssh_m2_det_context_conv2", [1, 1], "VALID", true)(
            ssh_m2_det_context_conv2_pad,
        )
    ssh_m2_det_context_conv3_1_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m2_det_context_conv1_relu)
    ssh_m2_det_context_conv3_1 =
        Conv2D(128, (3, 3), "ssh_m2_det_context_conv3_1", [1, 1], "VALID", true)(
            ssh_m2_det_context_conv3_1_pad,
        )
    ssh_c1_aggr_pad = ZeroPadding2D(tuple([1, 1]))(plus1_v1)
    ssh_c1_aggr = Conv2D(256, (3, 3), "ssh_c1_aggr", [1, 1], "VALID", true)(ssh_c1_aggr_pad)
    face_rpn_cls_score_stride32 =
        Conv2D(4, (1, 1), "face_rpn_cls_score_stride32", [1, 1], "VALID", true)(
            ssh_m3_det_concat_relu,
        )
    inter_1 = concatenate(
        [
            face_rpn_cls_score_stride32[(begin:end, begin:end, begin:end, 0)+1],
            face_rpn_cls_score_stride32[(begin:end, begin:end, begin:end, 1)+1],
        ],
        1,
    )
    inter_2 = concatenate(
        [
            face_rpn_cls_score_stride32[(begin:end, begin:end, begin:end, 2)+1],
            face_rpn_cls_score_stride32[(begin:end, begin:end, begin:end, 3)+1],
        ],
        1,
    )
    final = stack(tf, [inter_1, inter_2])
    face_rpn_cls_score_reshape_stride32 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_score_reshape_stride32")
    face_rpn_bbox_pred_stride32 =
        Conv2D(8, (1, 1), "face_rpn_bbox_pred_stride32", [1, 1], "VALID", true)(
            ssh_m3_det_concat_relu,
        )
    face_rpn_landmark_pred_stride32 =
        Conv2D(20, (1, 1), "face_rpn_landmark_pred_stride32", [1, 1], "VALID", true)(
            ssh_m3_det_concat_relu,
        )
    ssh_m2_det_context_conv2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m2_det_context_conv2_bn", false)(
            ssh_m2_det_context_conv2,
        )
    ssh_m2_det_context_conv3_1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m2_det_context_conv3_1_bn", false)(
            ssh_m2_det_context_conv3_1,
        )
    ssh_c1_aggr_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_c1_aggr_bn", false)(ssh_c1_aggr)
    ssh_m2_det_context_conv3_1_relu =
        ReLU("ssh_m2_det_context_conv3_1_relu")(ssh_m2_det_context_conv3_1_bn)
    ssh_c1_aggr_relu = ReLU("ssh_c1_aggr_relu")(ssh_c1_aggr_bn)
    face_rpn_cls_prob_stride32 =
        Softmax("face_rpn_cls_prob_stride32")(face_rpn_cls_score_reshape_stride32)
    input_shape = [shape(tf, face_rpn_cls_prob_stride32)[k+1] for k = 0:3]
    sz = cast(tf.dtypes, input_shape[2] / 2, tf.int32)
    inter_1 = face_rpn_cls_prob_stride32[(begin:end, 1:sz, begin:end, 0)+1]
    inter_2 = face_rpn_cls_prob_stride32[(begin:end, 1:sz, begin:end, 1)+1]
    inter_3 = face_rpn_cls_prob_stride32[(begin:end, sz+1:end, begin:end, 0)+1]
    inter_4 = face_rpn_cls_prob_stride32[(begin:end, sz+1:end, begin:end, 1)+1]
    final = stack(tf, [inter_1, inter_3, inter_2, inter_4])
    face_rpn_cls_prob_reshape_stride32 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_prob_reshape_stride32")
    ssh_m2_det_context_conv3_2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m2_det_context_conv3_1_relu)
    ssh_m2_det_context_conv3_2 =
        Conv2D(128, (3, 3), "ssh_m2_det_context_conv3_2", [1, 1], "VALID", true)(
            ssh_m2_det_context_conv3_2_pad,
        )
    ssh_m1_det_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c1_aggr_relu)
    ssh_m1_det_conv1 =
        Conv2D(256, (3, 3), "ssh_m1_det_conv1", [1, 1], "VALID", true)(ssh_m1_det_conv1_pad)
    ssh_m1_det_context_conv1_pad = ZeroPadding2D(tuple([1, 1]))(ssh_c1_aggr_relu)
    ssh_m1_det_context_conv1 =
        Conv2D(128, (3, 3), "ssh_m1_det_context_conv1", [1, 1], "VALID", true)(
            ssh_m1_det_context_conv1_pad,
        )
    ssh_m2_det_context_conv3_2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m2_det_context_conv3_2_bn", false)(
            ssh_m2_det_context_conv3_2,
        )
    ssh_m1_det_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_det_conv1_bn", false)(
            ssh_m1_det_conv1,
        )
    ssh_m1_det_context_conv1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_det_context_conv1_bn", false)(
            ssh_m1_det_context_conv1,
        )
    ssh_m2_det_concat = concatenate(
        [ssh_m2_det_conv1_bn, ssh_m2_det_context_conv2_bn, ssh_m2_det_context_conv3_2_bn],
        3,
        "ssh_m2_det_concat",
    )
    ssh_m1_det_context_conv1_relu =
        ReLU("ssh_m1_det_context_conv1_relu")(ssh_m1_det_context_conv1_bn)
    ssh_m2_det_concat_relu = ReLU("ssh_m2_det_concat_relu")(ssh_m2_det_concat)
    ssh_m1_det_context_conv2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m1_det_context_conv1_relu)
    ssh_m1_det_context_conv2 =
        Conv2D(128, (3, 3), "ssh_m1_det_context_conv2", [1, 1], "VALID", true)(
            ssh_m1_det_context_conv2_pad,
        )
    ssh_m1_det_context_conv3_1_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m1_det_context_conv1_relu)
    ssh_m1_det_context_conv3_1 =
        Conv2D(128, (3, 3), "ssh_m1_det_context_conv3_1", [1, 1], "VALID", true)(
            ssh_m1_det_context_conv3_1_pad,
        )
    face_rpn_cls_score_stride16 =
        Conv2D(4, (1, 1), "face_rpn_cls_score_stride16", [1, 1], "VALID", true)(
            ssh_m2_det_concat_relu,
        )
    inter_1 = concatenate(
        [
            face_rpn_cls_score_stride16[(begin:end, begin:end, begin:end, 0)+1],
            face_rpn_cls_score_stride16[(begin:end, begin:end, begin:end, 1)+1],
        ],
        1,
    )
    inter_2 = concatenate(
        [
            face_rpn_cls_score_stride16[(begin:end, begin:end, begin:end, 2)+1],
            face_rpn_cls_score_stride16[(begin:end, begin:end, begin:end, 3)+1],
        ],
        1,
    )
    final = stack(tf, [inter_1, inter_2])
    face_rpn_cls_score_reshape_stride16 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_score_reshape_stride16")
    face_rpn_bbox_pred_stride16 =
        Conv2D(8, (1, 1), "face_rpn_bbox_pred_stride16", [1, 1], "VALID", true)(
            ssh_m2_det_concat_relu,
        )
    face_rpn_landmark_pred_stride16 =
        Conv2D(20, (1, 1), "face_rpn_landmark_pred_stride16", [1, 1], "VALID", true)(
            ssh_m2_det_concat_relu,
        )
    ssh_m1_det_context_conv2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_det_context_conv2_bn", false)(
            ssh_m1_det_context_conv2,
        )
    ssh_m1_det_context_conv3_1_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_det_context_conv3_1_bn", false)(
            ssh_m1_det_context_conv3_1,
        )
    ssh_m1_det_context_conv3_1_relu =
        ReLU("ssh_m1_det_context_conv3_1_relu")(ssh_m1_det_context_conv3_1_bn)
    face_rpn_cls_prob_stride16 =
        Softmax("face_rpn_cls_prob_stride16")(face_rpn_cls_score_reshape_stride16)
    input_shape = [shape(tf, face_rpn_cls_prob_stride16)[k+1] for k = 0:3]
    sz = cast(tf.dtypes, input_shape[2] / 2, tf.int32)
    inter_1 = face_rpn_cls_prob_stride16[(begin:end, 1:sz, begin:end, 0)+1]
    inter_2 = face_rpn_cls_prob_stride16[(begin:end, 1:sz, begin:end, 1)+1]
    inter_3 = face_rpn_cls_prob_stride16[(begin:end, sz+1:end, begin:end, 0)+1]
    inter_4 = face_rpn_cls_prob_stride16[(begin:end, sz+1:end, begin:end, 1)+1]
    final = stack(tf, [inter_1, inter_3, inter_2, inter_4])
    face_rpn_cls_prob_reshape_stride16 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_prob_reshape_stride16")
    ssh_m1_det_context_conv3_2_pad =
        ZeroPadding2D(tuple([1, 1]))(ssh_m1_det_context_conv3_1_relu)
    ssh_m1_det_context_conv3_2 =
        Conv2D(128, (3, 3), "ssh_m1_det_context_conv3_2", [1, 1], "VALID", true)(
            ssh_m1_det_context_conv3_2_pad,
        )
    ssh_m1_det_context_conv3_2_bn =
        BatchNormalization(1.9999999494757503e-05, "ssh_m1_det_context_conv3_2_bn", false)(
            ssh_m1_det_context_conv3_2,
        )
    ssh_m1_det_concat = concatenate(
        [ssh_m1_det_conv1_bn, ssh_m1_det_context_conv2_bn, ssh_m1_det_context_conv3_2_bn],
        3,
        "ssh_m1_det_concat",
    )
    ssh_m1_det_concat_relu = ReLU("ssh_m1_det_concat_relu")(ssh_m1_det_concat)
    face_rpn_cls_score_stride8 =
        Conv2D(4, (1, 1), "face_rpn_cls_score_stride8", [1, 1], "VALID", true)(
            ssh_m1_det_concat_relu,
        )
    inter_1 = concatenate(
        [
            face_rpn_cls_score_stride8[(begin:end, begin:end, begin:end, 0)+1],
            face_rpn_cls_score_stride8[(begin:end, begin:end, begin:end, 1)+1],
        ],
        1,
    )
    inter_2 = concatenate(
        [
            face_rpn_cls_score_stride8[(begin:end, begin:end, begin:end, 2)+1],
            face_rpn_cls_score_stride8[(begin:end, begin:end, begin:end, 3)+1],
        ],
        1,
    )
    final = stack(tf, [inter_1, inter_2])
    face_rpn_cls_score_reshape_stride8 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_score_reshape_stride8")
    face_rpn_bbox_pred_stride8 =
        Conv2D(8, (1, 1), "face_rpn_bbox_pred_stride8", [1, 1], "VALID", true)(
            ssh_m1_det_concat_relu,
        )
    face_rpn_landmark_pred_stride8 =
        Conv2D(20, (1, 1), "face_rpn_landmark_pred_stride8", [1, 1], "VALID", true)(
            ssh_m1_det_concat_relu,
        )
    face_rpn_cls_prob_stride8 =
        Softmax("face_rpn_cls_prob_stride8")(face_rpn_cls_score_reshape_stride8)
    input_shape = [shape(tf, face_rpn_cls_prob_stride8)[k+1] for k = 0:3]
    sz = cast(tf.dtypes, input_shape[2] / 2, tf.int32)
    inter_1 = face_rpn_cls_prob_stride8[(begin:end, 1:sz, begin:end, 0)+1]
    inter_2 = face_rpn_cls_prob_stride8[(begin:end, 1:sz, begin:end, 1)+1]
    inter_3 = face_rpn_cls_prob_stride8[(begin:end, sz+1:end, begin:end, 0)+1]
    inter_4 = face_rpn_cls_prob_stride8[(begin:end, sz+1:end, begin:end, 1)+1]
    final = stack(tf, [inter_1, inter_3, inter_2, inter_4])
    face_rpn_cls_prob_reshape_stride8 =
        transpose(tf, final, (1, 2, 3, 0), "face_rpn_cls_prob_reshape_stride8")
    model = Model(
        data,
        [
            face_rpn_cls_prob_reshape_stride32,
            face_rpn_bbox_pred_stride32,
            face_rpn_landmark_pred_stride32,
            face_rpn_cls_prob_reshape_stride16,
            face_rpn_bbox_pred_stride16,
            face_rpn_landmark_pred_stride16,
            face_rpn_cls_prob_reshape_stride8,
            face_rpn_bbox_pred_stride8,
            face_rpn_landmark_pred_stride8,
        ],
    )
    model = load_weights(model)
    return model
end
