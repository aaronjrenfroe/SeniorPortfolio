

import javax.naming.SizeLimitExceededException;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

/*
 * @author Aaron Renfroe
 * EGR 326
 * Assignment 3 Restaurant
 * Class Restaurant: contains everything in the restaurant such as
 * Servers, the waiting list, the list of tables, and the Servers Manager
 */
public final class Restaurant {
    private String restaurantName;
    private HashMap<Table,Party> tables;
    private List<Party> waitList;
    private double cashRegister;
    private int tableCount;
    private int maxTableSize;
    //private HashMap theBoard;

    private Servers servers;

    /**
     *
     *The Constructor initializes the waiting list, the tables, the servers, and the cash register
     *
     */
    public Restaurant(){
        restaurantName = "";
        this.tables = new HashMap<>();
        this.waitList = new LinkedList();
        this.cashRegister = 0;
        this.tableCount = 0;
        this.maxTableSize = 0;
        this.servers = new Servers();

    }




    /**
     * Accessor Method from TextUI to Servers
     * @return List of Servers on duty's toStrings, returns empty if server count is 0
     */
    protected List<String> serversOnDutyToString() {
        return servers.serversToStrings();
    }
    /**
     * Accessor Method from TextUI to Servers
     * @return  number of servers on Duty
     */
    protected int addServer(){
        return servers.addServer();
    }

    /**
     * Accessor Method from TextUI to Servers
     * Attempts to dismiss server from Servers
     * @return Dismissed Servers toString output
     * @throws NullPointerException if server count is 0 before call, there are 0 servers to cashOut
     * @throws UnsupportedOperationException if there are parties seated and only one remaining server, the last server cannot cashOut.
     */
    protected String dismissServer()throws NullPointerException, UnsupportedOperationException{
        return servers.cashOut();
    }

    /**
     * Accessor Method from TextUI to Servers
     * @return returns number of servers on duty
     */
    protected int numberOfServers(){return servers.numberOfServers();}

    /**
     * Accessor Method for the cash Register
     * @return String representation of cash in the Register: $0.00
     */
    protected String countCash(){return "$" + String.format("%1.2f", this.cashRegister);}

    /**
     * Returns each table's status.
     * @return List of Table Status
     */
    protected List<String> tableStatuses(){
        List<String> tStrings = new ArrayList();

        for (Table tempT: tables.keySet()){
            StringBuilder tString = new StringBuilder();
        // Table 5 (2-top): Jones party of 2 - Server #2

        tString.append(tempT.toString() + " : ");
        Party hasParty = tables.get(tempT);
        if (hasParty!= null) {
            tString.append(hasParty.getName() + "Party of " + (hasParty.getSize()));
            tString.append(" Server #"+ servers.getServerForTable(tempT).getId());
            tStrings.add(tString.toString());
        } else {
            tString.append("empty");
            tStrings.add(tString.toString());
        }

    }
        return tStrings;
    }

    /**
     * Checks if Party's name exists in the system, if there is an empty table that will fit them
     * or if they are too large to be seated in the restaurant
     * @return  Returns true if can be seated.
     * @param p Party passed to check if Name exists in the system, if there is an empty table that will fit them,
     *          or if they are too large to be seated in the restaurant
     * @return  Returns true if can be seated.
     * @throws UnsupportedOperationException If the party's name exists in the system.
     * @throws SizeLimitExceededException If Party's size is too big.
     */
    protected boolean partyToBeSeated(Party p) throws UnsupportedOperationException, SizeLimitExceededException{

        if (servers.hasServers()){
            Set<Map.Entry<Table,Party>> tempTables = tables.entrySet();

            if (waitList.contains(p) || tableForPartyWithName(p.getName()) != null){
                throw new UnsupportedOperationException("Duplicate Name");
            }
            else if (p.getSize() > maxTableSize){
                throw new SizeLimitExceededException("Party is to large to be seated");
            }else if(p.getSize() < 1){
                throw new IllegalArgumentException();
            }

            Table smallestT = smallestAvailableTable(p.getSize());

            if (smallestT != null){
                servers.assignToServer(smallestT);
                tables.replace(smallestT, p);
                return true;
            }else {
                return false;
            }
        }else throw new NullPointerException("No servers Available");
    }

    /**
     * Adds passed party to waiting list
     * @param party The party to be added to the waiting list
     */
    protected void addToWaitingList(Party party){
        waitList.add(party);
    }

    /**
     * Reads the passed File in to memory and retrieves Restaurant Name and sets table ID's and Sizes
     * @param fileName File to be passed to the scanner upon initialization
     * @throws FileNotFoundException If file is not found
     */
    protected void readInfoFile(File fileName) throws FileNotFoundException{
        try{
            Scanner restInfo = new Scanner(fileName);
            String rName = restInfo.nextLine().trim();
            if (rName != "" || rName != null){
                restaurantName = rName;
            }
            while (restInfo.hasNextInt()){
                int tempSize = restInfo.nextInt();
                if (tempSize > 0 && tempSize < 12) {
                    if (maxTableSize < tempSize){
                        maxTableSize = tempSize;
                    }
                    tables.put(new Table(tableCount++, tempSize), null);
                }
            }
            restInfo.close();
        }catch(FileNotFoundException fi){
            throw new FileNotFoundException("fi");
        }

    }

    /**
     * Getter for  the output from the toString Method of every party in waiting list.
     * @return  If waiting list is empty returns an empty List
     */
    protected List<String> waitingList(){
        List wListStrings = new ArrayList();
        for (Party p:waitList) {
            wListStrings.add(p.toString());
        }

        return wListStrings;
    }

    /**
     * Called when CheckPlease is called. Adds bill to register, adds tip to assigned servers Tips, makes table available
     * @param t Table the party is seated at
     * @param bill bill amount to be added to register
     * @param tip Tip amount to be added to servers tips
     */
    protected void partyIsLeaving(Table t,double bill, double tip){

        if (tables.get(t)!=null && bill>=0) {
            servers.receiveTipClearTable(t, tip);
            cashRegister += bill;
            tables.replace(t, null);
        }


    }

    /**
     * Searches parties for party with name
     * @param name Search term
     * @return Table of siting party, if null returns null.
     */
    protected Table tableForPartyWithName(String name){
        Set<Map.Entry<Table,Party>> tempTables = tables.entrySet();
        for (Map.Entry<Table, Party> kv:tempTables) {
            if ((kv.getValue()) != null) {
                //getTableForPartyWithNAme();
                if ((kv.getValue()).getName().equals(name)) {
                    return kv.getKey();
                }
            }
        }
        return null;
    }

    // searches Tables for smallest empty Table
    //returns table if tables is found, otherwise returns null
    private Table smallestAvailableTable(int size){

        Table smallestFittingTable = new Table(99999,9999);
        Set<Map.Entry<Table,Party>> tempTables = tables.entrySet();
        for (Map.Entry kv:tempTables) {
            Table tempTable = (Table) kv.getKey();
            if (kv.getValue() == null) {
                if (tempTable.getSize() < smallestFittingTable.getSize() && tempTable.getSize() >= size) {
                    smallestFittingTable = tempTable;
                }
            }
        }
        if (smallestFittingTable.getSize()!= 9999){
            return smallestFittingTable;
        }
        else return null;
    }

    /**
     * Searches waiting list for a party that can fit at the recently cleared table
     * @param t Recently Cleared TAble
     * @return Returns Name of newly seated Party and the newly assigne server
     */
    protected String checkIfWaitListedCanBeSeated(Table t){

        for(Party p:waitList){
            if (p.getSize() <= t.getSize()){
                waitList.remove(p);
                tables.replace(t,p);
                servers.assignToServer(t);
                Server s = servers.getServerForTable(t);
                return p.toString() + " - Server #"+s.getId();
            }
        }
        return null;
    }
}

