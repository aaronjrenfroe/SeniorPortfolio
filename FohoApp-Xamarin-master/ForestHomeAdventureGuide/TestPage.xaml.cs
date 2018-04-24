using System;
using System.Collections.Generic;

using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public partial class TestPage : ContentPage
	{
		public TestPage()
		{
			InitializeComponent();
			fhLogo.Source = ImageSource.FromResource("ForestHomeAdventureGuide.Assets.logo_small.png");

		}


		async void Handle_Clicked_Help(object sender, System.EventArgs e)
		{
			var choice = await DisplayAlert("Login Information", "Use the same info used to access your account on our website", "Reset Password", "Thanks");
			if (choice)
			{
				Device.OpenUri(new Uri("https://mycircuitree.com/ForestHome/ForgotPassword"));
			}
		}

		async void Handle_Clicked_Login(object sender, System.EventArgs e)
		{
			((Button)sender).IsEnabled = false;
			// implement this
			var isConnected = true;
			if (isConnected)
			{
				var enteredEmail = emailEntry.Text;
				var enteredPassword = passwordEntry.Text;
				await DataManager.AttemptLogin(enteredEmail, enteredPassword, (bool status, int code) =>
				{
					if (status)
						Navigation.PopModalAsync();
					else
					{
						if (code == 1)
						{
							DisplayAlert("Login Failed", "Credentials Were Incorect", "Ok");
							(sender as Button).IsEnabled = true;
						}
						else if (code == 2)
						{
							DisplayAlert("Login Failed", "Was not able to connect with the server", "Ok");
							(sender as Button).IsEnabled = true;
						}
					}
				});
			}
			else
			{
				await DisplayAlert("No Connection", "You need to be connected to the Internet to do this.", "Ok");
				(sender as Button).IsEnabled = true;
			}


		}

		protected override bool OnBackButtonPressed()
		{
			// Close app for android nothing for ios
			if (Device.Android == Device.RuntimePlatform)
				DependencyService.Get<IAndroidMethods>().CloseApp();

			return base.OnBackButtonPressed();
		}

	}
}

/* 
  			<Image x:Name="fhLogo"  Aspect="AspectFit" 
				WidthRequest= "{local:PageHeight 0.10}"
				HeightRequest= "{local:PageHeight 0.10}"/>

*/