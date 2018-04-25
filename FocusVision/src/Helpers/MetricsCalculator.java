package Helpers;

import Models.Metrics;
import javafx.scene.control.Alert;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;

/**
 * Created by AaronR on 2/18/18.
 * for Senior Capstone 2018
 */
public class MetricsCalculator {

    private static final int MEDIAN_BLUR_RADIUS = 3;

    /*
    Given Mat, center points as ratio from left to right and top to bottom, radius (meaning how far from center point in each direction, not circular) and a metrics instance
    it calculates the metrics for the submat as defined by the center point and the radius.

     */
    public static void calculateMetrics(Mat mat, double percentX, double percentY, double radiusPercent , Metrics metrics){

            // Prepossessing
            try {
                int[] boxBounds = getBoxBounds(percentX, percentY, radiusPercent, mat.width(), mat.height());
                int centerX = boxBounds[0];
                int centerY = boxBounds[1];
                int radius = boxBounds[2];



                Mat submat = mat.submat(centerY - radius, centerY + radius, centerX - radius, centerX + radius);

                // Median Blur to reduce noise
                //                 output, input, blur radius / kernel size,
                Imgproc.medianBlur(submat, submat, MEDIAN_BLUR_RADIUS);
                // Convert BRG to black and white
                // submat is now just a simple 2d matrix
                Imgproc.cvtColor(submat, submat, Imgproc.COLOR_BGR2GRAY);

                // Calculate individual metrics
                calcLaplaceVar(submat,metrics);
                calcSTD(submat, metrics);
                calculateBrightness(submat,metrics);
                calculateMichelsonContrast(submat,metrics);

            }catch(Exception af){
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("Information Dialog");
                alert.setHeaderText("Error Calculating Metrics");
                alert.setContentText("Message from exception:" + af.getMessage());

                alert.showAndWait();
            }
    }


    // Calculates the variance of the result after a Laplace Transformation
    // https://docs.opencv.org/3.0-alpha/doc/tutorials/imgproc/imgtrans/laplace_operator/laplace_operator.html
    private static void calcLaplaceVar(Mat mat, Metrics metrics){




        Mat laplaceMat = new Mat();

        // mat is the source to be filtered by laplace, laplaceMat is the destination
        // depth represents the number of colors in the image: RGB so 3
        // can also include kernel for Sobal filter https://docs.opencv.org/2.4/doc/tutorials/imgproc/imgtrans/laplace_operator/laplace_operator.html
        Imgproc.Laplacian(mat, laplaceMat, 3);

        // These are essentially 1x1 Mats that will contain their respective information
        MatOfDouble mean = new MatOfDouble();
        MatOfDouble standardDev = new MatOfDouble();

        // Given a Mat, this calculates the mean? and Standard Deviation and sets the mean and standardDev variables
        // i'm not sure what this mean as at it can be negative between -1 and 1
        Core.meanStdDev(laplaceMat, mean, standardDev);
        double standardDevd = standardDev.get(0, 0)[0];
        // Variance of Laplace Transformation
        double laplaceBasedEdgeStrengthMetric = Math.pow(standardDevd, 2);

        metrics.setEdgeStrength(laplaceBasedEdgeStrengthMetric);

    }
    // Calculates Standard Deviation of Greyscale Mat
    // aka RMS Contrast
    // https://en.wikipedia.org/wiki/Contrast_(vision)#RMS_contrast
    private static void calcSTD(Mat mat, Metrics metrics){
        MatOfDouble mean = new MatOfDouble();
        MatOfDouble standardDev = new MatOfDouble();
        Core.meanStdDev(mat, mean, standardDev);
        double standardDevd = standardDev.get(0, 0)[0];
        metrics.setStandardDeviation(standardDevd);
    }

    // Brightness is calculates as the average value of the pixels in the greyscale image.
    // then converted to a percent of 0 to 255
    private static void calculateBrightness(Mat mat, Metrics metrics){

        Scalar mean2 = Core.mean(mat);

        metrics.setBrightness((mean2.val[0] / 255.0) * 100);
    }

    // Calculates Michelson Contrast
    // https://en.wikipedia.org/wiki/Contrast_(vision)#Michelson_contrast
    private static void calculateMichelsonContrast(Mat mat, Metrics metrics){
        Core.MinMaxLocResult minMax =  Core.minMaxLoc(mat);
        double mContrast = (minMax.maxVal - minMax.minVal) / (minMax.maxVal + minMax.minVal);
        metrics.setContrast(mContrast);
    }

    // xPercent is the percent of the width from the left where the center of the box is located
    // yPercent is the percent of the height from the top where the center of the box is located
    // radiusPercent is the percent of the width, so that when multiplied by the width is the distance from the center where the edges of the box are in pixels
    // returns int[] where [0] is x, [1] is y, and 2 is radius as an int.
    private  static int[] getBoxBounds(double xPercent, double yPercent, double radiusPercent, int width, int height){

        int[] boxBounds = new int[3];
        // radius is 1/2 the side length of the box in pixels
        double radius = width * radiusPercent;

        boxBounds[0] = (int) Math.round(xPercent * width);
        boxBounds[1] = (int) Math.round(yPercent * height);
        boxBounds[2] = (int) Math.round(radius);

        return boxBounds;
    }
}
