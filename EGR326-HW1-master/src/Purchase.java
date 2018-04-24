/*
Purchase class for HW1 Software Design and Architecture
Created by Aaron Renfroe with Specs provided by Dr. Mi Kyung Han
 */


import java.util.Objects;

/**
 * Created by AaronR on 1/17/17.
 */
public class Purchase {
    private Item item;
    private int purchaseQuantity;

    public Purchase(Item item, int quantity){
        this.item = item;
        this.purchaseQuantity = quantity;

    }

    // returns the total purchase price for the item
    public double getPrice(){
        return this.item.priceFor(purchaseQuantity);

    }
    // returns the quantity set by the constructor
    public int getQuantity(){
        return this.purchaseQuantity;
    }
    //

    // checks to see if the given purchase contains the same item as this purchase
    public boolean matchesPurchase(Purchase other){
        if (this.item.getName() == other.item.getName()){
            return true;
        }
        else {
            return false;
        }
    }
    // checks if the purchase quantity is set to 0
    public boolean isEmpty(){
        return (purchaseQuantity==0);
    }

}
