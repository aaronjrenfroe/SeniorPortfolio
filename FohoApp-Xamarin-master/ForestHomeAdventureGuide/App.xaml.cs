using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using Newtonsoft.Json;
using Xamarin.Forms;
using Realms;

namespace ForestHomeAdventureGuide
{
	public partial class App : Application
	{
		
		const string IsAuthedKey = "LoggegIn";
		const string FirstNameKey = "FirstName";
		const string LastNameKey = "LastName";
		const string EntityIDKey = "EntityID";
		const string FamilyIDKey = "FamilyID";
        const string FirstRun = "FirstRun";
		const string LastWeatherUpdateKey = "LastWeatherUpdate";

		public double ScreenWidth;
		public double ScreenHeight;

		public App()
		{
			InitializeComponent();
			ScreenWidth = 0;
			ScreenHeight = 0;
			MainPage = new AppEntryPage();
            var r = Realm.GetInstance();
		}

		protected override void OnStart()
		{
			// Handle when your app starts
		}

		protected override void OnSleep()
		{
			// Handle when your app sleeps
		}

		protected override void OnResume()
		{
			// Handle when your app resumes
		}

		public void SignOut()
		{
			Properties.Clear();
			IsAuthed = false;

			// Clear Realm

		}
		// Simplifying Persistant storage of basic info
		public bool IsAuthed
		{
			get
			{
				
				if (Properties.ContainsKey(IsAuthedKey))
					return (bool) Properties[IsAuthedKey];
				return false;
			}
			set
			{
				Properties[IsAuthedKey] = value;
				SavePropertiesAsync();
			}
		}
		public string FirstName
		{
			get
			{
				if (Properties.ContainsKey(FirstNameKey))
					return Properties[FirstNameKey].ToString();
				return "";
			}
			set
			{
				Properties[FirstNameKey] = value;
                SavePropertiesAsync();
				
			}
		}

		public string LastName
		{
			get
			{
				if (Properties.ContainsKey(LastNameKey))
					return Properties[LastNameKey].ToString();
				return "";
			}
			set
			{
				Properties[LastNameKey] = value;
                SavePropertiesAsync();
			}
		}
		public string EntityID
		{
			get
			{
				if (Properties.ContainsKey(EntityIDKey))
					return Properties[EntityIDKey].ToString();
				return "";
			}
			set
			{
				Properties[EntityIDKey] = value;
                SavePropertiesAsync();
			}
		}
		public List<string> FamilyIDs
		{
			get
			{
				if (Properties.ContainsKey(FamilyIDKey))
					return JsonConvert.DeserializeObject((String) Properties[FamilyIDKey] ) as List<string>;
				return new List<string>();
			}
			set
			{
				Properties[FamilyIDKey] =  JsonConvert.SerializeObject(value);
                SavePropertiesAsync();
			}
		}

		public string ApiToken
		{
			get
			{
				if (Properties.ContainsKey(FamilyIDKey))
					return Properties[FamilyIDKey].ToString();
				return "";
			}
			set
			{
				Properties[FamilyIDKey] = value;
				SavePropertiesAsync();
			}
		}
		public string LastWeatherUpdate
		{
			get
			{
				if (Properties.ContainsKey(LastWeatherUpdateKey))
					return (string) Properties[LastWeatherUpdateKey];
				return "";
			}
			set
			{
				Properties[LastWeatherUpdateKey] = value;
                SavePropertiesAsync();
			}
		}
	}
}