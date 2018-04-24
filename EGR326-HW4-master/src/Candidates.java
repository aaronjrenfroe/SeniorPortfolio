import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;
import java.util.Scanner;

/**
 * Written By Jose Morales
 * Refactored and Verified by Aaron Renfroe
 */
public class Candidates {
    // List of candidares that were in the text file and that have neem found on voters ballots
    private List<Candidate> listOfCandidates;
    // Singleton Instance
    private static Candidates uniqueInstance;

    //Constructor that initializes candidates to an empty ArrayList
    private Candidates(){
        listOfCandidates = new ArrayList();
    }

    /**
     * Written by Aaron
     * Singleton
     * @return returns Singleton instance
     */
    public static Candidates getInstance(){
        if (uniqueInstance == null){
            synchronized (Election.class) {
                if (uniqueInstance == null) {
                    uniqueInstance = new Candidates();
                }
            }
        }
        return uniqueInstance;
    }
    //add candidate that are not found in candidates txt file

    /**
     * Written by Jose
     * @param name Name of candidate
     * @param party Candidates Party ###
     */
    public void addCandidate(String name, String party){
        Candidate c = new Candidate(name, party);
        listOfCandidates.add(c);
    }

    //delete a candidate will take a string and delete the candidate that is passed from the candidates array

    /**
     * Written by Jose
     *  Finds the candidate whos name is equal to the one passed
     * @param name Finds the candidate whos name is equal to the one passed
     */
    public void deleteCandidate(String name){
        int index=0;
        boolean found=false;

        for(int i=0;i<listOfCandidates.size();i++)
        {
            if(listOfCandidates.get(i).getName().equals(name))
            {
                index=i;
                found=true;
            }
        }
        //if the candidate was found it is deleted.
        if(found)
        {
            listOfCandidates.remove(index);
        }
    }

    /**
     * Written by Aaron
     * Searches and returns the candidate with the given name
     * @param name Name to search for
     * @return Candidate with name, returns null if name not found but this will never occur
     */
    public Candidate getCandidateWithName(String name){
        for (int i = 0; i < listOfCandidates.size(); i++) {
            if (listOfCandidates.get(i).getName().equals(name)){
                return listOfCandidates.get(i);
            }
        }
        return null;
    }

    /**
     * Written by Aaron
     * @return a Set of all the names of the Candidates, if not candidates returns empty set
     */
    public Set getSetOfNames(){
        Set set = new HashSet<String>();
        for (int i = 0; i < listOfCandidates.size(); i++) {
            set.add(listOfCandidates.get(i).getName());
        }
        return set;
    }
}
