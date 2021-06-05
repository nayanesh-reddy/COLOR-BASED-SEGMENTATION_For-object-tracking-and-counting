# COLOR-BASED SEGMENTATION (For object tracking and counting)

In this project a color image in RGB format is segmented based on the selected color using HSV color model. This is achieved by thresholding the H, S and V channels by using the threshold values from an Android app which provides an interactive way to select those values. The segmented image forms a binary mask which is used for further processing (like morphological operations) and by applying connected-components algorithm (CCL) we can find number of objects in the image and can be used for tracking an object of specified color in case of video which is a temporal sequence of images. The tracking is done by drawing the object’s path using line drawing algorithms and regional properties such as Centroid and Area of regions. 
Finally, I am going to implement a MATLAB code by using which we can draw and fill any closed contours with specific color using the color-based object tracking approach. (like an Augmented Reality (AR) based application that can draw in air)

#
### FLOW CHART 
![flow_chart](https://user-images.githubusercontent.com/84563214/120884256-aaee2c00-c5ff-11eb-8660-7ac95c4dc204.png)

#
### Connected-component labeling (CCL)
It uses pixel connectivity for labeling the components in the binary image. This can be implemented by two-pass algorithm, (also known as the Hoshen–Kopelman algorithm) iterates through 2-dimensional binary data. 
The algorithm makes two passes over the image.

    1. The first pass to assign temporary labels and record equivalences.

    2. The second pass to replace each temporary label by the smallest label of its equivalence class.

<img width="776" alt="CCL" src="https://user-images.githubusercontent.com/84563214/120885186-31f1d300-c605-11eb-966a-9492b0233f79.png">
