// EGR 326/CSC 526 Homework 1 (Shopping)
// Instructor-provided support file.  Do not modify.

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * This class contains the main method to run the overall program.
 */
public class ShoppingMain {
	// the name of the catalog file of products to purchase;
	// you can change this to "mycatalog.txt" to test your own catalog file
	private static final String CATALOG_FILE_NAME = "catalog.txt";
	
	/**
	 * Runs the application by reading the catalog and creating a shopping gui.
	 * @throws FileNotFoundException if the catalog input file is not found.
	 */
	public static void main(String[] args) throws FileNotFoundException {
		Catalog catalog = readCatalog(CATALOG_FILE_NAME);
		new ShoppingGui(catalog);
	}
	
	// Reads the catalog of products from the given input file.
	// The input is in a format such as the following:
	//
	// itemname,price[,bulkquantity,bulkprice]
	// Silly Putty,3.95,10,19.99   <-- discounted item
	// Bottle o' Bubbles,0.99      <-- non-discounted item
	//
	// Precondition: filename != null; input file exists and is in valid format.
	// Throws a FileNotFoundException if the catalog input file is not found.
	private static Catalog readCatalog(String filename) throws FileNotFoundException{
		Catalog catalog = new Catalog("Gift Catalog");
		Scanner input = new Scanner(new File(CATALOG_FILE_NAME));
		while (input.hasNextLine()) {
			Scanner tokens = new Scanner(input.nextLine());
			tokens.useDelimiter(",");
			if (!tokens.hasNext()) {
				continue;
			}
			
			String name = tokens.next();
			double price = tokens.nextDouble();
			if (tokens.hasNext()) {
				// Silly Putty,3.95,10,19.99   <-- discounted item
				int bulkQuantity = tokens.nextInt();
				double bulkPrice = tokens.nextDouble();
				catalog.add(new DiscountedItem(name, price, bulkQuantity, bulkPrice));
			} else {
				// Bottle o' Bubbles,0.99      <-- non-discounted item
				catalog.add(new Item(name, price));
			}
		}
		return catalog;
	}
}
