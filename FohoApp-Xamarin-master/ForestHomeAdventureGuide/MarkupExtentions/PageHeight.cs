using System;
using Xamarin.Forms.Xaml;
using Xamarin.Forms;

namespace ForestHomeAdventureGuide
{
	[ContentProperty("Constant")]
	public class PageHeight : IMarkupExtension
	{
		public string Constant { get; set;}
		public object ProvideValue(IServiceProvider serviceProvider)
		{
			if (String.IsNullOrEmpty(Constant))
				return null;
			return (Application.Current as App).ScreenHeight * Double.Parse(Constant);
		}

	}
}
