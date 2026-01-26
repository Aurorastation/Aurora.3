/**
 * Adds the passed quirk to the mob
 *
 * Arguments
 * * quirktype - Quirk typepath to add to the mob
 * If not passed, defaults to this mob's client.
 *
 * Returns TRUE on success, FALSE on failure (already has the quirk, etc)
 */
/mob/living/proc/add_quirk(datum/quirk/quirktype, client/override_client, add_unique = TRUE, announce = TRUE)
	if(has_quirk(quirktype))
		return FALSE
	var/qname = initial(quirktype.name)
	if(!SSquirks || !SSquirks.quirks[qname])
		return FALSE
	var/datum/quirk/quirk = new quirktype()
	if(quirk.add_to_holder(new_holder = src, client_source = override_client, unique = add_unique, announce = announce))
		return TRUE
	qdel(quirk)
	return FALSE

/mob/living/proc/remove_quirk(quirktype)
	for(var/datum/quirk/quirk in quirks)
		if(quirk.type == quirktype)
			qdel(quirk)
			return TRUE
	return FALSE

/mob/living/proc/has_quirk(quirktype)
	for(var/datum/quirk/quirk in quirks)
		if(quirk.type == quirktype)
			return TRUE
	return FALSE

/**
 * Getter function for a mob's quirk
 *
 * Arguments:
 * * quirktype - the type of the quirk to acquire e.g. /datum/quirk/some_quirk
 *
 * Returns the mob's quirk datum if the mob this is called on has the quirk, null on failure
 */
/mob/living/proc/get_quirk(quirktype)
	for(var/datum/quirk/quirk in quirks)
		if(quirk.type == quirktype)
			return quirk
	return null
