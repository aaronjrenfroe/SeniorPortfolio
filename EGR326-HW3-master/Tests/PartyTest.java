import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by AaronR on 2/9/17.
 * for ?
 */
public class PartyTest {
    @Test
    public void getName() throws Exception {
        Party bob = new Party("Bob".toUpperCase(), 4);
        assertTrue(bob.getName().equals("Bob".toUpperCase()));
    }

    @Test
    public void getSize() throws Exception {
        Party bob = new Party("Bob".toUpperCase(), 7);
        Party sherry = new Party("Sherry".toUpperCase(), 4);
        assertEquals(4,sherry.getSize());
        assertEquals(7,bob.getSize());
    }

    @Test
    public void toStringTest() throws Exception {
        Party bob = new Party("Bob".toUpperCase(), 7);
        Party sherry = new Party("Sherry".toUpperCase(), 4);
        System.out.println(bob.toString());
        assertEquals("BOB, Party of 7",bob.toString());
        assertEquals("SHERRY, Party of 4",sherry.toString());
    }

    @Test
    public void hashCodeTest() throws Exception {
        Party bob = new Party("Bob".toUpperCase(), 7);
        Party sherry = new Party("Sherry".toUpperCase(), 4);
        assertEquals("SHERRY, Party of 4",sherry.toString());
    }

    @Test
    public void equalsTest() throws Exception {
        Party bob = new Party("Bob".toUpperCase(), 7);
        Party sherry = new Party("Sherry".toUpperCase(), 4);
        assertTrue(sherry.equals(new Party("Sherry".toUpperCase(),4)));
        assertFalse(sherry.equals(bob));
    }

}