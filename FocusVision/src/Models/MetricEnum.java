package Models;

/**
 * Created by AaronR on 3/8/18.
 * for Senior Capstone 2018
 *
 */
// USED in Metrics.class
public enum MetricEnum {

    EDGE_STRENGTH (0),
    M_CONTRAST (1),
    BRIGHTNESS(2),
    STANDARD_DEVIATION(3); // <- remember to move the semicolon down
    // New values would go here

    private int value;
    MetricEnum(int value){
        this.value = value;
    }
}
