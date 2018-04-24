import com.sun.deploy.util.StringUtils;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Aaron on 3/6/2017.
 * @author Aaron and Jose
 */

public class Ballot {

    //list to hold all the votes for each ballot
    private List<String> votes;

    /**
     * Written by Jose
     * Constructor, instantiates votes.
     */
     public Ballot(){
        //splitList();
        votes = new LinkedList<>();
    }

    /**
     * Adds the list of a Voters votes to the data structure
     * Written by Jose
     * @param list
     */
    public void addVotes(List list){
        this.votes = list;

    }

    /**
     * Written by Jose
     * @return the voters next choice
     */
    public String getVote(){
        //returning first vote
        return votes.get(0);
    }

    /**
     * Written by Jose
     * Deletes the given candidate from a voters preferences
     * @param name name of candidate to be deleted
     */
    public void deleteCandidateVotes(String name){
        //Savind index to be removed
        boolean found=false;
        int index=0;
        for(int i=0;i<votes.size();i++){
            if(votes.get(i).equals(name)){
                index=i;
                found=true;
            }
        }

        //Removing element
        if(found){        votes.remove(index);}
    }

    //function to eliminate the first candidate
    public void nextVote(){
        votes.remove(0);
    }

    /**
     * Written by Jose
     * @return string representation of Ballot
     */
    @Override
    public String toString(){
        StringBuilder b= new StringBuilder();
        for (int i=0;i<votes.size();i++){
            b.append(votes.get(i)+" ");
        }
        return b.toString();


    }
}
