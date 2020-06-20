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
            "magick",
            "tesseract"
            
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
    !"_02_image_processing_.R" %in% dir()
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

## magick -- R package --------------------------------------------------------

#### -- on the top of ImageMagick: an open-source image processing library
#### -- supports common formats such as png, jpeg, tiff, pdf, etc.
####    and different manipulations like rotate, scale, crop, trim, flip,
####    blur, etc.

#### reading an image into R console ------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- magick::image_read("toco_toucan.jpg")

setwd(mother_working_directory)


#### basic info about the image -----------------------------------------------

print(my_image)


#### viewing the image --------------------------------------------------------

plot(my_image)


#### writing the image in gray ------------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "outputs",
        sep = "/"
    )
)

magick::image_write(
    image = my_image,
    path = "toco_toucan_in_gray.png",
    format = "png"
)

setwd(mother_working_directory)


#### image modulations: brightness, saturation, hue ---------------------------

plot(
    magick::image_modulate(
        my_image,
        brightness = 120,
        saturation = 50,
        hue = 50
    )
)


#### image manipulations ------------------------------------------------------

plot(
    image_rotate(  # angle rotation of an image
        my_image,
        degrees = 45
    )
)

plot(
    image_flip(  # the image is now upside-down
        my_image
    )
)

plot(
    image_flop(  # the image is now horizontally inverted
        my_image
    )
)


#### image cropping -----------------------------------------------------------

###### the geometry argument follows a form of
###### 
######    <width>x<height>{+-}<xoffset>{+-}<yoffset>,
###### 
###### where xoffset and yoffset are used with either + or - to offset
###### the image with respect to the left or top edges

plot(
    magick::image_crop(
        my_image,
        geometry = "650x250"   # a rectangle of 650x250 pixels
                               # in the left upper corner of the image
    )
)

plot(
    magick::image_crop(
        my_image,
        geometry = "400x400+600+100"
                               # a square of 400x400 pixels
                               # with left edge placed 600 pixels in from
                               # the left edge of the image
                               # and
                               # with top edge of the object placed 100 pixels
                               # below the top edge of the image
    )
)


#### image rescaling ----------------------------------------------------------

plot(
    magick::image_scale(
        my_image,
        geometry = "120x120"
    )
)


#### filtering ----------------------------------------------------------------

plot(
    magick::image_blur(  # blurring
        my_image,
        radius = 15,
        sigma = 10
    )
)

plot(
    magick::image_blur(  # even more significant blurring
        my_image,
        radius = 100,
        sigma = 50
    )
)

plot(
    magick::image_noise( # gaussian noise
        my_image,
        noisetype = "gaussian"
    )
)

plot(
    magick::image_reducenoise( # denoising
        magick::image_noise(
            my_image,
            noisetype = "gaussian"
        ),
        radius = 5
    )
)

plot(
    magick::image_negate( # a negative image
        my_image
    )
)

plot(
    magick::image_quantize(  # a greyscaled image
        my_image,
        colorspace = "gray"
    )
)


#### optical character recognition --------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)


my_image_with_text <- magick::image_read("r_for_data_science.jpg")


setwd(mother_working_directory)


plot(
    my_image_with_text
)


#### let's crop the image such that it contains only text ---------------------

plot(
    image_crop(
        my_image_with_text,
        geometry = "270x120+20+250"
    )
)

my_image_with_text <- image_crop(
    my_image_with_text,
    geometry = "270x120+20+250"
)


#### do the OCR ---------------------------------------------------------------

cat(image_ocr(my_image_with_text))


#### another example of OCR ---------------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)


my_image_with_text <- magick::image_read("r_has_changed.jpg")


setwd(mother_working_directory)


plot(
    my_image_with_text
)


#### let's crop the image such that it contains only text ---------------------

plot(
    image_crop(
        my_image_with_text,
        geometry = "450x800+650+100"
    )
)

my_image_with_text <- image_crop(
    my_image_with_text,
    geometry = "450x800+650+100"
)


#### do the OCR ---------------------------------------------------------------

cat(image_ocr(my_image_with_text))


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################

## EBImage -- R package -------------------------------------------------------

## while EBImage package has been originally intended for biolgists,
## it provides general purpose functionality for image processing and analysis

## the package "EBImage" is stored on Bioconductor rather than CRAN,
## so we need to install and initialize it the following code -----------------

if(!requireNamespace("BiocManager", quietly = TRUE)){
    
    install.packages("BiocManager")
    
}
    
BiocManager::install("EBImage")
library("EBImage")


## loading an image -----------------------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- EBImage::readImage("parrots.jpg")

setwd(mother_working_directory)


## viewing the image ----------------------------------------------------------

display(my_image)  # in a browser

display(
    my_image,
    method = "raster"
)                  # in R environment

print(my_image)    # basic image properties

hist(my_image)     # histogram of pixel intensities for all (R, G, B) channels


## brightness adjustment ------------------------------------------------------

display(
    my_image + 0.3,  # a bit more intense
    method = "raster"
)

display(
    my_image - 0.3,  # a bit darker
    method = "raster"
)


## contrast adjustment --------------------------------------------------------

display(
    my_image * 2.0,  # more contrast
    method = "raster",
    all = T
)

display(
    my_image * 0.5,  # less contrast
    method = "raster"
)


## gamma correction -----------------------------------------------------------

display(
    my_image ** 4.0,  # non-linear decrease of intensity
    method = "raster"
)

display(
    my_image ** 0.5,  # non-linear increase of intensity
    method = "raster"
)


## image cropping -------------------------------------------------------------

display(
    my_image[200:500, 100:300, ],
    method = "raster"
)


## spatial transformations ----------------------------------------------------

display(
    resize(
        my_image,
        w = 200  # width of the resized image
    ),
    method = "raster"
)

display(
    flip(my_image),
    method = "raster"
)

display( #### the same ...
    my_image[, dim(my_image)[2]:1, ],
    method = "raster"
)

display(
    flop(my_image),
    method = "raster"
)

display( #### the same ...
    my_image[dim(my_image)[1]:1, , ],
    method = "raster"
)

display( #### rotated by 90° and translated by (+200, +100) pixels
    translate(rotate(my_image, 90), v = c(200, 100)), 
    method = "raster"
)


## colour management ----------------------------------------------------------

temp_image <- my_image

colorMode(temp_image) <- Grayscale

display(
    temp_image,
    method = "raster",
    all = TRUE
)


## image denoising ------------------------------------------------------------

temp_image <- my_image

set.seed(123)
noisy_pixel_indices <- sample(
    x = length(temp_image),
    size = length(temp_image) / 10
)

temp_image[noisy_pixel_indices] <- runif(
    length(temp_image) / 10,
    min = 0,
    max = 1
)

display(
    temp_image,
    method = "raster"
)

display(
    medianFilter(
        temp_image,
        size = 2 # the lower integer, the better denoising
    ),
    method = "raster"
)

hist(
    temp_image
)


## image filtering ------------------------------------------------------------

#### low-pass filtering is used to perform blur image, remove noise, etc.
#### high-pass filtering is used to perform detect edges, sharpen images etc.

#### low-pass filtering

display(
    filter2(
        my_image,
        makeBrush(
            size = 21,
            shape = "disc",
            step = FALSE
        ) ^ 2 / sum(
            makeBrush(
                size = 21,
                shape = "disc",
                step = FALSE
            )
        )
    ),
    method = "raster"
)


#### high-pass filtering

my_phi <- matrix(1, nc = 3, nr = 3)
my_phi[2, 2] <- -8

display(
    filter2(
        my_image,
        my_phi
    ),
    method = "raster"
)


## thresholding ---------------------------------------------------------------

temp_image <- my_image[, , 3]  # taking only blue intensities

colorMode(temp_image) <- Grayscale # grayscaling

display(
    temp_image,
    method = "raster"
)

display(
    ifelse(
        temp_image < 0.5,
        0,
        1
    ),
    method = "raster"
)

display(
    ifelse(
        temp_image < otsu(temp_image), # Otsu's threshold
        0,
        1
    ),
    method = "raster"
)


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################

## a use case: counting matches in a heap -------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- readImage("heap_of_matches.jpg")

setwd(mother_working_directory)

display(
    my_image,
    method = "raster"
)


## increasing contrast of a monochromatic image -------------------------------

display(
    my_image[, , 2],
    method = "raster"
)

my_image <- imageData(my_image)[, , 2] * 10

display(
    my_image,
    method = "raster"
)


## applying of gaussian blurring ----------------------------------------------

my_image <- filter2(
    
    my_image,
    makeBrush(
        size = 15,
        shape = "gaussian",
        sigma = 5
    )
    
)

display(
    my_image,
    method = "raster"
)


## reducing the contrast ------------------------------------------------------

my_image <- my_image / 10

display(
    ifelse(
        my_image < otsu(my_image),
        0,
        1
    ),
    method = "raster"
)


par(mfrow = c(10, 10))

for(my_threshold in seq(0.01, 1.00, by = 0.01)){
    
    display(
        ifelse(
            my_image < my_threshold,
            0,
            1
        ),
        method = "raster"
    )
    text(
        x = 120,
        y = 100,
        label = as.character(my_threshold),
        cex = 0.8
    )
    
}


display(
    ifelse(
        my_image < 0.02,
        0,
        1
    ),
    method = "raster"
)


## counting the blobs ---------------------------------------------------------

max(bwlabel(my_image < 0.02))  # 20

## a true count of the matches in the heap is 22 (I guess)


## ----------------------------------------------------------------------------

###############################################################################

## hands-on! ------------------------------------------------------------------

## set the appropriate threshold to automatically count up how many cells
## there are in the image cells.jpg -------------------------------------------

setwd(
    paste(
        mother_working_directory,
        "inputs",
        sep = "/"
    )
)

my_image <- readImage("cells.jpg")

setwd(mother_working_directory)

display(
    my_image,
    method = "raster"
)

display(
    my_image * 4,  # more contrast
    method = "raster"
)


## blurring the image ---------------------------------------------------------

w <- makeBrush(size = 11, shape = 'gaussian', sigma = 5)  # the blurring brush

my_blurred_image = filter2(
    my_image * 2,
    w
) # applying the blurring filter

display(
    my_blurred_image * 4,
    method = "raster"
)


## thresholding ---------------------------------------------------------------

my_gray_image <- channel(my_blurred_image, "gray")

display(
    my_gray_image * 4,
    method = "raster"
)


## THIS IS TO BE MODIFIED ! ---------------------------------------------------

my_threshold <- otsu(my_gray_image)# an appropriate value of the threshold

## ----------------------------------------------------------------------------


display(
    ifelse(my_gray_image > my_threshold, 1, 0),
    method = "raster"
)

max(
    bwlabel(
        ifelse(my_gray_image > my_threshold, 1, 0)
    )
) # automatically estimated count of the cells


## ----------------------------------------------------------------------------

###############################################################################
###############################################################################
###############################################################################





