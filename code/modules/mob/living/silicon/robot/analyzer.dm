//
//Robotic Component Analyser, basically a health analyser for robots
//
/obj/item/device/robotanalyzer
	name = "cyborg analyzer"
	icon_state = "robotanalyzer"
	item_state = "analyzer"
	desc = "A hand-held scanner able to diagnose robotic injuries."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 1, TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 200)
	var/mode = 1

/obj/item/device/robotanalyzer/attack(mob/living/M, mob/living/user)
	if((user.is_clumsy() || (DUMB in user.mutations)) && prob(50))
		to_chat(user, SPAN_WARNING("You try to analyze the floor's vitals!"))
		visible_message(SPAN_WARNING("\The [user] has analyzed the floor's vitals!"))

		to_chat(user, SPAN_NOTICE("Analyzing Results for The floor:"))
		to_chat(user, SPAN_NOTICE("Overall Status: Healthy"))
		to_chat(user, SPAN_NOTICE("Damage Specifics: [0]-[0]-[0]-[0]"))
		to_chat(user, SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"))
		to_chat(user, SPAN_NOTICE("Body Temperature: ???"))
		return

	var/scan_type
	if(istype(M, /mob/living/silicon/robot))
		scan_type = "robot"
	else if(istype(M, /mob/living/carbon/human))
		scan_type = "prosthetics"
	else
		to_chat(user, SPAN_WARNING("You can't analyze non-robotic things!"))
		return

	user.visible_message(SPAN_NOTICE("\The [user] has analyzed \the [M]'s components."), SPAN_NOTICE("You have analyzed \the [M]'s components."))
	switch(scan_type)
		if("robot")
			var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
			var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()

			to_chat(user, SPAN_NOTICE("Analyzing Results for [M]:"))
			to_chat(user, SPAN_NOTICE("Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.getHalLoss()]% functional"]"))
			to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>")
			to_chat(user, "Damage Specifics: <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
			if(M.tod && M.stat == DEAD)
				to_chat(user, SPAN_NOTICE("Time of Disable: [M.tod]"))
			var/mob/living/silicon/robot/H = M
			var/list/damaged = H.get_damaged_components(1, 1, 1)
			to_chat(user, SPAN_NOTICE("Localized Damage:"))
			if(length(damaged) > 0)
				for(var/datum/robot_component/org in damaged)
					user.show_message(text("<span class='notice'>\t []: [][] - [] - [] - []</span>",	\
					capitalize(org.name),					\
					(org.installed == -1)	?	"<font color='red'><b>DESTROYED</b></font> "							:"",\
					(org.electronics_damage > 0)	?	"<font color='#FFA500'>[org.electronics_damage]</font>"	:0,	\
					(org.brute_damage > 0)	?	"<font color='red'>[org.brute_damage]</font>"							:0,		\
					(org.toggled)	?	"Toggled ON"	:	"<font color='red'>Toggled OFF</font>",\
					(org.powered)	?	"Power ON"		:	"<font color='red'>Power OFF</font>"),1)
			else
				to_chat(user, SPAN_NOTICE("Components are OK."))
			if(H.emagged && prob(5))
				to_chat(user, SPAN_WARNING("ERROR: INTERNAL SYSTEMS COMPROMISED"))
			to_chat(user, SPAN_NOTICE("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"))
		if("prosthetics")
			var/mob/living/carbon/human/H = M
			to_chat(user, SPAN_NOTICE("Analyzing Results for \the [H]:"))
			to_chat(user, "Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>")

			to_chat(user, SPAN_NOTICE("External prosthetics:"))
			var/organ_found
			if(length(H.internal_organs))
				for(var/obj/item/organ/external/E in H.organs)
					if(!(E.status & ORGAN_ROBOT))
						continue
					organ_found = TRUE
					to_chat(user, "[E.name]: <font color='red'>[E.brute_dam]</font> <font color='#FFA500'>[E.burn_dam]</font>")
			if(!organ_found)
				to_chat(user, SPAN_NOTICE("No prosthetics located."))
			to_chat(user, "<hr>")
			to_chat(user, SPAN_NOTICE("Internal prosthetics:"))
			organ_found = FALSE
			if(length(H.internal_organs))
				for(var/obj/item/organ/O in H.internal_organs)
					if(!(O.status & ORGAN_ROBOT))
						continue
					organ_found = TRUE
					to_chat(user, "[O.name]: <font color='red'>[O.damage]</font>")
			if(!organ_found)
				to_chat(user, SPAN_NOTICE("No prosthetics located."))

	add_fingerprint(user)
	return