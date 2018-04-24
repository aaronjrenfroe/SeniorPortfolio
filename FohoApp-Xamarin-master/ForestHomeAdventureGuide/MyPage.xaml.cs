using System;
using System.Collections.Generic;

using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public partial class MyPage : ContentPage
	{
		public MyPage(String title)
		{
			InitializeComponent();
			label.Text = title + "";
			Title = title;

			// Debugging

		}
	}
}
