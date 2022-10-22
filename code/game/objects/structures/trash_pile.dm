/obj/structure/trash_pile
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	anchored = TRUE

	var/list/searched_by // Characters that have searched this trashpile, with values of searched time.
	var/mob/living/hider		// Someone or something hiding inside our pile

	var/chance_alpha	= 79	// Alpha list is junk items and normal random stuff.
	var/chance_beta		= 20	// Beta list is actually maybe some useful illegal items. If it's not alpha or gamma, it's beta.
	var/chance_gamma	= 1		// Gamma list is unique items only, and will only spawn one of each. This is a sub-chance of beta chance.

	//These are types that can only spawn once, and then will be removed from this list.
	//Alpha and beta lists are in their respective procs.
	var/list/unique_gamma = list(
		/obj/item/hand_tele,
		/obj/item/rfd/construction,
		/obj/item/reagent_containers/hypospray/cmo,
		/obj/item/gun/projectile/improvised_handgun/loaded,
		/obj/item/gun/launcher/crossbow,
		/obj/item/gun/launcher/pneumatic
		)

/obj/structure/trash_pile/Initialize()
	. = ..()
	if(icon_state == initial(icon_state))
		icon_state = pick(icon_states(icon) - icon_state)

/obj/structure/trash_pile/MouseDrop_T(obj/structure/trash_pile/target, mob/user)
	if(!Adjacent(user) || use_check_and_message(user))
		return
	user.visible_message("<b>[user]</b> starts climbing into \the [src]...", SPAN_NOTICE("You start climbing into \the [src]..."))
	if(do_after(user, 3 SECONDS))
		user.visible_message("<b>[user]</b> climbs into \the [src], disappearing from sight.", SPAN_NOTICE("You climb into \the [src], finally finding a good spot to hide."))
		user.forceMove(src)
		hider = user
		if(ishuman(user) && prob(5))
			var/mob/living/carbon/human/H = user
			H.take_overall_damage(5, 0, DAM_SHARP, src)
			to_chat(user, SPAN_WARNING("You cut yourself while climbing into \the [src]!"))

/obj/structure/trash_pile/relaymove(mob/user)
	if(user.stat || user.resting) // don't care too much about use_check here, checking these will suffice
		return
	user.forceMove(get_turf(src))
	if(user == hider)
		hider = null

/obj/structure/trash_pile/attack_hand(mob/user)
	//Human mob
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == I_HURT)
			H.visible_message("<b>[user]</b> starts taking \the [src] apart...", SPAN_NOTICE("You start taking \the [src] apart..."))
			if(do_after(user, 2 MINUTES))
				H.visible_message("<b>[user]</b> takes \the [src] apart.", SPAN_NOTICE("You takes \the [src] apart."))
				for(var/i = 1 to 5)
					var/obj/item/I = give_item()
					I.forceMove(get_turf(src))
				eject_hider(100, user)
				qdel(src)
			return
		H.visible_message("<b>[user]</b> starts searching through \the [src]...", SPAN_NOTICE("You start searching through \the [src]..."))
		if(hider)
			to_chat(hider, SPAN_WARNING("[user] is searching the trash pile you're in!"))
		//Do the searching
		if(do_after(user, rand(4 SECONDS, 6 SECONDS)))
			var/unique_string = "[user.ckey]-[user.real_name]"
			//If there was a hider, chance to reveal them
			if(eject_hider(50, user))
				return

			// This person already searched through this pile
			else if(unique_string in searched_by)
				to_chat(H, SPAN_WARNING("You already searched through \the [src], you find nothing of value, though someone else might."))

			//You found an item!
			else
				var/obj/item/I = give_item()
				//We either have an item to hand over or we don't, at this point!
				if(I)
					LAZYADD(searched_by, unique_string)
					H.put_in_hands(I)
					to_chat(H, SPAN_NOTICE("You found \a [I]!"))
	else
		return ..()

/obj/structure/trash_pile/proc/eject_hider(var/chance, var/mob/user)
	if(hider && prob(chance))
		to_chat(hider, SPAN_DANGER("You've been discovered!"))
		hider.forceMove(get_turf(src))
		to_chat(user, SPAN_DANGER("You discover that \the [hider] was hiding inside \the [src]!"))
		hider = null
		return TRUE
	return FALSE

/obj/structure/trash_pile/proc/give_item()
	var/obj/item/I
	var/luck = rand(1, 100)
	if(luck <= chance_alpha)
		I = produce_alpha_item()
	else if(luck <= chance_alpha + chance_beta)
		I = produce_beta_item()
	else if(luck <= chance_alpha + chance_beta + chance_gamma)
		I = produce_gamma_item()
	return I

//Random lists
/obj/structure/trash_pile/proc/produce_alpha_item()
	var/list/possible_path = list(
		/obj/item/clothing/gloves/black = 5,
		/obj/item/clothing/gloves/white = 5,
		/obj/item/storage/backpack = 5,
		/obj/item/storage/backpack/satchel = 5,
		/obj/item/storage/box = 5,
		/obj/item/clothing/head/hardhat = 4,
		/obj/item/clothing/mask/breath = 4,
		/obj/item/clothing/shoes/black = 4,
		/obj/item/clothing/shoes/laceup = 4,
		/obj/item/clothing/shoes/laceup/brown = 4,
		/obj/item/clothing/suit/storage/hazardvest = 4,
		/obj/item/clothing/under/color/grey = 4,
		/obj/item/clothing/suit/caution = 4,
		/obj/item/cell/device = 4,
		/obj/item/reagent_containers/food/snacks/liquidfood = 4,
		/obj/item/spacecash/c1 = 4,
		/obj/item/storage/backpack/satchel/leather = 4,
		/obj/item/storage/briefcase = 4,
		/obj/item/clothing/accessory/storage/webbing = 3,
		/obj/item/clothing/gloves/botanic_leather = 3,
		/obj/item/clothing/head/hardhat/red = 3,
		/obj/item/clothing/mask/gas = 3,
		/obj/item/clothing/suit/apron = 3,
		/obj/item/clothing/suit/storage/toggle/bomber = 3,
		/obj/item/clothing/suit/storage/toggle/brown_jacket = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/short = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless = 3,
		/obj/item/storage/box/fancy/cigarettes = 3,
		/obj/item/storage/box/fancy/cigarettes/acmeco = 3,
		/obj/item/storage/box/fancy/cigarettes/blank = 3,
		/obj/item/device/radio/headset = 3,
		/obj/item/camera_assembly = 3,
		/obj/item/clothing/head/cone = 3,
		/obj/item/cell/high = 3,
		/obj/item/spacecash/c10 = 3,
		/obj/item/spacecash/c20 = 3,
		/obj/item/storage/backpack/duffel = 3,
		/obj/item/storage/box/donkpockets = 3,
		/obj/item/storage/box/mousetraps = 3,
		/obj/item/storage/wallet = 3,
		/obj/item/clothing/gloves/yellow/budget = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/head/welding = 2,
		/obj/item/clothing/mask/gas/alt = 2,
		/obj/item/clothing/mask/gas/half = 2,
		/obj/item/clothing/shoes/galoshes = 2,
		/obj/item/clothing/under/pants/camo = 2,
		/obj/item/clothing/under/syndicate/tacticool = 2,
		/obj/item/device/camera = 2,
		/obj/item/device/flashlight/flare = 2,
		/obj/item/device/flashlight/flare/glowstick/random = 2,
		/obj/item/cell/super = 2,
		/obj/item/contraband/poster = 2,
		/obj/item/reagent_containers/glass/rag = 2,
		/obj/item/storage/box/sinpockets = 2,
		/obj/item/storage/secure/briefcase = 2,
		/obj/item/clothing/glasses/sunglasses = 1,
		/obj/item/clothing/glasses/welding = 1,
		/obj/item/clothing/gloves/yellow = 1,
		/obj/item/clothing/head/bio_hood/general = 1,
		/obj/item/clothing/head/ushanka = 1,
		/obj/item/clothing/shoes/syndigaloshes = 1,
		/obj/item/clothing/suit/bio_suit/general = 1,
		/obj/item/clothing/suit/space/emergency = 1,
		/obj/item/clothing/under/gearharness = 1,
		/obj/item/clothing/under/tactical = 1,
		/obj/item/clothing/suit/armor/material/makeshift/plasteel = 1,
		/obj/item/clothing/mask/gas/voice = 1,
		/obj/item/spacecash/c100 = 1,
		/obj/item/spacecash/c200 = 1,
	)

	var/path = pickweight(possible_path)
	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_beta_item()
	var/list/possible_path = list(
		/obj/item/storage/pill_bottle/mortaphenyl = 6,
		/obj/item/storage/pill_bottle/minaphobin = 4,
		/obj/item/storage/pill_bottle/inaprovaline = 4,
		/obj/item/seeds/ambrosiavulgarisseed = 4,
		/obj/item/gun/energy/mousegun = 4,
		/obj/item/material/knife/butterfly = 3,
		/obj/item/material/knife/butterfly/switchblade = 3,
		/obj/item/clothing/gloves/brassknuckles = 3,
		/obj/item/reagent_containers/syringe/drugs = 3,
		/obj/item/handcuffs = 2,
		/obj/item/handcuffs/legcuffs = 2,
		/obj/item/grenade/chem_grenade/gas = 2,
		/obj/item/clothing/suit/storage/vest/heavy = 1,
		/obj/item/device/radiojammer = 1,
		/obj/item/trap = 1,
		/obj/item/cell/hyper/empty = 1,
		/obj/item/material/knife/tacknife = 1,
		/obj/item/storage/firstaid/brute = 1,
		/obj/item/reagent_containers/pill/dexalin_plus = 1
		)

	var/path = pickweight(possible_path)
	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_gamma_item()
	var/path = pick_n_take(unique_gamma)
	if(path)
		var/obj/item/I = new path()
		return I
	else
		return produce_beta_item()
