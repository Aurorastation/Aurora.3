


//endless reagents!
/obj/item/reagent_containers/glass/replenishing
	var/spawning_id

/obj/item/reagent_containers/glass/replenishing/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)
	spawning_id = pick(/singleton/reagent/blood,/singleton/reagent/water/holywater,/singleton/reagent/lube,/singleton/reagent/soporific,/singleton/reagent/alcohol/ethanol,/singleton/reagent/drink/ice,/singleton/reagent/glycerol,/singleton/reagent/fuel,/singleton/reagent/spacecleaner)


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
	become_hearing_sensitive()

/obj/item/clothing/mask/gas/poltergeist/Destroy()
	STOP_PROCESSING(SSprocessing, src)
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
	///Amount of force required by the weapon to smash the statue.
	var/fragile = 15
	///Sets the type of material for use by the place shard proc.
	var/material/shatter_material = MATERIAL_STEEL

/obj/item/vampiric/New()
	..()
	START_PROCESSING(SSprocessing, src)
	become_hearing_sensitive()
	shatter_material = SSmaterials.get_material_by_name(shatter_material)

/obj/item/vampiric/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/vampiric/process()
	//see if we've identified anyone nearby
	if(world.time - last_bloodcall > bloodcall_interval && nearby_mobs.len)
		var/mob/living/carbon/human/M = pop(nearby_mobs)
		if((M in view(7,src)) && M.health > 20)
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
			src.visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] [src]'s eyes glow ruby red for a moment!"))
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
	if(world.time - last_bloodcall >= bloodcall_interval && (M in get_hearers_in_LOS(7, src)))
		audible_message(SPAN_NOTICE("\The [src] twitches as it listens."))
		bloodcall(M)

/obj/item/vampiric/proc/bloodcall(var/mob/living/carbon/human/M)
	last_bloodcall = world.time
	if(istype(M))
		playsound(src.loc, pick('sound/hallucinations/wail.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/far_noise.ogg'), 50, 1, -3)
		nearby_mobs.Add(M)

		var/target = pick(M.organs_by_name)
		M.apply_damage(rand(5, 10), DAMAGE_BRUTE, target)
		to_chat(M, SPAN_WARNING("The skin on your [parse_zone(target)] feels like it's ripping apart, and a stream of blood flies out."))
		var/obj/effect/decal/cleanable/blood/splatter/animated/B = new(M.loc)
		B.target_turf = pick(seen_turfs_in_range(src, 1))
		B.blood_DNA = list()
		B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		M.vessel.remove_reagent(/singleton/reagent/blood,rand(25,50))

///Is called when the statue is destroyed. Deals sufficiently consequential damage to IPCs and non-IPCS. Dionae are the least affected.
/obj/item/vampiric/proc/bloodcall_final(var/mob/living/carbon/human/hero)
	var/obj/item/vampiric/statue = src
	var/reagent_amount = 50
	var/datum/reagents/chem = new/datum/reagents(reagent_amount)
	chem.my_atom = statue
	chem.add_reagent(/singleton/reagent/blood, reagent_amount)

	var/datum/effect/effect/system/smoke_spread/chem/smoke = new
	smoke.show_log = 0 // This displays a log on creation
	smoke.show_touch_log = 1 // This displays a log when a player is chemically affected
	smoke.set_up(chem, 10, 0, statue, 120)
	smoke.start()
	qdel(chem)

	if(!istype(hero))
		return

	if(!istype(hero.species, /datum/species/machine))
		to_chat(hero, SPAN_HIGHDANGER("What have you done?! You feel an incredible pull as the statue breaks. The force crushes your hands and pulls your blood into an unseen void."))
		hero.apply_damage(40, DAMAGE_BRUTE, BP_L_HAND)
		hero.apply_damage(40, DAMAGE_BRUTE, BP_R_HAND)
		hero.vessel.remove_reagent(/singleton/reagent/blood,rand(120,175))
		return

	var/obj/item/organ/external/bishop = hero.get_organ(BP_GROIN)
	to_chat(hero, SPAN_HIGHDANGER("What have you done?! An unseen force grips you and starts to pull in opposite directions!"))
	hero.apply_damage(75, DAMAGE_BRUTE, BP_CHEST)
	bishop.droplimb(FALSE, DROPLIMB_BLUNT) //Damage to the chest, groin, and droplimb proc should guarantee a decent simulation of the IPC being ripped in half.

	return

///Adds an option to attack the statue with an item in-hand. If you have sufficient force it destroys the statue and calls the bloodcall_final proc.
/obj/item/vampiric/attackby(obj/item/attacking_item, mob/user)
	if(!(attacking_item.item_flags & ITEM_FLAG_NO_BLUDGEON) && (user.a_intent == I_HURT) && fragile && (attacking_item.force > fragile))
		if(do_after(user, 1 SECOND, src))
			if(!QDELETED(src))
				visible_message(SPAN_WARNING("[user] smashes [src] with \a [attacking_item]!"))
				user.do_attack_animation(src)
				audible_message(SPAN_WARNING("\The [src] shatters with a resounding crash!"))
				playsound(get_turf(src), 'sound/effects/projectile_impact/ion_any.ogg', 70, 1)
				playsound(get_turf(src), 'sound/species/revenant/grue_screech.ogg', 200, TRUE)
				playsound(get_turf(src), 'sound/magic/exit_blood.ogg', 70, 1)
				shatter_material.place_shard(get_turf(src))
				bloodcall_final(user)
				qdel(src)
	return ..()

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
	to_chat(obstacle, SPAN_WARNING("You feel a chill run down your spine!"))
