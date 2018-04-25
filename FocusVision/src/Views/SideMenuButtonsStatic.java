package Views;

import Controllers.StaticViewController;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.layout.VBox;
import org.opencv.core.Mat;


/**
 * Created by richa on 2/12/2018.
 */
public class SideMenuButtonsStatic extends VBox {
    Button saveButton;

    Mat bla;

    StaticViewController controller;

    public SideMenuButtonsStatic(StaticViewController controller) {

        this.controller =  controller;

        saveButton = new Button();
        saveButton.setText("Save");
        saveButton.setMaxWidth(90);
        saveButton.setMinWidth(90);

        saveButton.setOnAction(e ->
        {

            this.controller.saveImagePressed();

        });

        this.getChildren().addAll(saveButton);
        this.setSpacing(10);
        this.setAlignment(Pos.CENTER);
        this.setPadding(new Insets(10));

    }

}
