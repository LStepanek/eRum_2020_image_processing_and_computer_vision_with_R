###############################################################################
##################                                            #################
##################             Image processing               #################
##################                    and                     #################
##################              computer vision               #################
##################                   with R                   #################
##################                                            #################
##################                    ***                     #################
##################     a workshop at eRum 2020 conference     #################
##################                    ***                     #################
##################                                            #################
##################  By R by Lubomir Stepanek and Jiri Novak   #################
##################               June 20, 2020                #################
##################                                            #################
###############################################################################

## an installaton of Bnosac's packages is a bit tricky ------------------------
## (i)   firstly, we need to install current verstion of RTools
##       for Windows;
##       click https://cran.r-project.org/bin/windows/Rtools/;
##       please download installer based on your operation system version
## (ii)  then, in R console, copy and run the following command

writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")

## (iii) finally, install devtools using

install.packages("devtools")

##       and then, take a sip of coffee or rather two while you are
##       installing Bnosac's packages using

devtools::install_github(
    "bnosac/image",
    subdir = "image.dlib",
    build_vignettes = TRUE
)

devtools::install_github(
    "bnosac/image",
    subdir = "image.libfacedetection",
    build_vignettes = TRUE
)


## ----------------------------------------------------------------------------

###############################################################################

## I am setting a working directory -------------------------------------------

while(
    !"_03_computer_vision_.R" %in% dir()
){
    
    setwd(choose.dir())
    
}

mother_working_directory <- getwd()


## ----------------------------------------------------------------------------

###############################################################################

## I am creating subfolders of my working directory  --------------------------

setwd(mother_working_directory)

for(my_subdirectory in c(
    
    "inputs",
    "outputs"
    
)){
    
    if(
        !file.exists(my_subdirectory)
    ){
        
        dir.create(
            file.path(
                mother_working_directory,
                my_subdirectory
            )
        )
        
    }
    
}


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################

## face recognition -----------------------------------------------------------

## could be done using Bnosac's package image.libfacedetection ----------------

library(magick)
library(image.libfacedetection)


#### reading an image into R console ------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- magick::image_read(
  "graduating_students.jpg"
)

setwd(mother_working_directory)


## let's have a look at the image --------------------------------------------

plot(
    my_image
)


## face detection -------------------------------------------------------------

my_faces <- image_detect_faces(my_image)

print(my_faces) # properties of the detection


## let's plot the detection ---------------------------------------------------

my_plot <- as.raster(
    plot(
        my_faces,
        my_image,
        border = "red",
        lwd = 7,
        col = "white"
    )
)

windows()
plot(my_plot)


## another example of face detection ------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- magick::image_read(
  "friends.jpg"
)

setwd(mother_working_directory)


## let's have a look at the image --------------------------------------------

plot(
    my_image
)


## face detection -------------------------------------------------------------

my_faces <- image_detect_faces(my_image)

print(my_faces) # properties of the detection


## let's plot the detection ---------------------------------------------------

my_plot <- as.raster(
    plot(
        my_faces,
        my_image,
        border = "red",
        lwd = 7,
        col = "white"
    )
)

windows()
plot(my_plot)


## hands-on! ------------------------------------------------------------------

## think out and implement a suggestions how to consider only high-confident
## face detections ------------------------------------------------------------

my_faces <- image_detect_faces(my_image)


## THIS IS TO BE MODIFIED ! ---------------------------------------------------

my_faces

## ----------------------------------------------------------------------------


my_plot <- as.raster(
    plot(
        my_faces,
        my_image,
        border = "red",
        lwd = 7,
        col = "white"
    )
)

windows()
plot(my_plot)


## ----------------------------------------------------------------------------

###############################################################################

## unsupervised recognition of significant objects in images ------------------

library(imager)
library(magick)
library(image.dlib)

my_image_path <- "C:\\Users\\student\\Documents\\eRum_2020\\_image_processing_and_computer_vision_with_R_workshop_\\_workshop_20_06_2020_\\inputs\\traffic_sign.bmp"

surf_blobs <- image_surf(
    my_image_path,
    max_points = 10000,
    detection_threshold = 50
)

str(surf_blobs)

## plotting the points --------------------------------------------------------

my_image <-image_read(path = my_image_path)

windows()
plot(
    my_image,
    # main = "SURF points",
    ann = FALSE
)

points(
    surf_blobs$x,
    surf_blobs$y,
    col = "red",
    pch = 20
)


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################





