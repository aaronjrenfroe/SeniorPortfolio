import org.junit.Assert;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by AaronR on 2/9/17.
 * for ?
 */
public class ServerTest {


    @Test
    public void serverConstructorTest(){
        Server server = new Server(12);
        Server s1 = new Server(-9999999);
        Server s2 = new Server(9999999);
        Assert.assertEquals(-9999999,s1.getId());
        Assert.assertEquals(9999999,s2.getId());
        Assert.assertEquals("$0.00",s1.getTips());
        Assert.assertEquals("$0.00",s2.getTips());
    }

    @Test
    public void getIdTest() throws Exception {
        Server server = new Server(12);
        Assert.assertTrue(server.getId()==12);

        Server s1 = new Server(-99999999);
        Server s2 = new Server(99999999);
        Assert.assertEquals(-99999999,s1.getId());
        Assert.assertEquals(99999999,s2.getId());
    }

    @Test
    public void TipTest() throws Exception {
        Server server = new Server(12);
        Assert.assertEquals("$0.00",server.getTips());
        server.addTip(22.01);
        Assert.assertEquals("$22.01",server.getTips());
        server.addTip(10);
        Assert.assertEquals("$32.01",server.getTips());
        server.addTip(-100.0);
        Assert.assertEquals("$32.01",server.getTips());

    }

    @Test
    public void toStringTest() throws Exception {
        Server server = new Server(12);

        Assert.assertEquals("Server #12 ($0.00 in tips)",server.toString());
        server.addTip(22.01);
        Assert.assertEquals("Server #12 ($22.01 in tips)",server.toString());

        server.addTip(10);
        Assert.assertEquals("Server #12 ($32.01 in tips)",server.toString());

        server.addTip(-10.0);
        Assert.assertEquals("Server #12 ($32.01 in tips)",server.toString());

    }

}