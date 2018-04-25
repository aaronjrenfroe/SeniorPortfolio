# Focus Vision

California Baptist University conducts research on glaucoma and is developing software tools to help detect pressure changes within an eye. Our project was creating a software program that supports a small USB high magnification macro camera. This program contains a graphical user interface for the user to navigate through as well as algorithms to retrieve metrics from live and still images. Since the camera has a narrow depth of field of 2mm, our program will calculate how in-focus an image or portion of a frame is in order to let the user know when to take a picture.

## Getting Started

Clone and download the project. 

### Prerequisites

You need to provide your own OpenCV library and (dll for windows pr dylib for mac) file for the project. 
* If you already have the OpenCV library, great just add it to the project and run the project from AppEntry
* If you do not already have OpenCV you will have to get it. See [this page](http://opencv-java-tutorials.readthedocs.io/en/latest/01-installing-opencv-for-java.html)for how to get it.


### Building

Run AppEntry

### Operation


##### Starting the Camera
Upon running the application you will be presented with the main screen with a black center pane. This is where the camera feed will appear once "Open Camera is clicked". Upon Pressing "Open Camera", the program checks for available cameras and starts the first one. To change camera's use View->Change Camera in the Top Menu. 

##### Opening an Image
An Image can be opened using File->Open in the top menu. Supported file formats are png, jpg, jpeg, tif, and tiff. We know these file formats work, however removing the limits in code might allow you to open other formats. If the image you chose was captured by this application the image will open with the previously saved selection selected and metrics visible. 

##### Making a Selection
Once the live preview has started or you have opened an image you can click on the preview and a box will appear. The metrics will be calculated for the portion of the image within this box and you should see those begin to update. Double click or double tap the box to clear the box. You can also resize the box using the control in the menu on the left. 

##### Capturing an Image
You can capture an image by pressing "Capture" in the menu on the left and a new window will appear with your captured image, selection, and metrics. Pressing recapture in the main window will replace the image in this new window. 

##### Saving an Image
An image can only be saved once it has be captured and the default save location is the Desktop in a folder named "FocusVision". You can change the save location by modifying the location at the bottom of the left menu.  From your captured window, name your image, if you have selected a portion of the image information will be append to this file name. If wanted to name your image Patient1LeftEye2, It might look like this: 

Patient1LeftEye2_0.808235294117647_0.40366013071895424_0.058823529411764705.png

An image can only be saved once it has be captured and the default save location is the Desktop in a folder named "FocusVision". You can change the save location by modifying the location at the bottom of the left menu. 





## Built With

* [OpenCV](https://docs.opencv.org/3.3.1/) - The image and camera framework used
* [JavaFX](http://www.oracle.com/technetwork/java/javase/overview/javafx-overview-2158620.html) - The UI framework used
* [Java](http://www.oracle.com/technetwork/java/index.html) - The language

## Information about the metrics
* We calculate the variance of the result of the [Laplace Operator](https://docs.opencv.org/3.0-alpha/doc/tutorials/imgproc/imgtrans/laplace_operator/laplace_operator.html) of OpenCV to give us our focus metric. 
* We utilise [Median](https://docs.opencv.org/3.0-alpha/doc/py_tutorials/py_imgproc/py_filtering/py_filtering.html?#median-blurring) and [Gausian](https://docs.opencv.org/3.0-alpha/doc/py_tutorials/py_imgproc/py_filtering/py_filtering.html?#gaussian-blurring) blurs provided by OpenCV
* We calculate the [Michelson and RMS Contrast](https://en.wikipedia.org/wiki/Contrast_(vision)). 


## Authors

* **Aaron Renfroe** - *Project Lead - [LinkedIn](https://www.linkedin.com/in/aaron-renfroe/)
* **Richard Christensen** - *Team Member* - [Email](richardarsha@yahoo.com)
* **Jp Syfacunda** - *Team Member* - [LinkedIn](https://www.linkedin.com/in/john-syfacunda-10a917106/)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Python and cv2 for quick prototyping and development
* Stack Overflow
* Department Chair and Advisors
