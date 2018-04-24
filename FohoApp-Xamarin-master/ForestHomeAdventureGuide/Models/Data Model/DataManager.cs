using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Realms;
using Xamarin.Forms;
using System.Diagnostics;
/**
* The Data Manager is the pathway for all informaton from the data to the application
* 
*/

namespace ForestHomeAdventureGuide
{
    
	public static class DataManager
	{

        public static async Task AttemptLogin(string Email, string Pass, Action<bool, int> Complete)
        {
            // Try to login again if no response
            for (int i = 0; i < 2; i++)
            {
                var Result = await NetworkingLayer.Authenticate(Email, Pass);
                if (Result != "")
                {
                    checkLoginResult(Result, Complete);
                    return;
                }
            }
            // if failed twice , error
            Complete.Invoke(false, 2);

        }

		private static void checkLoginResult(String Result, Action<bool, int> Complete)
		{
			var authed = DataLayer.ProcessLogin(Result);
			var app = Application.Current as App;
			if (authed)
			{
				app.IsAuthed = true;
				Complete.Invoke(true, 0);
			}
			else
			{
				app.IsAuthed = false;
				Complete.Invoke(false, 1);
			}
		}
        // BLOGS
		public static List<Blog> GetBlogs()
		{
            
            return (List<Blog>) Realm.GetInstance().All<Blog>();
		}
        // Returns List of Family Members
		public static List<FamilyMember> GetFamilyMembers()
		{

			return (List<FamilyMember>) Realm.GetInstance().All<FamilyMember>();
		}
		// Returns List of Itineraries
		public static List<Itinerary> GetItineraries()
		{

			return (List<Itinerary>) Realm.GetInstance().All<Itinerary>();
		}
        // Returns List of Med Records
		public static List<MedRecord> GetMeds()
		{

			return (List<MedRecord>) Realm.GetInstance().All<MedRecord>();
		}
        // Returns List of StoreCards
		public static List<StoreCard> GetStoreCards()
		{
			return (List<StoreCard>)Realm.GetInstance().All<StoreCard>();
		}
        // Returns List of Transactions
		public static List<StoreCardTransaction> GetSCTransactions()
		{
			return (List<StoreCardTransaction>)Realm.GetInstance().All<StoreCardTransaction>();
		}

        // Returns List of Media Links
		public static List<LinkSummary> GetMediaLinks()
		{
			return (List<LinkSummary>)Realm.GetInstance().All<LinkSummary>();
		}
        // Returns List of Posts
		public static List<ScheduledPost> GetPosts()
		{
			return (List<ScheduledPost>)Realm.GetInstance().All<ScheduledPost>();
		}

        // Fetches Blogs From Server
        public static async Task RefreshBlogs(Action<bool, int> Complete)
		{
            // Try twice
            for (int i = 0; i < 2; i++)
            {
				var data = await NetworkingLayer.BlogClient();
                if (data != "") {
                    if (DataLayer.ParseBlogs(data)){
                        Complete.Invoke(true,0);
                        return;
                    }
                }
            }
            Complete.Invoke(false, 2);
		}

		// Fetches Blogs From Server
		public static async Task RefreshMeds(Action<bool, int> Complete)
		{
			// Try twice

			for (int i = 0; i < 2; i++)
			{
				var data = await NetworkingLayer.MedClient((Application.Current as App).EntityID);
				if (data != "")
				{
					if (DataLayer.ParseMeds(data))
					{
						Complete.Invoke(true, 0);
						return;
					}
				}
			}
			Complete.Invoke(false, 2);
            return;
		}

        public static async Task RefreshItineraries(Action<bool, int> Complete)
        {
			for (int i = 0; i < 2; i++)
			{
				var data = await NetworkingLayer.ItineraryClient((Application.Current as App).EntityID);
				if (data != "")
				{
					if (DataLayer.ParseItinUpdate(data))
					{
						Complete.Invoke(true, 0);
						return;
					}
				}
			}
			Complete.Invoke(false, 2);
            return;
        }

		public static async Task RefreshPosts(Action<bool, int> Complete)
		{
			for (int i = 0; i < 2; i++)
			{
				var data = await NetworkingLayer.PostClient((Application.Current as App).EntityID);
				if (data != "")
				{
					if (DataLayer.ParseItinUpdate(data))
					{
						Complete.Invoke(true, 0);
						return;
					}
				}
			}
			Complete.Invoke(false, 2);
			return;
		}

        public static async Task RegreshAll(){

            await RefreshMeds((bool b, int i) => Debug.WriteLine(b + i.ToString()));

            await RefreshBlogs((bool b, int i) => Debug.WriteLine(b + i.ToString()));

            await RefreshItineraries((bool b, int i) => Debug.WriteLine(b + i.ToString()));

            await RefreshPosts((bool b, int i) => Debug.WriteLine(b + i.ToString()));

        }

        static bool Old(RequestType type)
        {
            var r = Realm.GetInstance();
            var times = (List<UpdatedTime>)r.All<UpdatedTime>();
            if (times.Count > 0)
            {
                
                var time = times[0];
                var now = new DateTimeOffset(DateTime.Now);
                switch (type)
                {
                    case RequestType.Login:
                        return time.LoginTime.AddDays(14) < now;
                    case RequestType.Blogs:
                        return time.Blogs.AddDays(1) < now;
                    case RequestType.MediaLinks:
                        return time.MediaLinksTime.AddMinutes(30) < now;
                    case RequestType.Medications:
                        return time.MedsTime.AddMinutes(30) < now;

                    case RequestType.Posts:
                        return time.Posts.AddMinutes(30) < now;

                    case RequestType.Registrations:
                        return time.RegistrationTime.AddMinutes(30) < now;

                    case RequestType.StoreCardBalances:
                        return time.StoreCardBalanceTime.AddMinutes(30) < now;
                    case RequestType.StoreCardTransactions:
                        return time.SCTransactionTime.AddMinutes(30) < now;
                    case RequestType.Weather:
                        return time.Weather.AddMinutes(30) < now;
                }

            }
            //No record which would mean no information
            return true;

        }
	}
}
