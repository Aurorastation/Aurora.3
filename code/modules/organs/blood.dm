/****************************************************
				BLOOD SYSTEM
****************************************************/
//Blood levels
var/const/BLOOD_VOLUME_NORMAL = 560
var/const/BLOOD_VOLUME_SAFE = 501
var/const/BLOOD_VOLUME_OKAY = 336
var/const/BLOOD_VOLUME_BAD = 224
var/const/BLOOD_VOLUME_SURVIVE = 122

/mob/living/carbon/human/var/datum/reagents/vessel	//Container for blood and BLOOD ONLY. Do not transfer other chems here.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()
	if(vessel)
		return

	vessel = new/datum/reagents(BLOOD_VOLUME_NORMAL + 40)
	vessel.my_atom = src

	if(species && species.flags & NO_BLOOD) //We want the var for safety but we can do without the actual blood.
		return

	vessel.add_reagent("blood",BLOOD_VOLUME_NORMAL)
	fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	for(var/datum/reagent/blood/B in vessel.reagent_list)
		if(B.id == "blood")
			B.data = list(
				"donor" = WEAKREF(src),
				"viruses" = null,
				"species" = species.bodytype,
				"blood_DNA" = dna.unique_enzymes,
				"blood_colour" = species.blood_color,
				"blood_type" = dna.b_type,
				"resistances" = null,
				"trace_chem" = null,
				"virus2" = null,
				"antibodies" = list()
			)
			B.color = B.data["blood_colour"]

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt as num, var/tar = src, var/spraydir)

	if(species && species.flags & NO_BLOOD) //TODO: Make drips come from the reagents instead.
		return

	if(!amt)
		return

	vessel.remove_reagent("blood",amt)
	blood_splatter(tar, src, spray_dir = spraydir)

#define BLOOD_SPRAY_DISTANCE 2
/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(alldirs)
	amt = Ceiling(amt/BLOOD_SPRAY_DISTANCE)
	var/bled = 0
	spawn(0)
		for(var/i = 1 to BLOOD_SPRAY_DISTANCE)
			sprayloc = get_step(sprayloc, spraydir)
			if(!istype(sprayloc) || sprayloc.density)
				break
			var/hit_mob
			for(var/thing in sprayloc)
				var/atom/A = thing
				if(!A.simulated)
					continue

				if(ishuman(A))
					var/mob/living/carbon/human/H = A
					if(!H.lying)
						H.bloody_body(src)
						H.bloody_hands(src)
						var/blinding = FALSE
						if(ran_zone("head", 75))
							blinding = TRUE
							for(var/obj/item/I in list(H.head, H.glasses, H.wear_mask))
								if(I && (I.body_parts_covered & EYES))
									blinding = FALSE
									break
						if(blinding)
							H.eye_blurry = max(H.eye_blurry, 10)
							H.eye_blind = max(H.eye_blind, 5)
							to_chat(H, "<span class='danger'>You are blinded by a spray of blood!</span>")
						else
							to_chat(H, "<span class='danger'>You are hit by a spray of blood!</span>")
						hit_mob = TRUE

				if(hit_mob || !A.CanPass(src, sprayloc))
					break
			drip(amt, sprayloc, spraydir)
			bled += amt
	return bled
#undef BLOOD_SPRAY_DISTANCE

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/reagent_containers/container, var/amount)

	var/datum/reagent/B = get_blood(container.reagents)
	if(!B) B = new /datum/reagent/blood
	B.holder = container
	B.volume += amount

	//set reagent data
	B.data["donor"] = WEAKREF(src)
	if (!B.data["virus2"])
		B.data["virus2"] = list()
	B.data["virus2"] |= virus_copylist(src.virus2)
	B.data["antibodies"] = src.antibodies
	B.data["blood_DNA"] = copytext(src.dna.unique_enzymes,1,0)
	if(src.resistances && src.resistances.len)
		if(B.data["resistances"])
			B.data["resistances"] |= src.resistances.Copy()
		else
			B.data["resistances"] = src.resistances.Copy()
	B.data["blood_type"] = copytext(src.dna.b_type,1,0)

	// Putting this here due to return shenanigans.
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		B.data["blood_colour"] = H.species.blood_color
		B.color = B.data["blood_colour"]
		B.data["species"] = H.species.bodytype

	var/list/temp_chem = list()
	for(var/datum/reagent/R in src.reagents.reagent_list)
		temp_chem += R.id
		temp_chem[R.id] = R.volume
	B.data["trace_chem"] = list2params(temp_chem)
	return B

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/reagent_containers/container, var/amount)

	if(species && species.flags & NO_BLOOD)
		return null

	if(vessel.get_reagent_amount("blood") < amount)
		return null

	. = ..()
	vessel.remove_reagent("blood",amount) // Removes blood if human

//Transfers blood from container ot vessels
/mob/living/carbon/proc/inject_blood(var/datum/reagent/blood/injected, var/amount)
	if (!injected || !istype(injected))
		return
	var/list/sniffles = virus_copylist(injected.data["virus2"])
	for(var/ID in sniffles)
		var/datum/disease2/disease/sniffle = sniffles[ID]
		infect_virus2(src,sniffle,1)
	if (injected.data["antibodies"] && prob(5))
		antibodies |= injected.data["antibodies"]
	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / BLOOD_VOLUME_NORMAL) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/datum/reagent/blood/injected, var/amount)
	// In case of mobs without blood, put it in their chem storage.
	if(species.flags & NO_BLOOD)
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/blood/our = get_blood(vessel)

	if (!injected || !our)
		return
	if(blood_incompatible(injected.data["blood_type"],our.data["blood_type"],injected.data["species"],our.data["species"]) && !(mind && mind.vampire))
		reagents.add_reagent("toxin",amount * 0.5)
		reagents.update_total()
	else
		vessel.add_reagent("blood", amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(weakref && res.data["donor"] != weakref) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(D.data["donor"] == weakref)
					return D
	return res

proc/blood_incompatible(donor,receiver,donor_species,receiver_species)
	if(!donor || !receiver) return 0

	if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return 1

	var/donor_antigen = copytext(donor,1,lentext(donor))
	var/receiver_antigen = copytext(receiver,1,lentext(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

proc/blood_splatter(var/target, var/datum/reagent/blood/source, var/large, var/spray_dir)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)
	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && LAZYLEN(drips) && !large)
		drop.add_overlay(drips)
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	// Update appearance.
	if(source.data["blood_colour"])
		B.basecolor = source.data["blood_colour"]
		B.update_icon()

	if(spray_dir)
		B.icon_state = "squirt"
		B.dir = spray_dir

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	// Update virus information.
	if(source.data["virus2"])
		B.virus2 = virus_copylist(source.data["virus2"])

	B.fluorescent  = 0
	B.invisibility = 0
	return B
