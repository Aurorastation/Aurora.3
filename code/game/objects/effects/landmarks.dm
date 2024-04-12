/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/delete_me = 0
	layer = ABOVE_HUMAN_LAYER

/obj/effect/landmark/New()
	..()
	tag = text("landmark*[]", name)
	do_landmark_effect()
	return 1

/obj/effect/landmark/proc/do_landmark_effect()
	switch(name)			//some of these are probably obsolete
		if("start")
			GLOB.newplayer_start = get_turf(loc)
			delete_me = 1
			return
		if("JoinLate")
			GLOB.latejoin += loc
			delete_me = 1
			return
		if("KickoffLocation")
			GLOB.kickoffsloc += loc
			delete_me = 1
			return
		if("JoinLateGateway")
			GLOB.latejoin_gateway += loc
			delete_me = 1
			return
		if("JoinLateCryo")
			GLOB.latejoin_cryo += loc
			delete_me = 1
			return
		if("JoinLateCryoCommand")
			GLOB.latejoin_cryo_command += loc
			delete_me = 1
		if("JoinLateLift")
			GLOB.latejoin_living_quarters_lift += loc
			delete_me = 1
			return
		if("JoinLateCyborg")
			GLOB.latejoin_cyborg += loc
			delete_me = 1
			return
		if("JoinLateMerchant")
			GLOB.latejoin_merchant += loc
			delete_me = 1
			return
		if("tdome1")
			GLOB.tdome1 += loc
		if("tdome2")
			GLOB.tdome2 += loc
		if("tdomeadmin")
			GLOB.tdomeadmin += loc
		if("tdomeobserve")
			GLOB.tdomeobserve += loc
		if("endgame_exit")
			GLOB.endgame_safespawns += loc
			delete_me = 1
			return
		if("bluespacerift")
			GLOB.endgame_exits += loc
			delete_me = 1
			return
		if("asteroid spawn")
			GLOB.asteroid_spawn += loc
			delete_me = 1
			return
		if("skrell_entry")
			dream_entries += loc
			delete_me = 1
			return
		if("virtual_reality_spawn")
			GLOB.virtual_reality_spawn += loc
			delete_me = 1
			return

	GLOB.landmarks_list += src

/obj/effect/landmark/proc/delete()
	delete_me = 1

/obj/effect/landmark/Initialize()
	. = ..()
	if(delete_me)
		qdel(src)

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	. = ..()
	GC_TEMPORARY_HARDDEL

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x"
	anchored = 1.0
	invisibility = 101

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"

	return 1

/obj/effect/landmark/lobby_mobs_location
	name = "lobby_mobs_location"
	anchored = TRUE
	invisibility = 101

INITIALIZE_IMMEDIATE(/obj/effect/landmark/lobby_mobs_location)

/obj/effect/landmark/lobby_mobs_location/Initialize()
	..()

	if(GLOB.lobby_mobs_location)
		crash_with("There must be one, and only one, /obj/effect/landmark/lobby_mobs_location effect in any single server session!")

	else
		GLOB.lobby_mobs_location = get_turf(src)
		ASSERT(istype(GLOB.lobby_mobs_location, /turf))

	return INITIALIZE_HINT_QDEL


//Costume spawner landmarks
/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears

	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	delete_me = 1

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/New()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/gladiator/New()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/madscientist/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src.loc)
	new /obj/item/clothing/glasses/regular(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/elpresidente/New()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/jackboots(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/maid/New()
	new /obj/item/clothing/under/skirt/(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/butler/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/scratch/New()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/sneakers(src.loc)
	new /obj/item/clothing/under/suit_jacket/white(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/highlander/New()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret/red(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/prig/New()
	new /obj/item/clothing/suit/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/sneakers/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/nightowl/New()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/waiter/New()
	new /obj/item/clothing/under/waiter(src.loc)
	new /obj/item/clothing/head/rabbitears(src.loc)
	new /obj/item/clothing/accessory/apron/random(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/pirate/New()
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana/pirate)
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/commie/New()
	new /obj/item/clothing/head/ushanka/grey(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/holiday_priest/New()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/cutewitch/New()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/fakewizard/New()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/sexymime/New()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	delete_me = 1

/obj/effect/landmark/dungeon_spawn
	name = "asteroid spawn"
	icon = 'icons/1024x1024.dmi'
	icon_state = "yellow"

/obj/effect/landmark/distress_team_equipment
	name = "distress equipment"

/obj/effect/landmark/force_spawnpoint
	name = "force spawnpoint"
	var/job_tag = "Anyone"

/obj/effect/landmark/force_spawnpoint/do_landmark_effect()
	LAZYINITLIST(GLOB.force_spawnpoints)
	LAZYADD(GLOB.force_spawnpoints[job_tag], loc)

var/list/ruin_landmarks = list()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/New(loc, my_ruin_template)
	name = "ruin_[sequential_id(/obj/effect/landmark/ruin)]"
	..(loc)
	ruin_template = my_ruin_template
	ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	ruin_landmarks -= src
	ruin_template = null
	. = ..()

/obj/effect/landmark/entry_point
	name = "entry point landmark"
	icon_state = "dir_arrow"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/landmark/entry_point/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/entry_point/LateInitialize()
	if(SSatlas.current_map.use_overmap)
		SSshuttle.entry_points_to_initialize += src
	name += " [x], [y]"

/obj/effect/landmark/entry_point/proc/get_candidate()
	var/obj/effect/overmap/visitable/sector = GLOB.map_sectors["[z]"]
	if(!sector)
		return
	return attempt_hook_up_recursive(sector)

/obj/effect/landmark/entry_point/proc/attempt_hook_up_recursive(var/obj/effect/overmap/visitable/sector)
	if(attempt_hook_up(sector))
		return sector
	for(var/obj/effect/overmap/visitable/ship/candidate in sector)
		if((. = .(candidate)))
			return

/obj/effect/landmark/entry_point/proc/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	if(!istype(sector))
		return FALSE
	if(sector.check_ownership(src))
		return TRUE
	return FALSE

//The four entry point landmarks below are named assuming that fore is facing DOWNWARDS.
/obj/effect/landmark/entry_point/aft
	name = "aft"

/obj/effect/landmark/entry_point/starboard
	name = "starboard"
	dir = 4

/obj/effect/landmark/entry_point/port
	name = "port"
	dir = 8

/obj/effect/landmark/entry_point/fore
	name = "fore"
	dir = 1

/obj/effect/landmark/entry_point/south
	name = "south"

/obj/effect/landmark/entry_point/east
	name = "east"
	dir = 4

/obj/effect/landmark/entry_point/west
	name = "west"
	dir = 8

/obj/effect/landmark/entry_point/north
	name = "north"
	dir = 1
