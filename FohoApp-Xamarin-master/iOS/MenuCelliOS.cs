using System;
using System.Diagnostics.Contracts;
using ForestHomeAdventureGuide;
using ForestHomeAdventureGuide.iOS;
using UIKit;
using Xamarin.Forms;
using Xamarin.Forms.Platform.iOS;

[assembly: ExportRenderer(typeof(MenuCell), typeof(MenuCelliOS))]

namespace ForestHomeAdventureGuide.iOS
{
	public class MenuCelliOS: ImageCellRenderer
	{
		
		public override UIKit.UITableViewCell GetCell(Xamarin.Forms.Cell item, UIKit.UITableViewCell reusableCell, UIKit.UITableView tv)
		{
			Contract.Ensures(Contract.Result<UITableViewCell>() != null);
			var cell = base.GetCell(item,reusableCell, tv);

			cell.SelectedBackgroundView = new UIView
			{
				BackgroundColor = UIColor.FromRGB(233, 217, 133)
			};

			return cell;
		}

	}
}
