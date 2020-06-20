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

## I am loading and initializing important packages ---------------------------

invisible(
    
    lapply(
        
        c(  
            "bmp",
            "jpeg",
            "png"
        ),
        function(my_package){
            
            if(
                !(
                    my_package %in% rownames(installed.packages())
                )
            ){
                
                install.packages(
                    my_package,
                    dependencies = TRUE,
                    repos = "http://cran.us.r-project.org"
                )
                
            }
            
            library(
                my_package,
                character.only = TRUE
            )
            
        }
        
    )
    
)


## ----------------------------------------------------------------------------

###############################################################################

## I am setting a working directory -------------------------------------------

while(
    !"_01_image_reading_and_writing_basics_.R" %in% dir()
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

## basic packages for reading and writing images in R -------------------------

#### I am setting the working directory to my inputs folder -------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)


#### I am loading the image ---------------------------------------------------

my_image <- jpeg::readJPEG(    
    source = "girl_with_a_pearl_earring.jpg",
    native = FALSE
        # by FALSE, the image is represented as an array
        # of the dimensions height X width X channels;
        # by TRUE, the image as an object of the class nativeRaster
        # is returned instead
)


#### firstly, to plot a figure, we have to initialize an empty canvas ---------

plot(
    x = c(0, dim(my_image)[2]),
    y = c(0, dim(my_image)[1]),
    type = "n",
    axes = FALSE,
    ann = FALSE
)


#### now we can populate the empty canvas with the image ----------------------

rasterImage(
    image = my_image,
    xleft = 0,
    ybottom = 0,
    xright = dim(my_image)[2],
    ytop = dim(my_image)[1]
)


#### let's try to play with colour representation of the image ----------------

###### ! important note -- most image files decompress into RGB (3 channels)
######                     or Grayscale (1 channel)

class(my_image)  # our image is simply an array

dim(my_image)    # we can see the image height is 429 pixels
                 # and with 300 pixels;
                 # the image is treated as 3-dimensional array consisting
                 # of three matrices for three channels (R, G, B)

#my_image[, , 1]  # this is a matrix for red colour intensities
#my_image[, , 2]  # this is a matrix for green colour intensities
#my_image[, , 3]  # this is a matrix for blue colour intensities

#my_image[7, 8, ] # these are (R, G, B) intensities of the pixel
#                 # with coordinates [7, 8]


#### let's try to reduce red colour intensities in the image ------------------

temp_image <- my_image

hist(
    temp_image[, , 1],
    main = "",
    xlab = "red",
    ylab = "absolute frequency",
    col = "red"
)

temp_image[, , 1] <- 0 # all pixels in a matrix for red colour intensities
                       # are set to be 0 (the red colour is completely
                       # reduced in the image)

summary(as.vector(temp_image[, , 1]))  # red is reduced to zero

rasterImage(
    image = temp_image,
    xleft = 0,
    ybottom = 0,
    xright = dim(my_image)[2],
    ytop = dim(my_image)[1]
)   # the resulting image is only green-and-blue scaled


#### let's try to increase red colour intensities in the image ----------------

temp_image <- my_image

temp_image[, , 1] <- 1 # all pixels in a matrix for red colour intensities
                       # are set to be 1 (the red is miximized in the image)

summary(as.vector(temp_image[, , 1]))  # red is increaed to one

rasterImage(
    image = temp_image,
    xleft = 0,
    ybottom = 0,
    xright = dim(my_image)[2],
    ytop = dim(my_image)[1]
)   # the red component of the resulting image is maximized


#### let's try to reduce red and green colours in the image -------------------

temp_image <- my_image

temp_image[, , 1] <- 0
temp_image[, , 2] <- 0 # all pixels in a matrix for red and green colour
                       # intensities are set to be 0
                       # (both the red and green colour are completely
                       # reduced in the image)

rasterImage(
    image = temp_image,
    xleft = 0,
    ybottom = 0,
    xright = dim(my_image)[2],
    ytop = dim(my_image)[1]
)   # the resulting image is only blue scaled


#### I am setting the working directory to my outputs folder ------------------

setwd(
    paste(
        mother_working_directory,
        "outputs",
        sep = "/"
    )
)

jpeg::writeJPEG(
    image = temp_image,
    target = "girl_with_a_pearl_earring_in_blue.jpg",
    quality = 1.0
)


#### I am setting the working directory back to my mother directory -----------

setwd(mother_working_directory)


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################

## now let's try to do basic operations on greyscaled image -------------------

#### I am setting the working directory to my inputs folder -------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)


#### I am loading the image ---------------------------------------------------

my_image <- jpeg::readJPEG(    
    source = "einstein.jpg",
    native = FALSE
)


#### I am setting the working directory back to my mother directory -----------

setwd(mother_working_directory)


#### basic brightness and contrast enhancement --------------------------------

{
    
    # setwd(
        # paste(
            # mother_working_directory,
            # "outputs",
            # sep = "/"
        # )
    # )
    
    #### firstly, to plot a figure, we have to initialize an empty canvas -----
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = my_image,
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        my_image,
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey"
    )
    
    # jpeg::writeJPEG(
        # image = temp_image,
        # target = "einstein_original.jpg",
        # quality = 1.0
    # )
    
    
    #### now let's increase brightness of the image ---------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = ifelse(
            my_image + 0.5 > 1,
            1,
            my_image + 0.5
        ),
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        ifelse(
            my_image + 0.5 > 1,
            1,
            my_image + 0.5
        ),
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey"
    )
    
    # jpeg::writeJPEG(
        # image = ifelse(
            # my_image + 0.5 > 1,
            # 1,
            # my_image + 0.5
        # ),
        # target = "einstein_brightness_high.jpg",
        # quality = 1.0
    # )
    
    
    #### now let's decrease brightness of the image ---------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = ifelse(
            my_image - 0.5 < 0,
            0,
            my_image - 0.5
        ),
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        ifelse(
            my_image - 0.5 < 0,
            0,
            my_image - 0.5
        ),
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey"
    )
    
    # jpeg::writeJPEG(
        # image = ifelse(
            # my_image - 0.5 < 0,
            # 0,
            # my_image - 0.5
        # ),
        # target = "einstein_brightness_low.jpg",
        # quality = 1.0
    # )
    
    
    #### increasing of contrast -----------------------------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = ifelse(
            2 * (my_image - 0.5) + 0.5 > 1,
            1,
            ifelse(
                2 * (my_image - 0.5) + 0.5 < 0,
                0,
                2 * (my_image - 0.5) + 0.5
            )
        ),
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        ifelse(
            2 * (my_image - 0.5) + 0.5 > 1,
            1,
            ifelse(
                2 * (my_image - 0.5) + 0.5 < 0,
                0,
                2 * (my_image - 0.5) + 0.5
            )
        ),
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey"
    )
    
    # jpeg::writeJPEG(
        # image = ifelse(
            # 2 * (my_image - 0.5) + 0.5 > 1,
            # 1,
            # ifelse(
                # 2 * (my_image - 0.5) + 0.5 < 0,
                # 0,
                # 2 * (my_image - 0.5) + 0.5
            # )
        # ),
        # target = "einstein_contrast_high.jpg",
        # quality = 1.0
    # )
    
    
    #### decreasing of contrast -----------------------------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = ifelse(
            0.5 * (my_image - 0.5) + 0.5 > 1,
            1,
            ifelse(
                0.5 * (my_image - 0.5) + 0.5 < 0,
                0,
                0.5 * (my_image - 0.5) + 0.5
            )
        ),
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        ifelse(
            0.5 * (my_image - 0.5) + 0.5 > 1,
            1,
            ifelse(
                0.5 * (my_image - 0.5) + 0.5 < 0,
                0,
                0.5 * (my_image - 0.5) + 0.5
            )
        ),
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey",
        xlim = c(0, 1)
    )
    
    # jpeg::writeJPEG(
        # image = ifelse(
            # 0.5 * (my_image - 0.5) + 0.5 > 1,
            # 1,
            # ifelse(
                # 0.5 * (my_image - 0.5) + 0.5 < 0,
                # 0,
                # 0.5 * (my_image - 0.5) + 0.5
            # )
        # ),
        # target = "einstein_contrast_low.jpg",
        # quality = 1.0
    # )
    
    
    #### gamma increasing -----------------------------------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = my_image ^ 4,
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        my_image ^ 4,
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey",
        xlim = c(0, 1)
    )
    
    # jpeg::writeJPEG(
        # image = my_image ^ 4,
        # target = "einstein_gamma_high.jpg",
        # quality = 1.0
    # )
    
    
    #### gamma decreasing -----------------------------------------------------
    
    par(mfrow = c(1, 2))
    
    plot(
        x = c(0, dim(my_image)[2]),
        y = c(0, dim(my_image)[1]),
        type = "n",
        axes = FALSE,
        ann = FALSE
    )
    
    rasterImage(
        image = my_image ^ (1 / 4),
        xleft = 0,
        ybottom = 0,
        xright = dim(my_image)[2],
        ytop = dim(my_image)[1]
    )
    
    hist(
        my_image ^ (1 / 4),
        main = "",
        xlab = "grey",
        ylab = "absolute frequency",
        col = "lightgrey",
        xlim = c(0, 1)
    )
    
    # jpeg::writeJPEG(
        # image = my_image ^ (1 / 4),
        # target = "einstein_gamma_low.jpg",
        # quality = 1.0
    # )
    
    
    #### ----------------------------------------------------------------------
    
    # setwd(mother_working_directory)
    
    
}


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################

## hands-on ! -----------------------------------------------------------------

#### (i) try to simplify the ifelse() condition for contrast decreasing -------

my_alpha <- 0.5 # < 1

ifelse(
    my_alpha * (my_image - 0.5) + 0.5 > 1,
    1,
    ifelse(
        my_alpha * (my_image - 0.5) + 0.5 < 0,
        0,
        my_alpha * (my_image - 0.5) + 0.5
    )
)


#### (ii) try to convert the greyscaled image einstein.jpg into
#### a black-and-white image
####
#### HINT: think about an appropriate threshold -------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- jpeg::readJPEG(    
    source = "einstein.jpg",
    native = FALSE
)

setwd(mother_working_directory)

plot(
    x = c(0, dim(my_image)[2]),
    y = c(0, dim(my_image)[1]),
    type = "n",
    axes = FALSE,
    ann = FALSE
)

rasterImage(
    image = my_image,  # how to change this to get a black-noir image?
    xleft = 0,
    ybottom = 0,
    xright = dim(my_image)[2],
    ytop = dim(my_image)[1]
)


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################





