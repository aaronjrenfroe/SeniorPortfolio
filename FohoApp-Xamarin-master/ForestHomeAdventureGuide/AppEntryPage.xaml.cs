using System.Diagnostics;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public partial class AppEntryPage : ContentPage
	{
		public AppEntryPage()
		{
			
			InitializeComponent();
			logo.Source = ImageSource.FromResource("ForestHomeAdventureGuide.Assets.logo_small.png");

			switch (Device.RuntimePlatform)
			{
				case Device.iOS:
					Padding = new Thickness(0, 20, 0, 0);
					break;
			}
		}

		protected override async void OnAppearing()
		{
			base.OnAppearing();
			var app = Application.Current as App;
			app.ScreenWidth = Bounds.Width;
			app.ScreenHeight = Bounds.Height;
			Debug.WriteLine(app.IsAuthed);
			Debug.WriteLine(app.FirstName);
			if (app.IsAuthed)
			{
				// Go to CountDown Page
				await Navigation.PushModalAsync(new CountDownPage(), false);
			}
			else
			{
				// Go to Sign in Page
				await Navigation.PushModalAsync(new LoginPage(), false);
			}
		}

		protected override bool OnBackButtonPressed()
		{
			return false;
		}



	}

}
