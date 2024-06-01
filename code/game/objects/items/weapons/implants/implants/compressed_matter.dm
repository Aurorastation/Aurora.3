/obj/item/implant/compressed //TODO: This code is awful, and this implant is difficult to use. Port atom storage, and make the implant its own storage item
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_storage"
	implant_icon = "storage"
	implant_color = "#143464"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 2, TECH_ILLEGAL = 2)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/compressed
	action_button_name = "Retrieve Item from Compressed Implant"
	hidden = TRUE
	var/obj/item/scanned = null

/obj/item/implant/compressed/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(!scanned)
			to_chat(user, SPAN_NOTICE("There is nothing to remove from the implant."))
		else
			to_chat(user, SPAN_NOTICE("You remove \the [scanned] from the implant."))
			user.put_in_hands(scanned)
			scanned = null
	if(istype(attacking_item, /obj/item/implanter))
		var/obj/item/implanter/implanter = attacking_item
		if(implanter.imp)
			to_chat(user, SPAN_NOTICE("\The [implanter] already has an implant loaded."))
			return
		user.drop_from_inventory(src)
		forceMove(implanter)
		implanter.imp = src
		implanter.update_icon()
	else
		..()

/obj/item/implant/compressed/get_data()
	. = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> NT-06 Covert Insertion Implant<BR>
<b>Life:</b> Up to 6 months.<BR>
<b>Important Notes:</b> Uses a localized pocket of bluespace to store an item, that cannot be detected from most external sources.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Can store one item, that can be retrieved at will.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/implant/compressed/trigger(emote, mob/source as mob)
	if (src.scanned == null)
		return FALSE

	to_chat(source, SPAN_NOTICE("The air glows as \the [src.scanned.name] uncompresses."))
	activate()

/obj/item/implant/compressed/activate()
	var/turf/t = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(t)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source as mob)
	return TRUE

/obj/item/implant/compressed/isLegal()
	return FALSE

/obj/item/implanter/compressed
	name = "implanter (C)"
	imp = /obj/item/implant/compressed
