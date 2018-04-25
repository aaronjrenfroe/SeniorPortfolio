package Views;

import Helpers.GlobalSettings;
import javafx.scene.Node;
import javafx.scene.layout.BorderPane;

/**
 * Created by AaronR on 2/5/18.
 * for ?
 */
public class BasicLayout{

    private BorderPane layout;

    public BasicLayout() {
        this.layout = new BorderPane();
        layout.widthProperty().addListener( (obs, oldVal, newVal) -> {

            GlobalSettings.PreviewAreaWidth = (double)newVal;
        });
        layout.heightProperty().addListener( (obs, oldVal, newVal) -> {

            GlobalSettings.PreviewAreaHeight = (double)newVal;
        });
    }

    public void setPreview(Node preview){
        layout.setCenter(preview);
    }

    public void setTopMenu(Node topMenu){
        layout.setTop(topMenu);
    }

    public void setSideMenu(Node sideMenu){
        layout.setLeft(sideMenu);
    }

    public BorderPane getLayout() {
        return layout;
    }
}
