package Processing;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;

import com.sun.org.apache.xpath.internal.SourceTree;
import javafx.scene.image.Image;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfByte;
import org.opencv.imgcodecs.Imgcodecs;
import org.opencv.imgproc.Imgproc;

public class Mat2Image {

    Mat mat = new Mat();

    public Mat2Image() {}

    public static Image getImage2(Mat mat){
        if (mat == null)
        {

            return null;
        }
        MatOfByte buffer = new MatOfByte();
        Imgcodecs.imencode(".bmp",mat, buffer);
        return new Image(new ByteArrayInputStream(buffer.toArray()));
    }

    static{
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    }
}