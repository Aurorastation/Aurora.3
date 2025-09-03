//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/flame
	var/lit = FALSE

/obj/item/flame/isFlameSource()
	return lit

///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "safety match"
	desc = "A simple safety match. Used for lighting fine smokables, among other things."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "match_unlit"
	item_state = "match_unlit"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	var/smoketime = 10
	var/type_burnt = /obj/item/trash/match
	w_class = WEIGHT_CLASS_TINY
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/match
	name = "burnt match"
	desc = "A match. This one has seen better days."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "match_burnt"
	item_state = "match_burnt"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	randpixel = 10
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("flicked")
	drop_sound = 'sound/items/cigs_lighters/cig_snuff.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/match/Initialize()
	. = ..()
	randpixel_xy()
	transform = turn(transform,rand(0,360))

/obj/item/trash/match/attack_self(mob/user)
	var/turf/location = get_turf(src)
	new /obj/effect/decal/cleanable/ash(location)
	user.visible_message("<b>[user]</b> crushes \the [src] into a fine ash.", range = 3)
	qdel(src)

/obj/item/flame/match/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1 || istype(loc, /obj/item/storage)) // Shouldn't be lit in a bag.
		die()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/flame/match/attack_self(mob/user as mob)
	if(lit)
		user.visible_message("<b>[user]</b> waves out \the [src], extinguishing it.", range = 3)
		die(TRUE)
	return ..()

/obj/item/flame/match/attackby(obj/item/attacking_item, mob/user)
	..()
	if(attacking_item.isFlameSource() && !src.lit)
		playsound(src, 'sound/items/cigs_lighters/cig_light.ogg', 75, 1, -1)
		user.visible_message("In a feat of redundancy, <b>[user]</b> lights \the [src] using \the [attacking_item].", range = 3)
		light()

/obj/item/flame/match/dropped(mob/user)
	if(lit)
		spawn(0)
			var/turf/location = src.loc	// Light up the turf we land on.
			if(istype(location))
				location.hotspot_expose(700, 5)
			die(TRUE) // Put ourselves out.
	return ..()

/obj/item/flame/match/proc/light()
	lit = TRUE
	damtype = "fire"
	icon_state = "match_lit"
	item_state = "match_lit"
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_l_hand(0)
		M.update_inv_r_hand(1)
	set_light(2, 0.25, "#E38F46")
	START_PROCESSING(SSprocessing, src)

/obj/item/flame/match/proc/die(var/nomessage = FALSE)
	var/turf/T = get_turf(src)
	playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
	if(type_burnt)
		var/obj/item/burnt = new type_burnt(T)
		transfer_fingerprints_to(burnt)
		if(ismob(loc))
			var/mob/living/M = loc
			if(!nomessage)
				to_chat(M, span("notice", "Your [name] goes out."))
			if(M.wear_mask)
				M.remove_from_mob(src) //un-equip it so the overlays can update
				M.update_inv_wear_mask(0)
				M.equip_to_slot_if_possible(burnt, slot_wear_mask)
			else
				M.remove_from_mob(src) // if it dies in your hand.
				M.update_inv_l_hand(0)
				M.update_inv_r_hand(1)
				M.put_in_hands(burnt)
		set_light(0)
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)

//////////////////
//FINE SMOKABLES//
//////////////////
ABSTRACT_TYPE(/obj/item/clothing/mask/smokable)
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	icon = 'icons/obj/smokables.dmi'
	item_icons = null
	sprite_sheets = null
	contained_sprite = TRUE
	icon_auto_adapt = TRUE
	icon_supported_species_tags = list("una", "taj")
	body_parts_covered = 0
	var/lit = 0
	var/icon_on
	var/icon_off
	var/type_butt = null
	/// Size of a syringe
	var/chem_volume = 15
	var/genericmes = "USER lights NAME with FLAME"
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/initial_volume = 0
	var/burn_rate = 0
	/// Spam limiter for audio/message when taking a drag of cigarette.
	var/last_drag = 0
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/clothing/mask/smokable/Initialize()
	. = ..()
	// So it doesn't react until you light it
	atom_flags |= ATOM_FLAG_NO_REACT
	// Making the cigarette a chemical holder with a maximum volume of 15
	create_reagents(chem_volume)

/obj/item/clothing/mask/smokable/process()
	if(reagents && reagents.total_volume && burn_rate && !istype(loc, /obj/item/storage))
		if(!initial_volume)
			initial_volume = reagents.total_volume
		var/mob/living/carbon/human/C = loc
		if(istype(C) && src == C.wear_mask)
			reagents.trans_to_mob(C, burn_rate*initial_volume, CHEM_BREATHE, 0.75)
			if(C.check_has_mouth() && prob(5))
				reagents.trans_to_mob(C, burn_rate*initial_volume, CHEM_INGEST, 0.75)
		else
			reagents.remove_any(burn_rate*initial_volume)
	else
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		die()
		return

	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = TRUE
		playsound(src, 'sound/items/cigs_lighters/cig_light.ogg', 75, 1, -1)
		src.reagents.set_temperature(T0C + 45)
		damtype = "fire"
		if(REAGENT_VOLUME(reagents, /singleton/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(REAGENT_VOLUME(reagents, /singleton/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(REAGENT_VOLUME(reagents, /singleton/reagent/fuel)) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(REAGENT_VOLUME(reagents, /singleton/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		atom_flags &= ~ATOM_FLAG_NO_REACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		set_light(2, 0.25, "#E38F46")
		START_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/smokable/proc/die(var/no_message = FALSE, var/intentionally = FALSE)
	var/turf/T = get_turf(src)
	set_light(0)
	playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
	if(type_butt)
		var/obj/item/butt = new type_butt(src.loc)
		transfer_fingerprints_to(butt)
		if(ismob(loc))
			var/mob/living/M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out."))
			if(intentionally)
				butt.loc = T
			else if(M.wear_mask == src)
				M.remove_from_mob(src) //un-equip it so the overlays can update
				M.update_inv_wear_mask(0)
				if(!(M.equip_to_slot_if_possible(butt, slot_wear_mask, bypass_blocked_check = TRUE)))
					M.put_in_hands(butt) // In case the above somehow fails, ensure it is placed somewhere
			else
				M.remove_from_mob(src) // if it dies in your hand.
				M.update_inv_l_hand(0)
				M.update_inv_r_hand(1)
				M.put_in_hands(butt)

		STOP_PROCESSING(SSprocessing, src)
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
				playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		lit = FALSE
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/smokable/attackby(obj/item/attacking_item, mob/user)
	..()
	if(attacking_item.isFlameSource())
		var/text = matchmes
		if(istype(attacking_item, /obj/item/flame/match))
			text = matchmes
		else if(istype(attacking_item, /obj/item/flame/lighter/zippo))
			text = zippomes
		else if(istype(attacking_item, /obj/item/flame/lighter))
			text = lightermes
		else if(attacking_item.iswelder())
			text = weldermes
		else if(istype(attacking_item, /obj/item/device/assembly/igniter))
			text = ignitermes
		else
			text = genericmes
		text = replacetext(text, "USER", "\the [user]")
		text = replacetext(text, "NAME", "\the [name]")
		text = replacetext(text, "FLAME", "\the [attacking_item.name]")
		light(text)

/obj/item/clothing/mask/smokable/isFlameSource()
	return lit

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	item_state = "cigoff"
	throw_speed = 0.5
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"
	icon_off = "cigoff"
	has_blood_overlay = FALSE
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 30
	burn_rate = 0.003 //Lasts ~353 seconds)
	surgerysound = 'sound/items/surgery/cautery.ogg'
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to light their NAME with FLAME.")
	zippomes = SPAN_NOTICE("With a flick of their wrist, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER casually lights the NAME with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME.")
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco = 10,
		/singleton/reagent/mental/nicotine = 5
	)

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = attacking_item
		if(S.active)
			light(SPAN_WARNING("[user] swings their [attacking_item], barely missing themselves. They light their [name] in the process."))
		return TRUE

/obj/item/clothing/mask/smokable/cigarette/catch_fire()
	if(!lit)
		light(SPAN_WARNING("\The [src] is lit by the flames!"))

/obj/item/clothing/mask/smokable/cigarette/extinguish_fire()
	if(lit)
		die(TRUE)

/obj/item/clothing/mask/smokable/cigarette/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/human/H = target_mob

	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
			return 1
		if(last_drag <= world.time - 30) //Spam limiter. Only for messages/sound.
			last_drag = world.time
			H.visible_message(SPAN_NOTICE("[H.name] takes a drag of their [name]."))
			playsound(H, 'sound/items/cigs_lighters/inhale.ogg', 50, 0, -1)
			reagents.trans_to_mob(H, (rand(5,10)/10), CHEM_BREATHE) //Smokes it faster. Slightly random amount.
			return 1
	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity || lit)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transferred = glass.reagents.trans_to_obj(src, chem_volume)
		if(transferred)	//if reagents were transferred, show the message
			to_chat(user, SPAN_WARNING("You dip \the [src] into \the [glass]."))
			playsound(src.loc, 'sound/effects/footstep/water1.ogg', 50, 1)
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if(lit)
		user.visible_message(SPAN_NOTICE("<b>[user]</b> calmly drops and treads on the lit [src], putting it out instantly."), SPAN_NOTICE("You calmly drop and tread on the lit [src], putting it out instantly."))
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		die(TRUE, TRUE)
	else // Cigarette packing. For compulsive smokers.
		user.visible_message(SPAN_NOTICE("<b>[user]</b> taps \the [src] against their palm."), SPAN_NOTICE("You tap \the [src] against your palm."))
	return ..()


/obj/item/clothing/mask/smokable/cigarette/acmeco
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco = 5,
		/singleton/reagent/mental/nicotine = 5,
		/singleton/reagent/lexorin = 2,
		/singleton/reagent/drugs/serotrotium = 3
	)

/obj/item/clothing/mask/smokable/cigarette/blank
	chem_volume = 15
	reagents_to_add = null

/obj/item/clothing/mask/smokable/cigarette/dromedaryco
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco = 5,
		/singleton/reagent/mental/nicotine = 10
	)

/obj/item/clothing/mask/smokable/cigarette/nicotine
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/rich = 5,
		/singleton/reagent/mental/nicotine = 10
	)

/obj/item/clothing/mask/smokable/cigarette/rugged
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/fake = 10,
		/singleton/reagent/mental/nicotine = 5
	)

/obj/item/clothing/mask/smokable/cigarette/adhomai
	name = "adhomian cigarette"
	desc = "An adhomian cigarette made from processed S'rendarr's Hand."
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/srendarrs_hand = 10,
		/singleton/reagent/mental/nicotine = 5
	)

/obj/item/clothing/mask/smokable/cigarette/adhomai/menthol
	name = "adhomian menthol cigarette"
	desc = "An adhomian cigarette made from processed S'rendarr's Hand, with menthol added."
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/srendarrs_hand = 5,
		/singleton/reagent/mental/nicotine = 5,
		/singleton/reagent/menthol = 5
	)

/obj/item/clothing/mask/smokable/cigarette/sweet
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/sweet = 10,
		/singleton/reagent/mental/nicotine = 5
	)

/obj/item/clothing/mask/smokable/cigarette/dyn
	name = "dyn cigarette"
	desc = "A mentholated cigarette from Nralakk made with processed dyn."
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/sweet = 5,
		/singleton/reagent/mental/nicotine = 5,
		/singleton/reagent/drink/dynjuice = 5
	)

/obj/item/clothing/mask/smokable/cigarette/wulu
	name = "wulumunusha cigarette"
	desc = "A wulumunusha cigarette commonly smoked by Skrell for religious purposes."
	reagents_to_add = list(/singleton/reagent/wulumunusha = 15)

/obj/item/clothing/mask/smokable/cigarette/oracle
	name = "oracle cigarette"
	desc = "A roll of oracle and caromeg."
	reagents_to_add = list(
		/singleton/reagent/toxin/oracle = 10,
		/singleton/reagent/mental/caromeg = 5
	)

/obj/item/clothing/mask/smokable/cigarette/koko
	name = "unathi cigarette"
	desc = "An Unathi cigarette made with koko reed."
	reagents_to_add = list(/singleton/reagent/mental/kokoreed = 15)

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigaroff"
	icon_on = "cigaron"
	icon_off = "cigaroff"
	item_state = "cigaroff"
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = 0.5
	chem_volume = 60
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to offend their NAME by lighting it with FLAME.")
	zippomes = SPAN_NOTICE("With a flick of their wrist, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER insults NAME by lighting it with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME with the power of science.")
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/rich = 25,
		/singleton/reagent/mental/nicotine = 5
	)

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	item_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt/alt
	chem_volume = 60
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/rich = 15,
		/singleton/reagent/mental/nicotine = 5,
		/singleton/reagent/tricordrazine = 10
	)

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	item_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt/alt
	chem_volume = 120
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/rich = 30,
		/singleton/reagent/mental/nicotine = 10,
		/singleton/reagent/tricordrazine = 20
	)

/obj/item/clothing/mask/smokable/cigarette/cigar/prank
	reagents_to_add = list(
		/singleton/reagent/toxin/tobacco/rich = 20,
		/singleton/reagent/mental/nicotine = 5,
		/singleton/reagent/fuel = 5
	)

/obj/item/clothing/mask/smokable/cigarette/cigar/oracle
	name = "\improper Vedamor cigar"
	desc = "A premium oracle cigar, originating from Vedamor."
	icon_state = "vedamor_cigaroff"
	icon_on = "vedamor_cigaron"
	icon_off = "vedamor_cigaroff"
	item_state = "vedamor_cigaroff"
	reagents_to_add = list(
		/singleton/reagent/toxin/oracle/rich = 25,
		/singleton/reagent/mental/caromeg = 5
	)

/obj/item/trash/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/smokables.dmi'
	icon_state = "cigbutt"
	randpixel = 10
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	throwforce = 1
	drop_sound = 'sound/items/cigs_lighters/cig_snuff.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/trash/cigbutt/Initialize()
	. = ..()
	randpixel_xy()
	transform = turn(transform,rand(0,360))

/obj/item/trash/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/trash/cigbutt/cigarbutt/alt
	icon_state = "cigar2butt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/attacking_item, mob/user)
	..()
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/cigarette/cigar/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat, with a smoky scent."
	icon_state = "sausageoff"
	item_state = "sausageoff"
	icon_on = "sausageon"
	icon_off = "sausageoff"
	type_butt = /obj/item/trash/cigbutt/sausagebutt
	chem_volume = 6
	reagents_to_add = list(/singleton/reagent/nutriment/protein = 6)

/obj/item/trash/cigbutt/sausagebutt
	name = "sausage butt"
	desc = "A piece of burnt meat."
	icon_state = "sausagebutt"

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meerschaum or something."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"
	icon_off = "pipeoff"
	w_class = WEIGHT_CLASS_TINY
	chem_volume = 30
	burn_rate = 0.003
	matchmes = SPAN_NOTICE("USER lights their NAME with their FLAME.")
	lightermes = SPAN_NOTICE("USER manages to light their NAME with FLAME.")
	zippomes = SPAN_NOTICE("With much care, USER lights their NAME with their FLAME.")
	weldermes = SPAN_NOTICE("USER recklessly lights NAME with FLAME.")
	ignitermes = SPAN_NOTICE("USER fiddles with FLAME, and manages to light their NAME with the power of science.")
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/clothing/mask/smokable/pipe/Initialize()
	. = ..()
	name = "empty [initial(name)]"
	burn_rate = 0

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit && burn_rate)
		src.lit = TRUE
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		START_PROCESSING(SSprocessing, src)
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user as mob)
	if(lit == TRUE)
		user.visible_message(SPAN_NOTICE("[user] puts out [src]."), SPAN_NOTICE("You put out [src]."))
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSprocessing, src)
	else if (burn_rate)
		var/turf/location = get_turf(user)
		user.visible_message(SPAN_NOTICE("[user] empties out [src]."), SPAN_NOTICE("You empty out [src]."))
		new /obj/effect/decal/cleanable/ash(location)
		burn_rate = 0
		reagents.clear_reagents()
		name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/melee/energy/sword))
		return

	..()

	if (istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = attacking_item
		if (!G.dry)
			to_chat(user, SPAN_NOTICE("[G] must be dried before you stuff it into [src]."))
			return
		if (burn_rate)
			to_chat(user, SPAN_NOTICE("[src] is already packed."))
			return
		if(G.reagents)
			initial_volume = G.reagents.total_volume
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "[G.name]-packed [initial(name)]"
		burn_rate = initial(burn_rate)
		qdel(G)

	else if(istype(attacking_item, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = attacking_item
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [attacking_item]."))

	else if(istype(attacking_item, /obj/item/flame/match))
		var/obj/item/flame/match/M = attacking_item
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [attacking_item]."))

	else if(istype(attacking_item, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [attacking_item], and manages to light their [name] with the power of science."))

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"
	icon_off = "cobpipeoff"
	chem_volume = 30

/obj/item/clothing/mask/smokable/pipe/bonepipe
	name = "Europan bone pipe"
	desc = "A smoking pipe made out of the bones of the Europan bone whale."
	desc_extended = "While most commonly associated with bone charms, bones from various sea creatures on Europa are used in a variety of goods, such as this smoking pipe. While smoking in submarines is often an uncommon occurrence, due to a lack of available air or space, these pipes are a common sight in the many stations of Europa. Higher-quality pipes typically have scenes etched into their bones, and can tell the story of their owner's time on Europa."
	icon_state = "bonepipeoff"
	item_state = "bonepipeoff"
	icon_on = "bonepipeon"
	icon_off = "bonepipeoff"
	chem_volume = 30

/////////
//ZIPPO//
/////////
/obj/item/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	w_class = WEIGHT_CLASS_TINY
	throwforce = 4
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state
	var/activation_sound = list(
	'sound/items/cigs_lighters/cheap_on1.ogg',
	'sound/items/cigs_lighters/cheap_on2.ogg',
	'sound/items/cigs_lighters/cheap_on3.ogg',
	)
	var/deactivation_sound = 'sound/items/cigs_lighters/cheap_off.ogg'
	drop_sound = 'sound/items/drop/card.ogg'
	pickup_sound = 'sound/items/pickup/card.ogg'
	surgerysound = 'sound/items/surgery/cautery.ogg'
	/// Spam limiter.
	var/last_open = 0
	var/last_close = 0
	var/flame_light_range = 1
	var/flame_light_power = 2
	var/flame_light_color = LIGHT_COLOR_LAVA

/obj/item/flame/lighter/colourable
	icon_state = "lighter-col"
	item_state = "lighter-col"
	base_state = "lighter-col"
	build_from_parts = TRUE
	worn_overlay = "top"

/obj/item/flame/lighter/colourable/Initialize()
	. = ..()
	update_icon()

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo. If you've spent that amount of money on a lighter, you're either a badass or a chain smoker."
	icon_state = "zippo"
	item_state = "zippo"
	activation_sound = 'sound/items/cigs_lighters/zippo_on.ogg'
	deactivation_sound = 'sound/items/cigs_lighters/zippo_off.ogg'
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

/obj/item/flame/lighter/zippo/augment
	name = "retractable lighter"
	desc = "An augmented lighter, implanted directly into the hand, popping through the finger."
	icon_state = "lighter-aug"
	item_state = "lighter-aug"

/obj/item/flame/lighter/zippo/augment/throw_at(atom/target, range, speed, mob/thrower)
	thrower.drop_from_inventory(src)

/obj/item/flame/lighter/zippo/augment/dropped()
	. = ..()
	loc = null
	qdel(src)

/obj/item/flame/lighter/zippo/dominia
	name = "\improper Dominian Zippo lighter"
	desc = "A zippo lighter with a depiction of the Imperial standard of Dominia."
	desc_extended = "While never officially endorsed by the Emperor, lighters featuring a stylized Imperial standard are a common sight throughout the Empire. Due to the simplicity with which the standard can be recreated, these lighters are found even in the poorer frontier regions in the Empire and are commonly seen as a sign of patriotism."
	icon_state = "dominiazippo"
	item_state = "dominiazippo"

/obj/item/flame/lighter/zippo/sol
	name = "\improper Solarian Zippo lighter"
	desc = "A zippo lighter with a depiction of the flag of the Sol Alliance."
	desc_extended = "Zippo lighters with the flag of the Sol Alliance continue a long-standing tradition of Earth. While originally proclaiming patriotism to the nation, in the face of movements for more colonial self-determination, these lighters now push forward a message of unity."
	icon_state = "solzippo"
	item_state = "solzippo"

/obj/item/flame/lighter/zippo/tcfl
	name = "\improper Biesellite Zippo lighter"
	desc = "A zippo lighter with a depiction of the Biesellite flag."
	desc_extended = "In their rush to expand the Tau Ceti Foreign Legion, the Republic of Biesel manufactured thousands of Biesel-patterned zippo lighters to compliment the jackets and berets that were so often touted by recruiters. In the wake of Frost's Invasion, the popularity of such lighters has only increased and they serve as a small show of patriotism. A small NanoTrasen logo is stenciled on the base."
	icon_state = "tcflzippo"
	item_state = "tcflzippo"

/obj/item/flame/lighter/zippo/royal
	name = "royal Zippo lighter"
	desc = "A gold-plated zippo with a two-piece cover. A small chemical resevoir in the lighter allows for purple flames that burn with greater intensity."
	icon_state = "royalzippo"
	item_state = "royalzippo"
	flame_light_color = LIGHT_COLOR_VIOLET

/obj/item/flame/lighter/zippo/black
	name = "black Zippo lighter"
	desc = "A black zippo lighter with a rounded cover. This one seems to burn lower and slower, producing a faint glow."
	icon_state = "blackzippo"
	item_state = "blackzippo"

/obj/item/flame/lighter/zippo/black/cross
	name = "black Zippo lighter"
	desc = "A black zippo lighter with a rounded cover. This one seems to burn lower and slower, producing a faint glow. This one has a cross painted on it."
	icon_state = "blackcrosszippo"
	item_state = "blackzippo"

/obj/item/flame/lighter/zippo/himeo
	name = "\improper Himean Zippo lighter"
	desc = "A zippo with the symbol of the United Syndicates of Himeo on it. This seems to be a model of exceptional make and excessive fuel consumption and temperature."
	desc_extended = "Lighters of all kinds are a common sight in the United Syndicates of Himeo, where light sources are required for daily life in its dark tunnels, and its lighters are prized throughout the Coalition for their quality. The common emblem of the planet - a white circle surrounded by red triangles - is often featured on lighters originating from the planet."
	icon_state = "himeozippo"
	item_state = "himeozippo"
	flame_light_range = 2

/obj/item/flame/lighter/zippo/coalition
	name = "\improper Coalition Zippo lighter"
	desc = "A zippo lighter with a depiction of the Coalition of Colonies flag. This lighter utilizes advanced fuel from Xanu Prime which burns hotter, causing a blue flame."
	desc_extended = "As there are hundreds of cultures in the Coalition of Colonies, so too are there hundreds of local variations of zippo lighters. The most prized zippos tend to be those from the industrial colony of Himeo, where a strong work ethic and technological advancements combine to produce high-quality lighters that ignite through the harshest of conditions. Most exported Himean lighters have their logos scratched off, rebranded, and given a fresh coat of paint, much to the chagrin of their manufacturers."
	icon_state = "coalitionzippo"
	item_state = "coalitionzippo"
	flame_light_color = LIGHT_COLOR_BLUE

/obj/item/flame/lighter/zippo/gold
	name = "golden Zippo lighter"
	desc = "A golden zippo lighter. Badasses and chainsmokers might settle for a zippo, no sir - you can do better with this solid, 24-karat golden piece!"
	icon_state = "goldzippo"
	item_state = "goldzippo"
	flame_light_color = LIGHT_COLOR_BLUE

/obj/item/flame/lighter/zippo/europa
	name = "\improper Europan Zippo lighter"
	desc = "A smokeless electrical coil lighter in the style of a zippo with the tricolour of the Jovian moon Europa on the side. Even its outside feels somewhat hot to the touch when it is turned on."
	desc_extended = "Traditional lighters are often frowned upon in the various submarines and underwater bases of Europa for the fumes their open flames produce. As a result, flameless lighters using heated metal coils that ignite flammable material upon contact are employed instead. These lighters are often prized personal possessions of those who own them, as with living space, privacy and individual possessions are a luxury in the cramped quarters of Europan vessels and stations. A side effect of having lighters that use electrically heated metal coils as opposed to flames however, is that the exteriors of the lighters themselves can become heated to a point of inflicting superficial burns if left on for relatively short periods of time."
	icon_state = "europazippo"
	item_state = "europazippo"
	flame_light_power = 1

/obj/item/flame/lighter/zippo/gadpathur
	name = "\improper Gadpathurian Zippo lighter"
	desc = "A zippo lighter with a depiction of the flag of the United Planetary Defense Council of Gadpathur. The nozzle seems to be especially small in order to produce a weaker and dimmer flame."
	desc_extended = "Owing to the relative poverty of Gadpathur and the ever-present need for gasmasks, smoking is a rare habit on the planet. Still, Gadpathurians who choose to smoke typically keep lighters with smaller nozzles, both to reduce light and thus attention in the confines of a bunker and to conserve on fuel which too is hoarded for their endless war preparations. The Gadpathurian flag emblazoned on the side of the lighter is not a common feature, with most Gadpathurians who stay on the planet preferring to place a symbol of their cadre in its stead."
	icon_state = "gadpathurzippo"
	item_state = "gadpathurzippo"
	flame_light_power = 1

/obj/item/flame/lighter/zippo/asoral
	name = "\improper Asoral jet lighter"
	desc = "A thin lighter made from a heat-resistant polymer and a nozzle that wouldn't be out of place on a jet. While it might bear the logo of the Asoral Orbital and Suborbital Racing network on it, it utilizes advanced fuel from Xanu Prime which burns hotter, causing a blue flame."
	desc_extended = "The Asoral jet lighter began as a publicity stunt by a few intrepid engineers looking to recycle old and underperforming racing probe engines. Although that particular plan ended in disaster, the Asoral Racing network ended up loving the concept and adopting a smaller and safer version of the lighter as a form of advertising. In a pinch, lighters such as these are known to serve as replacement igniters for racers' engines. Until recently, they were produced with a plume similar to that of an afterburner before the merger of Crosk's racing networks with those of Xanu Prime."
	icon_state = "lighter-asoral"
	item_state = "lighter-asoral"
	flame_light_color = LIGHT_COLOR_BLUE
	flame_light_range = 2

/obj/item/flame/lighter/zippo/nt
	name = "\improper NanoTrasen Zippo lighter"
	desc = "A zippo lighter with a depiction of NanoTrasen's iconic logo."
	icon_state = "ntzippo"
	item_state = "ntzippo"

/obj/item/flame/lighter/zippo/fisanduh
	name = "\improper Fisanduhian Zippo lighter"
	desc = "A zippo with a depiction of the flag of the Confederate States of Fisanduh. This is a well crafted model that burns brighter and hotter than \
	the usual lighter."
	desc_extended = "On Moroz it's rather hard to find a Confederate without at least some manner of lighter on their person. Fisanduhians don't \
	smoke anymore than the rest of Moroz does, instead they prize these lighters for their utility. From burning loose thread to lighting a \
	molotov and more. A common adage is that the fire of Fisanduh burns brighter than Dominia's, which seems to be true for their lighters at least. \
	These have found purchase throughout the Spur due to their reliability and impressive capability to light up various things, causing a \
	competition of sorts to arise with Fisanduhian and Himean producers over the best quality lighter."
	icon_state = "fisanduhzippo"
	item_state = "fisanduhzippo"
	flame_light_range = 2

/obj/item/flame/lighter/zippo/luceian
	name = "\improper Luceian Zippo lighter"
	desc = "A bright zippo lighter with the all-seeing eye of Ennoia on its front. Clearly Luceian."
	desc_extended = "Luceian lighters, sometimes referred to as \"Ennoic Fires,\" are commonly carried by Assunzionii as an emergency light \
	source. A genuine lighter in the Luceian tradition will have a proving mark stamped upon its base that shows when and where it was \
	blessed following its construction."
	icon_state = "luceianzippo"
	item_state = "luceianzippo"
	flame_light_color = LIGHT_COLOR_WHITE
	flame_light_range = 2

/obj/item/flame/lighter/zippo/sancolette
	name = "\improper San Colette Zippo lighter"
	desc = "A tricolor zippo lighter depicting the flag of San Colette."
	desc_extended = "Among Solarian nations, it's popular to carry a lighter depicting the flag of the Sol Alliance as a proclaimation of \
	one's patriotism. After being recognised as the Sovereign Solarian Republic of San Colette, this tradition continued on with the Colettish, \
	now opting to pridefully bare their own tricolor flag instead."
	icon_state = "sancolettezippo"
	item_state = "sancolettezippo"

/obj/item/flame/lighter/callisto
	name = "\improper Callistean lighter"
	desc = "A cheap plastic lighter bearing the flag of Callisto."
	desc_extended = "It's debated whether this (recently) discontinued line of cheap lighters was a money laundering scheme or a publicity stunt - extremely cheap, extremely flimsy, these Idris made lighters became an unintended social phenomenon among Callistean smokers; running competitions amongst them as to how long they can keep those lighters alive."
	icon_state = "lightercallisto"
	item_state = "lightercallisto"

/obj/item/flame/lighter/zippo/nralakk
	name = "\improper Nralakk Federation Zippo lighter"
	desc = "An advanced zippo lighter depicting the flag of the Nralakk Federation."
	desc_extended = "A stylish lighter using Skrell hover technology. Burns with a purple flame. With the growth of the Federation's tobacco industry, these lighters are a commonplace convenience for many Skrell both within Nralakk space and abroad.These lighters are also often carried by wulumunusha smokers, and are a particularly common sight among adherents of the Weishii faith."
	icon_state = "nralakkzippo"
	item_state = "nralakkzippo"
	flame_light_color = LIGHT_COLOR_PURPLE

/obj/item/flame/lighter/zippo/nralakk/update_icon()
	if(lit)
		flick("[base_state]_turnon", src)
	else
		flick("[base_state]_turnoff", src)
	return ..()

/obj/item/flame/lighter/random/Initialize()
	. = ..()
	icon_state = "lighter-[pick("r","c","y","g")]"
	item_state = icon_state
	base_state = icon_state

/obj/item/flame/lighter/update_icon()
	if(lit)
		icon_state = "[base_state]on"
		item_state = "[base_state]on"
	else
		icon_state = "[base_state]"
		item_state = "[base_state]"
	update_held_icon()
	return ..()

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			handle_lighting()
			if(istype(src, /obj/item/flame/lighter/zippo))
				if(last_open <= world.time - 20) //Spam limiter.
					last_open = world.time
					user.visible_message(SPAN_NOTICE("Without even breaking stride, <b>[user]</b> flips open and lights \the [src] in one smooth movement."), range = 3)
			else // cheap lighter.
				if(prob(95))
					if(last_open <= world.time - 20) //Spam limiter.
						last_open = world.time
						user.visible_message(SPAN_NOTICE("After a few attempts, <b>[user]</b> manages to light \the [src]."), range = 3)
				else
					to_chat(user, SPAN_DANGER("You burn yourself while lighting the lighter.")) // shouldn't be a problem - you got hurt, after all.
					if(user.IgniteMob())
						user.visible_message(SPAN_DANGER("<b>[user]</b> accidentally sets themselves on fire!"))
					if(user.l_hand == src)
						user.apply_damage(2, DAMAGE_BURN,BP_L_HAND)
					else
						user.apply_damage(2, DAMAGE_BURN,BP_R_HAND)
					if(last_open <= world.time - 20) //Spam limiter.
						last_open = world.time
						user.visible_message(SPAN_DANGER("After a few attempts, <b>[user]</b> manages to light \the [src], they however burn their finger in the process."), range = 3)
		else
			lit = FALSE
			update_icon()
			playsound(src.loc, deactivation_sound, 75, 1)
			if(last_close <= world.time - 20) //Spam limiter.
				last_close = world.time
				if(istype(src, /obj/item/flame/lighter/zippo))
					user.visible_message(SPAN_NOTICE("You hear a quiet click, as <b>[user]</b> shuts off \the [src] without even looking at what they're doing."), range = 3)
				else
					user.visible_message(SPAN_NOTICE("<b>[user]</b> quietly shuts off \the [src]."), range = 3)

			set_light(0)
			STOP_PROCESSING(SSprocessing, src)
	else
		return ..()
	return

/obj/item/flame/lighter/proc/handle_lighting()
	lit = TRUE
	update_icon()
	playsound(src.loc, pick(activation_sound), 75, 1)
	set_light(flame_light_power, flame_light_range, l_color = flame_light_color)
	START_PROCESSING(SSprocessing, src)

/obj/item/flame/lighter/vendor_action(var/obj/machinery/vending/V)
	handle_lighting()

/obj/item/flame/lighter/attack(mob/living/target_mob, mob/living/user, target_zone)
	var/mob/living/carbon/M = target_mob

	if(!istype(M))
		return

	if(lit && M.IgniteMob())
		M.visible_message(SPAN_DANGER("\The [user] ignites \the [M] with \the [src]!"))

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == BP_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			var/response = ""
			user.visible_message(SPAN_NOTICE("\The <b>[user]</b> holds up \the [src] to \the [M]'s mouth."), SPAN_NOTICE("You hold up \the [src] to \the [M]'s mouth, waiting for them to accept."))
			response = alert(M, "\The [user] offers to light your [cig.name]. Do you accept?", "Lighter offer", "Accept", "Decline")
			if(response != "Accept")
				M.visible_message(SPAN_NOTICE("<b>[M]</b> pushes [user]'s [src] away."))
				return
			if(!M.Adjacent(user))
				to_chat(user, SPAN_WARNING("You need to stay in reaching distance to do that."))
				to_chat(M, SPAN_WARNING("\The [user] moved too far away."))
				return
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light(SPAN_NOTICE("In one smooth motion, \the <b>[user]</b> whips \the [name] out and lights \the [M]'s [cig.name]."))
			else
				cig.light(SPAN_NOTICE("\The <b>[user]</b> holds \the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/flame/lighter/throw_impact(atom/hit_atom)
	. = ..()
	var/mob/living/carbon/M = hit_atom
	if(istype(M) && lit && M.IgniteMob())
		M.visible_message(SPAN_DANGER("\The [M] is ignited by \the [src]!"))

/obj/item/flame/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(lit && prob(10) && isliving(src.loc))
		var/mob/living/M = src.loc
		if(M.IgniteMob())
			M.visible_message(SPAN_DANGER("\The [M] is ignited by \the [src]!"))

	if (istype(loc, /obj/item/storage))//A lighter shouldn't stay lit inside a closed container
		lit = 0
		icon_state = "[base_state]"
		item_state = "[base_state]"
		set_light(0)
		STOP_PROCESSING(SSprocessing, src)
	return

///////////
//ROLLING//
///////////
/obj/item/clothing/mask/smokable/cigarette/rolled
	name = "rolled cigarette"
	desc = "A hand rolled cigarette using dried plant matter."
	icon_state = "cigrolloff"
	item_state = "cigoff"
	type_butt = /obj/item/trash/cigbutt/roll
	chem_volume = 50
	var/filter = 0
	icon_on = "cigrollon"
	icon_off = "cigrolloff"

/obj/item/clothing/mask/smokable/cigarette/rolled/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(filter)
		. += "It's capped off one end with a filter."

/obj/item/trash/cigbutt/roll
	icon_state = "rollbutt"

/obj/item/clothing/mask/smokable/cigarette/rolled/update_icon()
	. = ..()
	icon_on = filter ? "cigon" : "cigrollon"
	icon_off = filter ? "cigoff" : "cigrolloff"
	if(!lit)
		icon_state = filter ? "cigoff" : "cigrolloff"
	else
		icon_state = filter ? "cigon" : "cigrollon"
	update_clothing_icon()

/obj/item/paper/cig
	name = "rolling paper"
	desc = "A thin piece of paper used to make smokables."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigpaper_generic"
	w_class = WEIGHT_CLASS_TINY
	can_fold = FALSE

/obj/item/paper/cig/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/flame) || attacking_item.iswelder())
		..()
	if(attacking_item.ispen())
		..()
	else
		return

/obj/item/paper/cig/fine
	name = "\improper Trident rolling paper"
	desc = "A thin piece of trident branded paper used to make fine smokables."
	icon_state = "cigpaper_fine"

/obj/item/cigarette_filter
	name = "cigarette filter"
	desc = "A small nub like filter for cigarettes."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "cigfilter"
	w_class = WEIGHT_CLASS_TINY

/obj/item/cigarette_filter/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/clothing/mask/smokable/cigarette/rolled))
		var/obj/item/clothing/mask/smokable/cigarette/rolled/CR = attacking_item
		return CR.attackby(src, user)
	. = ..()

//tobacco sold seperately if you're too snobby to grow it yourself.
/obj/item/reagent_containers/food/snacks/grown/dried_tobacco
	plantname = "tobacco"
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/Initialize()
	. = ..()
	dry = TRUE
	name = "dried [name]"
	color = "#a38463"

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/bad
	plantname = "badtobacco"

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/fine
	plantname = "finetobacco"

/obj/item/reagent_containers/food/snacks/grown/dried_tobacco/pure
	plantname = "puretobacco"

//oracle sold seperately if you're too snobby to grow it yourself.
/obj/item/reagent_containers/food/snacks/grown/dried_oracle
	plantname = "oracle"
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/dried_oracle/Initialize()
	. = ..()
	dry = TRUE
	name = "dried [name]"
	color = "#ff6f6f"

/obj/item/reagent_containers/food/snacks/grown/dried_oracle/fine
	plantname = "vedamororacle"

/obj/item/clothing/mask/smokable/cigarette/rolled/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/cigarette_filter))
		if(filter)
			to_chat(user, SPAN_WARNING("\The [src] already has a filter!"))
			return
		if(lit)
			to_chat(user, SPAN_WARNING("\The [src] is lit already!"))
			return
		if(user.unEquip(attacking_item))
			user.visible_message(SPAN_NOTICE("[user] sticks a cigarette filter into \the [src]."), SPAN_NOTICE("You stick a cigarette filter into \the [src]."))
			playsound(src, 'sound/items/drop/gloves.ogg', 25, 1)
			filter = TRUE
			name = "filtered [name]"
			update_icon()
			qdel(attacking_item)
			return
	..()
