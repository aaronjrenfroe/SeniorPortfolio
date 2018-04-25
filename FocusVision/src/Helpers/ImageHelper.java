package Helpers;

import Processing.Mat2Image;
import javafx.scene.image.Image;
import org.opencv.core.Mat;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

import java.awt.image.BufferedImage;
import java.awt.image.DataBufferByte;
import java.io.File;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by AaronR on 2/27/18.
 * for ?
 */
public class ImageHelper {

    //save image function
    public static void saveImage(String fileName, Mat mat)
    {
        Imgcodecs.imwrite(fileName, mat);

    }

    // open Image
    public static Mat openImage(File file){

        Mat mat = Imgcodecs.imread(file.getAbsolutePath());
        return mat;
    }


    public static Image getBufferedImageFromMat(Mat mat){

        return Mat2Image.getImage2(mat);
    }

    public static double[] parseSelectionFromName(String filename){
        double selectInfo[] = new double[3];  // create array for x y and radius
        filename = filename.substring(0, filename.length()-4);  // take out .png from file name

        String temp[];

        temp = filename.split("_");  // give temp array values for split string
        if(temp.length > 3) {
            selectInfo[2] = Double.parseDouble(temp[temp.length - 1]);  // radius
            selectInfo[1] = Double.parseDouble(temp[temp.length - 2]);  // y
            selectInfo[0] = Double.parseDouble(temp[temp.length - 3]);  // x
        }
        return selectInfo;
    }



}
