/**
 * Generate a new, unused NTNet address. (E.g. '**fc00:1a2b:45cd:6e3d**')
 *
 * Arguments:
 * * seed - **(REQUIRED)** A "seed" value, which is hashed in order to create an address.
 */
/proc/generate_ntnet_address(seed)
	var/static/list/existing_addresses = list()

	var/new_address = null
	do
		var/hash = md5(seed)
		// Split up the first 12 characters of the hash into groups of four.
		var/list/hex_groups = list(
			copytext(hash, 1, 5),
			copytext(hash, 5, 9),
			copytext(hash, 9, 13),
		)

		new_address = "fc00:[hex_groups.Join(":")]"
		seed = "[seed]0" //If we did get a collision, this should make the next attempt not have one.
	while(new_address in existing_addresses) //Collision test.

	existing_addresses += new_address
	return new_address

/**
 * Check if `address` is a valid NTNet address.
 *
 * An NTNet address consists of four colon-separated groups of four alphanumeric characters, beginning with the group '**fc00**'.
 * For example: '**fc00:1a2b:call:home**'
 *
 * Returns `TRUE` if `address` matches that criteria, else `FALSE`.
 *
 * Arguments:
 * * address - The string to check.
 */
/proc/validate_ntnet_address(address)
	var/static/regex/check_re = regex(@"^fc00(:[0-9a-z]{4}){3}$", "i")
	/*
		^			 	Beginning of the string
		fc00		 	String starts with "fc00"
		(			 	Group start
			:		 	One ':' character
			[0-9a-z]{4}	...followed by exactly four alphanumeric characters
		)			 	Group end
		{3}				Exactly three of the above groups
		$				End of the string
	*/

	return check_re.Find(address)
