


//endless reagents!
/obj/item/reagent_containers/glass/replenishing
	var/spawning_id

/obj/item/reagent_containers/glass/replenishing/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	spawning_id = pick(/decl/reagent/blood,/decl/reagent/water/holywater,/decl/reagent/lube,/decl/reagent/soporific,/decl/reagent/alcohol,/decl/reagent/drink/ice,/decl/reagent/glycerol,/decl/reagent/fuel,/decl/reagent/spacecleaner)


/obj/item/reagent_containers/glass/replenishing/process()
	reagents.add_reagent(spawning_id, 0.3)

/obj/item/reagent_containers/glass/replenishing/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

//a talking gas mask!
/obj/item/clothing/mask/gas/poltergeist
	var/list/heard_talk = list()
	var/last_twitch = 0
	var/max_stored_messages = 100

/obj/item/clothing/mask/gas/poltergeist/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	listening_objects += src

/obj/item/clothing/mask/gas/poltergeist/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	listening_objects -= src
	return ..()

/obj/item/clothing/mask/gas/poltergeist/process()
	if(heard_talk.len && istype(src.loc, /mob/living) && prob(10))
		var/mob/living/M = src.loc
		M.say(pick(heard_talk))

/obj/item/clothing/mask/gas/poltergeist/hear_talk(mob/M as mob, text)
	..()
	if(heard_talk.len > max_stored_messages)
		heard_talk.Remove(pick(heard_talk))
	heard_talk.Add(text)
	if(istype(src.loc, /mob/living) && world.time - last_twitch > 50)
		last_twitch = world.time



//a vampiric statuette
//todo: cult integration
/obj/item/vampiric
	name = "statuette"
	icon_state = "statuette"
	icon = 'icons/obj/xenoarchaeology.dmi'
	var/charges = 0
	var/list/nearby_mobs = list()
	var/last_bloodcall = 0
	var/bloodcall_interval = 50
	var/last_eat = 0
	var/eat_interval = 100
	var/wight_check_index = 1
	var/list/shadow_wights = list()

/obj/item/vampiric/New()
	..()
	START_PROCESSING(SSprocessing, src)
	listening_objects += src

/obj/item/vampiric/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	listening_objects -= src
	return ..()

/obj/item/vampiric/process()
	//see if we've identified anyone nearby
	if(world.time - last_bloodcall > bloodcall_interval && nearby_mobs.len)
		var/mob/living/carbon/human/M = pop(nearby_mobs)
		if(M in view(7,src) && M.health > 20)
			if(prob(50))
				bloodcall(M)
				nearby_mobs.Add(M)

	//suck up some blood to gain power
	if(world.time - last_eat > eat_interval)
		var/obj/effect/decal/cleanable/blood/B = locate() in range(2,src)
		if(B)
			last_eat = world.time
			B.loc = null
			if(istype(B, /obj/effect/decal/cleanable/blood/drip))
				charges += 0.25
			else
				charges += 1
				playsound(src.loc, 'sound/effects/splat.ogg', 50, 1, -3)

	//use up stored charges
	if(charges >= 10)
		charges -= 10
		new /obj/effect/spider/eggcluster(pick(seen_turfs_in_range(src, 1)))

	if(charges >= 3)
		if(prob(5))
			charges -= 1
			var/spawn_type = pick(/mob/living/simple_animal/hostile/creature)
			new spawn_type(pick(seen_turfs_in_range(src, 1)))
			playsound(src.loc, pick('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg'), 50, 1, -3)

	if(charges >= 1)
		if(shadow_wights.len < 5 && prob(5))
			shadow_wights.Add(new /obj/effect/shadow_wight(src.loc))
			playsound(src.loc, 'sound/effects/ghost.ogg', 50, 1, -3)
			charges -= 0.1

	if(charges >= 0.1)
		if(prob(5))
			src.visible_message("<span class='warning'>[icon2html(src, viewers(get_turf(src)))] [src]'s eyes glow ruby red for a moment!</span>")
			charges -= 0.1

	//check on our shadow wights
	if(shadow_wights.len)
		wight_check_index++
		if(wight_check_index > shadow_wights.len)
			wight_check_index = 1

		var/obj/effect/shadow_wight/W = shadow_wights[wight_check_index]
		if(isnull(W))
			shadow_wights.Remove(wight_check_index)
		else if(isnull(W.loc))
			shadow_wights.Remove(wight_check_index)
		else if(get_dist(W, src) > 10)
			shadow_wights.Remove(wight_check_index)

/obj/item/vampiric/hear_talk(mob/M as mob, text)
	..()
	if(world.time - last_bloodcall >= bloodcall_interval && (M in view(7, src)))
		bloodcall(M)

/obj/item/vampiric/proc/bloodcall(var/mob/living/carbon/human/M)
	last_bloodcall = world.time
	if(istype(M))
		playsound(src.loc, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)
		nearby_mobs.Add(M)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), BRUTE, target)
		to_chat(M, "<span class='warning'>The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out.</span>")
		var/obj/effect/decal/cleanable/blood/splatter/animated/B = new(M.loc)
		B.target_turf = pick(seen_turfs_in_range(src, 1))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		M.vessel.remove_reagent(/decl/reagent/blood,rand(25,50))

//animated blood 2 SPOOKY
/obj/effect/decal/cleanable/blood/splatter/animated
	var/turf/target_turf
	var/loc_last_process

/obj/effect/decal/cleanable/blood/splatter/animated/New()
	..()
	START_PROCESSING(SSprocessing, src)
	loc_last_process = src.loc

/obj/effect/decal/cleanable/blood/splatter/animated/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/decal/cleanable/blood/splatter/animated/process()
	if(target_turf && src.loc != target_turf)
		step_towards(src,target_turf)
		if(src.loc == loc_last_process)
			target_turf = null
		loc_last_process = src.loc

		//leave some drips behind
		if(prob(50))
			var/obj/effect/decal/cleanable/blood/drip/D = new(src.loc)
			D.blood_DNA = src.blood_DNA.Copy()
			if(prob(50))
				D = new(src.loc)
				D.blood_DNA = src.blood_DNA.Copy()
				if(prob(50))
					D = new(src.loc)
					D.blood_DNA = src.blood_DNA.Copy()
	else
		..()

/obj/effect/shadow_wight
	name = "shadow wight"
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	density = 1

/obj/effect/shadow_wight/New()
	START_PROCESSING(SSprocessing, src)

/obj/effect/shadow_wight/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/shadow_wight/process()
	if(src.loc)
		src.forceMove(pick(seen_turfs_in_range(src, 1) - get_turf(src)))
		var/mob/living/carbon/M = locate() in src.loc
		if(M)
			playsound(src.loc, pick('sound/hallucinations/behind_you1.ogg',\
			'sound/hallucinations/behind_you2.ogg',\
			'sound/hallucinations/i_see_you1.ogg',\
			'sound/hallucinations/i_see_you2.ogg',\
			'sound/hallucinations/im_here1.ogg',\
			'sound/hallucinations/im_here2.ogg',\
			'sound/hallucinations/look_up1.ogg',\
			'sound/hallucinations/look_up2.ogg',\
			'sound/hallucinations/over_here1.ogg',\
			'sound/hallucinations/over_here2.ogg',\
			'sound/hallucinations/over_here3.ogg',\
			'sound/hallucinations/turn_around1.ogg',\
			'sound/hallucinations/turn_around2.ogg',\
			), 50, 1, -3)
			M.sleeping = max(M.sleeping,rand(5,10))
			src.loc = null
	else
		STOP_PROCESSING(SSprocessing, src)

/obj/effect/shadow_wight/Collide(var/atom/obstacle)
	. = ..()
	to_chat(obstacle, "<span class='warning'>You feel a chill run down your spine!</span>")
