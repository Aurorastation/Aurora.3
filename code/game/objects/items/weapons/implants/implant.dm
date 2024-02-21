#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2


/obj/item/implant
	abstract_type = /obj/item/implant
	name = "implant"
	icon = 'icons/obj/item/implants.dmi'
	w_class = ITEMSIZE_TINY
	/**
	 * This gives the user an action button that allows them to activate the implant.
	 * If the implant needs no action button, then null this out.
	 * Or, if you want to add a unique action button, then replace this.
	 */
	default_action_type = /datum/action/item_action/hands_free/activate/implant
	action_button_name = "Activate Implant"
	var/implanted = null
	///The mob that has been implanted with this
	var/mob/imp_in = null
	///The organ/limb that has been implanted with this
	var/obj/item/organ/external/part = null
	///Implant icon name, used for getting the name of the implant for usage in the implant case name.
	var/implant_icon = null
	///Implant color, used for overlaying the implant into an implanter.
	var/implant_color = null
	var/malfunction = 0
	///If advanced scanners would name these in results
	var/known
	///If scanners can locate this implant at all
	var/hidden

/obj/item/implant/Initialize()
	. = ..()
	GLOB.implants += src

/obj/item/implant/proc/trigger(emote, source)
	return

/obj/item/implant/ui_action_click()
	INVOKE_ASYNC(src, PROC_REF(activate), "action_button")

/obj/item/implant/item_action_slot_check(slot, mob/user)
	return user = imp_in

/obj/item/implant/proc/hear(message)
	return

/obj/item/implant/proc/activate()
	return

/**
 * What does the implant do upon injection?
 * return FALSE if the implant fails (ex. Revhead and loyalty implant.)
 * return TRUE if the implant succeeds (ex. Nonrevhead and loyalty implant.)
*/
/obj/item/implant/proc/implanted(mob/source)
	return TRUE

/obj/item/implant/proc/canImplant(mob/M, mob/user, target_zone)
	var/mob/living/carbon/human/H = M
	if(istype(H) && !H.get_organ(target_zone))
		to_chat(user, SPAN_WARNING("\The [M] is missing that body part!"))
		return FALSE
	return TRUE

/obj/item/implant/proc/implantInMob(mob/M, target_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affected = H.get_organ(target_zone)
		if(affected)
			affected.implants += src
			part = affected

	forceMove(M)
	imp_in = M
	implanted = TRUE
	implanted(M)

	return TRUE

///Remove implant from mob.
/obj/item/implant/proc/removed()
	imp_in = null
	if(part)
		part.implants -= src
		part = null
	implanted = FALSE

///Called in surgery when incision is retracted open / ribs are opened - basically before you can take the implant out
/obj/item/implant/proc/exposed()
	return

///Get implant specifications for the implant pad
/obj/item/implant/proc/get_data()
	return "No information available"

/obj/item/implant/interact(user)
	var/datum/browser/popup = new(user, capitalize(name), capitalize(name), 300, 700, src)
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	dat += get_data()
	if(malfunction)
		popup.title = "??? Implant"
		dat = stars(dat,10)
	popup.set_content(dat)
	popup.open()

/**
 * Determines if the implant is known as a legal implant or not.
 *
 * If TRUE, increases the chance of removal during surgery
 */
/obj/item/implant/proc/isLegal()
	return FALSE

///Breaks the implant down, making it unrecognizable
/obj/item/implant/proc/meltdown()
	if(malfunction == MALFUNCTION_PERMANENT)
		return
	to_chat(imp_in, SPAN_DANGER("You feel something melting inside [part ? "your [part.name]" : "you"]!"))
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,DAMAGE_BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implant/Destroy()
	if(part)
		part.implants.Remove(src)
		part = null
	STOP_PROCESSING(SSprocessing, src)
	GLOB.implants -= src
	return ..()

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT
