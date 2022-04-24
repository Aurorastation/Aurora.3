/mob/living/simple_animal/hostile/commanded/baby_harvester
	name = "Ives"
	desc = "A mysterious docile hivebot, this type seems to be of a kind rarely seen in the Orion Spur. Look at its little tail!"
	named = TRUE
	gender = FEMALE

	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "ives"
	icon_living = "ives"
	icon_dead = "ives_dead"

	blood_overlay_icon = null

	health = 70
	maxHealth = 70

	belongs_to_station = TRUE
	stop_automated_movement_when_pulled = TRUE
	density = TRUE

	speak_chance = 1
	turns_per_move = 7
	see_in_dark = 6

	speak = list("Rawr!", "Gawrgle!", "Bizzbop!", "Bweeewoooo!")
	speak_emote = list("roars pitifully", "squeals out a mechanical attempt at a growl")
	emote_hear = list("roars pitifully", "squeals out a mechanical attempt at a growl")
	sad_emote = list("bwoops sadly")

	ranged = TRUE
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/beam/hivebot/harmless

	attacktext = "harmlessly clawed"
	harm_intent_damage = 5 // the damage we take
	melee_damage_lower = 0
	melee_damage_upper = 0
	resist_mod = 2

	mob_size = 5

	organ_names = list("core", "head", "tail")
	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	hunger_enabled = FALSE

	destroy_surroundings = FALSE
	attack_emote = "blares a tiny siren"

	psi_pingable = FALSE

/mob/living/simple_animal/hostile/commanded/baby_harvester/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/simple_animal/hostile/commanded/baby_harvester/death()
	..(null, "blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/commanded/baby_harvester/verb/befriend()
	set name = "Befriend Ives"
	set category = "IC"
	set src in view(1)

	if(!master)
		var/mob/living/carbon/human/H = usr
		if(istype(H))
			master = usr
			audible_emote("bwuups happily!")
			return TRUE
	else if(usr == master)
		return TRUE
	else
		to_chat(usr, SPAN_WARNING("[src] ignores you."))