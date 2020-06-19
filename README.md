# [eRum 2020] Image processing and computer vision with R

This is a repository for purposes of a workshop _Image processing and computer vision with R_ at [eRum 2020](https://2020.erum.io/).

---

## Abstract

Although R is sometimes not considered as a number-one language for image processing, there are options for effectively handling these tasks in the R environment. Furthermore, a large R speaking community would like to combine image data analysis with other kinds of analyses by keeping all their code "under one roof" within R.

In this workshop, we will revisit available packages such as magick, imager, EBImage (and some others) written purely in R (and for R), which deal mainly with image processing. A couple of times will be dedicated to amazing Bnosac’s family of R packages enabling computer vision and some other algorithmic tasks, besides other, objects or face detection and recognition. We will also take a short look a bit deeper into state-of-the-art possibilities bridging the R environment to non-R-based libraries using API packages, namely employing of dlib R package.

---

## How to prepare yourself before the workshop

To make things even smoother, it would be great when you install the following R packages before the beginning of the workshop. We are using lots of packages we are neither authors nor maintainers of, so all the credits go to their original authors!

(i) The following packages,

`bmp`, `jpeg`, `png`, `magick`, `tesseract`, `imager`, `OpenImageR`, `BiocManager`, `dlib`, `devtools`, `remotes`

could be installed one by one in RStudio or using the code below,

```
invisible(
    
    lapply(
        
        c(  
            "bmp",
            "jpeg",
            "png",
            "magick",
            "tesseract",
            "imager",
            "OpenImageR",
            "BiocManager",
            "dlib",
            "devtools",
            "remotes"
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
            
        }
        
    )
    
)
```


(ii) The package "EBImage" is stored on Bioconductor rather than CRAN, so we need to install it following a kinda different code,

```
BiocManager::install("EBImage")
```


(iii) The Bnosac's family of R packages for computer vision requires Rtools40, devtools, and installation from GitHub. Please see the attached code for details. You are also emphasized to download the folder with files containing weights for some deep neural networks somewhere to your local drive (information about proper paths to the files with weight will be provided during the workshop),

https://drive.google.com/drive/folders/1qNKJwmANHFJs-yAXdSQXz_Bc-tGsV6SY?usp=sharing

and

https://drive.google.com/drive/folders/1qNKJwmANHFJs-yAXdSQXz_Bc-tGsV6SY?usp=sharing.

We have checked the Bnosac's packages work appropriately on Windows computers. Linux systems are also recommended. We can't guarantee they will perform well on Macs.

I hope the installation will work! I will email you a couple of minutes before the workshop with some slides and codes to be run on the workshop. See you soon via https://cesnet.zoom.us/j/94091554320?pwd=ZFNSWWxUa2hNTDVFVElKQk1BUkg4QT09!


---

## Tutors

Lubomir Stepanek, MSc., M.D. is an assistant lecturer at the Department of Biomedical Statistics, Institute of Biophysics and Informatics, First Faculty of Medicine, Charles University, and tries to finish his Ph.D. somewhere around. He is absorbed by applied biostatistics, psychometrics, facial image processing, and computer vision.

Jiri Novak, MSc. is a teaching assistant and a Ph.D. student at the Department of Economic Statistics, Faculty of Informatics and Statistics, University of Economics. He is interested in Statistical Disclosure Control and R programming.



