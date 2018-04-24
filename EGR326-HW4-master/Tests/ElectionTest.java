import com.sun.org.apache.xpath.internal.operations.Bool;
import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by AaronR on 3/11/17.
 * for ?
 */
public class ElectionTest {
    @Test
    public void getInstance() throws Exception {
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
        Assert.assertTrue(Election.getInstance().equals(Election.getInstance()));
    }

    @Test
    public void addPollingPlace() throws Exception {
        Election n = Election.getInstance();
        n.addPollingPlace("bellevue");
        n.addPollingPlace("kent");
        n.closePollingPlaces();
        Boolean threwError = false;
        try {
            n.addPollingPlace("capitol-hill");
        }catch(UnsupportedOperationException uoe){
            threwError = true;
        }
        Assert.assertTrue("Can't add polling place while polls are closed.",threwError);

    }

}