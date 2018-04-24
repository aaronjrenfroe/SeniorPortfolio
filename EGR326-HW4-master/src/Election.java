

import Utils.MapUtil;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;
import java.util.Scanner;


/**
 * Created by Aaron Renfroe on 3/7/2017.
 * @author Aaron Renfroe
 */
public class Election {
    // Boolean value to identify it polls are open
    private static boolean isOpen;
    // Set of all polling locations
    private Set<PollingPlace> pollingStations;

    // Elections Unique instance
    private static Election uniqueInstance;

    //Constructor
    private Election(){
        isOpen=true;
        pollingStations = new HashSet();

    }

    /**
     * Written by Aaron
     * Sets returns the Unique instance of the singleton Election
     * @return
     */
    public static Election getInstance(){
        if (uniqueInstance == null){
            synchronized (Election.class) {
                if (uniqueInstance == null) {
                    uniqueInstance = new Election();
                }
            }
        }
        return uniqueInstance;
    }

    /**
     * Written by Aaron
     * Closes the polls. Becarefull Once closed they can not be re opened
     */
    public void closePollingPlaces(){
        isOpen = false;
    }

    /**
     * Written by Aaron
     * @return Returns the status of the polls, True for open False for closed
     */
    public boolean pollsStatus(){
        return isOpen;
    }

    /**
     * Written by Aaron
     * @param namePolling
     * @throws FileNotFoundException
     */
    public void addPollingPlace(String namePolling) throws FileNotFoundException, UnsupportedOperationException {

        //replacing blank spaces with dashes
        if (!isOpen){
            throw new UnsupportedOperationException("Sorry, Polls are closed");
        }
        namePolling = namePolling.toLowerCase();
        String fileToRead="ballots-"+(namePolling.replaceAll("\\s+","-"))+".txt";
        File file = new File(fileToRead);
        PollingPlace p = new PollingPlace(namePolling);

        //try statement to read specified file
        try {

            p.addBallotsFromFile(readFromFile(file));
            //updating results in polling place
            p.update();
            pollingStations.add(p);

        }catch(FileNotFoundException e){
            throw new FileNotFoundException("File not found");
        }
    }

    /**
     * Written by Aaron
     * File Reader
     * @return list of line in the file
     */
    private List readFromFile(File file) throws FileNotFoundException{

        Scanner newScanner = new Scanner(file);
        List<String> lineList = new ArrayList();
        while (newScanner.hasNext()){
            lineList.add(newScanner.nextLine());
        }
        return lineList;
    }

    /**
     * Written by Aaron
     * Pulls the results from each polling center and creates a grand total
     * @return Map of Candidate names and their tallies.
     * @throws UnsupportedOperationException if polling is still open.
     */
    public Map<String,Integer> getResultsFromPolls()throws UnsupportedOperationException{
        if (isOpen){
            throw new UnsupportedOperationException("Sorry, Polls are closed");
        }else {

            Map<String, Integer> candidateTotals = new LinkedHashMap<>();
            Set<String> oNames = Candidates.getInstance().getSetOfNames();
            for(String oname2:oNames){
                candidateTotals.put(oname2,0);
            }
            for (Object station : pollingStations) {
                Set<Map.Entry<String, Integer>> stationResults = ((PollingPlace) station).getCountedResults();
                candidateTotals = mergeCounts(candidateTotals, stationResults);

            }
            candidateTotals = MapUtil.sortByValue(candidateTotals);

            return candidateTotals;
        }

    }
    // Written by Aaron
    // combines allof the polling stations results
    private Map<String, Integer> mergeCounts(Map totals, Set set2){

        for(Object pollKV:set2){
            Map.Entry me = (Map.Entry) pollKV;
                int tally = (Integer) totals.getOrDefault(me.getKey(),0);
                totals.put(me.getKey(),tally+(Integer) me.getValue());
        }
        return totals;
    }

    /**
     * Written by Aaron
     * Returns the Results for specific polling place with given name
     * @param name String Name
     * @return Map with Name as Key and Integer as Value
     * @throws IllegalArgumentException when Polling place does not exist
     * @throws UnsupportedOperationException When polls are still open
     */
    public Map<String,Integer> resultsForSpecficPollingPlace(String name)throws IllegalArgumentException, UnsupportedOperationException{
        if (isOpen){
            throw new UnsupportedOperationException();
        }
        for(PollingPlace pl: pollingStations){
            Map<String, Integer> candidateTotals = new LinkedHashMap<>();

            if (pl.getName().equals(name.toLowerCase())){
                Set<String> oNames = Candidates.getInstance().getSetOfNames();
                for(String oname2:oNames){
                    candidateTotals.put(oname2,0);
                }
                candidateTotals = mergeCounts(candidateTotals, pl.getCountedResults());
                return MapUtil.sortByValue(candidateTotals);
            }
        }
        throw new IllegalArgumentException("");
    }

    /**
     * Written by Aaron
     * Reads in the candidates from file
     * @param fileName As string
     * @throws FileNotFoundException When file is not found
     */
    public void readInCandidates(String fileName){
        File file = new File(fileName);
        try {
            List<String> candidatesLines = readFromFile(file);
            for (String cLine : candidatesLines) {
                String[] cAndP = cLine.split("\\,");

                Candidates.getInstance().addCandidate(cAndP[0], cAndP[1]);

            }
        }catch(FileNotFoundException fnfError){
            // There must be no candidates to add
        }
    }

    /** Written by Aaron
     * Removes Candidate who's name was passed from Ballots of voters and form Candidates Class
     * @param name String of Candidates name
     */
    public void eliminateCandidateWithName(String name){

        for (PollingPlace pl:pollingStations) {
            pl.removeCandidateWithName(name);
            Candidates.getInstance().deleteCandidate(name);
            pl.update();
        }
    }
}
