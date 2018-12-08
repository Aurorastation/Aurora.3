/datum/species/human
	name = "Human"
	hide_name = TRUE
	short_name = "hum"
	name_plural = "Humans"
	bodytype = "Human"
	age_max = 125
	economic_modifier = 12

	primitive_form = "Monkey"
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
	)
	blurb = "Humanity originated in the Sol system, and over the last four centuries has spread colonies across a wide swathe of space. \
	They hold a wide range of forms and creeds.<br><br>\
	The Sol Alliance is still massively influential, but independent human nations have managed to shake off its dominance and forge their \
	own path. Driven by an unending hunger for wealth, powerful corporate interests are bringing untold wealth to humanity. Unchecked \
	megacorporations have sparked secretive factions to fight their influence, while there is always the risk of someone digging too \
	deep into the secrets of the galaxy..."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_SIIK_TAU)
	name_language = null // Use the first-name last-name generator rather than a language scrambler
	mob_size = 9
	spawn_flags = CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR | HAS_SOCKS
	remains_type = /obj/effect/decal/remains/human

	stamina = 130	// Humans can sprint for longer than any other species
	stamina_recovery = 5
	sprint_speed_factor = 0.9
	sprint_cost_factor = 0.5

	climb_coeff = 1

/datum/species/unathi
	name = "Unathi"
	short_name = "una"
	name_plural = "Unathi"
	bodytype = "Unathi"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)
	primitive_form = "Stok"
	darksight = 3
	gluttonous = 1
	slowdown = 0.5
	brute_mod = 0.8
	fall_mod = 1.2
	ethanol_resistance = 0.4
	taste_sensitivity = TASTE_SENSITIVE
	economic_modifier = 7

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	name_language = LANGUAGE_UNATHI
	stamina	=	120			  // Unathi have the shortest but fastest sprint of all
	sprint_speed_factor = 3.2
	stamina_recovery = 5
	sprint_cost_factor = 1.45
	exhaust_threshold = 65
	rarity_value = 3
	breakcuffs = list(MALE)
	mob_size = 10
	climb_coeff = 1.35

	blurb = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the Uuosa-Eso \
	system, which roughly translates to 'burning mother'. A relatively recent addition to the galactic stage, they \
	suffered immense turmoil after the cultural and economic disruption following first contact with humanity.<br><br>\
	With their homeworld of Moghes suffering catastrophic climate change from a nuclear war in the recent past, the \
	Hegemony that rules the majority of the species struggles to find itself in a galaxy filled with dangers far \
	greater than themselves. They mostly hold ideals of honesty, virtue, martial combat and spirituality above all \
	else.They prefer warmer temperatures than most species."

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	inherent_verbs = list(
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/regurgitate
	)


	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"

	heat_discomfort_level = 295
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

/datum/species/unathi/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	if(H.equip_to_slot_or_del(S,slot_shoes))
		S.autodrobe_no_remove = 1

/datum/species/tajaran
	name = "Tajara"
	short_name = "taj"
	name_plural = "Tajara"
	bodytype = "Tajara"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)
	darksight = 8
	slowdown = -1
	brute_mod = 1.2
	fall_mod = 0.5
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_YA_SSA, LANGUAGE_SIIK_TAU)
	name_language = LANGUAGE_SIIK_MAAS
	ethanol_resistance = 0.8//Gets drunk a little faster
	rarity_value = 2
	economic_modifier = 7

	stamina = 90	// Tajara evolved to maintain a steady pace in the snow, sprinting wastes energy
	stamina_recovery = 4
	sprint_speed_factor = 0.65
	sprint_cost_factor = 0.75

	blurb = "The Tajaran race is a species of feline-like bipeds hailing from the planet of Adhomai in the S'rendarr \
	system. They have been brought up into the space age by the Humans and Skrell, who alledgedly influenced their \
	eventual revolution that overthrew their ancient monarchies to become totalitarian - and NanoTrasen friendly - \
	republics. Adhomai is still enduring a global war in the aftermath of the new world order, and many Tajara are \
	fleeing their homeworld to seek safety and employment in human space. They prefer colder environments, and speak \
	a variety of languages, mostly Siik'Maas, using unique inflections their mouths form."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive_form = "Farwa"

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)
	cold_discomfort_level = 275

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	default_h_style = "Tajaran Ears"

/datum/species/tajaran/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	if(H.equip_to_slot_or_del(S,slot_shoes))
		S.autodrobe_no_remove = 1

/datum/species/skrell
	name = "Skrell"
	short_name = "skr"
	name_plural = "Skrell"
	bodytype = "Skrell"
	age_max = 500
	economic_modifier = 12
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	eyes = "skrell_eyes_s"
	primitive_form = "Neaera"
	unarmed_types = list(/datum/unarmed_attack/punch)

	blurb = "An amphibious species, Skrell come from the star system known as Nralakk, coined 'Jargon' by \
	humanity.<br><br>Skrell are a highly advanced, ancient race who place knowledge as the highest ideal. \
	A dedicated meritocracy, the Skrell strive for ever-expanding knowledge of the galaxy and their place \
	in it. However, a cataclysmic AI rebellion by Glorsh and its associated atrocities in the far past has \
	forever scarred the species and left them with a deep rooted suspicion of artificial intelligence. As \
	such an ancient and venerable species, they often hold patronizing attitudes towards the younger races."

	num_alternate_languages = 3
	language = LANGUAGE_SKRELLIAN
	secondary_langs = list(LANGUAGE_SIIK_TAU)
	name_language = LANGUAGE_SKRELLIAN
	rarity_value = 3

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_SOCKS
	flags = NO_SLIP

	has_organ = list(
		"heart" =    /obj/item/organ/heart/skrell,
		"lungs" =    /obj/item/organ/lungs/skrell,
		"liver" =    /obj/item/organ/liver/skrell,
		"kidneys" =  /obj/item/organ/kidneys/skrell,
		"brain" =    /obj/item/organ/brain/skrell,
		"appendix" = /obj/item/organ/appendix,
		"eyes" =     /obj/item/organ/eyes/skrell
		)

	flesh_color = "#8CD7A3"
	blood_color = "#1D2CBF"
	base_color = "#006666"

	reagent_tag = IS_SKRELL
	ethanol_resistance = 0.5//gets drunk faster
	taste_sensitivity = TASTE_SENSITIVE

	stamina = 90
	sprint_speed_factor = 1.25 //Evolved for rapid escapes from predators

	inherent_verbs = list(/mob/living/carbon/human/proc/commune)

/datum/species/skrell/can_breathe_water()
	return TRUE

/datum/species/skrell/set_default_hair(var/mob/living/carbon/human/H)
	if(H.gender == MALE)
		H.h_style = "Skrell Male Tentacles"
	else
		H.h_style = "Skrell Female Tentacles"
	H.update_hair()

/datum/species/diona
	name = "Diona"
	short_name = "dio"
	name_plural = "Dionaea"
	bodytype = "Diona"
	age_max = 1000
	economic_modifier = 3
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = LANGUAGE_ROOTSONG
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/diona
	)
	//primitive_form = "Nymph"
	slowdown = 7
	rarity_value = 4
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	eyes = "blank_eyes"
	show_ssd = "completely quiescent"
	num_alternate_languages = 1
	name_language = LANGUAGE_ROOTSONG
	ethanol_resistance = -1	//Can't get drunk
	taste_sensitivity = TASTE_DULL
	mob_size = 12	//Worker gestalts are 150kg
	remains_type = /obj/effect/decal/cleanable/ash //no bones, so, they just turn into dust
	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."

	has_organ = list(
		"nutrient channel"   = /obj/item/organ/diona/nutrients,
		"neural strata"      = /obj/item/organ/diona/strata,
		"response node"      = /obj/item/organ/diona/node,
		"gas bladder"        = /obj/item/organ/diona/bladder,
		"polyp segment"      = /obj/item/organ/diona/polyp,
		"anchoring ligament" = /obj/item/organ/diona/ligament
	)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/diona),
		"groin" =  list("path" = /obj/item/organ/external/groin/diona),
		"head" =   list("path" = /obj/item/organ/external/head/diona),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/diona),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/diona),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/diona),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/diona),
		"l_hand" = list("path" = /obj/item/organ/external/hand/diona),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/diona),
		"l_foot" = list("path" = /obj/item/organ/external/foot/diona),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/diona)
		)

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 273
	cold_level_2 = 223
	cold_level_3 = 173

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not

	flags = NO_BREATHE | NO_SCAN | IS_PLANT | NO_BLOOD | NO_PAIN | NO_SLIP | NO_CHUBBY
	appearance_flags = 0
	spawn_flags = CAN_JOIN | IS_WHITELISTED

	blood_color = "#97dd7c"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	stamina = -1	// Diona sprinting uses energy instead of stamina
	sprint_speed_factor = 0.5	//Speed gained is minor
	sprint_cost_factor = 0.8
	climb_coeff = 1.3
	vision_organ = "head"

	max_hydration_factor = -1

/datum/species/diona/handle_sprint_cost(var/mob/living/carbon/H, var/cost)
	var/datum/dionastats/DS = H.get_dionastats()

	if (!DS)
		return 0 //Something is very wrong

	var/remainder = cost * sprint_cost_factor

	if (H.total_radiation)
		if (H.total_radiation > (cost*0.5))//Radiation counts as double energy
			H.apply_radiation(cost*(-0.5))
			return 1
		else
			remainder = cost - (H.total_radiation*2)
			H.total_radiation = 0

	if (DS.stored_energy > remainder)
		DS.stored_energy -= remainder
		return 1
	else
		remainder -= DS.stored_energy
		DS.stored_energy = 0
		H.adjustHalLoss(remainder*5, 1)
		H.updatehealth()
		H.m_intent = "walk"
		H.hud_used.move_intent.update_move_icon(H)
		H << span("danger", "We have expended our energy reserves, and cannot continue to move at such a pace. We must find light!")
		return 0

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/equip_survival_gear(var/mob/living/carbon/human/H)
	var/obj/item/device/flashlight/flare/F = new /obj/item/device/flashlight/flare(H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(F, slot_r_hand)
	else
		H.equip_to_slot_or_del(F, slot_in_backpack)
	if(!QDELETED(F))
		F.autodrobe_no_remove = 1
	H.gender = NEUTER

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	if (ishuman(H))
		return ..()
	else//Most of the stuff in the parent function doesnt apply to nymphs
		add_inherent_verbs(H)

/datum/species/diona/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if (!gibbed)
		// This proc sleeps. Async it.
		INVOKE_ASYNC(H, /mob/living/carbon/human/proc/diona_split_into_nymphs)

/datum/species/diona/handle_speech_problems(mob/living/carbon/human/H, list/current_flags, message, message_verb, message_mode)
// Diona without head can live, but they cannot talk as loud anymore.
	var/obj/item/organ/external/O = H.organs_by_name["head"]
	current_flags[4] = O.is_stump() ? 3 : world.view
	return current_flags

/datum/species/diona/handle_speech_sound(mob/living/carbon/human/H, list/current_flags)
	current_flags = ..()
	var/obj/item/organ/external/O = H.organs_by_name["head"]
	current_flags[3] = O.is_stump()
	return current_flags

/datum/species/machine
	name = "Baseline Frame"
	short_name = "ipc"
	name_plural = "Baselines"
	bodytype = "Machine"
	age_min = 1
	age_max = 30
	economic_modifier = 3

	blurb = "IPCs are, quite simply, \"Integrated Positronic Chassis.\" In this scenario, 'positronic' implies that the chassis possesses a positronic processing core (or positronic brain), meaning that an IPC must be positronic to be considered an IPC. The Baseline model is more of a category - the long of the short is that they represent all unbound synthetic units. Baseline models cover anything that is not an Industrial chassis or a Shell chassis. They can be custom made or assembly made. The most common feature of the Baseline model is a simple design, skeletal or semi-humanoid, and ordinary atmospheric diffusion cooling systems."

	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	eyes = "blank_eyes"

	light_range = 2
	light_power = 0.5
	meat_type = /obj/item/stack/material/steel
	unarmed_types = list(/datum/unarmed_attack/punch)
	rarity_value = 2

	inherent_eye_protection = FLASH_PROTECTION_MAJOR
	eyes_are_impermeable = TRUE

	name_language = "Encoded Audio Language"
	num_alternate_languages = 2
	secondary_langs = list("Encoded Audio Language")
	ethanol_resistance = -1//Can't get drunk
	radiation_mod = 0	// not affected by radiation
	remains_type = /obj/effect/decal/remains/robot

	hud_type = /datum/hud_data/ipc

	brute_mod = 1.0
	burn_mod = 1.2
	show_ssd = "flashing a 'system offline' glyph on their monitor"
	death_message = "gives one shrill beep before falling lifeless."
	knockout_message = "encounters a hardware fault and suddenly reboots!"
	halloss_message = "encounters a hardware fault and suddenly reboots."
	halloss_message_self = "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..."

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = null
	passive_temp_gain = 10  // This should cause IPCs to stabilize at ~80 C in a 20 C environment.

	flags = IS_IPC
	appearance_flags = HAS_SKIN_COLOR | HAS_HAIR_COLOR
	spawn_flags = CAN_JOIN | IS_WHITELISTED

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	has_organ = list(
		"brain"   = /obj/item/organ/mmi_holder/posibrain,
		"cell"    = /obj/item/organ/cell,
		"optics"  = /obj/item/organ/eyes/optical_sensor,
		"ipc tag" = /obj/item/organ/ipc_tag
	)

	vision_organ = "optics"

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/ipc),
		"groin" =  list("path" = /obj/item/organ/external/groin/ipc),
		"head" =   list("path" = /obj/item/organ/external/head/ipc),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/ipc),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/ipc),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/ipc),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/ipc),
		"l_hand" = list("path" = /obj/item/organ/external/hand/ipc),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/ipc),
		"l_foot" = list("path" = /obj/item/organ/external/foot/ipc),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/ipc)
	)


	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina = -1	// Machines use power and generate heat, stamina is not a thing
	sprint_speed_factor = 1  // About as capable of speed as a human

	max_hydration_factor = -1

	// Special snowflake machine vars.
	var/sprint_temperature_factor = 1.15
	var/sprint_charge_factor = 0.65

datum/species/machine/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
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
			H << span("danger", "ERROR: Power reserves depleted, emergency shutdown engaged. Backup power will come online in approximately 30 seconds, initiate charging as primary directive.")
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

		var/obj/item/organ/ipc_tag/tag = new_machine.internal_organs_by_name["ipc tag"]

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
			new_machine.internal_organs_by_name -= "ipc tag"
			new_machine.internal_organs -= tag
			qdel(tag)

/datum/species/machine/proc/update_tag(var/mob/living/carbon/human/target, var/client/player)
	if (!target || !player)
		return

	if (establish_db_connection(dbcon))
		var/status = FALSE
		var/sql_status = FALSE
		if (target.internal_organs_by_name["ipc tag"])
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

		if ("yellow IPC screen")
			return LIGHT_COLOR_YELLOW

/datum/species/machine/equip_survival_gear(var/mob/living/carbon/human/H)
	check_tag(H, H.client)
	H.gender = NEUTER

/datum/species/bug
	name = "Vaurca Worker"
	short_name = "vau"
	name_plural = "Type A"
	bodytype = "Vaurca"
	age_min = 1
	age_max = 20
	economic_modifier = 2
	language = LANGUAGE_VAURCA
	primitive_form = "V'krexi"
	greater_form = "Vaurca Warrior"
	icobase = 'icons/mob/human_races/r_vaurca.dmi'
	deform = 'icons/mob/human_races/r_vaurca.dmi'
	name_language = LANGUAGE_VAURCA
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/bug
	rarity_value = 4
	slowdown = 1
	darksight = 8 //USELESS
	eyes = "vaurca_eyes" //makes it so that eye colour is not changed when skin colour is.
	eyes_are_impermeable = TRUE
	brute_mod = 0.5
	burn_mod = 1.5 //2x was a bit too much. we'll see how this goes.
	toxins_mod = 2 //they're not used to all our weird human bacteria.
	oxy_mod = 0.6
	radiation_mod = 0.2 //almost total radiation protection
	warning_low_pressure = 50
	hazard_low_pressure = 0
	ethanol_resistance = 2
	taste_sensitivity = TASTE_SENSITIVE
	reagent_tag = IS_VAURCA
	siemens_coefficient = 1 //setting it to 0 would be redundant due to LordLag's snowflake checks, plus batons/tasers use siemens now too.
	breath_type = "phoron"
	poison_type = "nitrogen" //a species that breathes plasma shouldn't be poisoned by it.
	mob_size = 13 //their half an inch thick exoskeleton and impressive height, plus all of their mechanical organs.
	natural_climbing = TRUE
	climb_coeff = 0.75

	blurb = "Type A are the most common type of Vaurca and can be seen as the 'backbone' of Vaurcae societies. Their most prevalent feature is their hardened exoskeleton, varying in colors \
	in accordance to their hive. It is approximately half an inch thick among all Type A Vaurca. The carapace provides protection against harsh radiation, solar \
	and otherwise, and acts as a pressure-suit to seal their soft inner core from the outside world. This allows most Type A Vaurca to have extended EVA \
	expeditions, assuming they have internals. They are bipedal, and compared to warriors they are better suited for EVA and environments, and more resistant to brute force thanks to their \
	thicker carapace, but also a fair bit slower and less agile. \
	<b>Type A are comfortable in any department except security. There will almost never be a Worker in a security position, as they are as a type disposed against combat.</b>"

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 600 //Default 1000
	flags = NO_SLIP | NO_CHUBBY
	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_SKIN_COLOR | HAS_HAIR_COLOR
	blood_color = "#E6E600" // dark yellow
	flesh_color = "#E6E600"
	base_color = "#575757"

	death_message = "chitters faintly before crumbling to the ground, their eyes dead and lifeless..."
	halloss_message = "crumbles to the ground, too weak to continue fighting."

	heat_discomfort_strings = list(
		"Your blood feels like its boiling in the heat.",
		"You feel uncomfortably warm.",
		"Your carapace feels hot as the sun."
	)

	cold_discomfort_strings = list(
		"You chitter in the cold.",
		"You shiver suddenly.",
		"Your carapace is ice to the touch."
	)

	stamina = 100			  // Long period of sprinting, but relatively low speed gain
	sprint_speed_factor = 0.7
	sprint_cost_factor = 0.30
	stamina_recovery = 2	//slow recovery

	has_organ = list(
		"neural socket"       = /obj/item/organ/vaurca/neuralsocket,
		"lungs"               = /obj/item/organ/lungs/vaurca,
		"filtration bit"      = /obj/item/organ/vaurca/filtrationbit,
		"right heart"         = /obj/item/organ/heart/right,
		"left heart"          = /obj/item/organ/heart/left,
		"phoron reserve tank" = /obj/item/organ/vaurca/preserve,
		"liver"               = /obj/item/organ/liver/vaurca,
		"kidneys"             = /obj/item/organ/kidneys/vaurca,
		"brain"               = /obj/item/organ/brain/vaurca,
		"eyes"                = /obj/item/organ/eyes/vaurca
	)

	default_h_style = "Classic Antennae"

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

/datum/species/bug/equip_survival_gear(var/mob/living/carbon/human/H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vaurca(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/vaurca(H.back), slot_in_backpack)
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	if(H.equip_to_slot_or_del(S,slot_shoes))
		S.autodrobe_no_remove = 1
	var/obj/item/clothing/mask/breath/M = new /obj/item/clothing/mask/breath(H)
	if(H.equip_to_slot_or_del(M, slot_wear_mask))
		M.autodrobe_no_remove = 1

/datum/species/bug/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()


/datum/species/getmorean
	name = "Getmorean"
	hide_name = FALSE
	short_name = "get"
	name_plural = "Getmoreans"
	bodytype = "Getmorean"
	age_max = 20
	economic_modifier = 4 // Getmorean don't get paid much money at all, as they're technically a hired corperate entity.
	icobase = 'icons/mob/human_races/r_getmore.dmi'
	deform = 'icons/mob/human_races/r_getmore.dmi'

	flesh_color = "#333333"

	mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human

	brute_mod =     3.0                  // Physical damage multiplier.
	burn_mod =      0.3                  // Burn damage multiplier.
	oxy_mod =       0                    // Oxyloss modifier
	toxins_mod =    0                    // Toxloss modifier
	radiation_mod = 0                    // Radiation modifier
	flash_mod =     0                    // Stun from blindness modifier.
	fall_mod =      0                    // Fall damage modifier, further modified by brute damage modifier
	inherent_eye_protection = 1          // If set, this species has this level of inherent eye protection.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	blood_color = "#654321"

	flags = NO_CHUBBY | NO_BLOOD | NO_BREATHE | NO_SCAN | NO_PAIN | NO_POISON | NO_HEAD


	primitive_form = null

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch
	)
	// Getmore Chocolate Corperation
	// Robust Industries, LLC
	blurb = "In cooperation with Robust Industries, LLC, the Getmore Chocolate Corperation attempted to produce a \
	genetically modified line of sodas in order to dynamically appeal to customers. The Result? Getmoreans. \
	A sentient line of soda products with human features, these human-can hybrides are famous for speaking \
	corperate double speak, and generally being creepy. Instead of organs, they have a sweet tasting yet fizzy \
	syrup that seems to serve the same functions. Because of this, things like temperature and radation have little \
	effect on the cans, but being made of thin aluminum makes them extra weak to punches."
	num_alternate_languages = 1
	secondary_langs = list(LANGUAGE_SOL_COMMON, LANGUAGE_SIIK_TAU)
	name_language = LANGUAGE_GETMORE

	mob_size = 9
	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = 0
	remains_type = /obj/effect/decal/remains/human

	// Getmorean are cans, and so sprinting is clunky.
	stamina = 90
	stamina_recovery = 5
	sprint_speed_factor = 0.7
	sprint_cost_factor = 0.5

	climb_coeff = 0.2


	has_organ = list(

	)

	// Getmoreans don't need heads. Heads are for species that aren't part can.
	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right)
	)