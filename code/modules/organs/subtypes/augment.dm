/obj/item/organ/internal/augment
	name = "augment"
	icon_state = "augment"
	parent_organ = BP_CHEST
	organ_tag = "augment"
	robotic = ROBOTIC_MECHANICAL
	emp_coeff = 2
	is_augment = TRUE
	species_restricted = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,
							SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI,
							SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_IPC, SPECIES_IPC_G1,
							SPECIES_IPC_G2, SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	var/cooldown = 150
	var/action_button_icon = "augment"
	var/activable = FALSE
	var/bypass_implant = FALSE

/obj/item/organ/internal/augment/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/augment/refresh_action_button()
	. = ..()
	if(.)
		if(activable)
			action.button_icon_state = action_button_icon
			if(action.button)
				action.button.update_icon()

/obj/item/organ/internal/augment/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_WARNING("\The [src] is still recharging!"))
			return FALSE

		if(use_check_and_message(owner))
			return FALSE

		if(is_bruised())
			if(do_bruised_act())
				return FALSE

		if(is_broken())
			if(do_broken_act())
				return FALSE

		if(!bypass_implant)
			for (var/obj/item/implant/anti_augment/I in owner)
				if (I.implanted)
					return FALSE

		owner.last_special = world.time + cooldown
		return TRUE

/obj/item/organ/internal/augment/proc/do_broken_act()
	spark(get_turf(owner), 3)
	return TRUE

/obj/item/organ/internal/augment/proc/do_bruised_act()
	spark(get_turf(owner), 3)
	return FALSE

/obj/item/organ/internal/augment/timepiece
	name = "integrated timepiece"
	icon_state = "augment-clock"
	parent_organ = BP_HEAD
	action_button_name = "Activate Integrated Timepiece"
	activable = TRUE
	organ_tag = BP_AUG_TIMEPIECE
	action_button_icon = "augment-clock"
	cooldown = 10

/obj/item/organ/internal/augment/timepiece/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	to_chat(owner, SPAN_NOTICE("Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day."))
	if (emergency_shuttle.get_status_panel_eta())
		to_chat(owner, SPAN_WARNING("Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()]."))

/obj/item/organ/internal/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	cooldown = 10
	activable = TRUE
	var/obj/item/augment_type


/obj/item/organ/internal/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE


	if(!augment_type)
		return FALSE

	if (locate(augment_type) in owner)
		to_chat(owner, SPAN_WARNING("\The [src] is already enabled!"))
		return

	if(owner.get_active_hand())
		to_chat(owner, SPAN_WARNING("You must empty your active hand before enabling your [src]!"))
		return

	var/obj/item/M = new augment_type(owner)
	owner.put_in_active_hand(M)
	owner.visible_message(SPAN_NOTICE("\The [M] slides out of \the [owner]'s [owner.organs_by_name[parent_organ]]."), SPAN_NOTICE("You deploy \the [M]!"))

/obj/item/organ/internal/augment/tool/combitool
	name = "retractable combitool"
	icon_state = "augment-tool"
	action_button_name = "Deploy Combitool"
	action_button_icon = "augment-tool"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_TOOL
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/internal/augment/tool/combitool/left
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/health_scanner
	name = "integrated health scanner"
	action_button_name = "Activate Health Scanner"
	action_button_icon = "health"
	organ_tag = BP_AUG_HEALTHSCAN
	activable = TRUE
	cooldown = 8

/obj/item/organ/internal/augment/health_scanner/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE

	health_scan_mob(owner, owner)

/obj/item/organ/internal/augment/tesla
	name = "tesla spine"
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	species_restricted = list(SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI)
	var/max_charges = 1
	var/actual_charges = 0
	var/recharge_time = 5 //this is in minutes

/obj/item/organ/internal/augment/tesla/proc/check_shock()
	if(is_broken())
		return FALSE
	if(is_bruised())
		if(prob(50))
			return FALSE
	if(actual_charges >= max_charges)
		return FALSE
	else
		do_tesla_act()
		return TRUE

/obj/item/organ/internal/augment/tesla/proc/do_tesla_act()
	if(owner)
		to_chat(owner, FONT_LARGE(SPAN_DANGER("You feel your [src.name] surge with energy!")))
		spark(get_turf(owner), 3)
		addtimer(CALLBACK(src, .proc/disarm), recharge_time MINUTES)
		if(is_bruised() && prob(50))
			owner.electrocute_act(40, owner)

/obj/item/organ/internal/augment/tesla/proc/disarm()
	if(actual_charges <= 0)
		return
	actual_charges = min(actual_charges - 1, max_charges)
	if(actual_charges > 0)
		addtimer(CALLBACK(src, .proc/disarm), recharge_time MINUTES)
	if(is_broken())
		visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
		playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
		tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/tesla/advanced
	name = "advanced tesla spine"
	max_charges = 15
	cooldown = 50
	emp_coeff = 1
	action_button_icon = "tesla_spine"
	action_button_name = "Activate Tesla Coil"
	activable = TRUE

/obj/item/organ/internal/augment/tesla/advanced/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
	playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
	tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/eye_sensors
	name = "integrated eye sensors"
	icon_state = "augment_eyes"
	cooldown = 25
	activable = TRUE
	organ_tag = BP_AUG_EYE_SENSORS
	action_button_name = "Toggle Eye Sensors"
	var/active_hud = "disabled"

	var/static/list/hud_types = list(
		"Disabled",
		SEC_HUDTYPE,
		MED_HUDTYPE)

	var/selected_hud = "Disabled"

/obj/item/organ/internal/augment/eye_sensors/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	var/choice = input("Select the Sensor Type.", "Bionic Eyes Sensors") as null|anything in capitalize_list(hud_types)

	selected_hud = lowertext(choice)

/obj/item/organ/internal/augment/eye_sensors/process()
	..()

	if(!owner)
		return

	switch(selected_hud)

		if(SEC_HUDTYPE)
			req_access = list(access_security)
			if(allowed(owner))
				active_hud = "security"
				process_sec_hud(owner, 1)
			else
				active_hud = "disabled"

		if(MED_HUDTYPE)
			req_access = list(access_medical)
			if(allowed(owner))
				active_hud = "medical"
				process_med_hud(owner, 1)
			else
				active_hud = "disabled"

		else
			active_hud = "disabled"

/obj/item/organ/internal/augment/eye_sensors/emp_act(severity)
	..()
	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return
	E.take_damage(5)

/obj/item/organ/internal/augment/eye_sensors/proc/check_hud(var/hud)
	return (hud == active_hud)

/obj/item/organ/internal/augment/cyber_hair
	name = "synthetic hair extensions"
	cooldown = 20
	action_button_icon = "cyber_hair"
	organ_tag = BP_AUG_HAIR
	activable = TRUE
	action_button_name = "Activate Synthetic Hair Extensions"
	species_restricted = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI, SPECIES_IPC_SHELL)

/obj/item/organ/internal/augment/cyber_hair/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	owner.visible_message(SPAN_NOTICE("\The [owner]'s hair begins to rapidly shift in shape and length."))
	owner.change_appearance(APPEARANCE_ALL_HAIR, owner.loc, owner, check_species_whitelist = 1)

/obj/item/organ/internal/augment/suspension
	name = "calf suspension"
	icon_state = "suspension"
	organ_tag = BP_AUG_SUSPENSION
	parent_organ = BP_GROIN
	min_broken_damage = 20
	max_damage = 20
	var/suspension_mod = 0.8

/obj/item/organ/internal/augment/suspension/advanced
	name = "advanced calf suspension"
	min_broken_damage = 50
	max_damage = 50
	suspension_mod = 0

/obj/item/organ/internal/augment/taste_booster
	name = "taste booster"
	organ_tag = BP_AUG_TASTE_BOOSTER
	parent_organ = BP_HEAD
	var/new_taste = TASTE_SENSITIVE //this will replace the species' taste var

/obj/item/organ/internal/augment/taste_booster/dull
	name = "taste duller"
	new_taste = TASTE_DULL

/obj/item/organ/internal/augment/fuel_cell
	name = "integrated fuel cell"
	organ_tag = BP_AUG_FUEL_CELL

// Geeves!
/obj/item/organ/internal/augment/language
	name = "language processor"
	desc = "An augment installed into the head that interfaces with the user's neural interface, intercepting and assisting language faculties."
	organ_tag = BP_AUG_LANGUAGE
	parent_organ = BP_HEAD
	var/list/augment_languages = list() // a list of languages that this augment will add. add your language to this
	var/list/added_languages = list() // a list of languages that get added when it's installed. used to remove languages later. don't touch this.

/obj/item/organ/internal/augment/language/replaced(var/mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	for(var/language in augment_languages)
		if(!(language in target.languages))
			target.add_language(language)
			added_languages += language

/obj/item/organ/internal/augment/language/removed(var/mob/living/carbon/human/target, mob/living/user)
	for(var/language in added_languages)
		target.remove_language(language)
	added_languages = list()
	..()

/obj/item/organ/internal/augment/language/emp_act()
	. = ..()
	for(var/language in added_languages)
		if(prob(25))
			owner.remove_language(language)
	owner.set_default_language(pick(owner.languages))

/obj/item/organ/internal/augment/language/klax
	name = "K'laxan language processor"
	augment_languages = list(LANGUAGE_UNATHI)

/obj/item/organ/internal/augment/language/cthur
	name = "C'thur language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)

// Snakebitten!
/obj/item/organ/internal/augment/psi
	name = "psionic receiver"
	desc = "An augment installed into the head that functions as a surrogate for a missing zona bovinae, also functioning as a filter for the psionically-challenged."
	organ_tag = BP_AUG_PSI
	parent_organ = BP_HEAD