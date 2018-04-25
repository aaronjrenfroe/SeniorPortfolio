package Views;

import Controllers.AbstractViewController;
import javafx.geometry.Pos;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;

/**
 * Created by richa on 2/28/2018.
 */
public class ScrollButtons extends BorderPane
{
    AbstractViewController controller;


    public ScrollButtons(AbstractViewController controller)
    {
        this.controller = controller;


        Button buttonLeft = new Button("<");
        Button buttonUp = new Button("^");
        Button buttonRight = new Button(">");
        Button buttonDown = new Button("v");
        Button buttonClear = new Button("  ");
        buttonClear.setDisable(true);
        setAlignment( buttonLeft, Pos.CENTER);
        setAlignment( buttonUp, Pos.CENTER);
        setAlignment( buttonRight, Pos.CENTER);
        setAlignment( buttonDown, Pos.CENTER);
        setAlignment( buttonClear, Pos.CENTER);


        buttonLeft.setOnAction(e-> {
            controller.translatePressed(4);
        });
        buttonUp.setOnAction(e-> {
            controller.translatePressed(1);
        });
        buttonRight.setOnAction(e-> {
            controller.translatePressed(2);
        });
        buttonDown.setOnAction(e-> {
            controller.translatePressed(3);
        });

        setLeft(buttonLeft);
        setTop(buttonUp);
        setRight(buttonRight);
        setBottom(buttonDown);
        setCenter(buttonClear);
    }
}
