/**
 * Created by Aaron Renfroe on 1/22/18.
 * for Software Engineering Senior Capstone 2017-2018
 * Team Members were Jp Syfacunda, Richard Christensen, and Aaron Renfroe
 * If something breaks as Aaron Renfroe @ aaronjrenfroe@gmail.com
 */

import Models.ViewManager;
import Models.WindowFactory;
import javafx.application.Application;
import javafx.application.Platform;
import javafx.stage.Stage;


public class AppEntry extends Application{


    Stage window;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws Exception {

        this.window = WindowFactory.createLiveWindow(primaryStage);

        window.setOnCloseRequest(e -> {
            e.consume();
            onClose();
        });

        this.window.show();
    }

    private void onClose(){
        // Terminating FX App
        ViewManager.getManager().getPrimaryStage().killTimer();
        window.close();
        Platform.exit();

    }

    @Override
    public void stop() throws Exception {
        super.stop();
        // Stopping JVM
        System.exit(0);
    }
}
