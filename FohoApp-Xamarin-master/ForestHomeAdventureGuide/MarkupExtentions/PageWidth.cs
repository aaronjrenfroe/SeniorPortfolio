using System;
using Xamarin.Forms.Xaml;
using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	[ContentProperty("Constant")]
	public class PageWidth : IMarkupExtension
	{
		public string Constant{ get; set;}
		public object ProvideValue(IServiceProvider serviceProvider)
		{
			if (String.IsNullOrEmpty(Constant))
				return null;
			return (Application.Current as App).ScreenWidth * Double.Parse(Constant);
		}
	
	}
}
