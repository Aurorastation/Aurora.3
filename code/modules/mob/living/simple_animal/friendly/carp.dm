/mob/living/simple_animal/carp
	name = "tame space carp"
	desc = "A tame, floating space carp. Careful around the teeth."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "carp"
	item_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	icon_rest = "carp_rest"
	can_nap = TRUE
	speak = list("Glub!", "Glub?", "Glub.")
	speak_emote = list("glubs", "glibs")
	emote_hear = list("glubs","glibs")
	emote_see = list("floats steadily", "inflates its gills", "flaps its flippers", "wiggles", "waggles")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	organ_names = list("head", "chest", "tail", "left flipper", "right flipper")
	response_help = "brushes"
	response_disarm = "attempts to push"
	response_harm = "injures"
	blood_overlay_icon = 'icons/mob/npc/blood_overlay_carp.dmi'
	gender = NEUTER
	faction = "carp"
	flying = TRUE

	can_be_milked = TRUE
	udder_size = 3
	milk_type = /singleton/reagent/toxin/carpotoxin
	milk_regeneration = list(1, 2)

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	mob_size = 4
	max_nutrition = 40
	metabolic_factor = 0.2
	bite_factor = 0.6 //Carp got big bites

	stomach_size_mult = 3 //They're just baby

	density = TRUE
	pass_flags = PASSTABLE | PASSRAILING
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag

	possession_candidate = TRUE
	sample_data = list("Cellular structure shows adaptation for a vacuum", "Genetic biomarkers identified linked with passiveness")

/mob/living/simple_animal/carp/update_icon()
	..()
	if(resting || stat == DEAD)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/carp/fall_impact()
	src.visible_message(SPAN_NOTICE("\The [src] gently floats to a stop."))
	return FALSE

//Basic friend AI
/mob/living/simple_animal/carp/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/carp/fluff/think()
	..()
	if(!stat && !buckled_to && (turns_since_move > 5))
		GLOB.move_manager.stop_looping(src)
		turns_since_move = 0
		handle_movement_target()
	if(!movement_target && (turns_since_move > 5))
		GLOB.move_manager.stop_looping(src)

/mob/living/simple_animal/carp/fluff/proc/handle_movement_target()
	if(!QDELETED(friend))
		var/follow_dist = 5
		if(friend.stat >= DEAD || friend.health <= GLOB.config.health_threshold_softcrit) //danger
			follow_dist = 1
		else if(friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if(movement_target != friend)
			if(current_dist > follow_dist && (friend in oview(src)))
				//stop existing movement
				GLOB.move_manager.stop_looping(src)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				GLOB.move_manager.move_to(src, movement_target, near_dist, seek_move_delay)

		//already following and close enough, stop
		else if(current_dist <= near_dist)
			GLOB.move_manager.stop_looping(src)
			movement_target = null
			stop_automated_movement = 0
			if(prob(10))
				say("Glub!")

/mob/living/simple_animal/carp/fluff/verb/friend(var/mob/user)
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Glubglub!")
		return

	if(!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		to_chat(user, SPAN_NOTICE("[src] ignores you."))
		return

	friend = user

	set_dir(get_dir(src, friend))
	say("Glubglub!")

// ENGINEERING HAS AN ACTUAL PET, WHAAAAAAAAAAAAAT? - geeves
/mob/living/simple_animal/carp/fluff/ginny
	name = "Ginny"
	desc = "Rough scales adorn the body of this baby space carp. She looks ready to fire up an emitter!"
	icon_state = "babycarp"
	item_state = "babycarp"
	icon_living = "babycarp"
	icon_dead = "babycarp_dead"
	icon_rest = "babycarp_rest"
	icon_gib = null

	gender = FEMALE

	emote_see = list("floats steadily", "inflates her gills", "flaps her flippers", "wiggles", "waggles")

	can_nap = TRUE
	mob_size = 3.5

	// Actually cannot be milked, but this way we get the error message.
	can_be_milked = TRUE
	udder_size = 2
	milk_type = /singleton/reagent/toxin/carpotoxin
	milk_regeneration = list(1, 1)

	befriend_job = "Chief Engineer"
	holder_type = /obj/item/holder/carp/baby

/mob/living/simple_animal/carp/fluff/ginny/death()
	.=..()
	desc = "WHO KILLED GINNY?!"

/mob/living/simple_animal/carp/fluff/ginny/handle_milking(mob/user, obj/item/reagent_containers/container)
	//user.visible_message("[SPAN_BOLD("Ginny")] shies away from the [container] and stares at [SPAN_BOLD("[user]")] judgementally.")
	user.visible_message("[pick("[SPAN_BOLD("Ginny")] shies away from the [container] and stares at [SPAN_BOLD("[user]")] judgementally.", "[SPAN_BOLD("Ginny")] recoils from [SPAN_BOLD("[user]")] with an indignant glub.", "[SPAN_BOLD("Ginny")] bares her tiny fangs and evades the [container].", "[SPAN_BOLD("Ginny")] stretches a flipper out and pushes the [container] away.")]")

/mob/living/simple_animal/carp/baby
	name = "baby space carp"
	desc = "Awfully cute! Looks friendly!"
	icon_state = "babycarp"
	item_state = "babycarp"
	icon_living = "babycarp"
	icon_dead = "babycarp_dead"
	icon_gib = null
	can_nap = TRUE
	gender = NEUTER
	mob_size = 3.5
	holder_type = /obj/item/holder/carp/baby

/mob/living/simple_animal/carp/baby/death()
	.=..()
	desc = "A dead baby space carp, what a tragedy!"
