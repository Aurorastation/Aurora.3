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
 * Expected arg structure:
 * 1st arg			- the url
 * 2nd arg			- the request body
 * 3rd - nth arg	- individual headers and their values in format: "headername: value"
 *
 * @return int		- 1 if success, 0 if failure.
 *
 * TODO: Modify ByondPOST.dll to return proper success/failure codes.
 *
 */
/proc/send_post_request()
	if (args.len < 1)
		return 0

	call("ByondPOST.dll", "send_post_request")(arglist(args))
	return 1
