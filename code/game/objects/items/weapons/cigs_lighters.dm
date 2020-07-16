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
	var/smoketime = 5
	var/type_burnt = /obj/item/trash/match
	w_class = ITEMSIZE_TINY
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

/obj/item/flame/match/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.isFlameSource() && !src.lit)
		playsound(src, 'sound/items/cigs_lighters/cig_light.ogg', 75, 1, -1)
		user.visible_message("In a feat of redundancy, <b>[user]</b> lights \the [src] using \the [W].", range = 3)
		light()

/obj/item/flame/match/dropped(mob/user as mob)
	if(lit)
		spawn(0)
			var/turf/location = src.loc	// Light up the turf we land on.
			if(istype(location))
				location.hotspot_expose(700, 5)
			die(TRUE) // Put ourselves out.
	return ..()

/obj/item/flame/match/proc/light()
	lit = TRUE
	damtype = "burn"
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
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_cigs_lighters.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_cigs_lighters.dmi',
		)
	body_parts_covered = 0
	var/lit = 0
	var/icon_on
	var/icon_off
	var/type_butt = null
	var/chem_volume = 15 //Size of a syringe
	var/genericmes = "USER lights NAME with FLAME"
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/initial_volume = 0
	var/burn_rate = 0
	var/last_drag = 0 //Spam limiter for audio/message when taking a drag of cigarette.
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

/obj/item/clothing/mask/smokable/Initialize()
	. = ..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

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
		if(reagents.get_reagent_amount(/datum/reagent/toxin/phoron)) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount(/datum/reagent/toxin/phoron) / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount(/datum/reagent/fuel)) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount(/datum/reagent/fuel) / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
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

/obj/item/clothing/mask/smokable/proc/die(var/no_message = 0, var/mob/living/M)
	var/turf/T = get_turf(src)
	set_light(0)
	playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
	if(type_butt)
		var/obj/item/butt = new type_butt(src.loc)
		transfer_fingerprints_to(butt)
		if(ismob(loc))
			M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out."))
			if(M.wear_mask)
				M.remove_from_mob(src) //un-equip it so the overlays can update
				M.update_inv_wear_mask(0)
				M.equip_to_slot_if_possible(butt, slot_wear_mask)
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
			M = loc
			if(!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
				playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
			lit = 0
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/mask/smokable/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.isFlameSource())
		var/text = matchmes
		if(istype(W, /obj/item/flame/match))
			text = matchmes
		else if(istype(W, /obj/item/flame/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/flame/lighter))
			text = lightermes
		else if(W.iswelder())
			text = weldermes
		else if(istype(W, /obj/item/device/assembly/igniter))
			text = ignitermes
		else
			text = genericmes
		text = replacetext(text, "USER", "\the [user]")
		text = replacetext(text, "NAME", "\the [name]")
		text = replacetext(text, "FLAME", "\the [W.name]")
		light(text)

/obj/item/clothing/mask/smokable/isFlameSource()
	return lit

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	icon_off = "cigoff"
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 30
	burn_rate = 0.006 //Lasts ~166 seconds)
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='notice'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"

/obj/item/clothing/mask/smokable/cigarette/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/tobacco,10)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5) // 2/3 ratio, Adds 0.03 units per second

/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user] swings their [W], barely missing themselves. They light their [name] in the process."))
	return

/obj/item/clothing/mask/smokable/cigarette/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
			return 1
		if(last_drag <= world.time - 30) //Spam limiter. Only for messages/sound.
			last_drag = world.time
			H.visible_message("<span class='notice'>[H.name] takes a drag of their [name].</span>")
			playsound(H, 'sound/items/cigs_lighters/inhale.ogg', 50, 0, -1)
			reagents.trans_to_mob(H, (rand(10,20)/10), CHEM_BREATHE) //Smokes it faster. Slightly random amount.
			return 1
	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity || lit)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_WARNING("You dip \the [src] into \the [glass]."))
			playsound(src.loc, 'sound/effects/footstep/water1.ogg', 50, 1)
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if(lit == TRUE)
		user.visible_message(SPAN_NOTICE("[user] calmly drops and treads on the lit [src], putting it out instantly."))
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		die(TRUE)
	return ..()


/obj/item/clothing/mask/smokable/cigarette/vanilla
	burn_rate = 0.003 //300 seconds

/obj/item/clothing/mask/smokable/cigarette/vanilla/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco,15)

/obj/item/clothing/mask/smokable/cigarette/acmeco
	burn_rate = 0.015

/obj/item/clothing/mask/smokable/cigarette/acmeco/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco,5)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5)
	reagents.add_reagent(/datum/reagent/lexorin,2)
	reagents.add_reagent(/datum/reagent/serotrotium,3)

/obj/item/clothing/mask/smokable/cigarette/blank
	burn_rate = 0.003 //300 seconds
	chem_volume = 15

/obj/item/clothing/mask/smokable/cigarette/blank/Initialize()
	. = ..()
	reagents.clear_reagents()

/obj/item/clothing/mask/smokable/cigarette/dromedaryco

/obj/item/clothing/mask/smokable/cigarette/dromedaryco/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco,5)
	reagents.add_reagent(/datum/reagent/mental/nicotine,10)

/obj/item/clothing/mask/smokable/cigarette/nicotine

/obj/item/clothing/mask/smokable/cigarette/nicotine/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco/rich,5)
	reagents.add_reagent(/datum/reagent/mental/nicotine,10)

/obj/item/clothing/mask/smokable/cigarette/rugged

/obj/item/clothing/mask/smokable/cigarette/rugged/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco/fake,10)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5)

/obj/item/clothing/mask/smokable/cigarette/adhomai
	name = "adhomian cigarette"
	desc = "An adhomian cigarette made from processed S'rendarr's Hand."

/obj/item/clothing/mask/smokable/cigarette/adhomai/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco,5)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5)

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
	burn_rate = 0.003 //Lasts ~300 seconds
	chem_volume = 60
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='notice'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/mask/smokable/cigarette/cigar/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco/rich,25)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5) // 1/5 Ratio

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt/alt
	chem_volume = 60

/obj/item/clothing/mask/smokable/cigarette/cigar/havana/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco/rich,15)
	reagents.add_reagent(/datum/reagent/mental/nicotine,5) // 1/6 Ratio
	reagents.add_reagent(/datum/reagent/tricordrazine,10)

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/trash/cigbutt/cigarbutt/alt
	chem_volume = 120

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/toxin/tobacco/rich,30)
	reagents.add_reagent(/datum/reagent/mental/nicotine,10) //1/6 Ratio
	reagents.add_reagent(/datum/reagent/tricordrazine,20)

/obj/item/trash/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	randpixel = 10
	w_class = ITEMSIZE_TINY
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

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/cigarette/rolled/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat, with a smoky scent."
	icon_state = "sausageoff"
	item_state = "sausageoff"
	icon_on = "sausageon"
	type_butt = /obj/item/trash/cigbutt/sausagebutt
	chem_volume = 6

/obj/item/clothing/mask/smokable/cigarette/rolled/sausage/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/nutriment/protein,6)

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
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	burn_rate = 0.003
	w_class = ITEMSIZE_TINY
	chem_volume = 30
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='notice'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
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

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/energy/sword))
		return

	..()

	if (istype(W, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
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

	else if(istype(W, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/device/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
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
	w_class = ITEMSIZE_TINY
	throwforce = 4
	flags = CONDUCT
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

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo. If you've spent that amount of money on a lighter, you're either a badass or a chain smoker."
	icon_state = "zippo"
	item_state = "zippo"
	activation_sound = 'sound/items/cigs_lighters/zippo_on.ogg'
	deactivation_sound = 'sound/items/cigs_lighters/zippo_off.ogg'
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

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

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = TRUE
			update_icon()
			playsound(src.loc, pick(activation_sound), 75, 1)
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message(FONT_SMALL("Without even breaking stride, <b>[user]</b> flips open and lights \the [src] in one smooth movement."), range = 3)
			else
				if(prob(95))
					user.visible_message(FONT_SMALL("After a few attempts, <b>[user]</b> manages to light \the [src]."), range = 3)
				else
					to_chat(user, FONT_SMALL("You burn yourself while lighting the lighter."))
					if(user.IgniteMob())
						user.visible_message(FONT_SMALL("<b>[user]</b> accidentally sets themselves on fire!"))
					if(user.l_hand == src)
						user.apply_damage(2, BURN,BP_L_HAND)
					else
						user.apply_damage(2, BURN,BP_R_HAND)
					user.visible_message(FONT_SMALL("After a few attempts, <b>[user]</b> manages to light \the [src], they however burn their finger in the process."), range = 3)

			set_light(2, 1, l_color = LIGHT_COLOR_LAVA)
			START_PROCESSING(SSprocessing, src)
		else
			lit = FALSE
			update_icon()
			playsound(src.loc, deactivation_sound, 75, 1)
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message(FONT_SMALL("You hear a quiet click, as <b>[user]</b> shuts off \the [src] without even looking at what they're doing."), range = 3)
			else
				user.visible_message(FONT_SMALL("<b>[user]</b> quietly shuts off \the [src]."), range = 3)

			set_light(0)
			STOP_PROCESSING(SSprocessing, src)
	else
		return ..()
	return


/obj/item/flame/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(lit && M.IgniteMob())
		M.visible_message(SPAN_DANGER("\The [user] ignites \the [M] with \the [src]!"))

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == BP_MOUTH && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light(SPAN_NOTICE("[user] whips the [name] out and holds it for [M]."))
			else
				cig.light(SPAN_NOTICE("[user] holds the [name] out for [M], and lights the [cig.name]."))
	else
		..()

/obj/item/flame/lighter/throw_impact(mob/living/carbon/M as mob)
	. = ..()
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

/obj/item/trash/cigbutt/roll
	icon_state = "rollbutt"

/obj/item/clothing/mask/smokable/cigarette/rolled/examine(mob/user)
	. = ..()
	if(. && filter)
		to_chat(user, "Capped off one end with a filter.")

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
	w_class = ITEMSIZE_TINY

/obj/item/paper/cig/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/flame) || P.iswelder())
		..()
	if(P.ispen())
		..()
	else
		return

/obj/item/paper/cig/fine
	name = "\improper Trident rolling paper"
	desc = "A thin piece of trident branded paper used to make fine smokables."
	icon_state = "cigpaper_fine"

/obj/item/paper/cig/filter
	name = "cigarette filter"
	desc = "A small nub like filter for cigarettes."
	icon_state = "cigfilter"
	w_class = ITEMSIZE_TINY

/obj/item/paper/cig/filter/attackby(obj/item/P as obj, mob/user as mob)
	if(istype(P, /obj/item/flame) || P.iswelder())
		..()
	else
		return //no writing on filters now

/obj/item/paper/cig/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		..()
		return
	if (user.a_intent == I_GRAB && icon_state != "scrap" && !istype(src, /obj/item/paper/carbon))
		user.show_message(SPAN_ALERT("The cigarette paper is too small to fold into a plane."))
		return

//tobacco sold seperately if you're too snobby to grow it yourself.
/obj/item/reagent_containers/food/snacks/grown/dried_tobacco
	plantname = "tobacco"
	w_class = ITEMSIZE_TINY

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

/obj/item/clothing/mask/smokable/cigarette/rolled/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/paper/cig/filter))
		if(filter)
			to_chat(user, SPAN_WARNING("[src] already has a filter!"))
			return
		if(lit)
			to_chat(user, SPAN_WARNING("[src] is lit already!"))
			return
		if(user.unEquip(I))
			to_chat(user, SPAN_NOTICE("You stick [I] into \the [src]"))
			playsound(src, 'sound/items/drop/gloves.ogg', 25, 1)
			filter = 1
			name = "filtered [name]"
			update_icon()
			qdel(I)
			return
	..()

/obj/item/reagent_containers/food/snacks/grown/attackby(obj/item/I, mob/user)
	if(is_type_in_list(I, list(/obj/item/paper/cig/, /obj/item/paper/, /obj/item/teleportation_scroll)))
		if(!dry)
			to_chat(user, SPAN_WARNING("You need to dry [src] first!"))
			return
		if(user.unEquip(I))
			var/obj/item/clothing/mask/smokable/cigarette/rolled/R = new(get_turf(src))
			R.chem_volume = reagents.total_volume
			reagents.trans_to_holder(R.reagents, R.chem_volume)
			to_chat(user, SPAN_NOTICE("You roll \the [src] into \the [I]"))
			playsound(src, 'sound/bureaucracy/paperfold.ogg', 25, 1)
			user.put_in_active_hand(R)
			qdel(I)
			qdel(src)
			return
	..()
