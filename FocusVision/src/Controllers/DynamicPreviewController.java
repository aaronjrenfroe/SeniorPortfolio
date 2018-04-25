package Controllers;


import Models.Metrics;
import Models.ViewManager;
import Models.WindowFactory;
import Processing.Mat2Image;
import Helpers.MetricsCalculator;
import Processing.VideoCap;

import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.scene.control.Alert;
import javafx.stage.Stage;
import org.opencv.core.Mat;


import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by AaronR on 2/25/18.
 * for ?
 */

/*
  Controller for the viewing the live view from a camera
*/
public class DynamicPreviewController extends AbstractViewController {

    // use to refresh frame
    private Timer timer;

    VideoCap cap;
    SimpleBooleanProperty recaptureButtonDisabledProperty;
    private SimpleStringProperty captureButtonText;

    boolean hasStartedCapturing = false;


    public SimpleStringProperty captureButtonTextProperty() {
        return captureButtonText;
    }



    public DynamicPreviewController(Stage stage) {
        super("FocusVision", stage);
        metrics = new Metrics(true);
        captureButtonText = new SimpleStringProperty("Open Camera");
        ViewManager.getManager().setPrimaryController(this);

        recaptureButtonDisabledProperty = new SimpleBooleanProperty();
        recaptureButtonDisabledProperty.set(true);

    }

    private void startCameraInit(){
        cap = VideoCap.getInstance();
        // This is on a delay because on initialization
        // the pane doesn't have a size

        this.timer = new Timer();
        timer.scheduleAtFixedRate(getFrameUpdater(metrics),0,33);
    }


    private TimerTask getFrameUpdater(Metrics metrics){

        return new TimerTask(){
            @Override
            public void run() {
                Mat mat = cap.getOneFrame();
                if (mat != null) {
                    imageView.setImage(Mat2Image.getImage2(mat));

                    if (selectionInfo != null) {
                        MetricsCalculator.calculateMetrics(mat, selectionInfo[0], selectionInfo[1], selectionInfo[2], metrics);
                    }
                }
            }
        };
    }

    // capture image
    public void captureImagePressed(){
        if(hasStartedCapturing) {


            Stage newWindow = WindowFactory.createStaticWindow(this, VideoCap.getInstance().getOneFrame(), "Capture " + (ViewManager.getManager().getTotalViewsCreated() + 1), patientName.get(), selectionInfo);
            newWindow.show();
            recaptureButtonDisabledProperty.setValue(false);
        }else{

            startCameraInit();
            hasStartedCapturing = true;
            captureButtonText.set("Capture");
        }

    }

    // recapture Image
    public void reCaptureImagePressed(){

        StaticViewController staticController = ViewManager.getManager().getLast();
        if(staticController != null){
            staticController.setMat(VideoCap.getInstance().getOneFrame());
        }
    }

    public void changeCameraPressed(){
        // Kills the thread that refreshes the image shown.
        killTimer();

        // There was an issue getting the VidCap Instance
        // and resetting the timer right away and this fixed it
        try{
            Thread.sleep(300);
            VideoCap.getInstance().nextCamera();
            timer = new Timer();
            timer.scheduleAtFixedRate(getFrameUpdater(metrics), 0, 33);
        }catch (InterruptedException e){ // Thrown by Thread.sleep
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Information Dialog");
            alert.setHeaderText("Error Sleeping frame updater thread");
            alert.setContentText(e.getMessage());
            alert.showAndWait();
        }

    }

    public void recountCameraPressed(){
        VideoCap.getInstance().countCameras();
    }

    public void lastCreatedCaptureDeleted(){
        recaptureButtonDisabledProperty.setValue(true);
    }

    public SimpleBooleanProperty getRecaptureButtonDisabledProperty() {
        return recaptureButtonDisabledProperty;
    }

    public void killTimer(){
        if(this.timer != null) {
            this.timer.cancel();
            this.timer.purge();
        }


    }



}
