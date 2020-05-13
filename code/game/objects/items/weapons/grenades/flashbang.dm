/obj/item/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	var/banglet = 0

/obj/item/grenade/flashbang/prime()
	..()
	for(var/obj/structure/closet/L in hear(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				bang(get_turf(src), M)

	for(var/mob/living/carbon/M in hear(7, get_turf(src)))
		bang(get_turf(src), M)

	for(var/obj/effect/blob/B in hear(8,get_turf(src)))       		//Blob damage here
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	single_spark(src.loc)
	new/obj/effect/effect/smoke/illumination(src.loc, brightness=15)
	qdel(src)
	return

/obj/item/grenade/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)  // Added a new proc called 'bang' that takes a location and a person to be banged.
	if (locate(/obj/item/cloaking_device, M))								// Called during the loop that bangs people in lockers/containers and when banging
		for(var/obj/item/cloaking_device/S in M)								// people in normal view.  Could theroetically be called during other explosions.
			S.active = 0															// -- Polymorph
			S.icon_state = "shield0"

	to_chat(M, "<span class='danger'>BANG</span>")
	playsound(src.loc, 'sound/weapons/flashbang.ogg', 50, 1, 3, 0.5, 1)

//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck(TRUE)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				ear_safety += 2
			if(HULK in H.mutations)
				ear_safety += 1
			if(istype(H.head, /obj/item/clothing/head/helmet))
				ear_safety += 1

//Flashing everyone
	if(eye_safety < FLASH_PROTECTION_MODERATE)
		flick("e_flash", M.flash)
		M.Weaken(10)
			//Vaurca damage 15/01/16
		var/mob/living/carbon/human/H = M
		if(isvaurca(H))
			var/obj/item/organ/internal/eyes/E = H.get_eyes()
			if(!E)
				return

			E.flash_act()

//Now applying sound
	if((get_dist(M, T) <= 2 || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.Weaken(1)
		else
			M.Weaken(3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= 5)
		if(!ear_safety)
			sound_to(M, sound('sound/weapons/flash_ring.ogg',0,1,0,100))
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

//This really should be in mob not every check
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, "<span class='danger'>Your eyes start to burn badly!</span>")
			if(!banglet && !(istype(src , /obj/item/grenade/flashbang/clusterbang)))
				if (E.damage >= E.min_broken_damage)
					to_chat(M, "<span class='danger'>You can't see anything!</span>")
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if(!banglet && !(istype(src , /obj/item/grenade/flashbang/clusterbang)))
			if (prob(M.ear_damage - 10 + 5))
				to_chat(M, "<span class='danger'>You can't hear anything!</span>")
				M.sdisabilities |= DEAF
	else
		if (M.ear_damage >= 5)
			to_chat(M, "<span class='danger'>Your ears start to ring!</span>")
	M.update_icons()

/obj/item/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"

/obj/item/grenade/flashbang/clusterbang/prime()
	var/numspawned = rand(4,8)
	var/again = 0
	var/atom/A = loc
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			again++
			numspawned --

	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/grenade/flashbang/cluster(A)//Launches flashbangs
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	for(,again > 0, again--)
		spawn(0)
			new /obj/item/grenade/flashbang/clusterbang/segment(A)//Creates a 'segment' that launches a few more flashbangs
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	QDEL_IN(src, 1)

/obj/item/grenade/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"

/obj/item/grenade/flashbang/clusterbang/segment/New()//Segments should never exist except part of the clusterbang, since these immediately 'do their thing' and asplode

	icon_state = "clusterbang_segment_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me
	var/dettime = rand(15,60)
	addtimer(CALLBACK(src, .proc/prime), dettime)
	..()

/obj/item/grenade/flashbang/clusterbang/segment/prime()
	var/numspawned = rand(4,8)
	for(var/more = numspawned,more > 0,more--)
		if(prob(35))
			numspawned --
	var/atom/A = src.loc
	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/grenade/flashbang/cluster(A)
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	QDEL_IN(src, 1)

/obj/item/grenade/flashbang/cluster/New()//Same concept as the segments, so that all of the parts don't become reliant on the clusterbang
	set waitfor = FALSE
	icon_state = "flashbang_active"
	active = 1
	banglet = 1
	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)
	var/dettime = rand(15,60)
	addtimer(CALLBACK(src, .proc/prime), dettime)
	..()
