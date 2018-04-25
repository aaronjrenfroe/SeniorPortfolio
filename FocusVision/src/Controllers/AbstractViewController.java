package Controllers;
import Helpers.GlobalSettings;
import Helpers.ImageHelper;
import Models.Metrics;
import Models.WindowFactory;
import Views.PreviewPane;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.geometry.Bounds;
import javafx.geometry.Point2D;
import javafx.geometry.Rectangle2D;
import javafx.scene.image.ImageView;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import org.opencv.core.Core;
import org.opencv.core.Mat;

import java.io.File;

/**
 * Created by Aaron Renfroe on 2/25/18.
 * for Senior Capstone 2018
 * for Dr. Jones and Dr. Rickard
 */

/*
AbstractViewController is and Abstract class that contains the functionality in common
between DynamicPreviewController and StaticViewController since both windows are nearly identical
 */
public abstract class AbstractViewController {


    String windowName;

    // Observables
    SimpleStringProperty patientName;
    SimpleStringProperty saveLocation;
    SimpleIntegerProperty boxSize;

    double[] currentBoxPosition;
    double[] selectionInfo;

    Metrics metrics; // Gets set in Child class
    Stage stage;

    ImageView imageView;
    PreviewPane previewPane;


    public AbstractViewController(String windowName, Stage stage) {

        this.stage = stage;
        this.windowName = windowName;

        imageView = new ImageView();

        // Init and setup
        patientName = new SimpleStringProperty();
        saveLocation = new SimpleStringProperty();
        boxSize = new SimpleIntegerProperty();
        boxSize.set(GlobalSettings.INITIAL_BOX_SIZE);
        patientName.set("untitled");
        saveLocation.set(System.getProperty("user.home") + "/Desktop/FocusVision/Images/");
        File file = new File(saveLocation.getValue());
        file.mkdirs();
        currentBoxPosition = new double[2];

    }

    public void setPreviewPane(PreviewPane previewPane) {
        this.previewPane = previewPane;
    }

    // open Image
    public void openImagePressed(){

        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Open Resource File");
        File file = fileChooser.showOpenDialog(stage);
        String filePath = file.getName();

        String extension = "";

        int i = filePath.lastIndexOf('.');
        if (i > 0) {
            extension = filePath.substring(i+1).toLowerCase();
        }

        if (extension.contains("png") || extension.contains("tiff") || extension.contains("tif") || extension.contains("jpg") || extension.contains("jpeg")){

            double selectInfo[] = ImageHelper.parseSelectionFromName(file.getName());

            Mat mat = ImageHelper.openImage(file);
            Stage stage = WindowFactory.createStaticWindow(this, mat, file.getAbsolutePath(), file.getName(), selectInfo);
            stage.show();
        }

    }

    public String getPatientName() {
        return patientName.get();
    }



    public void setPatientName(String patientName) {
        this.patientName.set(patientName);
    }

    public String getSaveLocation() {
        return saveLocation.get();
    }


    public void setSaveLocation(String saveLocation) {
        this.saveLocation.set(saveLocation);
    }

    public int getBoxSize() {
        return boxSize.get();
    }

    public SimpleIntegerProperty boxSizeProperty() {
        return boxSize;
    }

    public void setBoxSize(int newSize) {
        if (newSize > 10 && newSize < 120) {
            boxSize.set(newSize);
        }
        requestToMoveBox(currentBoxPosition[0], currentBoxPosition[1]);
    }

    public void setImageView(ImageView imageView){
        this.imageView = imageView;
    }

    public void requestToMoveBox(double x, double y){
        // x and y coordinates of location clicked within image

        currentBoxPosition[0] = x;
        currentBoxPosition[1] = y;

        Bounds bounds = imageView.boundsInParentProperty().getValue();

        double xReq = bounds.getMinX() + x - halfBoxSize();
        double yReq =  bounds.getMinY() + y - halfBoxSize();


        double xPos = Math.min(xReq, GlobalSettings.PreviewAreaWidth - GlobalSettings.MENU_WIDTH - (boxSize.get()) - 1);
        xPos = Math.max(xPos, bounds.getMinX());


        double yPos = Math.min(yReq, bounds.getHeight() + bounds.getMinY() - (boxSize.get()) - 1);
        yPos = Math.max(yPos, bounds.getMinY());

        updateVidCapMetricBox(x,y);

        previewPane.setBoxLocation(xPos,yPos);

    }

    protected void updateVidCapMetricBox(double centerX, double centerY){

        Bounds localBounds = imageView.getBoundsInLocal();
        double radiusWithRespectToWidth = halfBoxSize() / localBounds.getWidth();

        //TODO:  check edge cases literally
        double percentX = centerX/localBounds.getWidth();
        double percentY = centerY/localBounds.getHeight();

        percentX = Math.min(percentX, 1-(radiusWithRespectToWidth));
        percentX = Math.max(percentX, radiusWithRespectToWidth);

        percentY = Math.min(percentY, 1-(halfBoxSize() / localBounds.getHeight()));
        percentY = Math.max(percentY, boxSize.get() / localBounds.getHeight());

        updateSelection(percentX, percentY, radiusWithRespectToWidth);
        System.out.println(localBounds);
    }

    public void updateSelection(double xPercent, double yPercent, double radiusPercent){

        selectionInfo = new double[3];
        selectionInfo[0] = xPercent;//(int) Math.round(xPercent * nativeSize.width);
        selectionInfo[1] = yPercent; //(int) Math.round(yPercent * nativeSize.height);
        selectionInfo[2] = radiusPercent; //(int) Math.round(radius);

    }



    protected double halfBoxSize(){
        return boxSize.get()/2.0;
    }

    public void translatePressed(int direction)
    {

        switch (direction)
        {
            case 1:

                //System.out.println("up");

                break;
            case 2:

                //System.out.println("right");
                break;
            case 3:

                //System.out.println("down");
                break;
            case 4:

                //System.out.println("left");
                break;
            default:
                //System.out.println("default");
                break;
        }

    }

    // Needs implementation
    // Either copy and modify the mat and reset the imageView
    // or modify the imageView's viewport
    // we were not familiar enough with JavaFX to figure out the best method of implementing this
    public void zoomPressed(int value){
        // TODO: Implement this
        if(value  > 0){
            //System.out.println("Zoom in pressed");
        }else if (value < 0){
            //System.out.println("Zoom out pressed");
        }

    }

    // Called by view
    public Metrics getMetrics() {
        return metrics;
    }

    static{
        System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    }

}
