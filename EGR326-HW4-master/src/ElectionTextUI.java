// Homework 4 (Election)
// Instructor-provided code.
// You SHOULD modify this file to make it interface with your own classes.

import java.io.FileNotFoundException;
import java.util.*;

/**
 * This class represents the text user interface (UI) for the restaurant
 * program, allowing the user to view and manage the restaurant and its objects.
 * 
 * @author Han
 * @version Spring 2017
 */
public final class ElectionTextUI {

	private Election election;
	/**
	 * Constructs a new text user interface for managing a Election.
	 */
	public ElectionTextUI() {
		System.out.println("Election Vote Counter");

		// TODO: initialization code can go here
		//crash("TODO: implement initialization code");
		election = Election.getInstance();
		election.readInCandidates("candidates.txt");

	}
	
	/**
	 * Displays the main menu of choices and prompts the user to enter a choice.
	 * Once a valid choice is made, initiates other code to handle that choice.
	 */
	public void mainMenu() {
		// main menu
		displayOptions();
		while (true) {
			String choice = ValidInputReader.getValidString(
					"Main menu, enter your choice:",
					"^[aAcCrRpPeEqQ?]$").toUpperCase();
			if (choice.equals("A")) {
				addPollingPlace();
			} else if (choice.equals("C")) {
				closeElection();
			} else if (choice.equals("R")) {
				results();
			} else if (choice.equals("P")) {
				perPollingPlaceResults();
			} else if (choice.equals("E")) {
				eliminate();
			} else if (choice.equals("?")) {
				displayOptions();
			} else if (choice.equals("Q")) {
				System.out.println("Goodbye.");
				break;
			}
			System.out.println();
		}
	}
	
	// Displays the list of key commands the user can use.
	private void displayOptions() {
		System.out.println();
		System.out.println("Main System Menu");
		System.out.println("----------------");
		System.out.println("A)dd polling place");
		System.out.println("C)lose the polls");
		System.out.println("R)esults");
		System.out.println("P)er-polling-place results");
		System.out.println("E)liminate lowest candidate");
		System.out.println("?) display this menu of choices again");
		System.out.println("Q)uit");
		System.out.println();
	}
	
	// Called when P key is pressed from main menu.
	// Reads data from a new polling place.
	private void addPollingPlace() {

		// when the election is not open,
		if (!election.pollsStatus()) {
			System.out.println("The election is closed.");
			System.out.println("No more polling places may be added.");
		}else {

			String pollingPlaceName = ValidInputReader.getValidString("Name of polling place:", "^[a-zA-Z0-9 ]+$");
			try {
				election.addPollingPlace(pollingPlaceName);
				System.out.println("Added " + pollingPlaceName + ".");

			}catch(FileNotFoundException fnfError){
				// when the polling place is not found,
				System.out.println(fnfError.getMessage());
			}

		}
	}
	
	// Called when C key is pressed from main menu.
	// Closes the election so that no more voting can take place.
	private void closeElection() {

		System.out.println("Closing the election.");
		election.closePollingPlaces();

	}
	
	// Called when R key is pressed from main menu.
	// Shows the current results of the election.
	private void results() {
		// when the election is not closed,
		try{
			Map<String,Integer> results = election.getResultsFromPolls();
			// when the election is closed,

			Collection<Integer> values = results.values();
			int totalVotes = 0;

			for(Integer i:values){
				totalVotes += i;
			}
			System.out.println("Current election results for all polling places.");
			System.out.println("NAME                          PARTY   VOTES     %");
			printResultsHelper(results,totalVotes);

		}catch(UnsupportedOperationException uoe){
			System.out.println("The election is still open for votes.");
			System.out.println("You must close the election before viewing results.");
		}
	}
	
	// Called when R key is pressed from main menu.
	// Shows the current results of the election.
	private void perPollingPlaceResults() {
		if (election.pollsStatus()){
			// when the election is not closed,
			System.out.println("The election is still open for votes.");
			System.out.println("You must close the election before viewing results.");
			return;
		}

		try{
			String pollingPlaceName = ValidInputReader.getValidString("Name of polling place:", "^[a-zA-Z0-9 ]+$");
			Map<String,Integer> results = election.resultsForSpecficPollingPlace(pollingPlaceName);
			Collection<Integer> values = results.values();
			int totalVotes = 0;

			for(Integer i:values){
				totalVotes += i;
			}

			// when the polling place exists,
			System.out.println("Current election results for " + pollingPlaceName + ".");
			System.out.println("NAME                          PARTY   VOTES     %");
			printResultsHelper(results,totalVotes);

		}catch(UnsupportedOperationException uoeError){


		}catch(IllegalArgumentException iaeError){
			// when the polling place doesn't exist,
			System.out.println("No such polling place was found.");
		}
	}
	// Helper method to print results of ballots from both polling places
	// and the whole election
	private void printResultsHelper(Map<String,Integer> results,int totalVotes){
		List<Map.Entry<String,Integer>>  entryList = new ArrayList(results.entrySet());
		for (int i = entryList.size()-1; i >= 0; i--) {
			Map.Entry me = entryList.get(i);

			String name = (String) me.getKey();
			String party = Candidates.getInstance().getCandidateWithName(name).getParty();
			int votes = results.getOrDefault(name,0);
			double percentage = (votes/(double)totalVotes)*100;
			if (name.equals("Ralph Nader")){
				System.out.print("");
			}
			if(!(party.equals("???") && votes == 0)) {
				System.out.printf("%-30s%-8s%5d%9.1f\n", name, party, votes, percentage);
			}
		}
	}

	// Called when E key is pressed from main menu.
	// Removes the candidate who has the fewest votes, and reallocates his/her
	// votes to the next available choice for those ballots.
	private void eliminate() {
		// when the election is not closed,
		try{
			Map<String,Integer> results = election.getResultsFromPolls();
			List<Map.Entry<String,Integer>>  entryList = new ArrayList(results.entrySet());

			Collection<Integer> values = results.values();
			int totalVotes = 0;

			for(Integer i:values){
				totalVotes += i;
			}

			if(entryList.get(entryList.size()-1).getValue()/(double)totalVotes > 0.5) {
				// when the election already has a winner,
				System.out.println("A candidate already has a majority of the votes.");
				System.out.println("You cannot remove any more candidates.");
			}else {

				// when we can eliminate a candidate,
				System.out.println("Eliminating the lowest-ranked candidate.");
				List lowestCans = new ArrayList();
				lowestCans.add(entryList.get(0).getKey());
				int i = 1;
				while (i<entryList.size() && entryList.get(i).getValue() == entryList.get(0).getValue() ){
					lowestCans.add(entryList.get(i).getKey());
					i++;
				}

				if (lowestCans.size() >1) {
					Collections.sort(lowestCans);
					Collections.reverse(lowestCans);
				}
					election.eliminateCandidateWithName((String) lowestCans.get(0));

				System.out.println("Eliminated "+lowestCans.get(0)+".");
			}

		}catch(UnsupportedOperationException uso){
			System.out.println("The election is still open for votes.");
			System.out.println("You must close the election before eliminating candidates.");
		}

	}
}
