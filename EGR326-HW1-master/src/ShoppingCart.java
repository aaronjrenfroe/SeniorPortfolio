import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;


/**
 * ShoppingCart class for HW1 Software Design and Architecture
 * Created by Aaron Renfroe with Specs provided by Dr. Mi Kyung Han
 */
public class ShoppingCart {

    private static final int DISCOUNT_PERCENTAGE = 10;
    private static final int DISCOUNT_THRESHOLD = 20;

    private Collection<Purchase> shoppingCart;
    private boolean cartHasDiscount;
    private double totalPriceInCart;
    private int totalQuantityInCart;

    public ShoppingCart(){
        this.shoppingCart = new ArrayList<Purchase>();
        cartHasDiscount = false;
        totalPriceInCart = 0;
        totalQuantityInCart = 0;

    }
    /*
     I opted to do a little extra work in the add() method to give me
     the opportunity to make to other methods O(1)
     This method checks if the Item in the purchase is contained in another purchase
     that may or may not be in the cart. If it is it removes the item as well as the quantity and total price from the counters
     Then it will add the new Purchase and its price and quantity it will add to the cart to the appropriate locations.
    */
    public void add(Purchase newP){
        boolean found = false;
        Iterator<Purchase> k = shoppingCart.iterator();
        while (k.hasNext() && !found){
            Purchase kItem = k.next();
            if (kItem.matchesPurchase(newP)) {
                // prevents a Comodification error that occurs from modifying the array from an iterator
                found = true;
                totalPriceInCart -= kItem.getPrice();
                totalQuantityInCart -= kItem.getQuantity();
                shoppingCart.remove(kItem);
            }
        }
        totalPriceInCart += newP.getPrice();
        totalQuantityInCart += newP.getQuantity();
        System.out.println("ADDING");
        shoppingCart.add(newP);


        if(totalQuantity() >= 20){
            setDiscount(true);
        }else setDiscount(false);
    }

    // clears shooping cart
    public void clearAll(){
        shoppingCart.clear();
    }

    // gets total from variable that is maintained by add()
    public double getTotal(){
        if (cartHasDiscount && (totalQuantity() >= 20)) {
            return totalPriceInCart * (1 - (DISCOUNT_PERCENTAGE / 100.0));
        }else return totalPriceInCart;
    }
    // gets totalQuantity from variable that is maintained by add()
    public int totalQuantity(){

        return totalQuantityInCart;
    }
    // sets cartHasDiscount by the Check box in GUI
    public void setDiscount(boolean val){
        cartHasDiscount = val;
    }
    // returns true if cartHasDiscount == true
    public boolean hasDiscount(){
        return cartHasDiscount;
    }
    // returns the constant Discount_Percentage
    public static int getDiscountPercentage(){
        return DISCOUNT_PERCENTAGE;

    }
    // returns constant Discount_ Threshold
    public static double getDiscountQuantity(){
        return DISCOUNT_THRESHOLD;
    }
}
