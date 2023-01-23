/obj/item/grenade/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)

/obj/item/grenade/flashbang/prime()
	..()
	var/turf/T = get_turf(src)
	for(var/mob/living/L in get_hearers_in_view(7, src))
		bang(T, L)

	// Damage blobs
	for(var/obj/effect/blob/B in get_hear(8,get_turf(src)))
		var/damage = round(30/(get_dist(B,get_turf(src))+1))
		B.health -= damage
		B.update_icon()

	single_spark(T)
	new/obj/effect/effect/smoke/illumination(T, brightness=15)
	qdel(src)

/obj/item/grenade/flashbang/proc/bang(turf/T, mob/living/M)
	to_chat(M, SPAN_DANGER("BANG!"))
	playsound(T, 'sound/weapons/flashbang.ogg', 50, 1, 3, 0.5, 1)

	if(M.flash_act(ignore_inherent = TRUE))
		M.Weaken(10)

	// 1 - 9x/70 gives us an intensity of 100% at zero,
	// 87% at one turf, all the way to 10% at 7 tiles
	var/bang_intensity = 1 - (9 * get_dist(T,M) / 70)
	M.soundbang_act(bang_intensity, 3, 10, 15)

	M.disable_cloaking_device()
	M.update_icon()

/obj/item/grenade/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"

/obj/item/grenade/flashbang/clusterbang/prime()
	var/numspawned = rand(4,8)
	var/again = 0
	var/atom/A = get_turf(src)
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
	var/atom/A = get_turf(src)
	for(,numspawned > 0, numspawned--)
		spawn(0)
			new /obj/item/grenade/flashbang/cluster(A)
			playsound(src.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	QDEL_IN(src, 1)

/obj/item/grenade/flashbang/cluster/New()//Same concept as the segments, so that all of the parts don't become reliant on the clusterbang
	set waitfor = FALSE
	icon_state = "flashbang_active"
	active = 1
	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)
	var/dettime = rand(15,60)
	addtimer(CALLBACK(src, .proc/prime), dettime)
	..()
