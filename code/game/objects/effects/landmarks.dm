/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/add_to_landmark_list = TRUE

/obj/effect/landmark/Initialize()
	. = ..()

	var/do_qdel = do_landmark_action()
	if(do_qdel)
		return INITIALIZE_HINT_QDEL

	if(add_to_landmark_list)
		landmarks_list += src

/obj/effect/landmark/Destroy()
	landmarks_list -= src
	return ..()

/obj/effect/landmark/proc/do_landmark_action()
	tag = text("landmark*[]", name)

	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			return TRUE
		if("start")
			newplayer_start = get_turf(loc)
			return TRUE
		if("JoinLate")
			latejoin += loc
			return TRUE
		if("KickoffLocation")
			kickoffsloc += loc
			return TRUE
		if("JoinLateGateway")
			latejoin_gateway += loc
			return TRUE
		if("JoinLateCryo")
			latejoin_cryo += loc
			return TRUE
		if("JoinLateCryoCommand")
			latejoin_cryo_command += loc
			return TRUE
		if("JoinLateCyborg")
			latejoin_cyborg += loc
			return TRUE
		if("JoinLateMerchant")
			latejoin_merchant += loc
			return TRUE
		if("prisonwarp")
			prisonwarp += loc
			return TRUE
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			return TRUE
		if("xeno_spawn")
			xeno_spawn += loc
			return TRUE
		if("endgame_exit")
			endgame_safespawns += loc
			return TRUE
		if("bluespacerift")
			endgame_exits += loc
			return TRUE
		if("asteroid spawn")
			asteroid_spawn += loc
			return TRUE
		if("skrell_entry")
			dream_entries += loc
			return TRUE

	return FALSE

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x"
	anchored = 1.0
	invisibility = 101

/obj/effect/landmark/start/do_landmark_action()
	tag = "start*[name]"
	return FALSE

//Costume spawner landmarks
/obj/effect/landmark/costume/do_landmark_action() //costume spawner, selects a random subclass and disappears
	var/list/options = typesof(/obj/effect/landmark/costume)
	var/costume_type = pick(options)
	new costume_type(loc)
	return TRUE

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/do_landmark_action()
	new /obj/item/clothing/suit/chickensuit(loc)
	new /obj/item/clothing/head/chicken(loc)
	new /obj/item/reagent_containers/food/snacks/egg(loc)
	return TRUE

/obj/effect/landmark/costume/gladiator/do_landmark_action()
	new /obj/item/clothing/under/gladiator(loc)
	new /obj/item/clothing/head/helmet/gladiator(loc)
	return TRUE

/obj/effect/landmark/costume/madscientist/do_landmark_action()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat(loc)
	new /obj/item/clothing/glasses/regular(loc)
	return TRUE

/obj/effect/landmark/costume/elpresidente/do_landmark_action()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(loc)
	new /obj/item/clothing/shoes/jackboots(loc)
	return TRUE

/obj/effect/landmark/costume/maid/do_landmark_action()
	new /obj/item/clothing/under/skirt(loc)
	var/maid_headwear_type = pick(/obj/item/clothing/head/beret, /obj/item/clothing/head/rabbitears)
	new maid_headwear_type(loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(loc) // hollup
	return TRUE

/obj/effect/landmark/costume/butler/do_landmark_action()
	new /obj/item/clothing/suit/wcoat(loc)
	new /obj/item/clothing/under/suit_jacket(loc)
	new /obj/item/clothing/head/that(loc)
	return TRUE

/obj/effect/landmark/costume/scratch/do_landmark_action()
	new /obj/item/clothing/gloves/white(loc)
	new /obj/item/clothing/shoes/white(loc)
	new /obj/item/clothing/under/suit_jacket/white(loc)
	if(prob(30))
		new /obj/item/clothing/head/cueball(loc)
	return TRUE

/obj/effect/landmark/costume/highlander/do_landmark_action()
	new /obj/item/clothing/under/kilt(loc)
	new /obj/item/clothing/head/beret/red(loc)
	return TRUE

/obj/effect/landmark/costume/prig/do_landmark_action()
	new /obj/item/clothing/suit/wcoat(loc)
	new /obj/item/clothing/glasses/monocle(loc)
	var/hat_path = pick(/obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new hat_path(loc)
	new /obj/item/clothing/shoes/black(loc)
	new /obj/item/cane(loc)
	new /obj/item/clothing/under/sl_suit(loc)
	new /obj/item/clothing/mask/fakemoustache(loc)
	return TRUE

/obj/effect/landmark/costume/plaguedoctor/do_landmark_action()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(loc)
	new /obj/item/clothing/head/plaguedoctorhat(loc)
	return TRUE

/obj/effect/landmark/costume/nightowl/do_landmark_action()
	new /obj/item/clothing/under/owl(loc)
	new /obj/item/clothing/mask/gas/owl_mask(loc)
	return TRUE

/obj/effect/landmark/costume/waiter/do_landmark_action()
	new /obj/item/clothing/under/waiter(loc)
	new /obj/item/clothing/head/rabbitears(loc)
	new /obj/item/clothing/suit/apron(loc)
	return TRUE

/obj/effect/landmark/costume/pirate/do_landmark_action()
	new /obj/item/clothing/suit/pirate(loc)
	var/hat_path = pick(/obj/item/clothing/head/pirate, /obj/item/clothing/head/bandana/pirate)
	new hat_path(loc)
	new /obj/item/clothing/glasses/eyepatch(loc)
	return TRUE

/obj/effect/landmark/costume/commie/do_landmark_action()
	new /obj/item/clothing/head/ushanka/grey(loc)
	return TRUE

/obj/effect/landmark/costume/imperium_monk/do_landmark_action()
	new /obj/item/clothing/suit/imperium_monk(loc)
	if(prob(25))
		new /obj/item/clothing/mask/gas/cyborg(loc)
	return TRUE

/obj/effect/landmark/costume/holiday_priest/do_landmark_action()
	new /obj/item/clothing/suit/holidaypriest(loc)
	return TRUE

/obj/effect/landmark/costume/marisawizard/fake/do_landmark_action()
	new /obj/item/clothing/head/wizard/marisa/fake(loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(loc)
	return TRUE

/obj/effect/landmark/costume/cutewitch/do_landmark_action()
	new /obj/item/clothing/under/sundress(loc)
	new /obj/item/clothing/head/witchwig(loc)
	new /obj/item/staff/broom(loc)
	return TRUE

/obj/effect/landmark/costume/fakewizard/do_landmark_action()
	new /obj/item/clothing/suit/wizrobe/fake(loc)
	new /obj/item/clothing/head/wizard/fake(loc)
	new /obj/item/staff(loc)
	return TRUE

/obj/effect/landmark/costume/sexyclown/do_landmark_action()
	new /obj/item/clothing/mask/gas/sexyclown(loc)
	new /obj/item/clothing/under/sexyclown(loc)
	return TRUE

/obj/effect/landmark/costume/sexymime/do_landmark_action()
	new /obj/item/clothing/mask/gas/sexymime(loc)
	new /obj/item/clothing/under/sexymime(loc)
	return TRUE

/obj/effect/landmark/dungeon_spawn
	name = "asteroid spawn"
	icon = 'icons/1024x1024.dmi'
	icon_state = "yellow"

/obj/effect/landmark/distress_team_equipment
	name = "distress equipment"
