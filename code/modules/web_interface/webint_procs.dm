/*
 * Contains general purpose procs used with Aurora's web interface and related functions.
 */

/*
 * /proc/validate_webint_attributes()
 * Used to validate parametres sent to procs that are meant to communicate with the web interface.
 * Most commonly in Topic() calls, so that href tomfoolery is negated.
 *
 * Arguments:
 * - var/list/required_attributes	- A list of required attributes. This is what the other arguments will be tested against. Cannot be null.
 * - var/list/attributes_list 		- The attributes to be validated, passed in a list form. Can be null.
 * - var/attributes_text			- The attributes to be validated, passed in a text form. (Formatted according to list2params() convention.)
 * This overrides attributes_list if both are present. Can be null.
 *
 * Returns:
 * 1 - if all required attributes are present, and no erronious ones exist.
 * 0 - if certain required attributes are missing, or there are extras.
 */

/proc/webint_validate_attributes(var/list/required_attributes, var/list/attributes_list, var/attributes_text)
	if (!required_attributes || !istype(required_attributes) || !required_attributes.len)
		return 0

	if (attributes_text)
		attributes_list = params2list(attributes_text)

	if (!attributes_list || !attributes_list.len)
		return 0

	for (var/attribute in attributes_list)
		if (!(attribute in required_attributes))
			return 0

		if (attributes_list[attribute] && required_attributes[attribute])
			if (istype(required_attributes, /list))
				if (!(attributes_list[attribute] in required_attributes[attribute]))
					return 0

			else
				if (attributes_list[attribute] != required_attributes[attribute])
					return 0

	return 1

/*
 * /proc/webint_start_singlesignon()
 * Used to insert a token into the web_sso database and to enable a user to navigate to a page on the website and be automatically logged in. Generates a hash algorithmically. Additional security managed on the website's end.
 *
 * Arguments:
 * - var/user				- Must be a mob or a client. The player object that's going to be using the request.
 * - var/list/attributes	- The attributes to which we route the URL as we call user.process_webint_link().
 * Validated here with webint_validate_attributes().
 * Must contain the 'location' key.
 *
 * Returns:
 * 0 - if one of the checks is failed and the operation cancelled.
 * string - if everything works, it will return the attributes with the added token and ckey value.
 */

/proc/webint_start_singlesignon(var/client/user, var/attributes)
	if (!istype(user))
		return 0

	var/list/permitted_locations = list("user_dashboard", "contract_overview", "contract_details", "security_incident")

	if (!webint_validate_attributes(list("location" = permitted_locations, "contract", "incident"), attributes_text = attributes))
		return 0

	var/token = ""
	var/list/alphabet = alphabet_uppercase
	alphabet.Add(list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"))
	alphabet.Add(list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0"))

	for (var/i = 0, i <= 24, i++)
		token += alphabet[rand(1, alphabet.len)]

	attributes += "&"
	attributes += list2params(list("ckey" = user.ckey, "token" = token))

	if (!establish_db_connection(dbcon))
		alert("An error occured while attempting to connect to the database!")
		return 0

	var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO ss13_web_sso (ckey, token, ip, created_at) VALUES (:ckey:, :token:, :ip:, NOW())")
	insert_query.Execute(list("ckey" = user.ckey, "token" = token, "ip" = user.address))

	if (insert_query.ErrorMsg())
		alert("An error occured while trying to upload the session data!")
		return 0

	if (alert("This will take you to the webpage and log you in. Do you wish to proceed?",,"Yes","No") == "No")
		return 0

	return attributes
