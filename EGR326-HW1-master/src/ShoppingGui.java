// EGR 326/CSC5 26, Homework 1 (Shopping)
// Instructor-provided support file.  Do not modify.

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import javax.swing.BorderFactory;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.SwingConstants;

/**
 * This class represents the graphical user interface (GUI) for the shopping
 * program, allowing the user to select items to purchase in his/her shopping cart.
 */
public class ShoppingGui {
	private JFrame frame;
	private JLabel total;
	private JCheckBox discount;
	private ShoppingCart cart;
	
	/**
	 * Constructs a new GUI to display items from the given catalog.
	 * @param catalog The store catalog to use
	 * @pre catalog != null
	 */
	public ShoppingGui(Catalog catalog) {
		cart = new ShoppingCart();
		createComponents();
		setupEvents();
		performLayout(catalog);
		frame.setVisible(true);
	}
	
	// Constructs all of the graphical components to reside in the window frame
	private void createComponents() {
		// label to display the ORDER TOTAL
		total = new JLabel();
		total.setHorizontalAlignment(SwingConstants.CENTER);
		updateTotal();
		
		// checkbox for applying a bulk discount to the entire shopping cart
		discount = new JCheckBox();
		discount.setText(ShoppingCart.getDiscountPercentage()
				+ "% off when you buy "
				+ ShoppingCart.getDiscountQuantity()
				+ " or more items");
		discount.setSelected(cart.hasDiscount());
		discount.setHorizontalAlignment(SwingConstants.CENTER);

		// window frame for the overall display
		frame = new JFrame("Shopping");
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
	
	// Sets up event handlers on all relevant components in the window.
	private void setupEvents() {
		// when the user checks/unchecks the Discount box, inform the shopping cart
		discount.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				cart.setDiscount(discount.isSelected());
				updateTotal();
			}
		});
	}
	
	// Constructs containers to do the layout and positioning of the components
	// in the window.  Also creates the display components for the catalog items.
	private void performLayout(Catalog catalog) {
		// create a display panel to show each item in the store
		JPanel center = new JPanel(new GridLayout(0, 1));
		center.setBorder(BorderFactory.createTitledBorder(catalog.getStoreName()));
		for (Item item : catalog) {
			center.add(new ItemPanel(item));
		}
		
		// south panel stores the ORDER TOTAL label and discount checkbox
		JPanel south = new JPanel(new GridLayout(0, 1));
		south.add(total);
		south.add(discount);
		
		// frame's content pane stores overall layout for the window
		Container contentPane = frame.getContentPane();
		contentPane.add(center, BorderLayout.CENTER);
		contentPane.add(south, BorderLayout.SOUTH);
		frame.pack();
		center(frame);
	}
	
	// Updates the ORDER TOTAL label's text when a purchase in the window changes.
	private void updateTotal() {
		total.setText(String.format("$%.2f  ORDER TOTAL", cart.getTotal()));
	}
	
	// Positions the given window in the center of the screen.
	private static void center(Window window) {
		Dimension screen = Toolkit.getDefaultToolkit().getScreenSize();
		window.setLocation((screen.width - window.getWidth()) / 2,
				(screen.height - window.getHeight()) / 2);
	}
	
	/**
	 * Represents one panel container to hold the information about a single item
	 * available for purchase in the store, including the graphical components
	 * for that item, such as its text box to type in how many to buy, and the
	 * label to show the item's description.
	 */
	private class ItemPanel extends JPanel {
		private static final long serialVersionUID = 0;
		
		private Item item;
		private JTextField textField;
		private JLabel label;
		
		public ItemPanel(Item item) {
			this.item = item;
			
			setLayout(new FlowLayout(FlowLayout.LEFT));
			textField = new JTextField(3);
			textField.setHorizontalAlignment(SwingConstants.CENTER);
			label = new JLabel(item.toString());
			add(textField);
			add(label);
			
			textField.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent event) {
					update();
				}
			});
			
			textField.addFocusListener(new FocusAdapter() {
				public void focusLost(FocusEvent event) {
					update();
				}
			});
		}
		
		// Called when the text in this item's text field changes.
		// Informs the shopping cart of the update to the item's purchase quantity.
		private void update() {
			String text = textField.getText().replaceAll("[^0-9-]+", "");
			textField.setText(text);
			int quantity = 0;
			if (!text.isEmpty()) {
				try {
					quantity = Integer.parseInt(text);
				} catch (NumberFormatException nfe) {
					System.err.println(nfe);
				}
			}
			
			Purchase purchase = new Purchase(item, quantity);
			cart.add(purchase);
			updateTotal();
			
			if (textField.hasFocus()) {
				textField.transferFocus();
			}
		}
	}
}
