package Views;
import Controllers.AbstractViewController;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;

/**
 * Created by richa on 2/12/2018.
 */
public class SideMenuBottomZoom extends HBox
{
    Button zoomIn;
    Label percentage;  // = new Text(10, 50, "100%");
    Button zoomOut;
    AbstractViewController controller;
    ScrollButtons arrows;


    public SideMenuBottomZoom(int width, AbstractViewController controller)
    {
        super();
        this.controller = controller;

        this.setAlignment(Pos.CENTER);
        this.setAlignment(Pos.BOTTOM_CENTER);
        this.setAlignment(Pos.CENTER_RIGHT);
        setMaxWidth(width);
        setMinWidth(width);

        zoomIn = new Button();
        zoomIn.setText("+");
        zoomIn.setMaxWidth(31);
        zoomIn.setMinWidth(31);

        zoomIn.setOnAction(e ->
        {
            controller.zoomPressed(1);
        });

        percentage = new Label();
        percentage.setText("100%");
        percentage.setTextFill(Color.WHITE);

        zoomOut = new Button();
        zoomOut.setText("-");
        zoomOut.setMaxWidth(31);
        zoomOut.setMinWidth(31);

        zoomOut.setOnAction(e ->
        {
            controller.zoomPressed(-1);
        });

        arrows = new ScrollButtons(controller);

        setSpacing(10);

        getChildren().addAll(zoomOut, percentage, zoomIn, arrows);

        setAlignment(Pos.BASELINE_CENTER);
    }
}
