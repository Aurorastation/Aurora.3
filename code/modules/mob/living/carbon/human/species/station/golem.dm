var/global/list/golem_types = list("Coal Golem",
								   "Iron Golem",
								   "Bronze Golem",
								   "Steel Golem",
								   "Plasteel Golem",
								   "Titanium Golem",
								   "Cloth Golem",
								   "Cardboard Golem",
								   "Glass Golem",
								   "Phoron Golem",
								   "Metallic Hydrogen Golem",
								   "Wood Golem",
								   "Diamond Golem",
								   "Sand Golem",
								   "Uranium Golem",
								   "Homunculus",
								   "Adamantine Golem")

/datum/species/golem
	name = "Coal Golem"
	name_plural = "coal golems"

	icobase = 'icons/mob/human_races/golem/r_coal.dmi'
	deform = 'icons/mob/human_races/golem/r_coal.dmi'
	eyes = "blank_eyes"

	bodytype = "Golem"

	language = "Ceti Basic"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = NO_BREATHE | NO_PAIN | NO_BLOOD | NO_SCAN | NO_POISON | NO_EMBED
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 1
	rarity_value = 5

	inherent_verbs = list(/mob/living/carbon/human/proc/consume_material)

	mob_size = 12

	ethanol_resistance = -1
	taste_sensitivity = TASTE_NUMB

	meat_type = /obj/item/ore/coal

	brute_mod = 2
	burn_mod = 4
	virus_immune = 1
	grab_mod = 2
	resist_mod = 2

	warning_low_pressure = 50 //golems can into space now
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	breath_type = null
	poison_type = null

	blood_color = "#5C5B5D"
	flesh_color = "#5C5B5D"

	has_organ = list(
		BP_BRAIN = /obj/item/organ/internal/brain/golem
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

	death_message = "becomes completely motionless..."
	death_message_range = 7

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold

	remains_type = /obj/effect/decal/cleanable/ash

	radiation_mod = 0

	max_nutrition_factor = -1

	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

	var/turn_into_materials = TRUE //the golem will turn into materials upon its death
	var/golem_designation = "Coal" //used in the creation of the name

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	H.gender = NEUTER
	..()

/datum/species/golem/get_random_name()
	var/static/list/golem_descriptors = list("Lumbering", "Ponderous", "Slow", "Rumbling", "Sleek", "Solid", "Ephemeral", "Dense", "Shimmering", "Dull", "Glittering", "Shining", "Sluggish", "Quiet", "Ominious", "Lightweight", "Weighty", "Honest", "Watchful", "Short", "Tall", "Mysterious", "Curious", "Dimwitted")
	return "[pick(golem_descriptors)] [golem_designation] Golem"

/datum/species/golem/handle_death(var/mob/living/carbon/human/H)
	if(turn_into_materials)
		set waitfor = 0
		sleep(1)
		new H.species.meat_type(H.loc, rand(3,8))
		qdel(H)

/datum/species/golem/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE

/datum/species/golem/iron
	name = "Iron Golem"
	name_plural = "iron golems"

	siemens_coefficient = 1.2

	fall_mod = 2

	has_fine_manipulation = FALSE

	appearance_flags = HAS_SKIN_COLOR

	meat_type = /obj/item/stack/material/iron

	brute_mod = 0.6
	burn_mod = 0.7
	slowdown = 1

	blood_color = "#5C5454"
	flesh_color = "#5C5454"

	heat_level_1 = T0C+1138
	heat_level_2 = T0C+1338
	heat_level_3 = T0C+1538

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT

	golem_designation = "Iron"

/datum/species/golem/iron/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(92, 84, 84)
	H.update_dna()
	..()

/datum/species/golem/bronze
	name = "Bronze Golem"
	name_plural = "bronze golems"

	icobase = 'icons/mob/human_races/golem/r_bronze.dmi'
	deform = 'icons/mob/human_races/golem/r_bronze.dmi'

	meat_type = /obj/item/stack/material/bronze

	siemens_coefficient = 1.5

	brute_mod = 0.7
	burn_mod = 0.7
	slowdown = 1

	blood_color = "#EDD12F"
	flesh_color = "#EDD12F"

	death_sound = 'sound/magic/anima_fragment_death.ogg'

	heat_level_1 = T0C+550
	heat_level_2 = T0C+750
	heat_level_3 = T0C+950

	golem_designation = "Bronze"

/datum/species/golem/steel
	name = "Steel Golem"
	name_plural = "steel golems"

	siemens_coefficient = 1.3

	has_fine_manipulation = FALSE

	mob_size = 13

	fall_mod = 2

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.5
	burn_mod = 0.6
	slowdown = 1.5

	meat_type = /obj/item/stack/material/steel

	blood_color = "#666666"
	flesh_color = "#666666"

	heat_level_1 = T0C+1100
	heat_level_2 = T0C+1310
	heat_level_3 = T0C+1510

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT

	golem_designation = "Steel"

/datum/species/golem/steel/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(102,102,102)
	H.update_dna()
	..()

/datum/species/golem/plasteel
	name = "Plasteel Golem"
	name_plural = "plasteel golems"

	siemens_coefficient = 1.2

	fall_mod = 2

	has_fine_manipulation = FALSE

	mob_size = 14

	unarmed_types = list(/datum/unarmed_attack/golem)

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.3
	burn_mod = 0.5
	slowdown = 2

	meat_type = /obj/item/stack/material/plasteel

	blood_color = "#777777"
	flesh_color = "#777777"

	heat_level_1 = T0C+1200
	heat_level_2 = T0C+1400
	heat_level_3 = T0C+1600

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT

	golem_designation = "Plasteel"

/datum/species/golem/plasteel/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(80,80,80)
	H.update_dna()
	..()

/datum/species/golem/titanium
	name = "Titanium Golem"
	name_plural = "titanium golems"

	siemens_coefficient = 0.5

	mob_size = 15

	fall_mod = 2

	has_fine_manipulation = FALSE

	unarmed_types = list(/datum/unarmed_attack/golem)

	appearance_flags = HAS_SKIN_COLOR

	slowdown = 3

	brute_mod = 0.2
	burn_mod = 0.3

	meat_type = /obj/item/stack/material/titanium

	blood_color = "#D1E6E3"
	flesh_color = "#D1E6E3"

	heat_level_1 = T0C+1268
	heat_level_2 = T0C+1468
	heat_level_3 = T0C+1668 //bronze melts at around 1668 celsius

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT

	golem_designation = "Titanium"

/datum/species/golem/titanium/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(50,95,88)
	H.update_dna()
	..()

/datum/species/golem/cloth
	name = "Cloth Golem"
	name_plural = "cloth golems"

	icobase = 'icons/mob/human_races/golem/r_cloth.dmi'
	deform = 'icons/mob/human_races/golem/r_cloth.dmi'

	slowdown = -2

	brute_mod = 1.5
	burn_mod = 3

	fall_mod = 0

	meat_type = /obj/item/stack/material/cloth

	blood_color = "#FFFFFF"
	flesh_color = "#FFFFFF"

	heat_level_1 = T0C+232
	heat_level_2 = T0C+250
	heat_level_3 = T0C+300

	golem_designation = "Cloth"

/datum/species/golem/cardboard
	name = "Cardboard Golem"
	name_plural = "cardboard golems"

	icobase = 'icons/mob/human_races/golem/r_cardboard.dmi'
	deform = 'icons/mob/human_races/golem/r_cardboard.dmi'

	slowdown = -1

	brute_mod = 1.5
	burn_mod = 3

	fall_mod = 0

	meat_type = /obj/item/stack/material/cardboard

	blood_color = "#AAAAAA"
	flesh_color = "#AAAAAA"

	heat_level_1 = T0C+232
	heat_level_2 = T0C+250
	heat_level_3 = T0C+300

	golem_designation = "Cardboard"

/datum/species/golem/glass
	name = "Glass Golem"
	name_plural = "glass golems"

	fall_mod = 2

	appearance_flags = HAS_SKIN_COLOR

	siemens_coefficient = 0

	brute_mod = 3
	burn_mod = 0.3

	meat_type = /obj/item/material/shard

	blood_color = "#00E1FF"
	flesh_color = "#00E1FF"

	death_message = "shatters into many shards!"
	death_message_range = 7

	death_sound = "shatter"

	heat_level_1 = T0C+350
	heat_level_2 = T0C+550
	heat_level_3 = T0C+750

	golem_designation = "Glass"

/datum/species/golem/glass/bullet_act(var/obj/item/projectile/P, var/def_zone, var/mob/living/carbon/human/H)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 50 - round(P.damage/3)
		if(prob(reflectchance))
			H.visible_message("<span class='danger'>The [P.name] gets reflected by [H]!</span>", \
							"<span class='danger'>The [P.name] gets reflected by [H]!</span>")

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)

				// redirect the projectile
				P.firer = H
				P.old_style_target(locate(new_x, new_y, P.z))

			return -1 // complete projectile permutation

/datum/species/golem/glass/handle_death(var/mob/living/carbon/human/H)
	set waitfor = 0
	sleep(1)
	for(var/i in 1 to 5)
		var/obj/item/material/shard/T = new meat_type(H.loc)
		var/turf/landing = get_step(H, pick(alldirs))
		addtimer(CALLBACK(T, /atom/movable/.proc/throw_at, landing, 30, 5), 0)
	qdel(H)

/datum/species/golem/glass/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(0,132,150)
	H.alpha = 150
	H.update_dna()
	..()

/datum/species/golem/phoron
	name = "Phoron Golem"
	name_plural = "phoron golems"

	brute_mod = 1
	burn_mod = 2

	unarmed_types = list(/datum/unarmed_attack/flame)

	appearance_flags = HAS_SKIN_COLOR

	meat_type = /obj/item/stack/material/phoron

	blood_color = "#FC2BC5"
	flesh_color = "#FC2BC5"

	death_message = "burst into flames!"
	death_message_range = 7

	heat_level_1 = PHORON_MINIMUM_BURN_TEMPERATURE
	heat_level_2 = T0C+200
	heat_level_3 = PHORON_FLASHPOINT

	golem_designation = "Phoron"

/datum/species/golem/phoron/handle_death(var/mob/living/carbon/human/H)
	set waitfor = 0
	sleep(1)
	var/turf/location = get_turf(H)
	for(var/turf/simulated/floor/target_tile in range(0,location))
		target_tile.assume_gas("phoron", 200, 100+T0C)
		spawn (0) target_tile.hotspot_expose(700, 400)
	qdel(H)

/datum/species/golem/phoron/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(99,6,83)
	H.update_dna()
	..()

/datum/species/golem/silver
	name = "Silver Golem"
	name_plural = "silver golems"

	siemens_coefficient = 2.5

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.8
	burn_mod = 2

	meat_type = /obj/item/stack/material/silver

	blood_color = "#D1E6E3"
	flesh_color = "#D1E6E3"

	heat_level_1 = T0C+561
	heat_level_2 = T0C+761
	heat_level_3 = T0C+961

	golem_designation = "Silver"

/datum/species/golem/silver/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(120,120,120)
	H.update_dna()
	..()

/datum/species/golem/gold
	name = "Gold Golem"
	name_plural = "gold golems"

	siemens_coefficient = 2

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 1
	burn_mod = 2

	meat_type = /obj/item/stack/material/gold

	blood_color = "#EDD12F"
	flesh_color = "#EDD12F"

	heat_level_1 = T0C+664
	heat_level_2 = T0C+864
	heat_level_3 = T0C+1064

	golem_designation = "Gold"

/datum/species/golem/gold/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(176,152,14)
	H.update_dna()
	..()

/datum/species/golem/mhydrogen
	name = "Metallic Hydrogen Golem"
	name_plural = "metallic hydrogen golems"

	siemens_coefficient = 3

	appearance_flags = HAS_SKIN_COLOR

	unarmed_types = list(/datum/unarmed_attack/shocking)

	slowdown = 1.5

	brute_mod = 0.5
	burn_mod = 2

	meat_type = /obj/item/stack/material/mhydrogen

	inherent_verbs = list(/mob/living/carbon/human/proc/consume_material, /mob/living/carbon/human/proc/thunder)

	inherent_spells = list(/spell/aoe_turf/charge)

	blood_color = "#E6C5DE"
	flesh_color = "#E6C5DE"

	golem_designation = "Metallic Hydrogen"

/datum/species/golem/mhydrogen/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(199,127,181)
	H.update_dna()
	..()

/datum/species/golem/wood
	name = "Wood Golem"
	name_plural = "wood golems"

	icobase = 'icons/mob/human_races/golem/r_wood.dmi'
	deform = 'icons/mob/human_races/golem/r_wood.dmi'

	siemens_coefficient = 0.3

	brute_mod = 0.8
	burn_mod = 2

	meat_type = /obj/item/material/shard/wood

	blood_color = "#824B28"
	flesh_color = "#824B28"

	death_sound = 'sound/effects/woodcutting.ogg'

	heat_level_1 = T0C+188
	heat_level_2 = T0C+288
	heat_level_3 = T0C+300

	golem_designation = "Wooden"

/datum/species/golem/diamond
	name = "Diamond Golem"
	name_plural = "diamond golems"

	siemens_coefficient = 0

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.7
	burn_mod = 0.2

	meat_type = /obj/item/stack/material/diamond

	blood_color = "#00FFE1"
	flesh_color = "#00FFE1"

	heat_level_1 = T0C+4326
	heat_level_2 = T0C+4526
	heat_level_3 = T0C+4726

	golem_designation = "Diamond"

/datum/species/golem/diamond/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(0,197,172)
	H.alpha = 150
	H.update_dna()
	..()

/datum/species/golem/diamond/bullet_act(var/obj/item/projectile/P, var/def_zone, var/mob/living/carbon/human/H)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 80 - round(P.damage/3)
		if(prob(reflectchance))
			H.visible_message("<span class='danger'>The [P.name] gets reflected by [H]!</span>", \
							"<span class='danger'>The [P.name] gets reflected by [H]!</span>")

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)

				// redirect the projectile
				P.firer = H
				P.old_style_target(locate(new_x, new_y, P.z))

			return -1 // complete projectile permutation

/datum/species/golem/marble
	name = "Marble Golem"
	name_plural = "marble golems"

	siemens_coefficient = 0.3

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.4
	burn_mod = 0.5
	slowdown = 2

	has_fine_manipulation = FALSE

	meat_type = /obj/item/stack/material/marble

	blood_color = "#AAAAAA"
	flesh_color = "#AAAAAA"

	heat_level_1 = T0C+425
	heat_level_2 = T0C+625
	heat_level_3 = T0C+825

	golem_designation = "Marble"

/datum/species/golem/marble/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(170,170,170)
	H.update_dna()
	..()

/datum/species/golem/sand
	name = "Sand Golem"
	name_plural = "sand golems"

	siemens_coefficient = 0.2

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 1.2
	burn_mod = 1
	slowdown = -2

	meat_type = /obj/item/ore/glass

	blood_color = "#D9C179"
	flesh_color = "#D9C179"

	heat_level_1 = T0C+800
	heat_level_2 = T0C+1000
	heat_level_3 = T0C+1200

	inherent_verbs = list(/mob/living/proc/ventcrawl)

	death_message = "collapses into a pile of sand!"
	death_message_range = 7

	golem_designation = "Sand"

/datum/species/golem/sand/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(201,166,64)
	H.update_dna()
	..()

/datum/species/golem/sand/handle_environment_special(var/mob/living/carbon/human/H)
	var/turf/simulated/location = H.loc

	if(!istype(location))
		return

	var/datum/gas_mixture/environment = location.return_air()

	if(environment.temperature >= heat_level_3) //if the temperature is high enough, the sand golem turns into a glass one
		glassify(H)
		return

	if(H.getFireLoss() >= (H.health - H.maxHealth))	//if the sand golem suffered enough burn damage it turns into a glass one
		glassify(H)
		return

/datum/species/golem/sand/proc/glassify(var/mob/living/carbon/human/H)
	H.visible_message("<span class='warning'>\The [H] vitrifies into a glass construct!</span>")
	H.set_species("Glass Golem")

/datum/species/golem/plastic
	name = "Plastic Golem"
	name_plural = "plastic golems"

	siemens_coefficient = 0.4

	appearance_flags = HAS_SKIN_COLOR

	fall_mod = 0.5

	brute_mod = 1.2
	burn_mod = 1.3
	slowdown = -1

	meat_type = /obj/item/stack/material/plastic

	blood_color = "#CCCCCC"
	flesh_color = "#CCCCCC"

	heat_level_1 = T0C+60
	heat_level_2 = T0C+80
	heat_level_3 = T0C+100

	golem_designation = "Plastic"

/datum/species/golem/plastic/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(171,171,171)
	H.update_dna()
	..()

/datum/species/golem/uranium
	name = "Uranium Golem"
	name_plural = "uranium golems"

	siemens_coefficient = 1.3

	fall_mod = 2

	has_fine_manipulation = FALSE

	appearance_flags = HAS_SKIN_COLOR

	brute_mod = 0.5
	burn_mod = 0.6
	slowdown = 1.5

	meat_type = /obj/item/stack/material/uranium

	blood_color = "#007A00"
	flesh_color = "#007A00"

	heat_level_1 = T0C+732
	heat_level_2 = T0C+932
	heat_level_3 = T0C+1132

	golem_designation = "Uranium"

/datum/species/golem/uranium/handle_post_spawn(var/mob/living/carbon/human/H)
	H.change_skin_color(0,80,0)
	H.update_dna()
	..()

/datum/species/golem/uranium/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(25))
		for(var/mob/living/L in view(7, H))
			L.apply_effect(150, IRRADIATE, blocked = L.getarmor(null, "rad"))

/datum/species/golem/homunculus
	name = "Homunculus"
	name_plural = "homunculus"

	flags = NO_PAIN | NO_SCAN

	unarmed_types = list(
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)

	icobase = 'icons/mob/human_races/golem/r_flesh.dmi'
	deform = 'icons/mob/human_races/golem/r_flesh.dmi'

	inherent_verbs = list(/mob/living/carbon/human/proc/consume_material, /mob/living/carbon/human/proc/breath_of_life)

	bodytype = "Human"

	breath_pressure = 16
	breath_type = "oxygen"
	poison_type = "phoron"
	exhale_type = "carbon_dioxide"

	cold_level_1 = 260
	cold_level_2 = 200
	cold_level_3 = 120

	heat_level_1 = 360
	heat_level_2 = 400
	heat_level_3 = 1000

	hazard_high_pressure = HAZARD_HIGH_PRESSURE
	warning_high_pressure = WARNING_HIGH_PRESSURE
	warning_low_pressure = WARNING_LOW_PRESSURE
	hazard_low_pressure = HAZARD_LOW_PRESSURE

	meat_type = /obj/item/reagent_containers/food/snacks/meat

	blood_color = "#5C4831"
	flesh_color = "#FFC896"

	death_message = "collapses into a pile of flesh!"
	death_message_range = 7

	death_sound = 'sound/magic/disintegrate.ogg'

	golem_designation = "Flesh"

	radiation_mod = 1

	hud_type = /datum/hud_data

	max_nutrition_factor = 1

	max_hydration_factor = 1

/datum/species/golem/homunculus/handle_death(var/mob/living/carbon/human/H)
	if(turn_into_materials)
		set waitfor = 0
		sleep(1)
		H.gib()

/datum/species/golem/homunculus/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(25))
		H.drip(1)

/datum/species/golem/adamantine
	name = "Adamantine Golem"
	name_plural = "adamantine golems"

	icobase = 'icons/mob/human_races/r_golem.dmi'
	deform = 'icons/mob/human_races/r_golem.dmi'

	siemens_coefficient = 0

	has_fine_manipulation = FALSE

	brute_mod = 0.5
	slowdown = 1

	blood_color = "#515573"
	flesh_color = "#137E8F"

	turn_into_materials = FALSE

	heat_level_1 = T0C+1138
	heat_level_2 = T0C+1338
	heat_level_3 = T0C+1538

	golem_designation = "Adamantine"
