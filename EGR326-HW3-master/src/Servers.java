import java.util.*;

/**
 * Created by Aaron Renfroe on 1/24/17.
 * EGR 326
 * Assignment 3 Restaurant
 * Class Servers is a manager of all the servers and their actions
 */
public final class Servers {
    private LinkedList<Server> serverQueue;
    private int dailyServerCount;
    private HashMap<Server, List<Table>> assignments;
    private int numberOFNewServersInFront;

    /**
     * Constructor, Initializes collection of servers, daily server count, RoundRobin Iterator, and tableAssignments
     */
    public Servers() {
        serverQueue =  new LinkedList();
        dailyServerCount = 0;
        numberOFNewServersInFront = 0;

        assignments = new HashMap<>();
    }

    /**
     * Adds new Server to Round Robin
     * @return New total number of servers
     */
    protected int addServer() {


        serverQueue.add(numberOFNewServersInFront++,new Server(dailyServerCount++ + 1));
        return serverQueue.size();
    }

    /**
     * Check to see if there are servers on duty
     * @return True if there is at least one server on duty
     */
    protected boolean hasServers() {
        return serverQueue.size()>0;
    }

    /**
     * The number of servers on duty
     * @return The number of servers on duty
     */
    protected int numberOfServers() {
        return serverQueue.size();
    }

    /**
     *  Gets next server in Round Robin fashion Used for Testing
     * @return Next server
     */
    protected Server getNext(){
      Server nextS = serverQueue.poll();
      serverQueue.add(nextS);
      if (numberOFNewServersInFront > 0) {
          numberOFNewServersInFront--;
      }

      return nextS;
    }

    /**
     * Takes table and adds table to the Next server's Assignments
     * @param t Table to be assigned to Next server
     */
    protected void assignToServer(Table t){
        Server nextServer = getNext();
        if (assignments.containsKey(nextServer)){
            List serversTables = assignments.get(nextServer);
            serversTables.add(t);
            assignments.replace(nextServer,serversTables);
        }else{
            List<Table> serversTables = new ArrayList();
            serversTables.add(t);
            assignments.put(nextServer,serversTables);
        }
    }

    /**
     * Called to cash out the next server
     * @return Returns Number of remaining servers on duty after cash out
     * @throws NullPointerException Thrown is there are 0 servers on duty
     * @throws UnsupportedOperationException Thrown if there is only one server left and it is asked to cash out
     */
    protected String cashOut() throws NullPointerException, UnsupportedOperationException{

        if (assignments.size() > 0)  {

            if (serverQueue.size() == 1){
                throw new UnsupportedOperationException("Cannot remove last server while parties are still seated");
            }else {
                Server leavingServer = serverQueue.poll();

                if (assignments.containsKey(leavingServer)) {

                    List<Table> tList = assignments.get(leavingServer);

                    tList.forEach(table -> assignToServer(table));
                }
                return "Server #" + leavingServer.getId() + " cashes out with " + leavingServer.getTips();
            }

        }else if(serverQueue.size() == 0){
            throw new NullPointerException("There are no servers to remove.");
            // no parties so we can remove server
        }else{
            assert assignments.size() == 0;
            Server leavingServer = serverQueue.poll();
            return "Server #" + leavingServer.getId() + " cashes out with " + leavingServer.getTips();
        }
    }

    /**
     * This finds the server who was assigned to that table, removes the assignment, adds tip to server
     * @param t Table that tip was from
     * @param tip Tip amount to be added to server
     */
    protected void receiveTipClearTable(Table t, double tip){
        assignments.forEach((k,v)->{
            if (v.contains(t)){
                v.remove(t);
                k.addTip(tip);
                // return is necessary because once server is found we do not need to continue looking
                return;
            }
        });
    }

    /**
     * Gets server assigned to this table passes as a parameter
     * @param t Search Parameter
     * @return returns server who is assigned to Table t
     */
    protected Server getServerForTable(Table t){
        final Server[] returnedServer = new Server[1];
        assignments.forEach((k,v)->{
            if (v.contains(t)){
                returnedServer[0] = k;
                return;
            }
        });
        if (returnedServer[0] == null){
            throw new NullPointerException("Table doesn't have a server");
        }else {
            return returnedServer[0];
        }

    }

    /**
     *
     * @return List of Collection of Server toStrings
     */
    protected List<String> serversToStrings(){
        List<String> sStrings = new ArrayList();
        for (int i = 0; i < numberOfServers(); i++) {
            sStrings.add(serverQueue.get(i).toString());
        }
        return sStrings;
    }

}
