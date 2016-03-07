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

	return 1
