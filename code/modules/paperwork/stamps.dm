/obj/item/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	attack_verb = list("stamped")

/obj/item/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"

/obj/item/stamp/xo
	name = "executive officer's rubber stamp"
	icon_state = "stamp-hop"

/obj/item/stamp/hos
	name = "head of security's rubber stamp"
	icon_state = "stamp-hos"

/obj/item/stamp/warden
	name = "warden's rubber stamp"
	icon_state = "stamp-war"

/obj/item/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/stamp/rd
	name = "research director's rubber stamp"
	icon_state = "stamp-rd"

/obj/item/stamp/cmo
	name = "chief medical officer's rubber stamp"
	icon_state = "stamp-cmo"

/obj/item/stamp/op
	name = "operation manager's rubber stamp"
	icon_state = "stamp-qm"

/obj/item/stamp/investigations
	name = "case closed stamp"
	icon_state = "stamp-investigator"

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/stamp/centcomm
	name = "centcomm rubber stamp"
	icon_state = "stamp-cent"

/obj/item/stamp/einstein
	name = "einstein engines rubber stamp"
	icon_state = "stamp-einstein"

/obj/item/stamp/hephaestus
	name = "hephaestus industries rubber stamp"
	icon_state = "stamp-heph"

/obj/item/stamp/idris
	name = "idris incorporated rubber stamp"
	icon_state = "stamp-idris"

/obj/item/stamp/zavodskoi
	name = "zavodskoi interstellar rubber stamp"
	icon_state = "stamp-zavod"

/obj/item/stamp/zeng_hu
	name = "zeng-hu pharmaceuticals rubber stamp"
	icon_state = "stamp-zenghu"

/obj/item/stamp/biesel
	name = "\improper Republic of Biesel rubber stamp"
	icon_state = "stamp-biesel"

/obj/item/stamp/sol
	name = "\improper Sol Alliance rubber stamp"
	icon_state = "stamp-sol"

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user as mob)
	var/list/stamp_types = typesof(/obj/item/stamp)
	var/list/stamp_selection = list()

	for(var/stamp_type in stamp_types)
		var/obj/item/stamp/S = new stamp_type
		stamp_selection[capitalize(S.name)] = S

	var/input_stamp = input("Choose a stamp to disguise as.", "Chameleon stamp.") as null|anything in sortList(stamp_selection)
	if(isnull(input_stamp))
		return

	if(user && (src in user.contents))
		var/obj/item/stamp/chosen_stamp = stamp_selection[capitalize(input_stamp)]

		if(chosen_stamp)
			name = chosen_stamp.name
			icon_state = chosen_stamp.icon_state

/obj/item/stamp/chameleon/verb/rename()
	set name = "Rename stamp"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "Which faction or rank would you like your stamp to represent?", "Stamp Designation", null) as text, MAX_NAME_LEN)
	if(loc == usr && n_name)
		//Attempts to keep the custom stamp name consistent
		n_name = replacetext(n_name," rubber stamp","")
		n_name = replacetext(n_name," stamp","")
		n_name = replacetext(n_name,"stamp","")
		name = "[n_name] rubber stamp"
