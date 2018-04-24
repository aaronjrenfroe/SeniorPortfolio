using System;
using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	public class DrawerItem
	{
		public int Index { get; set; }
		public String Title { get; set;}
		public ImageSource Icon { get; set;}

		public DrawerItem(String title, String ImageResourceName, int index)
		{
			Title = title;
			Icon = ImageSource.FromResource(ImageResourceName);
			Index = index;

		}



	}
}
