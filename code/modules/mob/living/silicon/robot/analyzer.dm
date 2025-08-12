//
//Robotic Component Analyzer, basically a health analyzer for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon = 'icons/obj/item/device/robotanalyzer.dmi'
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)

/obj/item/device/robotanalyzer/attack(mob/living/target_mob, mob/living/user, target_zone)
	robotic_analyze_mob(target_mob, user)
	add_fingerprint(user)

/proc/robotic_analyze_mob(var/mob/living/M, var/mob/living/user, var/just_scan = FALSE)
	if(!just_scan)
		user.visible_message(SPAN_NOTICE("\The [user] has analyzed \the [M]'s components."), SPAN_NOTICE("You have analyzed \the [M]'s components."))

	var/scan_type
	if(isrobot(M))
		scan_type = "robot"
	else if(ishuman(M))
		scan_type = "prosthetics"
	else
		to_chat(user, SPAN_WARNING("You can't analyze non-robotic things!"))
		return

	switch(scan_type)
		if("robot")
			robot_scan(user, M)
		if("prosthetics")
			prosthetics_scan(user, M)

/proc/robot_scan(mob/user, mob/living/silicon/robot/M)
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()

	to_chat(user, SPAN_NOTICE("Analyzing Results for [M]:"))
	to_chat(user, SPAN_NOTICE("Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.getHalLoss()]% functional"]"))
	to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<span class='warning'>Physical Damage</span>")
	to_chat(user, "Damage Specifics: <font color='#FFA500'>[BU]</font> - <span class='warning'>[BR]</span>")
	if(M.tod && M.stat == DEAD)
		to_chat(user, SPAN_NOTICE("Time of Disable: [M.tod]"))
	var/mob/living/silicon/robot/H = M
	var/list/damaged = H.get_damaged_components(1, 1, 1)
	to_chat(user, SPAN_NOTICE("Localized Damage:"))
	if(length(damaged) > 0)
		for(var/datum/robot_component/org in damaged)
			user.show_message(SPAN_NOTICE("\t [capitalize(org.name)]: [(org.installed == -1)	?	SPAN_WARNING("<b>DESTROYED</b>") :""]\
			[(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	: 0] - [(org.brute_damage > 0)	?	SPAN_WARNING("[org.brute_damage]") :0] - \
			[(org.toggled) ?	"Toggled ON" : SPAN_WARNING("Toggled OFF")] - \
			[(org.powered) ? "Power ON" : SPAN_WARNING("Power OFF")]"),1)

	else
		to_chat(user, SPAN_NOTICE("Components are OK."))
	if(H.emagged && prob(5))
		to_chat(user, SPAN_WARNING("ERROR: INTERNAL SYSTEMS COMPROMISED"))
	to_chat(user, SPAN_NOTICE("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"))

/proc/prosthetics_scan(mob/user, mob/living/carbon/human/H)
	to_chat(user, SPAN_NOTICE("Analyzing Results for \the [H]:"))
	to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<span class='warning'>Wiring</span>")
	var/obj/item/organ/internal/machine/power_core/IC = H.internal_organs_by_name[BP_CELL]
	if(IC)
		to_chat(user, SPAN_NOTICE("Cell charge: [IC.percent()] %"))
	else
		to_chat(user, SPAN_NOTICE("Cell charge: ERROR - Cell not present"))
	to_chat(user, SPAN_NOTICE("External prosthetics:"))
	var/organ_found
	if(length(H.internal_organs))
		for(var/obj/item/organ/external/E in H.organs)
			if(!(E.status & (ORGAN_ROBOT || ORGAN_ASSISTED)))
				continue
			organ_found = TRUE
			to_chat(user, "[E.name]: <span class='warning'>[E.brute_dam]</span> <font color='#FFA500'>[E.burn_dam]</font>")
	if(!organ_found)
		to_chat(user, SPAN_NOTICE("No prosthetics located."))
	to_chat(user, "<hr>")
	to_chat(user, SPAN_NOTICE("Internal prosthetics:"))
	organ_found = FALSE
	if(length(H.internal_organs))
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		var/show_tag = FALSE
		if(head?.open == 3) // Hatch open
			show_tag = TRUE
		for(var/obj/item/organ/O in H.internal_organs)
			if(!(O.status & (ORGAN_ROBOT || ORGAN_ASSISTED)))
				continue
			if(!show_tag && istype(O, /obj/item/organ/internal/machine/ipc_tag))
				continue
			organ_found = TRUE
			var/found_damage = FALSE
			to_chat(user, SPAN_NOTICE(SPAN_BOLD("[O.name]")))
			if(O.damage)
				to_chat(user, SPAN_WARNING("Core damage detected."))
				found_damage = TRUE
			if(istype(O, /obj/item/organ/internal/machine))
				var/obj/item/organ/internal/machine/machine_organ = O
				if(machine_organ.get_integrity() < 100)
					to_chat(user, SPAN_WARNING("Integrity damage detected."))
					found_damage = TRUE
			if(!found_damage)
				to_chat(user, SPAN_NOTICE("No damage detected."))

	if(!organ_found)
		to_chat(user, SPAN_NOTICE("No prosthetics located."))

/obj/item/device/robotanalyzer/augment
	name = "retractable cyborg analyzer"
	desc = "An scanner implanted directly into the hand, popping through the finger. This scanner can diagnose robotic injuries."
	icon = 'icons/obj/item/device/robotanalyzer.dmi'
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	slot_flags = null
	w_class = WEIGHT_CLASS_HUGE

/obj/item/device/robotanalyzer/augment/throw_at(atom/target, range, speed, mob/user)
	user.drop_from_inventory(src)

/obj/item/device/robotanalyzer/augment/dropped()
	. = ..()
	loc = null
	qdel(src)
