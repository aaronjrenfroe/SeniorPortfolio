package Utils;
import java.util.*;

/**
 * Created by AaronR on 3/11/17.
 * for Reasons
 */
public class MapUtil {
    public static <K, V extends Comparable<? super V>> Map<K, V> sortByValue( Map<K, V> map ) {
        List<Map.Entry<K, V>> list =
                new LinkedList<Map.Entry<K, V>>( map.entrySet() );
        Collections.sort( list, new Comparator<Map.Entry<K, V>>() {
            public int compare( Map.Entry<K, V> o1, Map.Entry<K, V> o2 ) {

                int res = (o1.getValue()).compareTo( o2.getValue() );
                if (res == 0){
                    return (((String)o1.getKey()).compareTo((String)o2.getKey()));
                }else {
                    return res;
                }
            }
        } );

        Map<K, V> result = new LinkedHashMap<K, V>();
        for (Map.Entry<K, V> entry : list) {
            result.put( entry.getKey(), entry.getValue() );
        }
        return result;
    }
}
