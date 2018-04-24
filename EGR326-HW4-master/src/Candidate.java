/**
 * Written by Jose
 * Created by Jose on 3/4/2017.
 */
public final class Candidate {

    private String name, party;

    /**
     * Constructor
     * @param name Name of the Candidate
     * @param party String Representation of Candidates Party ###
     */
    public Candidate(String name, String party){
        this.name=name;
        this.party=party;
    }
    /**
     * @return Returns the Candidates Name as it was formatted in the file
    */
    public String getName() {
        return name;
    }

    /**
     *
     * @return Returns the String Representation of the Candidates Party ###
     */
    public String getParty() {
        return party;
    }

    /**
     *
     * @return Candidate: name name Party:  ###
    }
     */
    @Override
    public String toString(){
        return "Candidate: "+name+" Party: "+ party;
    }

}
