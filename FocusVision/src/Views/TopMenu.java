package Views;

import Controllers.AbstractViewController;
import Controllers.DynamicPreviewController;
import Controllers.StaticViewController;
import Models.ViewManager;
import javafx.application.Platform;
import javafx.scene.control.*;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;

import java.awt.*;
import java.net.URL;

/**
 * Created by AaronR on 2/5/18.
 * for ?
 */
public class TopMenu extends MenuBar {

    AbstractViewController controller;

    public TopMenu(String forWindow, AbstractViewController controller) {
        this.controller = controller;

        switch(forWindow){
            case "MAIN":
                initForMainWindow();
                break;
            case "VIEWER":
                initForViewWindow();
                break;
            default:
                break;
        }
    }

    private void initForViewWindow(){
        StaticViewController staticController = (StaticViewController) controller;

        Menu fileMenu = new Menu("_File");
        MenuItem openOption = new MenuItem("Open");
        MenuItem saveOption = new MenuItem("Save");
        MenuItem sep = new SeparatorMenuItem();

        saveOption.setOnAction(e -> {

            staticController.saveImagePressed();

        });

        openOption.setOnAction(e -> {

            staticController.openImagePressed();

        });



        fileMenu.getItems().addAll(openOption, saveOption, sep);

        // Help Menu
        Menu helpMenu = new Menu("_Help");
        MenuItem openGithub = new MenuItem("View On Github");
        openGithub.setOnAction(e -> {
            openWebpage("https://github.com/aaronjrenfroe/FocusVision");
        });
        helpMenu.getItems().addAll(openGithub);

        this.getMenus().addAll(fileMenu, helpMenu);
    }

    private void initForMainWindow(){
        Menu fileMenu = new Menu("_File");
        MenuItem openOption = new MenuItem("Open Image");

        // we need functions that are specific to DynamicPreviewController

        if(controller.getClass() == DynamicPreviewController.class) {
            DynamicPreviewController dController = (DynamicPreviewController) controller;

            openOption.setOnAction(e -> {

                controller.openImagePressed();

            });

            MenuItem sep = new SeparatorMenuItem();
            MenuItem exitOption = new MenuItem("Exit");
            exitOption.setOnAction(e -> {
                ViewManager.getManager().getPrimaryStage().killTimer();
                Platform.exit();
            });
            fileMenu.getItems().addAll(openOption, sep, exitOption);


            Menu viewMenu = new Menu("_View");
            MenuItem changeCamera = new MenuItem("Change Camera");

            changeCamera.setOnAction(e -> {
                dController.recountCameraPressed();
                dController.changeCameraPressed();
            });




            viewMenu.getItems().addAll(changeCamera);


            // Help Menu
            Menu helpMenu = new Menu("_Help");
            MenuItem openGithub = new MenuItem("View On Github");
            openGithub.setOnAction(e -> {
                openWebpage("https://github.com/aaronjrenfroe/FocusVision");
            });
            helpMenu.getItems().addAll(openGithub);

            this.getMenus().addAll(fileMenu, viewMenu, helpMenu);
        }
    }


    private static boolean openWebpage(String strUrl) {

        Desktop desktop = Desktop.isDesktopSupported() ? Desktop.getDesktop() : null;
        if (desktop != null && desktop.isSupported(Desktop.Action.BROWSE)) {
            try {
                desktop.browse(new URL(strUrl).toURI());
                return true;
            } catch (Exception e) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("Error");
                alert.setHeaderText("Could not open web page");
                alert.setContentText("Exception message: " + e.getMessage());

                alert.showAndWait();
            }
        }
        return false;
    }



}
