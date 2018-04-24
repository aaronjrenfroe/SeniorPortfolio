using System;
namespace ForestHomeAdventureGuide.Utils
{
    public static class MyDateTime
    {
		public static DateTimeOffset StringToDTO(string timeString)
		{
			return new DateTimeOffset(DateTime.ParseExact(timeString, "yyyy-MM-ddTHH:mm:ss",
														  System.Globalization.CultureInfo.InvariantCulture));

		}

    }
}
