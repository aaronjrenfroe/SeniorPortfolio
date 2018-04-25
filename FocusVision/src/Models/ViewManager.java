package Models;

import Controllers.AbstractViewController;
import Controllers.DynamicPreviewController;
import Controllers.StaticViewController;

import java.util.ArrayList;

/**
 * Created by AaronR on 1/22/18.
 * for ?
 */
public class ViewManager {

    private static ViewManager manager;
    private ArrayList<AbstractViewController> views;
    private ViewManager() {
        views = new ArrayList();
    }
    DynamicPreviewController controller;

    int totaleViewCreated = 0;

    public static ViewManager getManager(){
        if(manager == null){
            manager = new ViewManager();
        }
        return manager;
    }

    public void setPrimaryController(DynamicPreviewController controller){
        this.controller = controller;
    }

    public DynamicPreviewController getPrimaryStage(){
        return controller;
    }

    public void addStage(AbstractViewController view){
        views.add(view);
        totaleViewCreated ++;
    }

    public void removeStage(AbstractViewController view){
        if (view == getLast()){
            controller.lastCreatedCaptureDeleted();
        }
        if(views.contains(view)){
            views.remove(view);
        }
    }

    public StaticViewController getLast(){
        if(views.size() >= 0) {
            return (StaticViewController) views.get(views.size() - 1);
        }
        return null;
    }

    public int getTotalViewsCreated(){
        return totaleViewCreated;
    }

}
