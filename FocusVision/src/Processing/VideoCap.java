package Processing;

/**
 * Created by AaronR on 10/12/17.
 * for ?
 */

import org.opencv.core.Mat;
import org.opencv.core.MatOfDouble;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.videoio.VideoCapture;

import java.awt.image.BufferedImage;


import org.opencv.core.Core;


public class VideoCap {

    private static VideoCap instance;

    static{
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);

    }

    private VideoCapture cap;
    private Mat2Image mat2Img;

    public void setWidth(double width) {
        this.width = width;
    }

    private double width;



    Size nativeSize;
    int cameraCount;
    int currentCamera;

    private VideoCap(){

        cap = new VideoCapture();
        countCameras();
        currentCamera = -1;
        while(!cap.isOpened()){
            nextCamera();
        }

        mat2Img = new Mat2Image();
        cap.read(mat2Img.mat);
        if(mat2Img.mat.empty()){

        }
        nativeSize = mat2Img.mat.size();

        width = nativeSize.width;

    }

    public int countCameras(){

        cameraCount = 0;
        while(true){
            VideoCapture cap = new VideoCapture();
            cap.open(cameraCount);
            if(!cap.isOpened()){
                break;
            }else{
                cameraCount ++;
                cap.release();
            }
        }
        return cameraCount;
    }

    public void nextCamera(){

        if(cameraCount > 0) {
            currentCamera = ++currentCamera % cameraCount;

            cap.release();
            cap.open(currentCamera);

        }

    }

    public static VideoCap getInstance(){
        if (instance == null){
            instance = new VideoCap();
        }
        return instance;
    }

    public Size getNativeSize() {
        return nativeSize;
    }

    public Mat getOneFrame() {

        System.gc();
        cap.read(mat2Img.mat);
        if (mat2Img.mat.empty()){

            return null;
        }else{
//            If we would like to display a lower resolution image
            Mat mat = new Mat();
            double nativeWidth = mat2Img.mat.width();

            double heightScale = this.width / nativeWidth;

            Imgproc.resize(mat2Img.mat, mat, new Size(width, heightScale * mat2Img.mat.height()));
//
//
            return mat.clone();
        }
    }


    /*
    protected void saveImage(String fileName){
        cap.read(mat2Img.mat);
        Mat mat = mat2Img.mat;
        Imgcodecs.imwrite(fileName.replace(" ", "_")+".png", mat);
    }
    */
}


