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

	DLL Written by Oisin100 and modified by Skull132
*/

/*
 * A generic proc for sending a post request with the aforementioned .DLL files.
 * Expected arg structure:
 * 1st arg			- the url
 * 2nd arg			- the request body
 * 3rd - nth arg	- individual headers and their values in format: "headername: value"
 *
 * @return int		- Error code from one of three possible sources!
 * -1 indicates proc or library failure.
 * 0 - 92 are curl errors, and are usually accompanied by a HTTP response code of 0 (request was never made).
 * 100 - 6xx are HTTP response codes. Curl error code should be 0 in this case, but, in case that it is not,
 * the HTTP response code is always returned as long as it is not 0.
 *
 */
/proc/send_post_request()
	if (args.len < 2)
		return -1

	var/result = call("ByondPOST.dll", "send_post_request")(arglist(args))

	if (!result)
		log_debug("ByondPOST POST: No result returned from external library.")
		return -1

	var/list/A = params2list(result)

	if (!isnull(A["proc"]))
		// Log the proc error. It should be reviewed by coders ASAP.
		switch (A["proc"])
			if ("1")
				log_debug("ByondPOST POST: Proc error: Too few arguments sent to function.")
			if ("2")
				log_debug("ByondPOST POST: Proc error: Unable to initialize curl object.")
			if ("3")
				log_debug("ByondPOST POST: Proc error: General exception caught and logged.")
			else
				log_debug("ByondPOST POST: Proc error: Unknown error.")
		return -1

	// Curl oriented errors should leave the HTTP response code at 0, as no request was executed.
	// All HTTP oriented errors will definately return a response code other than 0, so prioritize that.
	// Fallback is a curl error code (0 - 92).
	return text2num(A["http"]) != 0 ? text2num(A["http"]) : text2num(A["curl"])

/*
 * A generic proc for sending a header equipped get requests with the aforementioned .DLL files.
 * If you're using this without sending custom headers, please stop. Use world.Export() instead.
 * Expected arg structure:
 * 1st arg			- the url
 * 2nd - nth arg	- individual headers and their values in format: "headername: value"
 *
 * @return mixed	- Returns list if request was successful, integer (specific cURL or HTTP error) if failed.
 * -1 indicates proc or library failure.
 * 0 - 92 are curl errors, and are usually accompanied by a HTTP response code of 0 (request was never made).
 * 100 - 6xx are HTTP response codes. Curl error code should be 0 in this case, but, in case that it is not,
 * the HTTP response code is always returned as long as it is not 0.
 *
 */
/proc/send_get_request()
	if (args.len < 2)
		return -1

	var/result = call("ByondPOST.dll", "send_get_request")(arglist(args))

	if (!result)
		log_debug("ByondPOST GET: No result returned from external library.")
		return -1

	var/list/A

	// Try to evaluate it as JSON data (successful request)
	try
		A = json_decode(result)

		return A
	catch()
	// Nope, we failed. do regular error parsing instead.
		A = params2list(result)

		if (!isnull(A["proc"]))
			switch (A["proc"])
				if ("1")
					log_debug("ByondPOST GET: Proc error: Too few arguments sent to function.")
				if ("2")
					log_debug("ByondPOST GET: Proc error: Unable to initialize curl object.")
				if ("3")
					log_debug("ByondPOST GET: Proc error: General exception caught and logged.")
				else
					log_debug("ByondPOST GET: Proc error: Unknown error.")
			return -1

		return text2num(A["http"]) != 0 ? text2num(A["http"]) : text2num(A["curl"])
