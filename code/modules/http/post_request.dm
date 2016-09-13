/*

	@===================================@
	|                                   |
	|    Guide to HTTP Post requests    |
	|                                   |
	@===================================@

	Making POST requests in byond is SUPER easy with the post request DLL.

	Simply use the call() function to call the post request DLL and enter your details!

	The first bit of code needed will always be the same, You will never have to touch this, Copy-pasta all you like:

			call("ByondPOST.dll", "send_post_request")

	Well thats the first part, the harder part is to input the details into DLL. Lets do that now! The syntax to add arguments to the post request is:

			call("ByondPOST.dll", "send_post_request")(PostURL, PostContent, Header)

	In a lot of cases you might need more then one custom header to make a valid POST request, One such case is when you want to use the Discord API,
	the discord API requires 2 custom headers, one to tell the server that you are making a JSON post request,
	the header for this is "Content-Type: application/json" And another to tell the Discord API your login token,
	Which looks like this "Authorization: YourLoginToken"
	This can be achieved in Byond with the following code

		call("ByondPOST.dll", "send_post_request")("http://example.com", somebodyhere, "Content-Type: application/json", "Authorization: YourTokenHere")

	As you can see we have added some more arguments onto the proc, You can add as many arguments you like to the proc, Any argument after the PostContent
	argument is considered a header.

	Some example POST requests:

	<-- Send Discord Message -->
		call("ByondPOST.dll", "send_post_request")("https://discordapp.com/api/channels/134720091576205312/messages", " { \"content\" : \"Hello World!\" } ", "Content-Type: application/json", "Authorization: DAsDAs4!"�DFdW45%fAsFSa^$!"�$Xfdsfh523ds")

	DLL Written by Oisin100
*/

/*
 * A generic proc for sending a post request with the aforementioned .DLL files.
 * @param text url - the URL you wish to send the post request to.
 * @param text content - the raw data you wish to send as the body of your post request.
 * @param list headers - a list of text headers to be added to the request.
 * @return int - 1 if success, 0 if failure.
 *
 * TODO: Modify ByondPOST.dll to return proper success/failure codes.
 *
 */
/proc/send_post_request(var/url, var/content = "", var/list/headers = list())
	if (!url)
		return 0

	call("ByondPOST.dll", "send_post_request")(url, content, arglist(headers))
	return 1
