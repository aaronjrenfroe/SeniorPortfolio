/*
Item class for HW1 Software Design and Architecture
Created by Aaron Renfroe with Specs provided by Dr. Mi Kyung Han
 */


// A single Item that can be purchased
public class Item {
    private String name;
    private double price;
    // constructor
    public Item(String name, double price) {
        if(price >= 0) {
            this.name = name;
            this.price = price;
        }else throw new IllegalArgumentException("I can't pay you to buy something, Silly");
    }
    // returns name set by constructor
    public String getName(){
        return this.name;
    }
    // calculates price for given quantity of items
    public double priceFor(int quantity){

        return Math.round(quantity*this.price * 100.0) / 100.0;
    }


    // overrides to string method to return in the format of ({name}, $0.00)
    @Override
    public String toString(){
        return (this.name + ", $" + String.format("%1$.2f",this.price));
    }
}
