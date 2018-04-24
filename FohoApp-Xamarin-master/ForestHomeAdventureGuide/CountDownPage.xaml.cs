using System;
using System.Collections.Generic;

using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public partial class CountDownPage : ContentPage
	{
		public CountDownPage()
		{
			InitializeComponent();
			//BackgroundImage = "ForestHomeAdventureGuide.Assets.Countdown Image.png";
			switch (Device.RuntimePlatform)
			{
				case Device.iOS:
					Padding = new Thickness(0, 20, 0, 0);
					break;
			}
		}

		protected override bool OnBackButtonPressed()
		{
			// Close app for android nothing for ios
			if (Device.Android == Device.RuntimePlatform)
		       DependencyService.Get<IAndroidMethods>().CloseApp();

		   return base.OnBackButtonPressed(); 
		}

		protected override void OnAppearing()
		{
			base.OnAppearing();
			var app = Application.Current as App;
			if (!app.IsAuthed)
			{
				// Go to CountDown Page
				Navigation.PopModalAsync();
			}
		}
		//

		void HandleContinueClicked(object sender, System.EventArgs e)
		{
            // Test this
            Navigation.PopModalAsync();
			Navigation.PushModalAsync(new ListMenuPage());
		}
	}
}
