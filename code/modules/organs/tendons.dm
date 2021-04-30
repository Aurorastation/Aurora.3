/datum/tendon
	var/name = "tendon"
	var/threshold
	var/intact = TRUE

	var/list/messages

	var/obj/item/organ/external/parent

/datum/tendon/New(var/obj/item/organ/external/E, var/name, var/damage_threshold, var/list/damage_msgs)
	if(!istype(E))
		crash_with("Tendon created with invalid parent organ: [E]")
		qdel(src)
		return

	parent = E

	if(name)
		src.name = name
	if(islist(damage_msgs))
		messages = damage_msgs

	if(damage_threshold)
		threshold = damage_threshold
	else
		threshold = parent.min_broken_damage

/datum/tendon/proc/heal()
	if(!parent?.owner || intact)
		return FALSE

	. = intact = TRUE

/datum/tendon/proc/sever()
	if(!parent?.owner || !intact)
		return FALSE

	playsound(parent.owner.loc, 'sound/effects/snap.ogg', 40, 1, -2)
	intact = FALSE

	if(parent.owner.species && parent.owner.can_feel_pain())
		parent.owner.emote("scream")
		parent.owner.flash_strong_pain()
		parent.owner.custom_pain("You feel something [pick(messages)] in your [parent.owner.name]!", 25)
		parent.owner.visible_message(SPAN_WARNING("You hear a loud snapping sound coming from [parent.owner]!"),
		blind_message = "You hear a sickening snap!")
	else
		parent.owner.visible_message(SPAN_WARNING("You hear a loud snapping sound coming from [parent.owner]!"),\
		SPAN_DANGER("Something feels like it [pick(messages)] in your [parent.name]!"),\
		"You hear a sickening snap!")

	if(istype(parent, /obj/item/organ/external/hand))
		parent.owner.update_hud_hands()

	return TRUE
