/datum/species/machine
	name = SPECIES_IPC
	short_name = "ipc"
	name_plural = "Baselines"
	category_name = "Integrated Positronic Chassis"
	bodytype = BODYTYPE_IPC
	species_height = HEIGHT_CLASS_SHORT
	height_min = 120
	height_max = 250
	age_min = 1
	age_max = 60
	economic_modifier = 6
	default_genders = list(NEUTER)
	selectable_pronouns = list(NEUTER, PLURAL)
	mob_weight = MOB_WEIGHT_HEAVY

	blurb = "IPCs are, quite simply, \"Integrated Positronic Chassis.\" In this scenario, 'positronic' implies that the chassis possesses a positronic processing core (or positronic brain), meaning that an IPC must be positronic to be considered an IPC. The Baseline model is more of a category - the long of the short is that they represent all unbound synthetic units. Baseline models cover anything that is not an Industrial chassis or a Shell chassis. They can be custom made or assembly made. The most common feature of the Baseline model is a simple design, skeletal or semi-humanoid, and ordinary atmospheric diffusion cooling systems."

	icobase = 'icons/mob/human_races/ipc/r_machine.dmi'
	deform = 'icons/mob/human_races/ipc/r_machine.dmi'
	preview_icon = 'icons/mob/human_races/ipc/machine_preview.dmi'
	eyes = "blank_eyes"

	light_range = 2
	light_power = 0.5
	meat_type = /obj/item/stack/material/steel
	unarmed_types = list(
		/datum/unarmed_attack/punch/ipc,
		/datum/unarmed_attack/stomp/ipc,
		/datum/unarmed_attack/kick/ipc)
	rarity_value = 2

	inherent_eye_protection = FLASH_PROTECTION_MAJOR
	eyes_are_impermeable = TRUE

	name_language = "Encoded Audio Language"
	num_alternate_languages = 2
	secondary_langs = list("Encoded Audio Language", "Sol Common", "Elyran Standard")
	ethanol_resistance = -1//Can't get drunk
	radiation_mod = 0	// not affected by radiation
	remains_type = /obj/effect/decal/remains/robot
	dust_remains_type = /obj/effect/decal/remains/robot/burned

	hud_type = /datum/hud_data/ipc

	brute_mod = 1.0
	burn_mod = 1.2

	grab_mod = 1.1 // Smooth, no real edges to grab onto
	resist_mod = 2 // Robotic strength

	show_ssd = "flashing a 'system offline' glyph on their monitor"

	death_message = "gives one shrill beep before falling lifeless."
	death_message_range = 7
	knockout_message = "encounters a hardware fault and suddenly reboots!"
	halloss_message = "encounters a hardware fault and suddenly reboots."
	halloss_message_self = "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..."

	stutter_verbs = list("sputters", "crackles", "stutters")

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 600
	heat_level_2 = 1200
	heat_level_3 = 2400

	body_temperature = null
	passive_temp_gain = 2

	inherent_verbs = list(
		/mob/living/carbon/human/proc/change_monitor,
		/mob/living/carbon/human/proc/check_tag
	)

	flags = IS_IPC
	appearance_flags = HAS_SKIN_COLOR | HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SOCKS
	spawn_flags = CAN_JOIN | IS_WHITELISTED | NO_AGE_MINIMUM

	blood_type = "oil"
	blood_color = COLOR_IPC_BLOOD
	flesh_color = "#575757"
	reagent_tag = IS_MACHINE

	// If you add a new organ to IPCs, remember that a lot of the normal subspecies have overrides because of custom subtype organs.
	// You'll need to add the new organ there too.
	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

	vision_organ = BP_EYES

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/ipc),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/ipc),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/ipc),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/ipc),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/ipc),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/ipc),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/ipc),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc)
	)


	heat_discomfort_level = 500 //This will be 100 below the first heat level
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina = -1	// Machines use power and generate heat, stamina is not a thing
	sprint_speed_factor = 1  // About as capable of speed as a human
	sprint_cost_factor = 1.5

	max_hydration_factor = -1
	max_nutrition_factor = -1

	bodyfall_sound = /singleton/sound_category/bodyfall_machine_sound

	possible_cultures = list(
		/singleton/origin_item/culture/ipc_sol,
		/singleton/origin_item/culture/ipc_elyra,
		/singleton/origin_item/culture/ipc_coalition,
		/singleton/origin_item/culture/ipc_tau_ceti,
		/singleton/origin_item/culture/golden_deep,
		/singleton/origin_item/culture/megacorporate,
		/singleton/origin_item/culture/scrapper
	)

	alterable_internal_organs = list(BP_COOLING_UNIT, BP_REACTOR)
	possible_speech_bubble_types = list("robot", "default")

	// Special snowflake machine vars.
	var/sprint_temperature_factor = 1.15
	var/move_charge_factor = 1
	/// The theme of the IPC's personal UIs, if not broken.
	var/machine_ui_theme = "hackerman"

	use_alt_hair_layer = TRUE
	psi_deaf = TRUE

	sleeps_upright = TRUE
	snore_key = "beep"
	indefinite_sleep = TRUE

	natural_armor_type = /datum/component/armor/synthetic
	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_MINOR,
		melee = ARMOR_MELEE_KNIVES
	)

/datum/species/machine/handle_temperature_regulation(mob/living/carbon/human/human)
	. = ..()
	// No cooling unit = you're cooking. Broken cooling unit effects are handled by the organ itself.
	// Here we just want to check if it's been removed.
	// 500K is about 226 degrees. Spicy!
	human.bodytemperature = min(human.bodytemperature + rand(1, 5), heat_level_3)

/datum/species/machine/handle_stance_damage(mob/living/carbon/human/H, damage_only)
	var/obj/item/organ/internal/machine/hydraulics/hydraulics = H.internal_organs_by_name[BP_HYDRAULICS]
	if(!hydraulics)
		return 6 //no hydraulics, no party

	if(hydraulics.status & ORGAN_DEAD)
		return 5
	else
		switch(hydraulics.get_integrity())
			if(0 to IPC_INTEGRITY_THRESHOLD_VERY_HIGH)
				to_chat(H, SPAN_MACHINE_WARNING("Your hydraulics are on the verge of breaking completely!"))
				spark(H, rand(3, 4), GLOB.alldirs)
				return 4
			if(IPC_INTEGRITY_THRESHOLD_VERY_HIGH to IPC_INTEGRITY_THRESHOLD_HIGH)
				to_chat(H, SPAN_MACHINE_WARNING("Your hydraulics spark and whine!"))
				spark(H, rand(1, 3), GLOB.alldirs)
				return 2
	return 0

/datum/species/machine/handle_post_spawn(var/mob/living/carbon/human/H)
	. = ..()
	H.AddComponent(/datum/component/synthetic_burst_damage)
	check_tag(H, H.client)
	var/obj/item/organ/internal/machine/power_core/C = H.internal_organs_by_name[BP_CELL]
	if(C)
		C.move_charge_factor = move_charge_factor

/datum/species/machine/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost, var/pre_move)
	if(!pre_move && H.stat == CONSCIOUS)
		H.bodytemperature += cost * sprint_temperature_factor
	var/obj/item/organ/internal/machine/hydraulics/hydraulics = H.internal_organs_by_name[BP_HYDRAULICS]
	if(istype(hydraulics))
		var/hydraulics_integrity = hydraulics.get_integrity()
		if(hydraulics_integrity < 75)
			var/damage_mod = 2
			if(hydraulics.is_bruised())
				damage_mod = 3
			if(hydraulics.is_broken())
				damage_mod = 5

			// x = x * (2 + 100 - y ) / 100
			// x = x * (2 + 100 - 75) / 100 -> x = x * (2 + (25 / 100)) --> x = x * 2.25
			// increases depending on integrity

			cost *= damage_mod + ((100 - hydraulics_integrity) / 100)

	var/obj/item/organ/internal/machine/power_core/C = H.internal_organs_by_name[BP_CELL]
	if(istype(C))
		C.use(cost * sprint_cost_factor)
		SEND_SIGNAL(H, COMSIG_IPC_HAS_SPRINTED)
	return TRUE

/datum/species/machine/handle_emp_act(mob/living/carbon/human/hit_mob, severity)
	var/obj/item/organ/internal/machine/surge/S = hit_mob.internal_organs_by_name[BP_SURGE_PROTECTOR]
	if(!isnull(S))
		if(S.surge_left >= 1)
			playsound(hit_mob.loc, 'sound/magic/LightningShock.ogg', 25, 1)
			S.surge_left -= 1
			if(S.surge_left)
				to_chat(hit_mob, SPAN_WARNING("Warning: EMP detected, integrated surge prevention module activated. There are [S.surge_left] preventions left."))
			else
				S.broken = TRUE
				S.icon_state = "surge_ipc_broken"
				to_chat(hit_mob, SPAN_DANGER("Warning: EMP detected, integrated surge prevention module activated. The surge prevention module is fried, replacement recommended."))
			return EMP_PROTECT_ALL
		else
			to_chat(src, SPAN_DANGER("Warning: EMP detected, integrated surge prevention module is fried and unable to protect from EMP. Replacement recommended."))
	return NONE

/datum/species/machine/handle_death(var/mob/living/carbon/human/H)
	..()
	H.f_style = ""
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, update_hair)), 100)

/datum/species/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/datum/species/machine/bypass_food_fullness(mob/living/carbon/human/H)
	var/obj/item/organ/internal/machine/reactor/reactor = H.internal_organs_by_name[BP_REACTOR]
	if(reactor && (reactor.power_supply_type & POWER_SUPPLY_BIOLOGICAL))
		return TRUE
	return FALSE

/datum/species/machine/proc/check_tag(var/mob/living/carbon/human/new_machine, var/client/player)
	if(!new_machine || !player)
		var/obj/item/organ/internal/machine/ipc_tag/tag = new_machine.internal_organs_by_name[BP_IPCTAG]
		if(tag)
			tag.serial_number = uppertext(dd_limittext(md5(new_machine.real_name), 12))
			tag.ownership_info = IPC_OWNERSHIP_COMPANY
			tag.citizenship_info = CITIZENSHIP_BIESEL
		return

	var/obj/item/organ/internal/machine/ipc_tag/tag = new_machine.internal_organs_by_name[BP_IPCTAG]

	if(player.prefs.machine_tag_status)
		tag.serial_number = player.prefs.machine_serial_number
		tag.ownership_info = player.prefs.machine_ownership_status
		tag.citizenship_info = new_machine.citizenship
	else
		new_machine.internal_organs_by_name -= BP_IPCTAG
		new_machine.internal_organs -= tag
		qdel(tag)

/datum/species/machine/proc/update_tag(var/mob/living/carbon/human/target, var/client/player)
	if (!target || !player)
		return

	if (establish_db_connection(GLOB.dbcon) && target.character_id)
		var/status = FALSE
		var/sql_status = FALSE
		if (target.internal_organs_by_name[BP_IPCTAG])
			status = TRUE

		var/list/query_details = list("char_id" = target.character_id)
		var/DBQuery/query = GLOB.dbcon.NewQuery("SELECT tag_status FROM ss13_characters_ipc_tags WHERE char_id = :char_id:")
		query.Execute(query_details)

		if (query.NextRow())
			sql_status = text2num(query.item[1])
			if (sql_status == status)
				return

			query_details["status"] = status
			var/DBQuery/update_query = GLOB.dbcon.NewQuery("UPDATE ss13_characters_ipc_tags SET tag_status = :status: WHERE char_id = :char_id:")
			update_query.Execute(query_details)

/datum/species/machine/get_light_color(mob/living/carbon/human/H)
	if (!istype(H))
		return null

	// I hate this, but I can't think of a better way that doesn't involve
	// rewriting hair.
	switch (H.f_style)
		if ("pink IPC screen")
			return LIGHT_COLOR_PINK

		if ("red IPC screen")
			return LIGHT_COLOR_RED

		if ("green IPC screen")
			return LIGHT_COLOR_GREEN

		if ("blue IPC screen")
			return LIGHT_COLOR_BLUE

		if ("breakout IPC screen")
			return LIGHT_COLOR_CYAN

		if ("eight IPC screen")
			return LIGHT_COLOR_CYAN

		if ("goggles IPC screen")
			return LIGHT_COLOR_RED

		if ("heart IPC screen")
			return LIGHT_COLOR_PINK

		if ("monoeye IPC screen")
			return LIGHT_COLOR_ORANGE

		if ("nature IPC screen")
			return LIGHT_COLOR_CYAN

		if ("orange IPC screen")
			return LIGHT_COLOR_ORANGE

		if ("purple IPC screen")
			return LIGHT_COLOR_PURPLE

		if ("shower IPC screen")
			return "#FFFFFF"

		if ("static IPC screen")
			return "#FFFFFF"

		if ("static2 IPC screen")
			return "#FFFFFF"

		if ("static3 IPC screen")
			return "#FFFFFF"

		if ("yellow IPC screen")
			return LIGHT_COLOR_YELLOW

		if ("eye IPC screen")
			return LIGHT_COLOR_CYAN

		if ("heartrate IPC screen")
			return LIGHT_COLOR_BLUE

		if ("cancel IPC screen")
			return LIGHT_COLOR_RED

		if ("testcard IPC screen")
			return "#FFFFFF"

		if ("blank IPC screen")
			return null

		if ("scroll IPC screen")
			return "#FFFFFF"

		if ("console IPC screen")
			return "#FFFFFF"

		if ("RGB IPC screen")
			return "#FFFFFF" //idk

		if ("GoL glider IPC screen")
			return "#FFFFFF"

		if ("rainbow IPC screen")
			return "#FFFFFF" //idk 2.0

		if ("smiley IPC screen")
			return LIGHT_COLOR_YELLOW

		if ("database IPC screen")
			return "#FFFFFF"

		if ("lumi eyes IPC screen")
			return "#FFFFFF"

		if ("music IPC screen")
			return "#FFFFFF"

		if ("waiting IPC screen")
			return "#FFFFFF"

		if ("nanotrasen IPC screen")
			return LIGHT_COLOR_BLUE

		if ("hephaestus IPC screen")
			return LIGHT_COLOR_ORANGE

		if ("idris IPC screen")
			return LIGHT_COLOR_CYAN

		if ("zavodskoi IPC screen")
			return LIGHT_COLOR_RED

		if ("zeng-hu IPC screen")
			return "#FFFFFF"

		if ("scc IPC screen")
			return LIGHT_COLOR_BLUE

		if ("republic of biesel IPC screen")
			return "#FFFFFF"

		if ("sol alliance IPC screen")
			return "#FFFFFF"

		if ("coalition of colonies IPC screen")
			return LIGHT_COLOR_BLUE

		if ("republic of elyra IPC screen")
			return LIGHT_COLOR_YELLOW

		if ("eridani IPC screen")
			return "#FFFFFF"

		if ("burzsia IPC screen")
			return LIGHT_COLOR_ORANGE

		if ("trinary perfection IPC screen")
			return LIGHT_COLOR_RED

		if ("golden deep IPC screen")
			return LIGHT_COLOR_YELLOW

/datum/species/machine/before_equip(var/mob/living/carbon/human/H)
	. = ..()
	check_tag(H, H.client)

/datum/species/machine/has_stamina_for_pushup(var/mob/living/carbon/human/human)
	var/obj/item/organ/internal/machine/power_core/C = human.internal_organs_by_name[BP_CELL]
	if(!C.cell)
		return FALSE
	return C.cell.charge > (C.cell.maxcharge / 10)

/datum/species/machine/drain_stamina(var/mob/living/carbon/human/human, var/stamina_cost)
	var/obj/item/organ/internal/machine/power_core/C = human.internal_organs_by_name[BP_CELL]
	if(C)
		C.use(stamina_cost * 8)

/datum/species/machine/sleep_msg(var/mob/M)
	M.visible_message(SPAN_NOTICE("\The [M] locks [M.get_pronoun("his")] chassis into place, entering standby."))
	to_chat(M, SPAN_NOTICE("You lock your chassis into place, entering standby."))

/datum/species/machine/sleep_examine_msg(var/mob/M)
	return SPAN_NOTICE("[M.get_pronoun("He")] appears to be in standby.\n")

/datum/species/machine/can_speak(mob/living/carbon/human/speaker, datum/language/speaking, message)
	var/obj/item/organ/internal/machine/voice_synthesizer/voice_synth = speaker.internal_organs_by_name[BP_VOICE_SYNTHESIZER]
	if(istype(voice_synth))
		return TRUE
	else
		to_chat(speaker, SPAN_WARNING("You cannot synthesize a voice without your [BP_VOICE_SYNTHESIZER]!"))
		return FALSE

/datum/species/machine/handle_speech_problems(mob/living/carbon/human/H, message, say_verb, message_mode, message_range)
	var/obj/item/organ/internal/machine/voice_synthesizer/voice_synth = H.internal_organs_by_name[BP_VOICE_SYNTHESIZER]
	if(istype(voice_synth))
		if(voice_synth.is_bruised())
			// at most, 30 * 2 + 10 = 70, which is the maximum value we can use for Gibberish
			message = Gibberish(message, voice_synth.damage * 2 + (voice_synth.is_broken() ? 10 : 0))
			return list(HSP_MSG = message, HSP_VERB = pick(list("crackles", "buzzes")))
