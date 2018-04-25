package Models;

import Controllers.AbstractViewController;
import Controllers.DynamicPreviewController;
import Controllers.StaticViewController;
import Helpers.GlobalSettings;

import Views.BasicLayout;
import Views.PreviewPane;
import Views.SideMenu;
import Views.TopMenu;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.stage.Stage;
import org.opencv.core.Mat;

/**
 * Created by AaronR on 2/20/18.
 * for ?
 */
public class WindowFactory {


    public static Stage createLiveWindow(Stage window) {
        window.setTitle("Focus Vision");

        DynamicPreviewController controller = new DynamicPreviewController(window);

        SideMenu menu = new SideMenu(GlobalSettings.MENU_WIDTH, true, controller);

        PreviewPane preview = new PreviewPane(GlobalSettings.INITIAL_WIDTH - GlobalSettings.MENU_WIDTH, controller);
        controller.setPreviewPane(preview);
        TopMenu topMenu = new TopMenu("MAIN",controller);

        BasicLayout mainLayout = new BasicLayout();
        mainLayout.setSideMenu(menu);
        mainLayout.setPreview(preview);
        mainLayout.setTopMenu(topMenu);

        Scene scene = new Scene(mainLayout.getLayout(), GlobalSettings.INITIAL_WIDTH, GlobalSettings.INITIAL_HEIGHT, Color.GRAY);
        window.setScene(scene);
        return window;

    }


    public static Stage createStaticWindow(AbstractViewController creator, Mat mat, String windowTitle, String fileName, double selectionInfo[]) {

        Stage newWindow = new Stage();

        StaticViewController controller = new StaticViewController(mat, newWindow);

        controller.setPatientName(fileName);

        controller.setSaveLocation(creator.getSaveLocation());

        TopMenu tm = new TopMenu("VIEWER", controller);
        PreviewPane pp = new PreviewPane(GlobalSettings.INITIAL_WIDTH - GlobalSettings.MENU_WIDTH, controller);

        controller.setPreviewPane(pp);

        BasicLayout bl = new BasicLayout();

        //StaticViewModel model = new StaticViewModel();

        bl.setPreview(pp);
        bl.setSideMenu(new SideMenu(GlobalSettings.MENU_WIDTH, false, controller));
        bl.setTopMenu(tm);


        newWindow.setTitle("FocusVision | " + windowTitle);

        Scene scene = new Scene(bl.getLayout());

        newWindow.setScene(scene);

        ViewManager.getManager().addStage(controller);
        newWindow.setOnCloseRequest(e -> {
            ViewManager.getManager().removeStage(controller);
        });

        try {
            controller.updateSelection(selectionInfo[0], selectionInfo[1], selectionInfo[2]);
            controller.setInitialSelectionBox();
        } catch (NullPointerException e) {}

        return newWindow;

    }
}
