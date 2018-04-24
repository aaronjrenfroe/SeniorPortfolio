/**
 * DiscountedItem class for HW1 Software Design and Architecture
 * Inherits from Item Class
 * Created by Aaron Renfroe with Specs provided by Dr. Mi Kyung Han
 */
public class DiscountedItem extends Item {

    private int bQnty;
    private double bPrice;

    public DiscountedItem(String name, double price, int bulkQuantity, double bulkPrice){
        super(name, price);
        this.bQnty = bulkQuantity;
        this.bPrice = bulkPrice;

    }

    @Override
    public double priceFor(int quantity){
        //gets bulk total

        double bulkTotal = super.priceFor(quantity % this.bQnty);
        if (quantity >= this.bQnty) {
            bulkTotal += this.bPrice * (quantity / this.bQnty);
        }
        return Math.round(bulkTotal * 100.0) / 100.0;

    }
    // overrides to string method to return in the format of ({name}, {singleItemPRice}, {bulkItemPrice} for $0.00)
    @Override
    public String toString(){
        return super.toString() + " (" + this.bQnty + " for $" + String.format("%1$.2f",this.bPrice)+ ")";
    }

}
