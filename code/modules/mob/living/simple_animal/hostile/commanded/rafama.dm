
/mob/living/simple_animal/hostile/commanded/rafama
	name = "steed of Mata'ke"
	desc = "An animal native to Adhomai, known for its agressive behavior and mighty tusks."
	icon = 'icons/mob/npc/livestock.dmi'
	icon_state = "rafama"
	icon_living = "rafama"
	icon_dead = "rafama_dead"
	turns_per_move = 3
	speak_emote = list("chuffs")
	emote_hear = list("growls")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 12
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai

	maxHealth = 150
	health = 150

	harm_intent_damage = 3
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	butchering_products = list(/obj/item/stack/material/animalhide = 5)
	meat_amount = 8

	known_commands = list("stay", "stop", "attack", "follow", "dance", "boogie", "boogy")

	tameable = FALSE


/mob/living/simple_animal/hostile/commanded/rafama/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(!.)
		src.emote("chuffs in rage!")

/mob/living/simple_animal/hostile/commanded/rafama/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT)
		src.emote("chuffs in rage!")

/mob/living/simple_animal/hostile/commanded/rafama/listen()
	if(stance != COMMANDED_MISC) //cant listen if its booty shakin'
		..()

/mob/living/simple_animal/hostile/commanded/rafama/misc_command(var/mob/speaker,var/text)
	stay_command()
	stance = COMMANDED_MISC //nothing can stop this ride
	INVOKE_ASYNC(src, .proc/command_dance)

/mob/living/simple_animal/hostile/commanded/rafama/proc/command_dance()
	visible_message("\The [src] starts to dance!.")
	var/datum/gender/G = gender_datums[gender]
	for(var/i in 1 to 10)
		if(stance != COMMANDED_MISC || incapacitated()) //something has stopped this ride.
			return
		var/message = pick(
						"moves [G.his] head back and forth!",
						"bobs [G.his] rear!",
						"shakes [G.his] hoofs in the air!",
						"wiggles [G.his] ears!",
						"taps [G.his] foot!",
						"dances like you've never seen!")
		if(dir != WEST)
			set_dir(WEST)
		else
			set_dir(EAST)
		visible_message("\The [src] [message]")
		sleep(30)
	stance = COMMANDED_STOP
	set_dir(SOUTH)
	visible_message("\The [src] bows, finished with [G.his] dance.")
