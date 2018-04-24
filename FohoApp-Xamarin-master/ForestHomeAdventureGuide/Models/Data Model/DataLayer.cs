using System;
using Realms;
using Newtonsoft.Json;
using Xamarin.Forms;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using System.Diagnostics;

// Stores data from network layer to Realm

namespace ForestHomeAdventureGuide
{
	public static class DataLayer
	{
		static JsonSerializerSettings settings = new JsonSerializerSettings
		{
			NullValueHandling = NullValueHandling.Ignore
		};

		public static bool ProcessLogin(String StringData)
		{

			LoginLogin ll = JsonConvert.DeserializeObject<LoginLogin>(StringData, settings);
			var authed = false;
			var app = Application.Current as App;

			if (ll.StatusCode == 1)
			{
				authed = true;

                app.ApiToken = ll.ApiToken;//(string)(Dict["ApiToken"]);

                app.EntityID = ll.EntityID.ToString();//((long)Dict["EntityID"]).ToString();

                app.FirstName = ll.FirstName;//(string) Dict["FirstName"];

                app.LastName = ll.LastName;//(string)Dict["LastName"];

                var FamilyIds = ll.FamilyIDs; //(Dict["FamilyIDs"]) as JArray;
				var stringFamilyIds = new List<string>();
				app.FamilyIDs = stringFamilyIds;
                StoreFamilyMembers(ll.FamilyMembers);
                StoreRegistrations(ll.Itineraries);
			}
			return authed;
		}

		public static bool ParseBlogs(string data)
		{
			
			var blogR = JsonConvert.DeserializeObject<BlogResponse>(data,settings);
			if (blogR.status == "ok")
			{
                // parse content
                var r = Realm.GetInstance();
                var blogsList = blogR.blogs;
                var old = r.All<Blog>();
                RemoveFromRealm(old);
                foreach (var item in blogsList)
                {
                    if (item.author_image == ""){
                        item.author_image = "ForestHomeAdventureGuide.Assets.PlaceHolders.fc_bear.png";
                    }
                    if (item.banner == ""){
                        item.banner = "https://www.foresthome.org/wp-content/uploads/2016/10/16AM_Wk1_Tuesday_Freetime-226.jpg";
                    }
                    if (item.title == ""){
                        continue;
                    }
                    if (item.content == ""){
                        continue;
                    }
                    if (item.excerpt == ""){
                        continue;
                    }
                    if (item.date == ""){
                        continue;
                    }
					r.Write(() =>
					{
						r.Add(item);
					});
                }

                return true;
			}
			// else
			return false;

		}
        // Parsing MedRecords
        public static bool ParseMeds(string data)
        {
			
            var mrj = JsonConvert.DeserializeObject<MedRecordJson>(data, settings);
            if (mrj.StatusCode == "1"){
                var old = Realm.GetInstance().All<MedRecord>();
				RemoveFromRealm(old);
                StoreCamperMeds(mrj.Records);
                return true;
            }
            return false;
        }

        public static bool ParseItinUpdate(string data)
        {
            var itinData = JsonConvert.DeserializeObject<UpdateUpdate>(data, settings);
            if (itinData.StatusMessage == "Success")
            {
				var old = Realm.GetInstance().All<Itinerary>();
				RemoveFromRealm(old);
                if (itinData.FamilyMembers.Count > 1) {
                    
                    StoreFamilyMembers(itinData.FamilyMembers);
                }
                StoreRegistrations(itinData.Itineraries);
                return true;
            }
            return false;
        }

		public static bool ParsePosts(string data)
		{
            var postData = JsonConvert.DeserializeObject<ScheduledPostJson>(data, settings);
			if (postData.StatusCode == 1)
			{
				var old = Realm.GetInstance().All<ScheduledPost>();
				RemoveFromRealm(old);
				StorePosts(postData.Posts);
				return true;
			}
			return false;
		}

		public static bool ParseMediaLinks(string data)
		{
			var mLinks = JsonConvert.DeserializeObject<MediaLinkJson>(data, settings);
			if (mLinks.StatusCode=="1")
			{
				var old = Realm.GetInstance().All<LinkSummary>();
				RemoveFromRealm(old);
				StoreMediaLinks(mLinks.LinkSummaries);
				return true;
			}
			return false;
		}

        public static bool ParseStoreCards(string data)
        {
			var storeCards = JsonConvert.DeserializeObject<StoreCardBalanceJson>(data, settings);
			if (storeCards.StatusCode == 1)
			{
				var old = Realm.GetInstance().All<StoreCard>();
				RemoveFromRealm(old);
				StoreStoreCardBalance(storeCards.Results);
				return true;
			}
			return false;
        }

		public static bool ParseStoreCardsTransactions(string data)
		{
			var dict = JsonConvert.DeserializeObject<Dictionary<String, Object>>(data, settings);
            if (((int) dict["StatusCode"]) == 1 )
			{
                // transactions
                var transactions = (dict["Results"] as Dictionary<String, List<Dictionary<String, Object>>>);
                var keys = new List<string>(transactions.Keys);
                var sortedTransactions = new List<StoreCardTransaction>();
                foreach (var key in keys)
                {
                    var trans = transactions[key];
                    if (trans.Count != 0)
                    {
                        var tempTrans = new StoreCardTransaction();
                        tempTrans.EntityID = (string)trans[0]["entityID"];
                        tempTrans.Invoice = (string)trans[0]["invoice"];
                        tempTrans.ItineraryID = (string)trans[0]["itineraryID"];
                        tempTrans.CamperName = (string)trans[0]["name"];
                        tempTrans.Time = (string)trans[0]["time"];
                        tempTrans.TotalCharged = (string)trans[0]["charge"];
                        tempTrans.Type = (string)trans[0]["transactionDescription"];
                        switch (tempTrans.Type)
                        {
                            case "Store Purchase":
                                tempTrans.Header = tempTrans.CamperName + " made a purchase";
                                foreach (var item in trans)
                                {
                                    try
                                    {
                                        tempTrans.Details += (string)item["description"] + "for: " + ((Int32)item["quantity"]).ToString() + " x " + (String.Format("{0:C2", (decimal)item["price"])) + "\n";
                                    }
                                    catch (Exception ex)
                                    {
                                        Debug.WriteLine(ex.StackTrace);
                                        continue;
                                    }
                                }

                                break;
                            case "Add Store Credit":
                                tempTrans.Header = tempTrans.CamperName;
                                tempTrans.Details = tempTrans.TotalCharged + "was added to your campers storecard";
                                break;
                            case "Donate Remaining Credit":
                                tempTrans.Header = tempTrans.CamperName;
                                tempTrans.Details = tempTrans.TotalCharged + "was donated from your campers storecard";
                                break;
                            case "Reduce Store Credit":
                                tempTrans.Header = tempTrans.CamperName;
                                tempTrans.Details = tempTrans.TotalCharged + "was returned from your campers storecard";
                                break;
                            case "Cancel Card":
                                tempTrans.Header = tempTrans.CamperName;
                                tempTrans.Details = tempTrans.TotalCharged + "was returned from your campers storecard";
                                break;
                            default:
                                // Transaction type unknown do nothing
                                continue;
                        }
                        sortedTransactions.Add(tempTrans);
                    }
                }
                var old = Realm.GetInstance().All<StoreCardTransaction>();
				RemoveFromRealm(old);
                StoreStoreCardTransactions(sortedTransactions);
				return true;
			}
			return false;
		}

        static void RemoveFromRealm(System.Linq.IQueryable<RealmObject> objects)
        {
            var r = Realm.GetInstance();
			foreach (var old in objects)
			{
                r.Write(() =>
                {
                    r.Remove(old);
                });
			}
        }

        static void StoreFamilyMembers(List<FamilyMember> fms)
        {
            var r = Realm.GetInstance();
            foreach (var item in fms)
            {
                
                {
                    r.Write(() =>
                    {
                        r.Add(item);
                    });
                }
            }

        }

        static void StoreRegistrations(List<Itinerary> itins)
        {
			var r = Realm.GetInstance();
            foreach (var item in itins)
            {
				r.Write(() =>
				{
					r.Add(item);
				});
            }
        }

        static void StoreStoreCardTransactions(List<StoreCardTransaction> stc)
        {
            var r = Realm.GetInstance();
            foreach (var item in stc)
            {
				r.Write(() =>
				{
					r.Add(item);
				});
            }
        }

        static void StoreStoreCardBalance(List<List<StoreCard>> scs)
        {
            var r = Realm.GetInstance();
            foreach (var person in scs)
            {
                foreach (var item2 in person)
                {
                    r.Write(() =>
                    {
                        r.Add(item2);
                    });
                }
            }
        }

		static void StoreCamperMeds(List<MedRecord> cmr)
		{
			var r = Realm.GetInstance();
			foreach (var item in cmr)
			{
				r.Write(() =>
				{
					r.Add(item);
				});
			}
		}

		static void StoreMediaLinks(List<LinkSummary> mlink)
		{
			var r = Realm.GetInstance();
			foreach (var item in mlink)
			{
				r.Write(() =>
				{
					r.Add(item);
				});
			}
		}

		static void StorePosts(List<ScheduledPost> sps)
		{
			var r = Realm.GetInstance();
			foreach (var item in sps)
			{
                if (item.Location_ID == null) {
                    item.Location_ID = "0";
                    item.Location = "";
                }
                if (item.Event_ID == null || item.Event_Name == "")
                {
                    item.Event_ID = "";
                    item.Event_Name = "";
                }
				r.Write(() =>
				{
					r.Add(item);
				});
			}
		}


	}


}
