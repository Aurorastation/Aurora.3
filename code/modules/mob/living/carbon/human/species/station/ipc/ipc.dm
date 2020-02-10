/datum/species/machine
	name = "Baseline Frame"
	short_name = "ipc"
	name_plural = "Baselines"
	bodytype = "Machine"
	age_min = 1
	age_max = 30
	economic_modifier = 3
	default_genders = list(NEUTER)

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
	secondary_langs = list("Encoded Audio Language", "Sol Common")
	ethanol_resistance = -1//Can't get drunk
	radiation_mod = 0	// not affected by radiation
	remains_type = /obj/effect/decal/remains/robot

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

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 600		
	heat_level_2 = 1200
	heat_level_3 = 2400

	body_temperature = null
	passive_temp_gain = 10  // This should cause IPCs to stabilize at ~80 C in a 20 C environment.

	inherent_verbs = list(
		/mob/living/carbon/human/proc/self_diagnostics,
		/mob/living/carbon/human/proc/change_monitor
	)

	flags = IS_IPC
	appearance_flags = HAS_SKIN_COLOR | HAS_HAIR_COLOR
	spawn_flags = CAN_JOIN | IS_WHITELISTED | NO_AGE_MINIMUM

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/mmi_holder/posibrain,
		BP_CELL    = /obj/item/organ/internal/cell,
		BP_OPTICS  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/ipc_tag
	)

	vision_organ = BP_OPTICS

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

	max_hydration_factor = -1

	allowed_citizenships = list(CITIZENSHIP_NONE, CITIZENSHIP_BIESEL, CITIZENSHIP_COALITION, CITIZENSHIP_ERIDANI)
	default_citizenship = CITIZENSHIP_NONE

	// Special snowflake machine vars.
	var/sprint_temperature_factor = 1.15
	var/sprint_charge_factor = 0.65

datum/species/machine/handle_post_spawn(var/mob/living/carbon/human/H)
	. = ..()
	check_tag(H, H.client)

/datum/species/machine/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost)
	if (H.stat == CONSCIOUS)
		H.bodytemperature += cost * sprint_temperature_factor
		H.adjustNutritionLoss(cost * sprint_charge_factor)
		if(H.nutrition <= 0 && H.max_nutrition > 0)
			H.Weaken(15)
			H.m_intent = "walk"
			H.hud_used.move_intent.update_move_icon(H)
			to_chat(H, span("danger", "ERROR: Power reserves depleted, emergency shutdown engaged. Backup power will come online in approximately 30 seconds, initiate charging as primary directive."))
			playsound(H.loc, 'sound/machines/buzz-two.ogg', 100, 0)
		else
			return 1

	return 0

/datum/species/machine/handle_death(var/mob/living/carbon/human/H)
	..()
	H.f_style = ""
	addtimer(CALLBACK(H, /mob/living/carbon/human/.proc/update_hair), 100)

/datum/species/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/datum/species/machine/proc/check_tag(var/mob/living/carbon/human/new_machine, var/client/player)
	if (!new_machine || !player)
		return

	if (establish_db_connection(dbcon))

		var/obj/item/organ/internal/ipc_tag/tag = new_machine.internal_organs_by_name[BP_IPCTAG]

		var/status = TRUE
		var/list/query_details = list("ckey" = player.ckey, "character_name" = player.prefs.real_name)
		var/DBQuery/query = dbcon.NewQuery("SELECT tag_status FROM ss13_ipc_tracking WHERE player_ckey = :ckey: AND character_name = :character_name:")
		query.Execute(query_details)

		if (query.NextRow())
			status = text2num(query.item[1])
		else
			var/DBQuery/log_query = dbcon.NewQuery("INSERT INTO ss13_ipc_tracking (player_ckey, character_name, tag_status) VALUES (:ckey:, :character_name:, 1)")
			log_query.Execute(query_details)

		if (!status)
			new_machine.internal_organs_by_name -= BP_IPCTAG
			new_machine.internal_organs -= tag
			qdel(tag)

/datum/species/machine/proc/update_tag(var/mob/living/carbon/human/target, var/client/player)
	if (!target || !player)
		return

	if (establish_db_connection(dbcon))
		var/status = FALSE
		var/sql_status = FALSE
		if (target.internal_organs_by_name[BP_IPCTAG])
			status = TRUE

		var/list/query_details = list("ckey" = player.ckey, "character_name" = target.real_name)
		var/DBQuery/query = dbcon.NewQuery("SELECT tag_status FROM ss13_ipc_tracking WHERE player_ckey = :ckey: AND character_name = :character_name:")
		query.Execute(query_details)

		if (query.NextRow())
			sql_status = text2num(query.item[1])
			if (sql_status == status)
				return

			query_details["status"] = status
			var/DBQuery/update_query = dbcon.NewQuery("UPDATE ss13_ipc_tracking SET tag_status = :status: WHERE player_ckey = :ckey: AND character_name = :character_name:")
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

/datum/species/machine/before_equip(var/mob/living/carbon/human/H)
	. = ..()
	check_tag(H, H.client)

/datum/species/machine/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE