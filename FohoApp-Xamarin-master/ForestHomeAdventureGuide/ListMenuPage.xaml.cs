using System;
using System.Collections.Generic;
using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public partial class ListMenuPage : MasterDetailPage
	{
		List<DrawerItem> diList;
		List<string> names;
		// Declared in xaml: drawerItems: ListView
		public ListMenuPage()
		{
			InitializeComponent();
			//Detail = new NavigationPage(new MyPage("Feed"));
			IsPresented = false;
			 

			switch (Device.RuntimePlatform)
			{
				case Device.iOS:
					Padding = new Thickness(0, 20, 0, 0);
					break;
			}
			NavSetup();
			Icon = "ForestHomeAdventureGuide.Assets.menuIcon.png";
			Title = "Bob";

		}

		protected override void OnAppearing()
		{
			base.OnAppearing();
			userNameLabel.Text  = (Application.Current as App).FirstName;
			drawerItems.SelectedItem = diList[0];
		}

		private void NavSetup()
		{
			names = new List<string>
			{

				"Feed",
				"Registrations",
				"Blogs",
				"Directions",
				"Weather",
				"Storecards",
				"Give",
				"About",
				"Sign out"
			};

			diList = new List<DrawerItem>();
			var prefix = "ForestHomeAdventureGuide.Assets.";
			// Feed
			diList.Add(new DrawerItem(names[0], prefix + "house@3x", 0 ));
			// Registrations
			diList.Add(new DrawerItem(names[1], prefix + "calendar@3x.png", 1));
			// Blogs
			diList.Add(new DrawerItem(names[2], prefix + "Media.png", 2));
			// Directions
			diList.Add(new DrawerItem(names[3], prefix + "Map.png", 3));
			// Weather
			diList.Add(new DrawerItem(names[4], prefix + "weather@3x.png", 4));
			// Storecards
			diList.Add(new DrawerItem(names[5], prefix + "storeCards@3x", 5));
			// Give
			diList.Add(new DrawerItem(names[6], prefix + "give.png" , 6));
			// About Us
			diList.Add(new DrawerItem(names[7], prefix + "information@3x.png", 7));
			// Sign Out
			diList.Add(new DrawerItem(names[8], prefix + "power@3x.png", 8));
			drawerItems.ItemsSource = diList;
			menuLogo.Source = ImageSource.FromResource("ForestHomeAdventureGuide.Assets.logo_small.png");
		}

		async void Handle_ItemSelected(object sender, Xamarin.Forms.SelectedItemChangedEventArgs e)
		{	
			
			var drawerItem = e.SelectedItem as DrawerItem; //.SelectedAction.Invoke((e.SelectedItem as DrawerItem).Title);
			if (drawerItem != null)
			{
				switch (drawerItem.Index)
				{
					// Feed Button
					case 0:
						
						Detail = new NavigationPage(new MyPage(drawerItem.Title));
						IsPresented = false;
						break;
					// Registrations Page
					case 1:
						Detail = new NavigationPage(new BlogsPage());
						IsPresented = false;
						break;
					// Blog Page
					case 2:
						Detail = new NavigationPage(new MyPage(drawerItem.Title));
						IsPresented = false;
						break;
					// Directions Page
					case 3:
						Detail = new NavigationPage(new MyPage(drawerItem.Title));
						IsPresented = false;
						break;
					// Weather Page
					case 4:
						Detail = new NavigationPage(new MyPage(drawerItem.Title));
						IsPresented = false;
						break;
					// StoreCards Page
					case 5:
						Detail = new NavigationPage(new TestPage());
						IsPresented = false;
						break;
					// Give Button
					case 6:
						Device.OpenUri(new Uri("https://www.foresthome.org/donate/giving-opportunities/"));
						break;

					// About
					case 7:
						Device.OpenUri(new Uri("http://www.foresthome.org/About"));
						break;
					// Signout Button
					case 8:
						//throw new NotImplementedException();

						//IsPresented = false;
						var app = Application.Current as App;
						app.SignOut();
						await Navigation.PopModalAsync();
						break;
					// Would never happen
					default:
						Detail = new NavigationPage(new MyPage(drawerItem.Title));
						IsPresented = false;
						break;

				}
			}

		}

	}
}
