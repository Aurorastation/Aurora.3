//Cat
/datum/ai_holder/simple_animal/passive/cat
	use_astar = TRUE

/datum/ai_holder/simple_animal/passive/cat/should_flee(force = FALSE)
	if(istype(target, /mob/living/simple_animal/rat))
		return FALSE
	return ..()

/datum/ai_holder/simple_animal/passive/cat/handle_special_tactic()
	if(!istype(target, /mob/living/simple_animal/rat))
		return
	var/mob/living/simple_animal/rat/rat = target
	if(rat.stat == DEAD)
		remove_target()
		return
	if(holder.Adjacent(rat))
		var/mob/living/simple_animal/cat/cat = holder
		cat.attack_mice()
		remove_target(FALSE)

/datum/ai_holder/simple_animal/passive/cat/handle_special_strategical()
	if(stance == AI_STANCE_IDLE && !target)
		for(var/mob/living/simple_animal/rat/snack in oview(holder, 7))
			if(snack.stat != DEAD && prob(65))
				if(prob(15))
					holder.AIAudibleEmote(pick("hisses and spits!", "mrowls fiercely!", "eyes [snack] hungrily."))
				give_target(snack, TRUE)
				break
	if(prob(2))
		var/mob/abstract/ghost/observer/spook = locate() in range(holder, 5)
		if(spook)
			var/list/visible_objects = list()
			for(var/obj/visible_object in spook.loc)
				if(!visible_object.invisibility && visible_object.name && !istype(visible_object, /obj/effect))
					visible_objects += visible_object
			if(length(visible_objects))
				var/atom/visible_object = pick(visible_objects)
				holder.AIVisualEmote("suddenly stops and stares at something unseen near [visible_object].")

/datum/ai_holder/simple_animal/passive/cat/fluff/handle_special_strategical()
	. = ..()
	var/mob/living/simple_animal/cat/fluff/cat = holder
	if(QDELETED(cat.friend) || target || (stance in AI_STANCES_COMBAT))
		return
	var/follow_trigger_distance = 5
	if(cat.friend.stat >= DEAD || cat.friend.health <= GLOB.config.health_threshold_softcrit)
		follow_trigger_distance = 1
	else if(cat.friend.stat || cat.friend.health <= 50)
		follow_trigger_distance = 2
	follow_distance = max(follow_trigger_distance - 2, 1)
	leader = cat.friend
	var/friend_distance = get_dist(holder, leader)
	if(friend_distance > follow_trigger_distance && can_see_target(leader))
		set_stance(AI_STANCE_FOLLOW)
	if(friend_distance <= 1)
		if(cat.friend.stat >= DEAD || cat.friend.health <= GLOB.config.health_threshold_softcrit)
			if(prob(cat.friend.stat < DEAD ? 50 : 15))
				var/distress_verb = pick("meows", "mews", "mrowls")
				holder.AIAudibleEmote(pick("[distress_verb] in distress.", "[distress_verb] anxiously."))
		else if(prob(5))
			holder.AIVisualEmote(pick("nuzzles [cat.friend].", "brushes against [cat.friend].", "rubs against [cat.friend].", "purrs."))
	else if(cat.friend.health <= 50 && prob(10))
		holder.AIAudibleEmote("[pick("meows", "mews", "mrowls")] anxiously.")

/mob/living/simple_animal/cat
	ai_holder_type = /datum/ai_holder/simple_animal/passive/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	icon_rest = "cat2_rest"
	color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	can_nap = 1
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	holder_type = /obj/item/holder/cat
	mob_size = 3.5
	scan_range = 3//less aggressive about stealing food
	metabolic_factor = 0.75
	max_nutrition = 60
	density = 0
	seek_speed = 5
	pass_flags = PASSTABLE
	//Counter for how intense the radlight is
	var/radlight = 0
	//How many metabolism procs to wait before rapidly dropping the levels down so the cats stop glowing fairly quickly
	var/radlight_fade_delay = 10
	canbrush = TRUE
	possession_candidate = 1
	emote_sounds = list('sound/effects/creatures/cat_meow.ogg', 'sound/effects/creatures/cat_meow2.ogg')
	butchering_products = list(/obj/item/stack/material/animalhide/cat = 2)

/mob/living/simple_animal/cat/Initialize()
	. = ..()
	src.filters += filter(type="drop_shadow", size = 2, offset = 2, color = rgb(0,208,0,0))

/mob/living/simple_animal/cat/proc/attack_mice()
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled_to)
			for(var/mob/living/simple_animal/rat/M in oview(src,1))
				if(M.stat != DEAD)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"),0)
					ai_holder?.give_up_movement()
					stop_automated_movement = 0
					if (prob(75))
						break//usually only kill one rat per proc

/mob/living/simple_animal/cat/Released()
	//A thrown cat will immediately attack mice near where it lands
	addtimer(CALLBACK(src, PROC_REF(attack_mice)), 3)
	..()

/mob/living/simple_animal/cat/proc/handle_radiation_light()
	radlight = clamp(radlight, 0, 98)
	if (radlight > 0)
		radlight_fade_delay = clamp(radlight_fade_delay-1, 0, 10)
		var/cc = radlight/120.0
		if(radlight_fade_delay == 0)
			radlight = clamp(radlight - 11, 0, 100)
		var/cshift = list()
		var/radintensity = round(radlight/33.0)
		switch(radintensity)
			if(0)
				cc = cc+(cc/2.0)
				cshift = list(1,cc,0,0, 0,1,0,0, 0,cc,1,0, 0,0,0,1, 0,0,0,0)
			if(1)
				cc = cc+(cc/2.0)
				cshift = list(1,0,0,0, 0,1,0,0, cc,cc,1,0, 0,0,0,1, 0,0,0,0)
			if(2)
				cshift = list(1,0,0,0, cc,1,0,0, cc,0,1,0, 0,0,0,1, 0,0,0,0)

		if(color != cshift || radlight == 0)
			animate(src, color=cshift,time=8,flags=ANIMATION_PARALLEL)
			switch(radintensity)
				if(0)
					animate(src.filters[1], color=rgb(0,208,0,140), time=10, easing = SINE_EASING,flags=ANIMATION_PARALLEL)
					set_light(1.4, radlight/15, "#2cfa1f",)
				if(1)
					animate(src.filters[1], color=rgb(208,208,0,140), time=10, easing = SINE_EASING,flags=ANIMATION_PARALLEL)
					set_light(1.4, radlight/25, "#ffff00",)
				if(2)
					animate(src.filters[1], color=rgb(208,0,0,140), time=10, easing = SINE_EASING,flags=ANIMATION_PARALLEL)
					set_light(1.4, radlight/30, "#ca0b00",)
			if (radlight == 0)
				animate(src.filters[1], color=rgb(0,255,0,0), time=5,flags=ANIMATION_PARALLEL)
				color = color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

/mob/living/simple_animal/cat/apply_radiation(var/rads)
	radlight += rads*2
	radlight_fade_delay = 10
	total_radiation += rads
	if (total_radiation < 0)
		total_radiation = 0

/mob/living/simple_animal/cat/death()
	.=..()
	set_stat(DEAD)

/mob/living/simple_animal/cat/Life(seconds_per_tick, times_fired)
	. = ..()
	handle_radiation_light()

/mob/living/simple_animal/cat/ex_act(var/severity = 2.0)
	. = ..()
	ai_holder?.react_to_attack(src.loc)

/mob/living/simple_animal/cat/fall_impact(levels_fallen, stopped_early = FALSE, var/damage_mod = 1)
	src.visible_message(SPAN_NOTICE("\The [src] lands softly on \the [loc]!"))
	return FALSE

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	ai_holder_type = /datum/ai_holder/simple_animal/passive/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/fluff/verb/friend()
	set name = "Befriend Cat"
	set category = "IC.Critters"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Meow!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		to_chat(usr, SPAN_NOTICE("[src] ignores you."))
		return

	friend = usr

	set_dir(get_dir(src, friend))
	say("Meow!")

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	named = TRUE
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	icon_rest = "cat_rest"
	can_nap = 1
	befriend_job = "Chief Medical Officer"
	holder_type = /obj/item/holder/cat/black

/mob/living/simple_animal/cat/fluff/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(stat == DEAD)
		. += "Oh no, [name] is dead! What kind of monster would do this?"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww."
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	can_nap = 0 //No resting sprite
	gender = NEUTER
	holder_type = /obj/item/holder/cat/kitten

/mob/living/simple_animal/cat/kitten/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(stat == DEAD)
		. += "It's a dead kitten! What kind of monster would do this?"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "He's a laid back, black cat. Meow."
	named = TRUE
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"
	can_nap = 1
	var/friend_name = "Erstatz Vryroxes"
	holder_type = /obj/item/holder/cat/black

/mob/living/simple_animal/cat/kitten/Initialize()
	. = ..()
	gender = pick(MALE, FEMALE)

/mob/living/simple_animal/cat/penny
	name = "Penny"
	desc = "An important cat, straight from Central Command."
	named = TRUE
	icon_state = "penny"
	item_state = "penny"
	icon_living = "penny"
	icon_dead = "penny_dead"
	icon_rest = "penny_rest"
	holder_type = /obj/item/holder/cat/penny

/mob/living/simple_animal/cat/crusher
	name = "Crusher"
	desc = "A cream coloured, young, and cuddly cat, with a small tag on her collar that says \"Dr. Crusher\". She never lets an opportunity pass to receive some pets or prey on some unsuspecting mice."
	named = TRUE
	gender = FEMALE
	icon_state = "crusher"
	icon_living = "crusher"
	icon_dead = "crusher_dead"
	icon_rest = "crusher_rest"
	can_nap = TRUE
	holder_type = /obj/item/holder/cat/crusher

/mob/living/simple_animal/cat/crusher/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(stat == DEAD)
		. += "Crusher's dead. How could this have happened? She counted on you!"
