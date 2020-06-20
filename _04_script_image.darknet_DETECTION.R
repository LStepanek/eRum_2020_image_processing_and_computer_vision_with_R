###############################################################################
###############################################################################
###############################################################################

# Image processing and computer vision with R

## e-Rum 2020
## 20.06.2020

###############################################################################

# Installation ----------------------------------------------------------------
# install.packages("devtools")
# devtools::install_github("bnosac/image",
#                          subdir = "image.darknet",
#                          build_vignettes = TRUE)

# Load library ----------------------------------------------------------------
library(image.darknet)

# DETECT ######################################################################

# Define the detection model (YOLO)  ------------------------------------------
## https://pjreddie.com/darknet/yolo/
## (structure of the deep learning model + the learned weights + the labels)

labels_VOC <- readLines(
  system.file(package="image.darknet", "include", "darknet", "data", 
              "voc.names")
)
labels_COCO <- readLines(
  system.file(package="image.darknet", "include", "darknet", "data", 
              "coco.names")
)

## YOLO trained on VOC ........................................................
## https://github.com/pjreddie/darknet/blob/master/cfg/yolov2-tiny-voc.cfg
## https://pjreddie.com/media/files/yolov2-tiny-voc.weights
cfg <- "model_detection/yolov2-tiny-voc.cfg"
weights <- "model_detection/yolov2-tiny-voc.weights"
yolo_VOC <- image_darknet_model(type = 'detect', 
                                model = cfg, 
                                weights = weights, 
                                labels = labels_VOC)
yolo_VOC 
yolo_VOC$labels

## YOLO trained on COCO .......................................................
## https://github.com/pjreddie/darknet/blob/master/cfg/yolov2.cfg
## https://pjreddie.com/media/files/yolov2.weights
cfg <- "model_detection/yolov2.cfg"
weights <- "model_detection/yolov2.weights"
yolo_COCO <- image_darknet_model(type = 'detect', 
                                 model = cfg, 
                                 weights = weights, 
                                 labels = labels_COCO)
yolo_COCO
yolo_COCO$labels

# -----------------------------------------------------------------------------

###############################################################################

# Example (1) .................................................................

# Set image from package ------------------------------------------------------
f <- system.file(package="image.darknet","include","darknet", "data",
                 "dog.jpg")

# Detect from image -----------------------------------------------------------
image_darknet_detect(file = f, 
                     object = yolo_VOC)
### So we detected
# car: 76%
# dog: 79%

image_darknet_detect(file = f, 
                     object = yolo_COCO)
### So we detected
# truck: 79%
# bicycle: 85%
# dog: 77%


### Now let's try to customize it .............................................

### Default threshold is 0.3
### Try change threshold to 0.2 -----------------------------------------------
image_darknet_detect(file = f, 
                     object = yolo_VOC,
                     threshold = 0.2
)
### So we detected
# car: 76%
# bicycle: 24%
# dog: 79%
### See, with lowering threshold we can now identify the bicycle in VOC.

image_darknet_detect(file = f, 
                     object = yolo_COCO,
                     threshold = 0.2
)

### Try different values of threshold -----------------------------------------
threshold <- 0.05
image_darknet_detect(file = f, 
                     object = yolo_VOC,
                     threshold = threshold
)

image_darknet_detect(file = f, 
                     object = yolo_COCO,
                     threshold = threshold
)


### Let's now use our own image (1) -------------------------------------------
image_darknet_detect(file = "gallery/car.png", 
                     object = yolo_VOC,
                     threshold = 0.2
)
image_darknet_detect(file = "gallery/car.png", 
                     object = yolo_COCO,
                     threshold = 0.2
)

# Example (2) .................................................................
image_darknet_detect(file = "gallery/little_dog.jpg", 
                     object = yolo_VOC,
                     threshold = 0.2
)

image_darknet_detect(file = "gallery/little_dog.jpg", 
                     object = yolo_COCO,
                     threshold = 0.2
)

# Example (3) .................................................................

image_darknet_detect(file = "gallery/person.jpg", 
                     object = yolo_VOC,
                     threshold = 0.3
)

image_darknet_detect(file = "gallery/person.jpg", 
                     object = yolo_COCO,
                     threshold = 0.2
)

# Example (4) .................................................................

image_darknet_detect(file = "gallery/giraffe.jpg", 
                     object = yolo_VOC,
                     threshold = 0.1
)

image_darknet_detect(file = "gallery/giraffe.jpg", 
                     object = yolo_COCO,
                     threshold = 0.2
)

# Try your own .................................................................

image_darknet_detect(file = "gallery/4903167.jpg", 
                     object = yolo_VOC,
                     threshold = 0.2
)

image_darknet_detect(file = "gallery/4903167.jpg", 
                     object = yolo_COCO,
                     threshold = 0.2
)
# -----------------------------------------------------------------------------


###############################################################################
###############################################################################
###############################################################################
