import org.junit.Test;
import org.junit.Assert;

import javax.naming.SizeLimitExceededException;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;

import static org.junit.Assert.*;

/**
 * Created by AaronR on 2/10/17.
 * for ?
 */
public class RestaurantTest {

    private Restaurant restaurantInit(){
        Restaurant restaurant = new Restaurant();
        try{
            File file = new File("tables.txt");
            restaurant.readInfoFile(file);
            return restaurant;
        }catch(FileNotFoundException fe){
            return null;
        }
    }

    @Test
    public void serversOnDutyToStringTest() throws Exception {
        Restaurant r = restaurantInit();
        Assert.assertEquals(new ArrayList(),r.serversOnDutyToString());
        Assert.assertEquals(1,r.addServer());
        Assert.assertEquals(2,r.addServer());

        //System.out.println(r.serversOnDutyToString());
        Assert.assertEquals("[Server #2 ($0.00 in tips), Server #1 ($0.00 in tips)]",r.serversOnDutyToString().toString());
        Assert.assertEquals(2,r.serversOnDutyToString().size());
        r.dismissServer();
        Assert.assertEquals("[Server #1 ($0.00 in tips)]",r.serversOnDutyToString().toString());
        r.dismissServer();
        Assert.assertEquals(0,r.serversOnDutyToString().size());


    }
    @Test
    public void addAndDismissServerTest(){
        Restaurant r = restaurantInit();
        Assert.assertEquals(0,r.numberOfServers());
        for (int i = 1; i <= 100; i++) {
            Assert.assertEquals(i,r.addServer());
            Assert.assertEquals(i,r.numberOfServers());
        }
        Assert.assertEquals(100,r.numberOfServers());
        for (int i = 100; i <= 1; i--) {
            Assert.assertEquals(i,r.dismissServer());
            Assert.assertEquals(i,r.numberOfServers());
        }
    }

    @Test
    public void countCashTest() throws Exception {
        Restaurant r = restaurantInit();
        Assert.assertEquals("$0.00",r.countCash());
        r.partyIsLeaving(new Table(1,4),9.99,5.0);
        Assert.assertEquals("$0.00",r.countCash());
        r.partyIsLeaving(new Table(1,4),-9.99,5.0);
        Assert.assertEquals("$0.00",r.countCash());
        r.addServer();
        r.partyToBeSeated(new Party("Sherry",4));
        r.partyIsLeaving(new Table(6,4),5.15,4.00);
        Assert.assertEquals("$5.15",r.countCash());



    }

    @Test
    public void tableStatusesTest() throws Exception {
        Restaurant r = restaurantInit();
        r.addServer();
        r.partyToBeSeated(new Party("Sherry",4));
        String tStatus = "[Table 3 (2-top) : empty,"
                + " Table 4 (2-top) : empty,"
                + " Table 6 (4-top) : SherryParty of 4 Server #1,"
                + " Table 7 (2-top) : empty,"
                + " Table 2 (8-top) : empty,"
                + " Table 0 (4-top) : empty,"
                + " Table 1 (4-top) : empty,"
                + " Table 5 (6-top) : empty]";

        Assert.assertEquals(tStatus,r.tableStatuses().toString());
    }

    @Test
    public void partyToBeSeatedTest() throws Exception {
        Restaurant r = restaurantInit();
        r.addServer();
        Assert.assertTrue(r.partyToBeSeated(new Party("Sherry",4)));
        boolean thrown = false;
        try {
            r.partyToBeSeated(new Party("Sherry", 4));
        }catch(UnsupportedOperationException un){
            thrown = true;
        }catch(SizeLimitExceededException si){

        }
        Assert.assertTrue(thrown);
        thrown = false;
        try {
            r.partyToBeSeated(new Party("Bob", 15));
        }catch(UnsupportedOperationException un){

        }catch(SizeLimitExceededException si){
            thrown = true;
        }
        Assert.assertTrue(thrown);
        Assert.assertTrue(r.partyToBeSeated(new Party("Jim",8)));
        // should be wait listed, should return false
        Assert.assertFalse(r.partyToBeSeated(new Party("Pam",8)));
        r.addToWaitingList(new Party("Pam",8));

        assertTrue(r.waitingList().toString().equals("[Pam, Party of 8]"));

    }

    @Test
    public void tableForPartyWithNameTest() throws Exception {
        Restaurant r = restaurantInit();
        r.addServer();
        Assert.assertTrue(r.partyToBeSeated(new Party("Sherry",4)));
        r.tableForPartyWithName("Sherry");
        assertEquals(r.tableForPartyWithName("Sherry").toString(),("Table 6 (4-top)"));
    }


}