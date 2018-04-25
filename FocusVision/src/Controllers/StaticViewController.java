package Controllers;

import Controllers.AbstractViewController;
import Helpers.ImageHelper;
import Helpers.MetricsCalculator;

import Models.Metrics;
import javafx.geometry.Bounds;
import javafx.geometry.Point2D;
import javafx.scene.control.Alert;

import javafx.scene.control.ButtonBar;
import javafx.scene.control.ButtonType;
import javafx.scene.image.ImageView;
import javafx.stage.Stage;
import org.opencv.core.Mat;

import java.io.File;
import java.util.Optional;


/**
 * Created by AaronR on 2/25/18.
 * for Software Engineering Senior Capstone 2018
 */

/*
  Controller for the static image viewer window for viewing an opened image or captured image
*/
public class StaticViewController extends AbstractViewController {
    // pass it a Mat or pass it a png

    Mat mat;

    public StaticViewController(Mat image, Stage stage){
        super("", stage);
        metrics = new Metrics(false);
        mat = image;
    }

    @Override
    public void setImageView(ImageView imageView){
        this.imageView = imageView;
        if (this.mat != null) {
            this.imageView.setImage(ImageHelper.getBufferedImageFromMat(this.mat));
        }

    }

    public void setMat(Mat mat){
        this.mat = mat;
        this.imageView.setImage(ImageHelper.getBufferedImageFromMat(this.mat));
        updateMetrics();
    }

    @Override
    public void updateSelection(double xPercent, double yPercent, double radiusPercent) {
        super.updateSelection(xPercent, yPercent, radiusPercent);
        updateMetrics();
    }

    private void updateMetrics(){
        MetricsCalculator.calculateMetrics(this.mat, selectionInfo[0], selectionInfo[1], selectionInfo[2] , metrics);
    }

    // save Image
    public void saveImagePressed(){


        File theDir = new File(this.getSaveLocation());
        // if the directory does not exist, create it
        if (!theDir.exists()) {

            try{
                theDir.mkdirs();
            }
            catch(SecurityException se){
                //handle it

                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("Exception Dialog");
                alert.setHeaderText("An Exception was caught while trying to save an image");
                alert.setContentText(se.getMessage());

                alert.showAndWait();
            }
        }


        String outputName = this.getSaveLocation()+"/"+this.getPatientName();

        try {
            //metrics in order displayed: xPercent, yPercent, Radius
            outputName = outputName.replace(" ", "_") + "_" + selectionInfo[0] + "_" + selectionInfo[1] +
                    "_" + selectionInfo[2] + ".png";
        } catch (NullPointerException e) {
            //metrics not displayed because there is no box in image
            outputName = outputName.replace(" ", "_") + ".png";
        }


        File file = new File(outputName);

        if(file.exists()) {
            ButtonType foo = new ButtonType("Yes", ButtonBar.ButtonData.YES);
            ButtonType bar = new ButtonType("Cancel", ButtonBar.ButtonData.CANCEL_CLOSE);
            Alert alert = new Alert(Alert.AlertType.WARNING, "Would you like to overwrite the existing image?", foo, bar);
            alert.setHeaderText("File exists with the name: \"" + this.getPatientName()+"\"");
            alert.setTitle("Action Needed");

            Optional<ButtonType> result = alert.showAndWait();

            if (result.isPresent() && result.get() == foo) {
                ImageHelper.saveImage(outputName, this.mat);
            }

        }else{
            ImageHelper.saveImage(outputName, this.mat);
        }
    }


    // Not being Used yet
    // given x and y percent set the box location over that point.
    public void setInitialSelectionBox() {
        // localBounds are incorrect until shortly after stage is presented which is why we wait.
        new java.util.Timer().schedule(
                new java.util.TimerTask() {
                    @Override
                    public void run() {

                        Bounds localBounds = imageView.getBoundsInLocal();

                        double halfBoxWidthInPixels = selectionInfo[2] * localBounds.getWidth();
                        double centerX = (selectionInfo[0] * localBounds.getWidth()) - (halfBoxWidthInPixels);
                        double centerY = (selectionInfo[1] * localBounds.getHeight()) - (halfBoxWidthInPixels);

                        System.out.println("X: " + selectionInfo[0] * localBounds.getWidth() + "Y: " + selectionInfo[1] * localBounds.getHeight());
                        System.out.println(localBounds);
                        Point2D newPoxPos = imageView.localToParent(centerX, centerY);
                        previewPane.setBoxLocation(newPoxPos.getX(), newPoxPos.getY());

                    }
                },
                500
        );

    }

}

