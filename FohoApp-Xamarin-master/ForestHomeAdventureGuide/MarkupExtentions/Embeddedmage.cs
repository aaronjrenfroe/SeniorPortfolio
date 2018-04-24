using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace ForestHomeAdventureGuide
{	
	[ContentProperty("ResourceID")]
	public class EmbeddedImage : IMarkupExtension
	{
		public string ResourceID { get; set;}
		public object ProvideValue(IServiceProvider serviceProvider)
		{
			if (String.IsNullOrEmpty(ResourceID))
				return null;
			return ImageSource.FromResource(ResourceID);
		}
	}
}
