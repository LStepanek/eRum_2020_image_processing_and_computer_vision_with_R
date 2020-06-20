###############################################################################
###############################################################################
###############################################################################

# Image processing and computer vision with R

## e-Rum 2020
## 20.06.2020

###############################################################################

# Installation ----------------------------------------------------------------
# install.packages("devtools"
# devtools::install_github("bnosac/image",
#                          subdir = "image.darknet",
#                          build_vignettes = TRUE)

# Load library ----------------------------------------------------------------
library(image.darknet)

# CLASSIFICATION  #############################################################

# Define the classification model ---------------------------------------------
## https://pjreddie.com/darknet/imagenet
## (structure of the deep learning model + the learned weights + the labels)

labels <- readLines(
  system.file(package="image.darknet", 
              "include", "darknet", "data", 
              "imagenet.shortnames.list")
)
### http://www.image-net.org/

## AlexNet ....................................................................
### http://pjreddie.com/media/files/alexnet.weights
weights <- "model_classification/alexnet.weights"
alexnet <- image_darknet_model(type = 'classify', 
                               model = "alexnet.cfg", 
                               weights = weights, labels = labels, 
                               resize = FALSE #Set to FALSE for the Alexnet 
                               )
alexnet
alexnet$labels

## Darknet Reference Model ....................................................
### http://pjreddie.com/media/files/darknet.weights
weights <- "model_classification/darknet.weights"
darknetref <- image_darknet_model(type = 'classify', 
                                  model = "darknet.cfg" ,
                                  weights = weights, labels = labels
)
darknetref

## VGG-16 .....................................................................
### http://pjreddie.com/media/files/vgg-16.weights
weights <- "model_classification/vgg-16.weights"
vgg16 <- image_darknet_model(type = 'classify', 
                             model = "vgg-16.cfg", 
                             weights = weights, labels = labels, 
                             resize = FALSE #Set to FALSE for the VGG-16 model
                             )
vgg16

## Googlenet/extraction .......................................................
### http://pjreddie.com/media/files/extraction.weights
weights <- "model_classification/extraction.weights"
googlenet <- image_darknet_model(type = 'classify', 
                                 model = "extraction.cfg",
                                 weights = weights, labels = labels)
googlenet

## Darknet19 ..................................................................
### http://pjreddie.com/media/files/extraction.weights        
weights <- "model_classification/darknet19.weights"
darknet19 <- image_darknet_model(type = 'classify', 
                                 model = "darknet19.cfg",
                                 weights = weights, labels = labels)
darknet19

## Darknet19 448x448 ..........................................................
## http://pjreddie.com/media/files/darknet19_448.weights
weights <- "model_classification/darknet19_448.weights"
darknet19_448 <- image_darknet_model(type = 'classify', 
                                     model = "darknet19_448.cfg", 
                                     weights = weights, labels = labels)
darknet19_448

## Darknet tiny ...............................................................
weights <- system.file(package="image.darknet", "models", "tiny.weights")
darknet_tiny <- image_darknet_model(type = 'classify', 
                                    model = "tiny.cfg", 
                                    weights = weights, labels = labels)
darknet_tiny

# -----------------------------------------------------------------------------

###############################################################################

# Classify from image ---------------------------------------------------------

## Compare models .............................................................

### We can run model separately
image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = alexnet)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = darknetref)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = vgg16)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = googlenet)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = darknet19)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = darknet19_448)

image_darknet_classify(file = "gallery/doggy.jpg", 
                       object = darknet_tiny)

# alexnet - 0.65
# darknetref - 0.50
# vgg16 - 0.70
# googlenet - 0.73
# darknet19 - 0.83
# darknet19_448 - 0.85
# darknet_tiny - 0.87

### But that's too much work, so let's automatize it
models <- c("alexnet","darknetref", "vgg16", "googlenet", "darknet19", "darknet19_448", "darknet_tiny")
models_summary <- data.frame(model = models,
                             probability = 0,
                             label = "x")
for(i in 1:length(models)){
  x <- image_darknet_classify(file = "gallery/doggy.jpg", 
                         object = get(models[i]))
  models_summary$probability[i] <- x$type$probability[1]
  models_summary$label[i] <- x$type$label[1]
    
}
models_summary
models_summary[order(-models_summary$probability),] # sort descending by probability

# Example (2) .................................................................

for(i in 1:length(models)){
  x <- image_darknet_classify(file = "gallery/eagle.jpg", 
                              object = get(models[i]))
  models_summary$probability[i] <- x$type$probability[1]
  models_summary$label[i] <- x$type$label[1]
  
}
models_summary
models_summary[order(-models_summary$probability),] # sort descending by probability

# Example (3) .................................................................

for(i in 1:length(models)){
  x <- image_darknet_classify(file = "gallery/husky.jpg", 
                              object = get(models[i]))
  models_summary$probability[i] <- x$type$probability[1]
  models_summary$label[i] <- x$type$label[1]
  
}
models_summary
models_summary[order(-models_summary$probability),] # sort descending by probability

# Example (4) .................................................................
image_darknet_classify(file = "gallery/husky.jpg", 
                       object = darknet_tiny)

image_darknet_classify(file = "gallery/husky.jpg", 
                       object = darknet19)


# Example (5) .................................................................
image_darknet_classify(file = "gallery/german shepherd.jpg", 
                       object = darknet_tiny)

image_darknet_classify(file = "gallery/german shepherd.jpg", 
                       object = darknet19)


# -----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################
