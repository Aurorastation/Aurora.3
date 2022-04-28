// This code is responsible for the examine tab. When someone examines something, it copies the examined object's desc_info, desc_fluff, and desc_antag, and shows it in a new tab.
// Some atom and mob stuff is defined in this file. It is defined here instead of in the normal files, to keep the whole system self-contained.
// This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.

/atom/
	var/desc_fluff = null // Text about the atom's fluff description, if any exists.
	var/desc_info = null // Blue text (SPAN_NOTICE()), informing the user about how to use the item or about game controls.
	var/desc_antag = null // Red text (SPAN_ALERT()), informing the user about how they can use an object to antagonize.
	var/desc_cult = null // Purple text (SPAN_CULT()), telling the user, if they're a cultist, how they can use certain items related to being a cultist.

// Override these if you need special behaviour for a specific type.
/atom/proc/get_desc_info()
	if(desc_info)
		return desc_info
	return

/atom/proc/get_desc_fluff()
	if(desc_fluff)
		return desc_fluff
	return

/atom/proc/get_desc_antag()
	if(desc_antag)
		return desc_antag
	return

/mob/living/get_desc_fluff()
	if(flavor_text) // Get flavor text for the green text.
		return flavor_text
	else // No flavor text? Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_desc_fluff()
	return print_flavor_text(0)

/atom/proc/get_desc_cult()
	if(desc_cult)
		return desc_cult
	return

// The examine panel itself.
/client/var/description_holders[0]

/client/proc/update_description_holders(atom/A, update_antag_info = FALSE, show_cult_info = FALSE)
	description_holders["icon"] = "[icon2html(A, usr)]"
	description_holders["name"] = "[A.name]"
	description_holders["desc"] = A.desc

	description_holders["fluff"] = A.get_desc_fluff()
	description_holders["info"] = A.get_desc_info()
	description_holders["antag"] = (update_antag_info)? A.get_desc_antag() : ""
	description_holders["cult"] = show_cult_info ? A.get_desc_cult() : ""

/client/Stat()
	. = ..()
	if(usr && statpanel("Examine"))
		stat(null, "[description_holders["icon"]] <font size='5'>[description_holders["name"]]</font>") // The name, written in big letters.
		stat(null, "[description_holders["desc"]]") // The default examine text.
		if(description_holders["fluff"])
			stat(null, "[description_holders["fluff"]]") // Normal, fluff-related text.
		if(description_holders["info"])
			stat(null, "<font color='#084B8A'>[description_holders["info"]]</font>") // Blue, informative text.
		if(description_holders["antag"])
			stat(null, "<font color='#8A0808'>[description_holders["antag"]]</font>") // Red, antagonism related text.
		if(description_holders["cult"])
			stat(null, "<font color='#9A0AAD'>[description_holders["cult"]]</font>") // Purple text, telling cultists how they can use certain items.

// Override examinate verb to update description holders when things are examined.
/mob/examinate(atom/A as mob|obj|turf in view())
	if(UNLINT(..()))
		return 1

	if(!A)
		return 0

	var/is_antag = mind?.special_role || isobserver(src) // Ghosts don't have minds.
	var/is_cult = mind?.special_role == "Cultist" || isobserver(src)
	if(client)
		client.update_description_holders(A, is_antag, is_cult)

/mob/proc/can_examine()
	if(client?.eye == src)
		return TRUE
	return FALSE

/mob/living/silicon/pai/can_examine()
	. = ..()
	if(!.)
		var/atom/our_holder = recursive_loc_turf_check(src, 5)
		if(isturf(our_holder.loc)) // Are we folded on the ground?
			return TRUE

/mob/living/simple_animal/borer/can_examine()
	. = ..()
	if(!. && iscarbon(loc) && isturf(loc.loc)) // We're inside someone, let us examine still.
		return TRUE