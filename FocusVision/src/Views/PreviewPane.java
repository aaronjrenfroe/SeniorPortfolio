package Views;

import Controllers.AbstractViewController;
import javafx.beans.property.SimpleStringProperty;
import javafx.geometry.Pos;
import javafx.scene.control.Label;
import javafx.scene.image.ImageView;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.scene.shape.Rectangle;

/**
 * Created by AaronR on 1/22/18.
 * for ?
 */

public class PreviewPane extends AnchorPane {

    // Consists of Image Preview, and BoxDrawing

    AbstractViewController controller;


    ImageView preview;
    BorderPane pane1;
    Rectangle square;


    public PreviewPane(int width, AbstractViewController controller) {
        super();
        this.controller = controller;

        commonInit(width);
        controller.setImageView(preview);

    }

    private void commonInit(int width){

        // Allows clicks to pass through
        this.setPickOnBounds(true);

        preview = new ImageView();
        preview.setStyle("-fx-background-color: #336699;");
        preview.setPreserveRatio(true);

        setStyle("-fx-background-color: #000000;");

        pane1= new BorderPane();
        pane1.setMaxWidth(width);
        pane1.setMinWidth(width);
        preview.fitWidthProperty().bind(widthProperty());

        pane1.setCenter(preview);


        AnchorPane.setRightAnchor(pane1,0.0);
        AnchorPane.setLeftAnchor(pane1,0.0);
        AnchorPane.setTopAnchor(pane1,0.0);
        AnchorPane.setBottomAnchor(pane1,0.0);

        getChildren().add(pane1);

        square = new Rectangle(controller.getBoxSize(), controller.getBoxSize());

        square.heightProperty().bind(controller.boxSizeProperty());
        square.widthProperty().bind(controller.boxSizeProperty());

        square.setFill(Color.color(0,0,0,0));
        square.setStroke(Color.color(14/255.0, 250/255.0, 250/255.0));
        getChildren().add(square);
        square.setVisible(false);
        square.setMouseTransparent(true);


        preview.setOnMouseClicked(e -> {

            if(e.getClickCount() == 2){
                square.setVisible(false);
                e.consume();
            }else {
                System.out.println("Click Location: " + e.getX() + " " + e.getY());
                controller.requestToMoveBox(e.getX(), e.getY());
            }

        });

        preview.setOnMouseDragged(e -> {
            controller.requestToMoveBox( e.getX(),  e.getY());
        });
        layoutMetrics();
    }

    private void layoutMetrics(){

        GridPane bottomMetrics = new GridPane();

        SimpleStringProperty[] metricProperties = controller.getMetrics().getProperties();

        for (int i = 0; i < metricProperties.length; i++) {
            // Top Label
            Label metricLabel = new Label();
            metricLabel.textProperty().bind(metricProperties[i]);
            // Starts from bottom to top, left to right,
            // 3, 4, 5
            // 0, 1, 2
            bottomMetrics.add(metricLabel,i%4, (metricProperties.length/4) - (i/4));

        }


        bottomMetrics.setStyle("-fx-background-color: #FFFFFF;");
        bottomMetrics.setAlignment(Pos.BOTTOM_LEFT);

        // This needs to be beautified
        // Makes the Columns equal spaced
        ColumnConstraints cc = new ColumnConstraints();
        cc.setPercentWidth(25);
        ColumnConstraints cc1 = new ColumnConstraints();
        cc1.setPercentWidth(25);
        ColumnConstraints cc2 = new ColumnConstraints();
        cc2.setPercentWidth(25);
        bottomMetrics.getColumnConstraints().add(cc);
        bottomMetrics.getColumnConstraints().add(cc1);
        bottomMetrics.getColumnConstraints().add(cc2);

        // add metrics to pane
        pane1.setBottom(bottomMetrics);

    }


    public void setBoxLocation(double x, double y){

        square.setVisible(true);
        square.setX(x);
        square.setY(y);
        System.out.println("Box Location: " + x + ", " + y);
    }

}
