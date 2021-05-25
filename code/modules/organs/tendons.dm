/datum/tendon
	var/name = "tendon"
	var/max_health = 30
	var/health = 30
	var/status

	var/list/messages

	var/obj/item/organ/external/parent

/datum/tendon/New(var/obj/item/organ/external/E, var/name, var/hp, var/list/damage_msgs)
	if(!istype(E))
		crash_with("Tendon created with invalid parent organ: [E]")
		qdel(src)
		return

	parent = E

	if(name)
		src.name = name
	if(islist(damage_msgs))
		messages = damage_msgs

	if(hp)
		max_health = hp
		health = max_health

/datum/tendon/proc/update_status(var/fix_cut = FALSE)
	// determine if tendon should be cut, bruised, or unbruised
	if(health <= 0 && !(status & TENDON_CUT))
		sever()
	else if(get_health() >= 0.5 && status & TENDON_BRUISED)
		status &= ~TENDON_BRUISED
	else if(get_health() < 0.5 && get_health() > 0 && !status)
		status |= TENDON_BRUISED
		if(parent.owner.species && parent.owner.can_feel_pain())
			parent.owner.custom_pain("You feel a burning soreness in your [parent.name]!", 10, nohalloss = TRUE)

	if(fix_cut && status & TENDON_CUT)
		// fix_cut should only be TRUE through means like surgery, adv. tech, or space magic
		status &= ~TENDON_CUT

/datum/tendon/proc/update_damage(var/total_dmg)
	// called by organ/external/update_damages()
	var/lost_health = max_health - health
	if(total_dmg <= 0)
		heal(max_health)
	else
		if(total_dmg < lost_health)
			heal(lost_health - total_dmg)
		else
			damage(total_dmg - lost_health)

/datum/tendon/proc/get_health()
	if(!parent?.owner)
		return FALSE

	return health / max_health

/datum/tendon/proc/can_recover()
	// This is basically just used for the half-dozen times that tendons are "healed"
	// using methods that may or may not heal the limb enough to actually heal the tendon
	// thus, this prevents infinite tendon snapping
	update_status()
	if(status & TENDON_CUT)
		return health > 0
	return TRUE

/datum/tendon/proc/rejuvenate()
	heal(max_health, TRUE)

/datum/tendon/proc/heal(var/hp, var/fix_cut)
	if(!parent?.owner || hp <= 0)
		return

	health = min(max_health, health + hp)

	update_status(fix_cut)

/datum/tendon/proc/damage(var/dmg)
	if(!parent?.owner || health <= 0 || dmg <= 0)
		return

	health = max(0, health - dmg)

	update_status()

/datum/tendon/proc/sever()
	if(!parent?.owner || (status & TENDON_CUT))
		return FALSE

	playsound(parent.owner.loc, 'sound/effects/snap.ogg', 40, 1, -2)
	status |= TENDON_CUT

	if(parent.owner.species && parent.owner.can_feel_pain())
		parent.owner.emote("scream")
		parent.owner.flash_strong_pain()
		parent.owner.custom_pain(FONT_LARGE("You feel something [pick(messages)] in your [parent.name]!"), 25)
		parent.owner.visible_message(SPAN_WARNING("You hear a loud snapping sound coming from [parent.owner]!"),
		blind_message = "You hear a sickening snap!")
	else
		parent.owner.visible_message(SPAN_WARNING("You hear a loud snapping sound coming from [parent.owner]!"),\
		SPAN_DANGER("Something feels like it [pick(messages)] in your [parent.name]!"),\
		"You hear a sickening snap!")

	if(istype(parent, /obj/item/organ/external/hand))
		parent.owner.update_hud_hands()

	return status
