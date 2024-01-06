/obj/item/organ/internal/augment
	name = "augment"
	icon = 'icons/obj/organs/augments.dmi'
	icon_state = "augment"
	parent_organ = BP_CHEST
	organ_tag = "augment"
	robotic = ROBOTIC_MECHANICAL
	emp_coeff = 2
	is_augment = TRUE
	species_restricted = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,
							SPECIES_TAJARA, SPECIES_TAJARA_ZHAN, SPECIES_TAJARA_MSAI,
							SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_G1,
							SPECIES_IPC_G2, SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	robotic_sprite = FALSE
	var/cooldown = 150
	var/action_button_icon = "augment"
	var/activable = FALSE
	var/bypass_implant = FALSE
	var/supports_limb = FALSE // if true, will make parent limb not count as broken, as long as it's not bruised (40%) and not broken (0%)

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

	to_chat(owner, SPAN_NOTICE("Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [GLOB.game_year]'. Have a lovely day."))
	if (evacuation_controller.get_status_panel_eta())
		to_chat(owner, SPAN_WARNING("Notice: You have one (1) scheduled flight, ETA: [evacuation_controller.get_status_panel_eta()]."))

/obj/item/organ/internal/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	cooldown = 10
	activable = TRUE
	var/obj/item/augment_type
	var/aug_slot = slot_r_hand

/obj/item/organ/internal/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(!augment_type)
		return FALSE

	if (locate(augment_type) in owner)
		var/obj/slot_item = locate(augment_type) in owner
		owner.drop_from_inventory(slot_item)
		qdel(slot_item)
		owner.visible_message(SPAN_NOTICE("\The [slot_item] slides back into \the [owner]'s [owner.organs_by_name[parent_organ]]."), SPAN_NOTICE("You retract \the [slot_item]!"))
		return

	if (owner.get_equipped_item(aug_slot))
		to_chat(owner, SPAN_WARNING("Something is stopping you from enabling your [src]!"))
		return

	var/obj/item/M = new augment_type(owner)
	M.canremove = FALSE
	M.item_flags |= ITEM_FLAG_NO_MOVE
	owner.equip_to_slot(M, aug_slot)
	var/obj/item/organ/O = owner.organs_by_name[parent_organ]
	owner.visible_message(SPAN_NOTICE("\The [M] slides out of \the [owner]'s [O.name]."), SPAN_NOTICE("You deploy \the [M]!"))

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
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/drill
	name = "integrated drill"
	icon_state = "drill"
	action_button_name = "Deploy Drill"
	action_button_icon = "drill"
	parent_organ = BP_R_HAND
	organ_tag = BP_AUG_DRILL
	augment_type = /obj/item/pickaxe/drill/integrated

/obj/item/organ/internal/augment/tool/drill/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/combitool/lighter
	name = "integrated lighter"
	icon_state = "lighter-aug"
	action_button_name = "Deploy Lighter"
	action_button_icon = "lighter-aug"
	organ_tag = BP_AUG_LIGHTER
	augment_type = /obj/item/flame/lighter/zippo/augment

/obj/item/organ/internal/augment/tool/combitool/lighter/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/pen
	name = "retractable pen"
	icon_state = "combipen"
	action_button_name = "Deploy Pen"
	action_button_icon = "combipen"
	organ_tag = BP_AUG_PEN
	parent_organ = BP_R_HAND
	augment_type = /obj/item/pen/augment

/obj/item/organ/internal/augment/tool/pen/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/crayon
	name = "integrated crayon"
	icon_state = "crayonaugment"
	action_button_name = "Deploy Crayon"
	action_button_icon = "crayonaugment"
	organ_tag = BP_AUG_CRAYON
	parent_organ = BP_R_HAND
	augment_type = /obj/item/pen/crayon/augment

/obj/item/organ/internal/augment/tool/crayon/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

/obj/item/organ/internal/augment/tool/cyborg_analyzer
	name = "retractable cyborg analyzer"
	icon_state = "robotanalyzer"
	action_button_name = "Deploy Analyzer"
	action_button_icon = "augment-tool"
	organ_tag = BP_AUG_CYBORG_ANALYZER
	parent_organ = BP_R_HAND
	augment_type = /obj/item/device/robotanalyzer/augment

/obj/item/organ/internal/augment/tool/cyborg_analyzer/left
	parent_organ = BP_L_HAND
	aug_slot = slot_l_hand

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
		addtimer(CALLBACK(src, PROC_REF(disarm)), recharge_time MINUTES)
		if(is_bruised() && prob(50))
			owner.electrocute_act(40, owner)

/obj/item/organ/internal/augment/tesla/proc/disarm()
	if(actual_charges <= 0)
		return
	actual_charges = min(actual_charges - 1, max_charges)
	if(actual_charges > 0)
		addtimer(CALLBACK(src, PROC_REF(disarm)), recharge_time MINUTES)
	if(is_broken())
		owner.visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
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

	owner.visible_message(SPAN_DANGER("\The [owner] crackles with energy!"))
	playsound(owner, 'sound/magic/LightningShock.ogg', 75, 1)
	tesla_zap(owner, 7, 1500)

/obj/item/organ/internal/augment/tesla/massive
	name = "massive tesla spine"
	icon_state = "tesla_spine"
	organ_tag = BP_AUG_TESLA
	on_mob_icon = 'icons/mob/human_races/tesla_body_augments.dmi'
	species_restricted = list(SPECIES_TAJARA_TESLA_BODY)

/obj/item/organ/internal/augment/eye_sensors
	name = "integrated HUD sensors"
	icon_state = "augment_eyes"
	cooldown = 25
	activable = TRUE
	organ_tag = BP_AUG_EYE_SENSORS
	parent_organ = BP_HEAD
	action_button_name = "Toggle Security Sensors"
	var/active_hud = "disabled"

	var/static/list/hud_types = list(
		"disabled",
		SEC_HUDTYPE,
		MED_HUDTYPE)

	var/selected_hud = "disabled"

/obj/item/organ/internal/augment/eye_sensors/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

/obj/item/organ/internal/augment/eye_sensors/process()
	..()

	if(!owner)
		return

/obj/item/organ/internal/augment/eye_sensors/emp_act(severity)
	. = ..()

	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return

	E.take_damage(5)

/obj/item/organ/internal/augment/eye_sensors/proc/check_hud(var/hud)
	return (hud == active_hud)

/obj/item/organ/internal/augment/eye_sensors/security
	name = "integrated security HUD sensors"
	action_button_name = "Toggle Security Sensors"

/obj/item/organ/internal/augment/eye_sensors/security/attack_self(var/mob/user)
	. = ..()

	if(selected_hud == "disabled")
		selected_hud = SEC_HUDTYPE
		to_chat(user, "You activate \the [src].")
	else
		selected_hud = "disabled"
		to_chat(user, "You deactivate \the [src].")

/obj/item/organ/internal/augment/eye_sensors/security/process()
	..()

	switch(selected_hud)

		if(SEC_HUDTYPE)
			req_access = list(ACCESS_SECURITY)
			if(allowed(owner))
				active_hud = "security"
				process_sec_hud(owner, 1)
			else
				active_hud = "disabled"
		else
			active_hud = "disabled"
/obj/item/organ/internal/augment/eye_sensors/medical
	name = "integrated medical HUD sensors"
	action_button_name = "Toggle Medical Sensors"

/obj/item/organ/internal/augment/eye_sensors/medical/attack_self(var/mob/user)
	. = ..()

	if(selected_hud == "disabled")
		selected_hud = MED_HUDTYPE
		to_chat(user, "You activate \the [src].")
	else
		selected_hud = "disabled"
		to_chat(user, "You deactivate \the [src].")

/obj/item/organ/internal/augment/eye_sensors/medical/process()
	..()

	switch(selected_hud)

		if(MED_HUDTYPE)
			req_access = list(ACCESS_MEDICAL)
			if(allowed(owner))
				active_hud = "medical"
				process_med_hud(owner, 1)
			else
				active_hud = "disabled"
		else
			active_hud = "disabled"

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
	owner.change_appearance(APPEARANCE_ALL_HAIR, owner)

/obj/item/organ/internal/augment/suspension
	name = "calf suspension"
	icon_state = "suspension"
	organ_tag = BP_AUG_SUSPENSION
	parent_organ = BP_GROIN
	min_broken_damage = 20
	max_damage = 20
	var/suspension_mod = 0.8
	var/jump_bonus = 1

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

/obj/item/organ/internal/augment/ethanol_burner
	name = "integrated ethanol burner"
	organ_tag = BP_AUG_ETHANOL_BURNER

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

/obj/item/organ/internal/augment/language/mikuetz
	name = "Mi'kuetz language processor"
	augment_languages = list(LANGUAGE_AZAZIBA)

/obj/item/organ/internal/augment/language/zino
	name = "Zino language processor"
	augment_languages = list(LANGUAGE_GUTTER)

/obj/item/organ/internal/augment/language/eridani
	name = "Eridani language processor"
	augment_languages = list(LANGUAGE_TRADEBAND)

/obj/item/organ/internal/augment/language/zeng
	name = "Zeng-Hu Nral'malic language processor"
	augment_languages = list(LANGUAGE_SKRELLIAN)

/obj/item/organ/internal/augment/gustatorial
	name = "gustatorial centre"
	action_button_name = "Activate Gustatorial Centre (tongue)"
	action_button_icon = "augment"
	organ_tag = BP_AUG_GUSTATORIAL
	parent_organ = BP_HEAD
	activable = TRUE
	cooldown = 8

	var/taste_sensitivity = TASTE_NORMAL
	var/action_verb = "licks"
	var/self_action_verb = "lick"

/obj/item/organ/internal/augment/gustatorial/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/reagent_containers/food/F = user.get_active_hand()
	if(istype(F))
		if(!F.is_open_container())
			to_chat(user, SPAN_WARNING("\The [F] is closed!"))
			return
		user.visible_message("<b>[user]</b> [action_verb] \the [F].", SPAN_NOTICE("You [self_action_verb] \the [F]."))
		to_chat(user, SPAN_NOTICE("\The [src] reports that \the [F] tastes like: [F.reagents.generate_taste_message(user, taste_sensitivity)]"))
	else
		var/list/tastes = list("Hypersensitive" = TASTE_HYPERSENSITIVE, "Sensitive" = TASTE_SENSITIVE, "Normal" = TASTE_NORMAL, "Dull" = TASTE_DULL, "Numb" = TASTE_NUMB)
		var/taste_choice = input(user, "How well do you want to taste?", "Taste Sensitivity", "Normal") as null|anything in tastes
		if(taste_choice)
			to_chat(user, SPAN_NOTICE("\The [src] will now output taste as if you were <b>[taste_choice]</b>."))
			taste_sensitivity = tastes[taste_choice]

/obj/item/organ/internal/augment/gustatorial/hand
	parent_organ = BP_R_HAND
	action_button_name = "Activate Gustatorial Centre (hand)"

	action_verb = "sticks their finger in"
	self_action_verb = "stick your finger in"

/obj/item/organ/internal/augment/gustatorial/hand/left
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/synthetic_cords
	name = "synthetic vocal cords"
	desc = "An array of vocal cords loaded into an augment kit, allowing easy installation by a skilled technician."
	organ_tag = BP_AUG_CORDS
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/synthetic_cords/voice
	desc = "An array of vocal cords. These appears to have been modified with a specific accent."
	organ_tag = BP_AUG_ACC_CORDS
	var/accent = ACCENT_TTS

/obj/item/organ/internal/augment/synthetic_cords/replaced(var/mob/living/carbon/human/target, obj/item/organ/external/affected)
	. = ..()
	target.sdisabilities &= ~MUTE

/obj/item/organ/internal/augment/synthetic_cords/removed(var/mob/living/carbon/human/target, mob/living/user)
	target.sdisabilities |= MUTE
	..()

/obj/item/organ/internal/augment/cochlear
	name = "cochlear implant"
	desc = "A synthetic replacement for the structures within the ear, allowing the user to hear without requiring external tools."
	organ_tag = BP_AUG_COCHLEAR
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/psi
	name = "psionic receiver"
	desc = "An augment installed into the head that functions as a surrogate for a missing zona bovinae, also functioning as a filter for the psionically-challenged."
	organ_tag = BP_AUG_PSI
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/memory_inhibitor
	name = "memory inhibitor"
	desc = "A Zeng Hu implant that allows one to have control over their memories, allowing you to set a timer and remove any memories developed within it. This is most popular in Zeng Hu labs within Eridani."
	icon_state = "memory_inhibitor"
	organ_tag = BP_AUG_MEMORY
	parent_organ = BP_HEAD
	activable = TRUE
	cooldown = 20
	action_button_icon = "memory_inhibitor"
	action_button_name = "Activate Memory Inhibitor"
	var/ready_to_erase = FALSE

/obj/item/organ/internal/augment/memory_inhibitor/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(!ready_to_erase)
		to_chat(owner, SPAN_NOTICE("Your memories following this point will be deleted on the following activation."))
		ready_to_erase = TRUE
	else
		to_chat(owner, SPAN_WARNING("You do not recall the events since the last time you activated your memory inhibitor!"))
		ready_to_erase = FALSE

/obj/item/organ/internal/augment/memory_inhibitor/do_broken_act()
	if(owner)
		to_chat(owner, SPAN_WARNING("You forgot everything that happened today!"))
	return TRUE

/obj/item/organ/internal/augment/memory_inhibitor/emp_act(severity)
	. = ..()

	if(prob(25))
		do_broken_act()

/obj/item/organ/internal/augment/emotional_manipulator
	name = "emotional manipulator"
	desc = "A Zeng Hu brain implant to manipulate the brain's chemicals to induce a calming or happy feeling. This is one of the most popular implants across the company."
	icon_state = "emotional_manipulator"
	organ_tag = BP_AUG_EMOTION
	parent_organ = BP_HEAD
	action_button_name = "Activate Emotional Manipulator"
	activable = TRUE
	action_button_icon = "emotional_manipulator"
	cooldown = 10
	var/set_emotion = "Disabled"
	var/last_emotion = 0

	var/list/possible_emotions = list(
		"Disabled",
		"Happiness",
		"Calmness")

/obj/item/organ/internal/augment/emotional_manipulator/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	var/choice = input("Select the Emotional Choice.", "Emotional Manipulator") as null|anything in capitalize_list(possible_emotions)

	set_emotion = lowertext(choice)

/obj/item/organ/internal/augment/emotional_manipulator/process()
	..()

	if(!owner)
		return

	if(world.time > (last_emotion + 5 MINUTES))
		switch(set_emotion)
			if("happiness")
				to_chat(owner, SPAN_GOOD("You feel happy."))
			if("calmness")
				to_chat(owner, SPAN_GOOD("You feel calm."))
		last_emotion = world.time

		if(is_broken())
			do_broken_act()

/obj/item/organ/internal/augment/emotional_manipulator/do_broken_act()
	if(owner)
		owner.hallucination += 20
	return TRUE


/obj/item/organ/internal/augment/enhanced_vision
	name = "vision enhanced retinas"
	desc = "Zeng Hu implants given to EMTs to assist with finding the injured. These eye implants allow one to see further than you normally could."
	icon_state = "enhanced_vision"
	organ_tag = BP_AUG_ENCHANED_VISION
	parent_organ = BP_HEAD
	action_button_name = "Activate Vision Enhanced Retinas"
	action_button_icon = "enhanced_vision"
	cooldown = 30
	activable = TRUE

/obj/item/organ/internal/augment/enhanced_vision/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	zoom(owner, 7, 7, FALSE, FALSE)
	owner.visible_message(zoom ? "<b>[owner]</b>'s pupils narrow..." : "<b>[owner]</b>'s pupils return to normal.", range = 3)

/obj/item/organ/internal/augment/enhanced_vision/emp_act(severity)
	. = ..()

	var/obj/item/organ/internal/eyes/E = owner.get_eyes()
	if(!E)
		return

	E.take_damage(5)

/obj/item/organ/internal/augment/sightlights
	name = "ocular installed sightlights "
	desc = "Designed to assist medical personnel in darker areas or places experiencing periodic power issues, Sightlights will allow one to be able to use their eyes as a flashlight."
	icon_state = "sightlights"
	organ_tag = BP_AUG_SIGHTLIGHTS
	parent_organ = BP_HEAD
	action_button_name = "Activate Ocular Installed Sightlights "
	action_button_icon = "sightlights"
	cooldown = 30
	activable = TRUE
	var/lights_on = FALSE

/obj/item/organ/internal/augment/sightlights/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	lights_on = !lights_on

	if(lights_on)
		set_light(5, 2, LIGHT_COLOR_TUNGSTEN, uv = 0, angle = LIGHT_WIDE)
	else
		set_light(0)

/obj/item/organ/internal/augment/sightlights/emp_act(severity)
	. = ..()
	set_light(0)

/obj/item/organ/internal/augment/sightlights/take_damage(var/amount, var/silent = 0)
	. = ..()
	set_light(0)

/obj/item/organ/internal/augment/sightlights/take_internal_damage(var/amount, var/silent = 0)
	. = ..()
	set_light(0)

/obj/item/organ/internal/augment/zenghu_plate
	name = "zeng-hu veterancy plate "
	desc = " A clear sign of Zeng-Hu's best, this plate bearing the company's symbol is installed on those who prove themselves in the hyper-competitive environment."
	icon_state = "zenghu_plate"
	on_mob_icon = 'icons/mob/human_races/augments_external.dmi'
	sprite_sheets = list(
		BODYTYPE_VAURCA_BULWARK = 'icons/mob/species/bulwark/augments_external.dmi'
	)
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/head_fluff
	name = "head augmentation"
	desc = "An augment installed inside the head of someone."
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/head_fluff/chest_fluff
	name = "chest augmentation"
	desc = "An augment installed inside the chest of someone."
	parent_organ = BP_CHEST

/obj/item/organ/internal/augment/head_fluff/rhand_fluff
	name = "right hand augmentation"
	desc = "An augment installed inside the right hand of someone."
	parent_organ = BP_R_HAND

/obj/item/organ/internal/augment/head_fluff/lhand_fluff
	name = "left hand augmentation"
	desc = "An augment installed inside the left hand of someone."
	parent_organ = BP_L_HAND

/obj/item/organ/internal/augment/head_fluff/die()
	..()
	if (owner)
		to_chat(owner, SPAN_DANGER("You sense your [name] stops functioning!"))

/obj/item/organ/internal/augment/head_fluff/process()
	..()
	if (is_broken() && !ORGAN_DEAD)
		if (prob(5))
			to_chat(owner, SPAN_WARNING("You sense your [name] isn't working right!"))

/obj/item/organ/internal/augment/head_fluff/removed()
	if (owner)
		to_chat(owner, SPAN_DANGER("You lose your connection with \the [name]!"))
	..()

/obj/item/organ/internal/augment/tool/correctivelens
	name = "corrective lenses"
	icon_state = "augment-tool"
	action_button_name = "Deploy Corrective Lenses"
	action_button_icon = "augment-tool"
	parent_organ = BP_EYES
	organ_tag = BP_AUG_CORRECTIVE_LENS
	augment_type = /obj/item/clothing/glasses/aug/glasses
	aug_slot = slot_glasses

/obj/item/organ/internal/augment/tool/correctivelens/glare_dampener
	name = "glare dapmeners"
	icon_state = "augment-tool"
	action_button_name = "Deploy Glare Dampeners"
	organ_tag = BP_AUG_GLARE_DAMPENER
	augment_type = /obj/item/clothing/glasses/aug/welding
