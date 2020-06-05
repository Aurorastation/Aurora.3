/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's desc_info,
	desc_fluff, and desc_antag, and shows it in a new tab.

	In this file, some atom and mob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/


/atom/
	var/desc_info = null //Helpful blue text.
	var/desc_fluff = null //Green text about the atom's fluff, if any exists.
	var/desc_antag = null //Malicious red text, for the antags.
	var/description_cult = null // Spooky purple text, telling cultists how they can use certain items

//Override these if you need special behaviour for a specific type.
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
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_desc_fluff()
	return print_flavor_text(0)

/atom/proc/get_description_cult()
	if(description_cult)
		return description_cult
	return

/* The examine panel itself */

/client/var/description_holders[0]

/client/proc/update_description_holders(atom/A, update_antag_info = FALSE, show_cult_info = FALSE)
	description_holders["info"] = A.get_desc_info()
	description_holders["fluff"] = A.get_desc_fluff()
	description_holders["antag"] = (update_antag_info)? A.get_desc_antag() : ""
	description_holders["cult"] = show_cult_info ? A.get_description_cult() : ""

	description_holders["name"] = "[A.name]"
	description_holders["icon"] = "\icon[A]"
	description_holders["desc"] = A.desc

/client/Stat()
	. = ..()
	if(usr && statpanel("Examine"))
		stat(null,"[description_holders["icon"]]    <font size='5'>[description_holders["name"]]</font>") //The name, written in big letters.
		stat(null,"[description_holders["desc"]]") //the default examine text.
		if(description_holders["info"])
			stat(null,"<font color='#084B8A'><b>[description_holders["info"]]</b></font>") //Blue, informative text.
		if(description_holders["fluff"])
			stat(null,"<font color='#298A08'><b>[description_holders["fluff"]]</b></font>") //Yellow, fluff-related text.
		if(description_holders["antag"])
			stat(null,"<font color='#8A0808'><b>[description_holders["antag"]]</b></font>") //Red, malicious antag-related text
		if(description_holders["cult"])
			stat(null,"<font color='#9A0AAD'><b>[description_holders["cult"]]</b></font>") // Spooky purple text, telling cultists how they can use certain items

//override examinate verb to update description holders when things are examined
/mob/examinate(atom/A as mob|obj|turf in view())
	if(UNLINT(..()))
		return 1

	if(!A)
		return 0

	var/is_antag = mind?.special_role || isobserver(src) //ghosts don't have minds
	var/is_cult = mind?.special_role == "Cultist" || isobserver(src)
	if(client)
		client.update_description_holders(A, is_antag, is_cult)
