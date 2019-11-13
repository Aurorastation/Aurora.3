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
	var/lit = 0

/proc/isflamesource(A)
	var/obj/item/I = A
	if(I.iswelder())
		var/obj/item/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(I, /obj/item/flame))
		var/obj/item/flame/F = I
		return (F.lit)
	else if(istype(I, /obj/item/device/assembly/igniter))
		return 1
	else if(istype(I, /obj/item/clothing/gloves/fluff/lunea_gloves))
		var/obj/item/clothing/gloves/fluff/lunea_gloves/F = I
		return (F.lit)
	return 0

///////////
//MATCHES//
///////////
/obj/item/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/obj/cigs_lighters.dmi'
	icon_state = "match_unlit"
	var/burnt = 0
	var/smoketime = 5
	w_class = 1.0
	origin_tech = list(TECH_MATERIAL = 1)
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")
	drop_sound = null

/obj/item/flame/match/process()
	if(isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		burn_out()
		return
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/flame/match/dropped(mob/user as mob)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if(lit)
		spawn(0)
			var/turf/location = src.loc
			if(istype(location))
				location.hotspot_expose(700, 5)
			burn_out()
	return ..()

/obj/item/flame/match/proc/burn_out()
	lit = 0
	burnt = 1
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	STOP_PROCESSING(SSprocessing, src)

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = 0
	var/lit = 0
	var/icon_on
	var/icon_off
	var/type_butt = null
	var/chem_volume = 15 //Size of a syringe
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/initial_volume = 0
	var/burn_rate = 0
	drop_sound = 'sound/items/cigs_lighters/cig_snuff.ogg'

/obj/item/clothing/mask/smokable/Initialize()
	. = ..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/smokable/process()

	if(reagents && reagents.total_volume && burn_rate)
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
		src.lit = 1
		playsound(src, 'sound/items/cigs_lighters/cig_light.ogg', 75, 1, -1)
		src.reagents.set_temperature(T0C + 45)
		damtype = "fire"
		if(reagents.get_reagent_amount("phoron")) // the phoron explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("phoron") / 2.5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		if(reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, 1), get_turf(src), 0, 0)
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

/obj/item/clothing/mask/smokable/proc/die(var/nomessage = 0)
	var/turf/T = get_turf(src)
	set_light(0)
	playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
	if (type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				to_chat(M, "<span class='notice'>Your [name] goes out.</span>")
			M.remove_from_mob(src) //un-equip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if(ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				to_chat(M, "<span class='notice'>Your [name] goes out, and you empty the ash.</span>")
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
	if(isflamesource(W))
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
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = 1
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	icon_off = "cigoff"
	type_butt = /obj/item/cigbutt
	chem_volume = 30
	burn_rate = 0.006 //Lasts ~166 seconds)
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='notice'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"

/obj/item/clothing/mask/smokable/cigarette/Initialize()
	. = ..()
	reagents.add_reagent("tobacco",10)
	reagents.add_reagent("nicotine",5) // 2/3 ratio, Adds 0.03 units per second


/obj/item/clothing/mask/smokable/cigarette/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/melee/energy/sword))
		var/obj/item/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing themselves. They light their [name] in the process.</span>")

	return

/obj/item/clothing/mask/smokable/cigarette/attack(mob/living/carbon/human/H, mob/user, def_zone)
	if(lit && H == user && istype(H))
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(H, "<span class='warning'>\The [blocked] is in the way!</span>")
			return 1
		H.visible_message("<span class='notice'>[H.name] takes a drag of their [name].</span>")
		playsound(H, 'sound/items/cigs_lighters/inhale.ogg', 50, 0, -1)
		return 1
	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if(!proximity || lit)
		return
	if(istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>You dip \the [src] into \the [glass].</span>")
			playsound(src.loc, 'sound/effects/footsteps/slosh1.wav', 50, 1)
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, "<span class='notice'>[glass] is empty.</span>")
			else
				to_chat(user, "<span class='notice'>[src] is full.</span>")

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on the lit [src], putting it out instantly.</span>")
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		die(1)
	return ..()


/obj/item/clothing/mask/smokable/cigarette/vanilla
	burn_rate = 0.003 //300 seconds

/obj/item/clothing/mask/smokable/cigarette/vanilla/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent("tobacco",15)

/obj/item/clothing/mask/smokable/cigarette/acmeco
	burn_rate = 0.015

/obj/item/clothing/mask/smokable/cigarette/acmeco/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent("tobacco",5)
	reagents.add_reagent("nicotine",5)
	reagents.add_reagent("lexorin",2)
	reagents.add_reagent("serotrotium",3)

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
	reagents.add_reagent("tobacco",5)
	reagents.add_reagent("nicotine",10)


////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	burn_rate = 0.003 //Lasts ~300 seconds
	chem_volume = 60
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='notice'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/cigarette/cigar/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent("tobaccorich",25)
	reagents.add_reagent("nicotine",5) // 1/5 Ratio

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	chem_volume = 60

/obj/item/clothing/mask/smokable/cigarette/cigar/havana/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent("tobaccorich",15)
	reagents.add_reagent("nicotine",5) // 1/6 Ratio
	reagents.add_reagent("tricordrazine",10)

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	chem_volume = 120

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba/Initialize()
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent("tobaccorich",30)
	reagents.add_reagent("nicotine",10) //1/6 Ratio
	reagents.add_reagent("tricordrazine",20)

/obj/item/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	randpixel = 10
	w_class = 1
	slot_flags = SLOT_EARS
	throwforce = 1

/obj/item/cigbutt/Initialize()
	. = ..()
	randpixel_xy()
	transform = turn(transform,rand(0,360))

/obj/item/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

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
	w_class = 1
	chem_volume = 30
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='notice'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/pipe/Initialize()
	. = ..()
	name = "empty [initial(name)]"
	burn_rate = 0

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit && burn_rate)
		src.lit = 1
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
	if(lit == 1)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		playsound(src.loc, 'sound/items/cigs_lighters/cig_snuff.ogg', 50, 1)
		lit = 0
		icon_state = icon_off
		item_state = icon_off
		STOP_PROCESSING(SSprocessing, src)
	else if (burn_rate)
		var/turf/location = get_turf(user)
		user.visible_message("<span class='notice'>[user] empties out [src].</span>", "<span class='notice'>You empty out [src].</span>")
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
			to_chat(user, "<span class='notice'>[G] must be dried before you stuff it into [src].</span>")
			return
		if (burn_rate)
			to_chat(user, "<span class='notice'>[src] is already packed.</span>")
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
			light("<span class='notice'>[user] manages to light their [name] with [W].</span>")

	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights their [name] with their [W].</span>")

	else if(istype(W, /obj/item/device/assembly/igniter))
		light("<span class='notice'>[user] fiddles with [W], and manages to light their [name] with the power of science.</span>")

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
	w_class = 1
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

/obj/item/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo. If you've spent that amount of money on a lighter, you're either a badass or a chain smoker."
	icon_state = "zippo"
	item_state = "zippo"
	activation_sound = 'sound/items/cigs_lighters/zippo_on.ogg'
	deactivation_sound = 'sound/items/cigs_lighters/zippo_off.ogg'

/obj/item/flame/lighter/random
	New()
		icon_state = "lighter-[pick("r","c","y","g")]"
		item_state = icon_state
		base_state = icon_state

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(!base_state)
		base_state = icon_state
	if(user.r_hand == src || user.l_hand == src)
		if(!lit)
			lit = 1
			icon_state = "[base_state]on"
			item_state = "[base_state]on"
			playsound(src.loc, pick(activation_sound), 75, 1)
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message("<span class='notice'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
			else
				if(prob(95))
					user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src].</span>")
				else

					to_chat(user, "<span class='warning'>You burn yourself while lighting the lighter.</span>")
					if(user.IgniteMob())
						user.visible_message(span("danger","\The [user] accidentally sets themselves on fire!"))
					if (user.l_hand == src)
						user.apply_damage(2,BURN,"l_hand")
					else
						user.apply_damage(2,BURN,"r_hand")
					user.visible_message("<span class='notice'>After a few attempts, [user] manages to light the [src], they however burn their finger in the process.</span>")

			set_light(2)
			START_PROCESSING(SSprocessing, src)
		else
			lit = 0
			icon_state = "[base_state]"
			item_state = "[base_state]"
			playsound(src.loc, deactivation_sound, 75, 1)
			if(istype(src, /obj/item/flame/lighter/zippo) )
				user.visible_message("<span class='notice'>You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing.</span>")
			else
				user.visible_message("<span class='notice'>[user] quietly shuts off the [src].</span>")

			set_light(0)
			STOP_PROCESSING(SSprocessing, src)
	else
		return ..()
	return


/obj/item/flame/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(lit && M.IgniteMob())
		M.visible_message(span("danger","\The [user] ignites \the [M] with \the [src]!"))

	if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == "mouth" && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/flame/lighter/zippo))
				cig.light("<span class='notice'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/flame/lighter/throw_impact(mob/living/carbon/M as mob)
	. = ..()
	if(istype(M) && lit && M.IgniteMob())
		M.visible_message(span("danger","\The [M] is ignited by \the [src]!"))

/obj/item/flame/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

	if(lit && prob(10) && isliving(src.loc))
		var/mob/living/M = src.loc
		if(M.IgniteMob())
			M.visible_message(span("danger","\The [M] is ignited by \the [src]!"))

	if (istype(loc, /obj/item/storage))//A lighter shouldn't stay lit inside a closed container
		lit = 0
		icon_state = "[base_state]"
		item_state = "[base_state]"
		set_light(0)
		STOP_PROCESSING(SSprocessing, src)
	return