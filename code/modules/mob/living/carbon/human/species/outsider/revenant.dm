/mob/living/carbon/human/revenant/Initialize(mapload)
	. = ..(mapload, SPECIES_REVENANT)
	alpha = 0
	animate(src, 2 SECONDS, alpha = 180)

/datum/species/revenant
	name = SPECIES_REVENANT
	name_plural = "revenants"

	blurb = "Have you ever been alone at night \
	thought you heard footsteps behind, \
	and turned around and no one's there? \
	And as you quicken up your pace \
	you find it hard to look again, \
	because you're sure there's someone there."

	icobase = 'icons/mob/human_races/r_revenant.dmi'
	deform = 'icons/mob/human_races/r_revenant.dmi'
	eyes = "eyes_revenant"
	has_floating_eyes = TRUE

	default_genders = list(NEUTER)

	language = LANGUAGE_REVENANT
	default_language = LANGUAGE_REVENANT

	unarmed_types = list(/datum/unarmed_attack/claws/shredding)
	darksight = 8
	siemens_coefficient = 0
	rarity_value = 10

	break_cuffs = TRUE

	ethanol_resistance = -1
	taste_sensitivity = TASTE_NUMB

	speech_sounds = list('sound/species/revenant/grue_growl.ogg')
	speech_chance = 50

	warning_low_pressure = 50 //immune to pressure, so they can into space/survive breaches without worries
	hazard_low_pressure = -1

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	brute_mod = 1.2
	burn_mod = 0.6
	fall_mod = 0

	breath_type = null
	poison_type = null

	blood_color = "#0084b8"
	flesh_color = "#0071db"

	respawn_type = ANIMAL
	remains_type = /obj/effect/decal/cleanable/ash
	dust_remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."
	death_message_range = 7

	flags = NO_BLOOD | NO_SCAN | NO_POISON | NO_BREATHE
	spawn_flags = IS_RESTRICTED

	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	has_organ = list(
		BP_EYES = /obj/item/organ/internal/eyes/night/revenant
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/revenant),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	stamina = 100
	stamina_recovery = 5
	sprint_speed_factor = 0.8
	sprint_cost_factor = 0.5

	inherent_verbs = list(
		/mob/living/carbon/human/proc/shatter_light,
		/mob/living/carbon/human/proc/dissolve
	)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	max_nutrition_factor = -1
	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

/datum/species/revenant/handle_death(var/mob/living/carbon/human/H)
	if(player_is_antag(H.mind))
		var/datum/ghostspawner/revenant/R = SSghostroles.get_spawner(MODE_REVENANT)
		R.count = max(R.count - 1, 0)
	revenants.kill_count++
	INVOKE_ASYNC(src, PROC_REF(spawn_gore), get_turf(H))
	H.set_death_time(ANIMAL, world.time)
	for(var/obj/item/I in H)
		H.unEquip(I)
	qdel(H)

/datum/species/revenant/proc/spawn_gore(var/turf/T)
	var/portal_type = pick(/obj/effect/portal/spawner/silver, /obj/effect/portal/spawner/gold, /obj/effect/portal/spawner/phoron)
	new portal_type(T)
	var/obj/effect/decal/cleanable/blood/gibs/G = new /obj/effect/decal/cleanable/blood/gibs(T)
	G.basecolor = blood_color
	G.fleshcolor = flesh_color
	G.update_icon()

/datum/species/revenant/handle_post_spawn(var/mob/living/carbon/human/H)
	H.real_name = "Revenant"
	H.name = H.real_name
	..()
	H.gender = NEUTER
	H.universal_understand = TRUE
	H.add_language(LANGUAGE_REVENANT_RIFTSPEAK)
	var/datum/martial_art/revenant/R = new /datum/martial_art/revenant()
	R.teach(H)

/datum/species/revenant/get_random_name()
	return "Revenant"

/datum/species/revenant/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE

/datum/species/revenant/bullet_act(var/obj/item/projectile/P, var/def_zone, var/mob/living/carbon/human/H)
	if((istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam)) && prob(20))
		H.visible_message(SPAN_CULT("The [P.name] gets absorbed by [H]!"), SPAN_CULT("You absorb the [P.name]!"))
		return -1
	return ..()

/obj/item/organ/internal/eyes/night/revenant
	name = "spectral eyes"
	desc = "A pair of glowing eyes. The ocular nerves still slowly writhe."
	icon_state = "revenant_eyes"
	eye_emote = null
	vision_color = null
	default_action_type = /datum/action/item_action/organ/night_eyes/rev

/obj/item/organ/internal/eyes/night/revenant/flash_act()
	return
