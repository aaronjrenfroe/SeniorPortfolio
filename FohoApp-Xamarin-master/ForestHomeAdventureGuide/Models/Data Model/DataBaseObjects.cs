using System;
using System.Collections.Generic;
using Realms;
namespace ForestHomeAdventureGuide
{
    public class FamilyMember : RealmObject
    {
		public int IndividualsEntityID { get; set; }
		public string IndividualsLastName { get; set; }
		public string Gender { get; set; }
		public string IndividualsFirstName { get; set; }
		public string FamiliesFamilyName { get; set; }
		public int FamiliesEntityID { get; set; }
    }

	public class Itinerary : RealmObject
	{
		public int ItineraryID { get; set; }
		public int RegistrationID { get; set; }
		public int EventDivisionID { get; set; }
		public int EntityID { get; set; }
		public int EventID { get; set; }
		public int EnrollmentStatus { get; set; }
        public string RegistrationBalance { get; set; }
		public string EventsName { get; set; }
		public string EventsAbbreviation { get; set; }
		public int LocationID { get; set; }
		public string LocationsName { get; set; }
		public string FirstName { get; set; }
		public string LastName { get; set; }
		public int EventTypeID { get; set; }
		public string BeginDateTime { get; set; }
		public string EndDate { get; set; }
	}

	public class LinkSummary : RealmObject
	{
        
		public string Caption { get; set; }
		public int DisplayOrder { get; set; }
		public string Link { get; set; }
		public string Name { get; set; }
		public string ThumbPath { get; set; }
		public int Year { get; set; }
		public string OriginalLink { get; set; }
		public string SetID { get; set; }
		public int RegistrationID { get; set; }
        public string Type {
            get{
                if (Link.Contains("flickr")){
                    return "flickr";
                }
                    return "unknown";
            }
        }   
	}

	public class ScheduledPost : RealmObject
	{
		public string Post_ID { get; set; }
		public string User_ID { get; set; }
		public string Title { get; set; }
		public string Body { get; set; }
		public string Has_Attachment { get; set; }
		public string Thumnail_URL { get; set; }
		public string Excerpt { get; set; }
		public string Expire_Date { get; set; }
		public string Date_Visable { get; set; }
		public string Timestamp { get; set; }
		public string Event_ID { get; set; }
		public string Event_Name { get; set; }
		public string Visable_Date { get; set; }
		public string Location { get; set; }
		public string Location_ID { get; set; }
        public string Type { 
            get{
                if (Body.ToLower().Contains("vimeo")){
                    return "vimeo";
                }
                if (Body.ToLower().Contains(".pdf"))
                {
                    return "pdf";
                }
                return "HTML";
            }
        }
        public bool ShouldDisplay {
            get{
				var vDate = DateTime.ParseExact(Visable_Date, "yyyy-MM-ddTHH:mm:ss",
									   System.Globalization.CultureInfo.InvariantCulture);
                
                if (vDate.Date < DateTime.Today.Date){
                    return true;
                }
                return false;
            }
        }
    }

	public class MedRecord : RealmObject
	{
		public string DosageTimeOfDay { get; set; }
		public int LogID { get; set; }
		public string DosageStatus { get; set; }
		public string LogDate { get; set; }
		public string EntryDate { get; set; }
		public string MedName { get; set; }
		public string EntityName { get; set; }
		public int EntityID { get; set; }
	}

	public class StoreCard : RealmObject
	{
		public int RegistrationID { get; set; }
		public int CamperID { get; set; }
		public string LastName { get; set; }
		public string FirstName { get; set; }
		public string Gender { get; set; }
		public string EventName { get; set; }
		public string BeginDate { get; set; }
		public string Location { get; set; }
		public string CostCenter { get; set; }
		public string EndDate { get; set; }
		public string EventDivisionName { get; set; }
		public int ParentID { get; set; }
		public string ParentName { get; set; }
		public string DonateRemainingBalance { get; set; }
		public string GiftCardStatus { get; set; }
		public double Credit { get; set; }
		public double Debit { get; set; }
		public double PendingBalance { get; set; }
		public double ClearedBalance { get; set; }
		public double RegistrationBalance { get; set; }
		public string PaymentSource { get; set; }
		public bool HasElectronicPayments { get; set; }
	}

	public class StoreCardTransaction : RealmObject
	{
		public String EntityID { get; set; }
		public String Invoice { get; set; }
		public String ItineraryID { get; set; }
		public String CamperName { get; set; }
		public String Time { get; set; }
		public String TotalCharged { get; set; }
		public String Type { get; set; }
		public String Details { get; set;}
        public String Header { get; set; }

	}

    public class Blog : RealmObject
    {
        public string author_image { get; set; }
        public string banner { get; set; }
        public string excerpt { get; set; }
        public string content { get; set; }
        public string date { get; set; }
        public string title { get; set; }
        public string author { get; set; }
        public string author_image_type { get; set; }
    }

    public class UpdatedTime : RealmObject
    {
        public DateTimeOffset LoginTime { get; set;  }
        public DateTimeOffset RegistrationTime { get; set; }
        public DateTimeOffset MedsTime { get; set; }
        public DateTimeOffset StoreCardBalanceTime { get; set; }
        public DateTimeOffset SCTransactionTime { get; set; }
        public DateTimeOffset MediaLinksTime { get; set; }
        public DateTimeOffset Posts { get; set; }
        public DateTimeOffset Blogs { get; set; }
        public DateTimeOffset Weather { get; set; }

    }
}
