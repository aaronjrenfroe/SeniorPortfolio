import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Iterator;


public class ShopTest {

    @Test
    public void itemTest() {

        Item item = new Item("Car", 0.99);
        System.out.println(item);
        Assertions.assertTrue(item.toString().equals("Car, $0.99"));
        Assertions.assertTrue(item.getName() == "Car");
        Assertions.assertTrue(item.priceFor(1) == 0.99);
        Assertions.assertTrue(item.priceFor(10) == 9.90);


    }

    @Test
    public void purchaseTest(){
        Purchase newPurchase = new Purchase(new Item("Nike Shoes", 19.99), 2);
        Purchase secondPurchase = new Purchase(new Item("Nike Shoes", 19.99), 2);
        Purchase thirdPurchase = new Purchase(new Item("Rebok Shoes", 19.99), 2);

        Assertions.assertTrue(newPurchase.matchesPurchase(secondPurchase));
        Assertions.assertFalse(newPurchase.matchesPurchase(thirdPurchase));

    }
    @Test
    public void catalogTest(){
        Item item = new DiscountedItem("Truck", 2.99, 10, 2.79);
        Item item2 = new Item("Car", 0.99);
        Catalog cat = new Catalog("MyCatalog");
        cat.add(item);
        cat.add(item2);
        Assertions.assertTrue(cat.getStoreName()== "MyCatalog");
        Assertions.assertTrue(cat.getItem("Car") == item2);

    }
    @Test
    public void DiscountedItemTest(){

        Item item = new DiscountedItem("Truck", 2.99, 10, 24.99);

        System.out.println(item);
        System.out.println(item.priceFor(9));
        System.out.println(item.priceFor(23));
        Assertions.assertTrue(item.toString().equals("Truck, $2.99 (10 for $24.99)"));
        Assertions.assertTrue(item.getName() == "Truck");
        Assertions.assertTrue(item.priceFor(9) == 26.91);
        Assertions.assertTrue(item.priceFor(23) == 58.95);

    }


}

