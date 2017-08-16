# cnn-feature-point-descriptor
This repository contains the code for local image descriptors which based on convolutional neural network.
This is a part of our research, we will release more CNN descriptor models in the furture. These CNN based descriptors can be used as a replacement for other local image decriptors, such as SIFT.

Below is a guide for how to use our descriptor. We assume [Caffe](https://github.com/BVLC/caffe) and [vlfeat](http://www.vlfeat.org/) is intalled.

# USAGE:
Download the model:
```
run models/get_models.m
```

Matching 2 images (This will show the matching results on the screen.):
```
match_pairs(im1_path, im2_path)
```

Write the matching results to text for other purpose:
```
get_match_files(image_path,output_file_path,'jpg')
``` 
`image_path` is the path you place your original images. All matching results will output to `output_file_path` with files `feature_points` and `match_points`. Feature point is saved in the form of (width,height). Match point marks which two feature points from different images are matched. For example, if one match_points text is named "0000_0001", and in the text, it has one line "10 15". Then this means the 11th feature point in image 0000 matches the 16th feature point in image 0001. Match point counts start from zero.
