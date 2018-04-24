using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
// Handles all networking requests
namespace ForestHomeAdventureGuide
{

	public static class NetworkingLayer
	{	 

		// Blogs
		public static async Task<string> BlogClient()
		{
			var value = await GeneralClient(ApiUri.Blog_Url, null);
			return value;
		}

		// Login 
		public static async Task<string> Authenticate(String email, String pass)
		{

			var parameters = new Dictionary<String, String>
				{
					{"1",email},
					{"2",pass}
				};
			var value = await GeneralClient(ApiUri.Auth_Server, parameters);
			return value;
		}
		// Shedualed Posts
		public static async Task<string> PostClient(string id)
		{
			var parameters = new Dictionary<String, String>
				{
					{"1",id}
				};
			var value = await GeneralClient(ApiUri.Scheduled_Posts_URL, parameters);
			return value;
		}
		// Media Links
		public static async Task<string> MediaLinksClient(string id)
		{
			var parameters = new Dictionary<String, String>
				{
					{"1",id}
				};
			var value = await GeneralClient(ApiUri.Media_Links_URL, parameters);
			return value;
		}
		// Meds
		public static async Task<string> MedClient(string id)
		{
			var parameters = new Dictionary<String, String>
				{
					{"1",id}

				};
			var value = await GeneralClient(ApiUri.Update_Meds, parameters);
			return value;
		}
		//FamilyMember Members and Registrations
		public static async Task<string> ItineraryClient(string id)
		{
				var parameters = new Dictionary<String, String>
				{
					{"1",id}
				};
			var value = await GeneralClient(ApiUri.Update_Family, parameters);
			return value;
		}
		// Store Card Transactions
		public static async Task<string> StorecardTransactionClient(string id)
		{	
			var parameters = new Dictionary<String, String>
				{
					{"1",id}
				};
			var value = await GeneralClient(ApiUri.Update_Store_Cards, null);
			return value;
		}
		// Store Card Balances
		public static async Task<string> StorecardBalanceClient(string id)
		{	
			var parameters = new Dictionary<String, String>
				{
					{"1",id}
				};
			var value = await GeneralClient(ApiUri.Card_Balances_URL, parameters);
			return value;
		}

		// General Requester
		public static async Task<String> GeneralClient(String location, Dictionary<String, String> parameters)
		{
            if (parameters == null)
            {
                parameters = new Dictionary<string, string>();
            }
			parameters.Add("Jesus", "is risen");
			var client = new HttpClient();
			client.BaseAddress = new Uri(location);

			string jsonData = JsonConvert.SerializeObject(parameters);

			var content = new StringContent(jsonData, Encoding.UTF8, "application/json");
			HttpResponseMessage response = await client.PostAsync("", content);

			// this result string should be something like: "{"token":"rgh2ghgdsfds"}"

			var result = await response.Content.ReadAsStringAsync();
            if (response.IsSuccessStatusCode)
            {
                return result;
            }
            else
            {
                return "";
            }
		}
	}
}

