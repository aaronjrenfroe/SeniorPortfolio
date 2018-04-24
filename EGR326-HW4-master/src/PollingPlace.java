import java.io.FileNotFoundException;
import java.util.*;

/**
 * Written by Jose and Aaron
 * Created by Jose on 3/6/2017.
 * Edited and Verified by Aaron
 */
public class PollingPlace {

    private List<Ballot> ballots;
    private String locationName;//to store the name of each polling place

    // CandidateName, Votes
    private Map<String, Integer> pollCount; //to keep count of the tally of the ballots in this polling place

    //Constructor initializing list to an empty list
    public PollingPlace(String name){
        ballots = new LinkedList();
        this.locationName = name;
        pollCount = new HashMap();
    }

    //This function will update the results of the polling place

    /**
     * Written by Jose
     * called when Election is finished editing Information
     * Updates the pollcount table for this polling place
     */
    public void update(){
        //creating a list to store the votes temporarily
        List names = new ArrayList();
        boolean repeated = false;

        //creating a list of candidates without duplicates
        for(int i=0;i<ballots.size();i++)
        {
            if(names.isEmpty())
            {
                names.add(ballots.get(i).getVote());
            }else{

                for(int j=0;j<names.size();j++)//this for loop checks if the name repeats itself
                {
                    if(names.get(j).equals(i))
                    {
                        repeated=true;
                    }
                }
                if(!repeated)
                {
                    names.add(ballots.get(i).getVote());
                }
            }
        }

        //To store the votes
        Integer[] votes= new Integer[ballots.size()];
        //getting the votes for each candidate
        for(int i=0;i<names.size();i++)
        {
            int vote=0;
            for(int j=0;j<ballots.size();j++){
                if(names.get(i).equals(ballots.get(j).getVote()))
                {
                    vote++;
                    votes[i]=vote;

                }

            }

        }

        //creating loop to fill the HashMap with the information
        for(int i=0;i<names.size();i++) {
            pollCount.put(names.get(i).toString(), votes[i]);
        }
    }

    /**
     * Written By Jose, Refactored by Aaron
     * @param lines lines read in from a file
     * @throws FileNotFoundException
     */
    public void addBallotsFromFile(List lines) throws FileNotFoundException{

        Iterator lineIterator = lines.iterator();
        while (lineIterator.hasNext()) {
            String candidates = (String) lineIterator.next();
            String[] candidatesSeparated = candidates.split("\\,");

            Ballot clonedBallot = new Ballot();
            // names get sent to be spell checked,
            // unknown names are added to the candidates list in Candidates
            List ofCandidatesNames = cleanNames(Arrays.asList(candidatesSeparated));
            clonedBallot.addVotes(ofCandidatesNames);
            ballots.add(clonedBallot);
            //adding the object to the ballots list
        }
    }


    //return poll place name

    /**
     *
     * @return The name of this polling place as String
     */
    public String getName()
    {
        return locationName;
    }

    //this function removes the desired candidate from every ballot from the polling place
    public void removeCandidateWithName(String name){
        //deleting from the ballots
        for(int i=0;i<ballots.size();i++){
            ballots.get(i).deleteCandidateVotes(name);
        }
        //deleting from the HashMap
        pollCount.remove(name);
    }

    /**
     * Written by Aaron
     * @return a set that contains a copy entries in the pollCount table
     *
     */
    public Set getCountedResults(){

        return this.pollCount.entrySet();
    }

    // helper method the corrects all misspelling in the ballots before they are set
    // Adds unknown candidates to the Candidates class.
    private List cleanNames(List names){
        // new List to be
        List cleanedList = new LinkedList();

        Candidates c = Candidates.getInstance();
        Set<String> candidatesNames = c.getSetOfNames();
        for (int i = 0; i < names.size(); i++) {
            String currentName = (String) names.get(i);
            if (candidatesNames.size() == 0){
                c.addCandidate(currentName,"???");
                candidatesNames=c.getSetOfNames();
            }
            else if (!candidatesNames.contains(currentName)){
                boolean found = false;
                for (Object o:candidatesNames) {
                    String realName = (String) o;

                    if (levenshteinDistance(realName, currentName) < 4) {
                        found = true;
                        cleanedList.add(realName);
                        break;
                    }
                }
                if (!found) {
                    c.addCandidate(currentName, "???");
                    cleanedList.add(currentName);
                    candidatesNames = c.getSetOfNames();
                }
            }else{
                cleanedList.add(currentName);
            }
        }
        return cleanedList;
    }

    /**
     * Written by Jose edited by Aaron
     * @param s1 Name 1
     * @param s2 Name 2
     * @return returns how many changes are needed for the name to be the same
     */
    public int levenshteinDistance(String s1, String s2) {
        int m = s1.length();
        int n = s2.length();
        int d[][] = new int[m+1][n+1];
        for(int i = 1 ; i <= m ; i++)
            d[i][0] = i;
        for(int j = 1 ; j <= n ; j++)
            d[0][j] = j;
        for(int j = 1 ; j <= n; j++){
            for(int i = 1 ; i <= m; i++){
                int cost = (s1.charAt(i-1) == s2.charAt(j-1)) ? 0 : 1;
                d[i][j] = Math.min(Math.min(d[i-1][j] + 1, d[i][j-1] + 1), d[i-1][j-1] + cost);
            }
        }
        return d[m][n];
    }

    /**
     * Written By Aaron
     * Only checking Location name as that is all that matters in this case
     * @param obj
     * @return
     */
    @Override
    public boolean equals(Object obj) {

        if (obj.getClass() == this.getClass()){
            PollingPlace other = (PollingPlace) obj;
            return other.locationName.equals(this.locationName);
        }else{
            return false;
        }
    }

    /** Written by Aaron
     * Only hashing location name to allow quick lookup in Hash Map
     *
     */
    @Override
    public int hashCode() {
        return locationName.hashCode();
    }

}
