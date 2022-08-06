// Left Leg
/obj/item/organ/external/leg/nymph
	nymph_child = /obj/item/organ/external/foot/nymph

/obj/item/organ/external/leg/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

/obj/item/organ/external/leg/nymph/process()
	..()
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.handle_nymph(src)

// Right Leg
/obj/item/organ/external/leg/right/nymph
	nymph_child = /obj/item/organ/external/foot/right/nymph

/obj/item/organ/external/leg/right/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

/obj/item/organ/external/leg/right/nymph/process()
	..()
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.handle_nymph(src)

// Left Arm
/obj/item/organ/external/arm/nymph
	nymph_child = /obj/item/organ/external/hand/nymph

/obj/item/organ/external/arm/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

/obj/item/organ/external/arm/nymph/process()
	..()
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.handle_nymph(src)

// Right Arm
/obj/item/organ/external/arm/right/nymph
	nymph_child = /obj/item/organ/external/hand/right/nymph

/obj/item/organ/external/arm/right/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

/obj/item/organ/external/arm/right/nymph/process()
	..()
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.handle_nymph(src)

// Left Hand
/obj/item/organ/external/hand/nymph

/obj/item/organ/external/hand/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

// Right Hand
/obj/item/organ/external/hand/right/nymph

/obj/item/organ/external/hand/right/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

// Left Foot
/obj/item/organ/external/foot/nymph

/obj/item/organ/external/foot/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

// Right Foot
/obj/item/organ/external/foot/right/nymph

/obj/item/organ/external/foot/right/nymph/Initialize()
	. = ..()
	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	N.setup_limb(src)

/datum/component/nymph_limb
	var/list/valid_species = list(SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	var/list/valid_organs_to_replace = list(BP_L_ARM, BP_L_HAND, BP_R_ARM, BP_R_HAND, BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
	// Main limb where the Nymph mob lives
	var/list/nymph_limb_types = list(
		/obj/item/organ/external/arm/nymph,
		/obj/item/organ/external/arm/right/nymph,
		/obj/item/organ/external/leg/nymph,
		/obj/item/organ/external/leg/right/nymph,
		/obj/item/organ/external/hand/nymph,
		/obj/item/organ/external/hand/right/nymph,
		/obj/item/organ/external/foot/nymph,
		/obj/item/organ/external/foot/right/nymph
	)

	var/list/nymph_limb_types_by_name = list(
		BP_L_ARM = /obj/item/organ/external/arm/nymph,
		BP_R_ARM = /obj/item/organ/external/arm/right/nymph,
		BP_L_LEG = /obj/item/organ/external/leg/nymph,
		BP_R_LEG = /obj/item/organ/external/leg/right/nymph,
		BP_L_HAND = /obj/item/organ/external/hand/nymph,
		BP_R_HAND = /obj/item/organ/external/hand/right/nymph,
		BP_L_FOOT = /obj/item/organ/external/foot/nymph,
		BP_R_FOOT = /obj/item/organ/external/foot/right/nymph
	)

/datum/component/nymph_limb/proc/setup_limb(var/obj/item/organ/external/E)
	if(is_type_in_list(E, nymph_limb_types))
		E.nymph = new /mob/living/carbon/alien/diona

	E.status |= (ORGAN_PLANT | ORGAN_NYMPH)
	E.species = all_species["Nymph Limb"]
	E.fingerprints = null
	if(!E.dna)
		E.blood_DNA = list()
		E.set_dna(new /datum/dna)

	E.limb_flags &= ~(ORGAN_CAN_BREAK | ORGAN_CAN_MAIM | ORGAN_HAS_TENDON)

// Called by process()
/datum/component/nymph_limb/proc/handle_nymph(var/obj/item/organ/external/E)
	var/mob/living/carbon/alien/diona/limb_nymph = E.nymph
	if(!istype(limb_nymph))
		return FALSE
	if(!E || !is_type_in_list(E, nymph_limb_types))
		return FALSE
	if((!E.owner || limb_nymph.stat == DEAD))
		nymph_out(E, limb_nymph)
		return FALSE

	if(!E.is_usable())
		nymph_out(E, limb_nymph, forced = TRUE)
		return FALSE

	var/blood_volume = round(REAGENT_VOLUME(E.owner.vessel, /decl/reagent/blood))
	if(blood_volume)
		if(REAGENT_DATA(E.owner.vessel, /decl/reagent/blood))
			E.owner.vessel.remove_reagent(/decl/reagent/blood, BLOOD_REGEN_RATE / (2 * nymph_limb_types_by_name.len))
	if(blood_volume <= 0)
		nymph_out(E, limb_nymph, forced = TRUE)

// Host detach
/mob/living/carbon/human/proc/detach_nymph_limb()
	set category = "Abilities"
	set name = "Detach Nymph"

	var/list/nymph_limb_types = list(
		/obj/item/organ/external/arm/nymph,
		/obj/item/organ/external/arm/right/nymph,
		/obj/item/organ/external/leg/nymph,
		/obj/item/organ/external/leg/right/nymph,
		/obj/item/organ/external/hand/nymph,
		/obj/item/organ/external/hand/right/nymph,
		/obj/item/organ/external/foot/nymph,
		/obj/item/organ/external/foot/right/nymph
	)

	// Find our existing nymphlimbs
	var/list/my_nymph_limbs = list()
	for(var/obj/item/organ/external/O in organs)
		if(is_type_in_list(O, nymph_limb_types))
			my_nymph_limbs += O
	if(!my_nymph_limbs.len)
		return FALSE

	// Player picks a nymphlimb and removes it
	var/obj/item/organ/external/E = input(src, "Select a limb to detach:", "Nymph Limb Detach") as null|anything in my_nymph_limbs
	if(!istype(E))
		return
	if(!do_after(src, delay = 3 SECONDS, needhand = FALSE))
		return
	if(E.detach_nymph_limb() && my_nymph_limbs.len == 1)
		verbs -= /mob/living/carbon/human/proc/detach_nymph_limb

	regenerate_icons()

// Nymph detach
/mob/living/carbon/alien/diona/proc/detach_nymph_limb()
	set category = "Abilities"
	set name = "Detach from Host"

	var/obj/item/organ/external/E = loc
	if(istype(E))
		to_chat(src, "You start to detach from your host.")
		to_chat(E.owner, "The nymph acting as your [E.name] starts to unattach itself.")
		if(do_after(src, delay = 3 SECONDS, needhand = FALSE))
			E.detach_nymph_limb()

// Organ detach
/obj/item/organ/external/proc/detach_nymph_limb()
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	var/mob/living/carbon/alien/diona/nymph = src.nymph
	var/nymph_owner = owner

	if(nymph)
		N.nymph_out(src, nymph)
		to_chat(nymph_owner, span("warning", "The nymph attached to you as \a [name] unlatches its tendrils from your body and drops to \the [get_turf(owner)]."))
		to_chat(nymph, span("notice", "You tear your tendrils free of your host and drop to \the [get_turf(owner)]."))

	return TRUE

// Nymph attach
/mob/living/carbon/alien/diona/proc/attach_nymph_limb()
	set category = "Abilities"
	set name = "Attach to Nearby Host"

	if(incapacitated())
		return
	if(!isturf(loc))
		return
	if(!can_attach)
		to_chat(src, span("warning", "You do not have the strength to attach to another host so soon."))

	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
	var/list/mob/living/carbon/human/mob_list = list()

	// Find a new host
	for(var/mob/living/carbon/human/H in view(1))
		if(ishuman(H) && (H.species?.name in N.valid_species) && \
		H.client && H.stat == CONSCIOUS)
			mob_list += H

	if(!LAZYLEN(mob_list))
		to_chat(src, span("warning", "There are no valid hosts to bond to."))
		return FALSE

	var/choice = input(src, "Choose a host to bond to:", "Attach to Host") in mob_list
	var/mob/living/carbon/human/target = choice
	if(!Adjacent(target) || target.stat || !target.client)
		return

	// Find a location to bond to, on the host
	var/list/valid_locations = list()
	for(var/O in target.organs_by_name)
		if(!target.organs_by_name[O] && (O in N.valid_organs_to_replace))
			valid_locations += O

	var/limb_choice
	if(!valid_locations.len)
		to_chat(src, span("warning", "\The [target.name] has no suitable spots for you to attach to their body!"))
		return
	else
		limb_choice = input(src,"Choose a location to attach onto \the [target.name]","Nymph Attachment Point") as null|anything in valid_locations
		if(!limb_choice)
			return

	if(!do_after(src, delay = 3 SECONDS, needhand = FALSE))
		return

	// Make new limb and put it on the host
	limb_choice = N.nymph_limb_types_by_name[limb_choice]
	var/obj/item/organ/external/new_nymph_limb = new limb_choice
	if(!istype(new_nymph_limb))
		return
	new_nymph_limb.replaced(target)

	if(new_nymph_limb.nymph_child)
		var/obj/item/organ/external/new_nymph_child = new new_nymph_limb.nymph_child
		new_nymph_child.replaced(target)

	target.regenerate_icons()

	N.nymph_in(new_nymph_limb, src)

/mob/living/carbon/alien/diona/verb/snatch_limb()
	set category = "IC"
	set name = "Attach Nymph Limb"
	set desc = "Replaces a missing limb with a dionae nymph."
	set src in view(1)

	if(!ishuman(usr))
		return

	if(incapacitated())
		return
	if(!isturf(loc))
		return
	if(!can_attach)
		to_chat(usr, SPAN_WARNING("\The [src] does not have the strength to attach to another host so soon."))

	var/mob/living/carbon/human/target = usr

	if(!Adjacent(target) || target.stat || !target.client)
		return

	AddComponent(/datum/component/nymph_limb)
	var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)

	if(!(target.species?.name in N.valid_species))
		to_chat(target, SPAN_WARNING("\The [src] refuses to attach to your limb."))
		return

	var/list/valid_locations = list()
	for(var/O in target.organs_by_name)
		if(!target.organs_by_name[O] && (O in N.valid_organs_to_replace))
			valid_locations += O

	var/limb_choice
	if(!valid_locations.len)
		to_chat(target, SPAN_WARNING("You have no suitable spots for you to attach to their body!"))
		return
	else
		limb_choice = input(target,"Choose a location to attach onto \the [target.name]","Nymph Attachment Point") as null|anything in valid_locations
		if(!limb_choice)
			return

	if(!do_after(target, delay = 3 SECONDS, needhand = TRUE))
		return

	// Make new limb and put it on the host
	limb_choice = N.nymph_limb_types_by_name[limb_choice]
	var/obj/item/organ/external/new_nymph_limb = new limb_choice
	if(!istype(new_nymph_limb))
		return
	new_nymph_limb.replaced(target)

	if(new_nymph_limb.nymph_child)
		var/obj/item/organ/external/new_nymph_child = new new_nymph_limb.nymph_child
		new_nymph_child.replaced(target)

	target.regenerate_icons()

	N.nymph_in(new_nymph_limb, src)
	target.visible_message(SPAN_NOTICE("\The [N] attaches to \the [target]'s body!"), SPAN_NOTICE("\The [N] attaches to your body!"))

/datum/component/nymph_limb/proc/nymph_in(var/obj/item/organ/external/E, var/mob/living/carbon/alien/diona/nymph)
	var/mob/living/carbon/alien/diona/limb_nymph = E.nymph
	if(limb_nymph)
		if(!limb_nymph.client)
			QDEL_NULL(limb_nymph)
		else
			return

	if(nymph.client)
		nymph.client.eye = E.owner
	limb_nymph = nymph
	limb_nymph.forceMove(E)

/datum/component/nymph_limb/proc/nymph_out(var/obj/item/organ/external/E, var/mob/living/carbon/alien/diona/nymph, var/forced = FALSE)
	if(nymph.client)
		nymph.client.eye = nymph
	nymph.forceMove(get_turf(E))
	E.nymph = null

	if(forced)
		nymph.can_attach = FALSE
		addtimer(CALLBACK(nymph, /datum/component/nymph_limb/.proc/can_attach, nymph), 5 MINUTES, TIMER_UNIQUE)

	E.removed(E.owner)
	qdel(E)

/datum/component/nymph_limb/proc/can_attach(var/mob/living/carbon/alien/diona/nymph)
	if(nymph)
		nymph.can_attach = TRUE
		to_chat(nymph, SPAN_NOTICE("Your body has regained enough strength to attach to a new host, if you can find one."))

// For limbs created by character setup
/datum/component/nymph_limb/proc/nymphize(var/mob/living/carbon/human/H, var/organ_name, var/forced = FALSE)
	if(!H.should_have_limb(organ_name))
		return
	if(H.organs_by_name[organ_name])
		if(forced) // Do we wish to remove any limbs currently occupying that spot?
			var/obj/item/organ/external/O = H.get_organ(organ_name)
			qdel(O)
			H.organs_by_name[organ_name] = null
		else
			return
	// Create and attach our new nymph limb
	var/nymph_limb_type = nymph_limb_types_by_name[organ_name]
	var/obj/item/organ/external/E = new nymph_limb_type
	E.replaced(H)
	for(var/obj/item/organ/external/child in E.children)
		nymphize(H, child.organ_tag, TRUE)
	H.verbs |= /mob/living/carbon/human/proc/detach_nymph_limb

/datum/species/diona/nymph_limb // For use on nymph-limb organs only
	name = "Nymph Limb"
	short_name = "nym"
	name_plural = "Nymph Limbs"
	bodytype = "Nymph"
	icobase = 'icons/mob/human_races/limbs_nymph.dmi'
	deform = 'icons/mob/human_races/limbs_nymph.dmi'

	has_organ = list()

	spawn_flags = IS_RESTRICTED

	has_limbs = list(
		BP_L_ARM = list( "path" = /obj/item/organ/external/arm/nymph),
		BP_R_ARM = list( "path" = /obj/item/organ/external/arm/right/nymph),
		BP_L_LEG = list( "path" = /obj/item/organ/external/leg/nymph),
		BP_R_LEG = list( "path" = /obj/item/organ/external/leg/right/nymph),
		BP_L_HAND = list( "path" = /obj/item/organ/external/hand/nymph),
		BP_R_HAND = list( "path" = /obj/item/organ/external/hand/right/nymph),
		BP_L_FOOT = list( "path" = /obj/item/organ/external/foot/nymph),
		BP_R_FOOT = list( "path" = /obj/item/organ/external/foot/right/nymph)
		)