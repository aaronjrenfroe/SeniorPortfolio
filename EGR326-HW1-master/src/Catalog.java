import java.util.*;

/**
 * ShoppingCart class for HW1 Software Design and Architecture
 * Created by Aaron Renfroe with Specs provided by Dr. Mi Kyung Han
 *
 *
 *
 */

public class Catalog implements Iterable<Item> {
    private Collection<Item> items;
    private String storeName;

    // constructor
    public Catalog(String name){
        this.storeName = name;
        this.items = new ArrayList<Item>();
    }
    // adds item to catalog
    public void add(Item item){
        items.add(item);
    }
    // returns name set by constructor
    public String getStoreName(){
        return this.storeName;
    }

    // searches catalog for given item name.
    public Item getItem(String name){
        Item checkItem = new Item("",0.0);
        Iterator<Item> iterator = items.iterator();
        while (iterator.hasNext()){

            checkItem = iterator.next();
            if (checkItem.getName() == name) {
                return checkItem;
            }
        }
        return checkItem;

    }
    // provides an Iterator for items in the Catalog
    public Iterator<Item> iterator(){
       return items.iterator();
    }

}
