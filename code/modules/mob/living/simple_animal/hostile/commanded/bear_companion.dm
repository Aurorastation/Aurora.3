/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."

	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear_dead"
	icon_gib = "brownbear_gib"

	health = 100
	maxHealth = 100

	density = TRUE
	belongs_to_station = FALSE

	attacktext = "swatted"
	melee_damage_lower = 25
	melee_damage_upper = 25
	resist_mod = 5

	min_oxy = 5
	max_co2 = 5
	max_tox = 2 //We tuff bear

	mob_size = 17

	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow", "dance", "boogie", "boogy")

	tameable = FALSE

	hostile_nameable = TRUE

	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	butchering_products = list(/obj/item/clothing/head/bearpelt = 1)
	meat_amount = 5

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/listen()
	if(stance != COMMANDED_MISC) //cant listen if its booty shakin'
		..()

//WE DANCE!
/mob/living/simple_animal/hostile/commanded/bear/misc_command(var/mob/speaker,var/text)
	stay_command()
	stance = COMMANDED_MISC //nothing can stop this ride
	INVOKE_ASYNC(src, PROC_REF(command_dance))

/mob/living/simple_animal/hostile/commanded/bear/proc/command_dance()
	visible_message("\The [src] starts to dance!.")
	for(var/i in 1 to 10)
		if(stance != COMMANDED_MISC || incapacitated()) //something has stopped this ride.
			return
		var/message = pick(
						"moves [get_pronoun("his")] head back and forth!",
						"bobs [get_pronoun("his")] booty!",
						"shakes [get_pronoun("his")] paws in the air!",
						"wiggles [get_pronoun("his")] ears!",
						"taps [get_pronoun("his")] foot!",
						"shrugs [get_pronoun("his")] shoulders!",
						"dances like you've never seen!")
		if(dir != WEST)
			set_dir(WEST)
		else
			set_dir(EAST)
		visible_message("\The [src] [message]")
		sleep(30)
	stance = COMMANDED_STOP
	set_dir(SOUTH)
	visible_message("\The [src] bows, finished with [get_pronoun("his")] dance.")
