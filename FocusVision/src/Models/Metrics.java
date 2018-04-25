package Models;

import javafx.application.Platform;
import javafx.beans.property.SimpleStringProperty;

import java.util.EnumMap;

/**
 * Created by AaronR on 1/26/18.
 * for ?
 */
public class Metrics {
    // ============= HOW TO ADD A NEW METRIC =================
    // you need to add it to the MetricEnum class file
    // it's easy go look at it...
    // and then follow the steps enumerated below
    private static  final int NUMBER_OF_METRICS = MetricEnum.values().length;

    private static final int STATIC_BUFFER__SIZE = 1;
    private static final int DYNAMIC_BUFFER_SIZE = 5;
    private int bufferSize;

    // Step 1) Give your metric a label
    private static final String EDGE_STRENGTH_LABEL = "Laplace Variance: ";
    private static final String CONTRAST_LABEL = "Michelson Contrast: ";
    private static final String BRIGHTNESS_LABEL = "Brightness: ";
    private static final String STANDARD_DEVIATION_LABEL = "Standard Deviation: ";

    private SimpleStringProperty [] properties;

    // ADD BUFFERS
    // ADD GETTERS AND SETTERS

    private int[] bufferPositions;
    private double[][] buffers;

    // Constructor
    /*
        Given boolean isLive Metrics is the class the manages the image metrics once a box is placed on the screen.
        if isLive, metrics keeps a running average of the last DYNAMIC_BUFFER_SIZE results to smooth the metrics displayed on screen
        if !isLive metrics just provides the requested metric for the given selection
     */
    public Metrics(boolean isLive){

        bufferSize = isLive ? DYNAMIC_BUFFER_SIZE : STATIC_BUFFER__SIZE;

        properties = new SimpleStringProperty[NUMBER_OF_METRICS];
        buffers = new double[NUMBER_OF_METRICS][bufferSize];

        for (int i = 0; i < properties.length; i++) {
            properties[i] = new SimpleStringProperty();
            buffers[i] = new double[bufferSize];
        }

        // Step 2) Set your Label
        properties[MetricEnum.EDGE_STRENGTH.ordinal()].set(EDGE_STRENGTH_LABEL + "n/a");
        properties[MetricEnum.M_CONTRAST.ordinal()].set(CONTRAST_LABEL + "n/a");
        properties[MetricEnum.BRIGHTNESS.ordinal()].set(BRIGHTNESS_LABEL + "n/a");
        properties[MetricEnum.STANDARD_DEVIATION.ordinal()].set(STANDARD_DEVIATION_LABEL + "n/a");

        bufferPositions = new int[NUMBER_OF_METRICS];

    }

    // Step 3) create a SETTER for it
    public void setContrast(double michelsonContrast) {

        updateBuffer(michelsonContrast, MetricEnum.M_CONTRAST);
        String string = CONTRAST_LABEL + getFormatedMetric(MetricEnum.M_CONTRAST);
        setProperty(string, MetricEnum.M_CONTRAST);
    }

    public void setEdgeStrength(double laplace) {

        updateBuffer(laplace, MetricEnum.EDGE_STRENGTH);
        String string = EDGE_STRENGTH_LABEL + getFormatedMetric(MetricEnum.EDGE_STRENGTH);
        setProperty(string, MetricEnum.EDGE_STRENGTH);
    }

    public void setBrightness(double brightness) {

        updateBuffer(brightness, MetricEnum.BRIGHTNESS);
        String string = BRIGHTNESS_LABEL + getFormatedMetric(MetricEnum.BRIGHTNESS) + "%";
        setProperty(string, MetricEnum.BRIGHTNESS);
    }

    public void setStandardDeviation(double stdDev) {

        updateBuffer(stdDev, MetricEnum.STANDARD_DEVIATION);
        String string = STANDARD_DEVIATION_LABEL+ getFormatedMetric(MetricEnum.STANDARD_DEVIATION);
        setProperty(string, MetricEnum.STANDARD_DEVIATION);
    }

    private void setProperty(String valueAsString, MetricEnum property){
        int index = property.ordinal();
        Platform.runLater(() -> properties[index].set(valueAsString));
    }

    private void updateBuffer(double value, MetricEnum property){
        int index = property.ordinal();
        buffers[index][bufferPositions[property.ordinal()]] = value;

        bufferPositions[index] += 1;

        if (bufferPositions[index] == bufferSize){
            bufferPositions[index] = 0;
        }
    }

    private double getMeanFor(MetricEnum property){
        double [] array = buffers[property.ordinal()];

        double sum = 0.0;
        for (double d : array) sum += d;
        return sum/array.length;
    }

    private String formatDecimals(double d){
        return String.format("%.2f", d);
    }

    private String getFormatedMetric(MetricEnum property){
        return formatDecimals(getValueFor(property));
    }
    public SimpleStringProperty[] getProperties() {
        return properties;
    }

    public double getValueFor(MetricEnum property){
        return getMeanFor(property);
    }
}
