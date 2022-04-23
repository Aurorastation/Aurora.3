/obj/item/sample
	name = "forensic sample"
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEMSIZE_TINY
	var/list/evidence
	var/list/source
	var/label_text = ""

/obj/item/sample/Initialize(var/newloc, var/atom/supplied)
	. = ..(newloc)
	if(supplied)
		copy_evidence(supplied)
		name = "[initial(name)] ([supplied.get_swab_name()])"
		LAZYADD(source, supplied.get_swab_name())

/obj/item/sample/print/Initialize(var/newloc, var/atom/supplied)
	. = ..(newloc, supplied)
	if(LAZYLEN(evidence))
		icon_state = "fingerprint1"

/obj/item/sample/proc/copy_evidence(var/atom/supplied)
	if(supplied.suit_fibers && supplied.suit_fibers.len)
		LAZYADD(evidence, supplied.suit_fibers.Copy())
		supplied.suit_fibers.Cut()

/obj/item/sample/proc/merge_evidence(var/obj/item/sample/supplied, var/mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	LAZYDISTINCTADD(evidence, supplied.evidence)
	LAZYDISTINCTADD(source, supplied.source)
	name = "[initial(name)] (combined)"
	to_chat(user, SPAN_NOTICE("You transfer the contents of \the [initial(supplied.name)] into \the [src]."))
	return 1

/obj/item/sample/print/merge_evidence(var/obj/item/sample/supplied, var/mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	for(var/print in supplied.evidence)
		if(LAZYISIN(evidence, print))
			LAZYSET(evidence, print, stringmerge(evidence[print],supplied.evidence[print]))
		else
			LAZYSET(evidence, print, supplied.evidence[print])
	LAZYDISTINCTADD(source, supplied.source)
	name = "[initial(name)] (combined)"
	to_chat(user, SPAN_NOTICE("You overlay \the [src] and \the [initial(supplied.name)], combining the print records."))
	return 1

/obj/item/sample/attackby(var/obj/O, var/mob/user)
	if(O.type == src.type)
		user.unEquip(O)
		if(merge_evidence(O, user))
			qdel(O)
		return TRUE
	else if (O.ispen())
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("The label can be at most [MAX_NAME_LEN] characters long."))
		else
			to_chat(user, SPAN_NOTICE("You set the label to \"[tmp_label]\"."))
			label_text = tmp_label
			update_name_label()
		return TRUE
	return ..()

/obj/item/sample/proc/update_name_label()
	if(label_text == null)
		name = initial(name)
	else
		name = "[initial(name)] ([label_text])"


/atom/proc/get_swab_name()
  return "\the [initial(name)]"

/obj/machinery/door/get_swab_name()
  if(name != initial(name))
    return "\the [initial(name)]: [name]"
  return ..()

/obj/item/sample/fibers
	name = "fiber bag"
	desc = "Used to hold fiber evidence for the detective."
	desc_info = "Holds various fibre evidence. Place it in a slide and the slide into a microscope to check them."
	icon_state = "fiberbag"

/obj/item/sample/print
	name = "fingerprint card"
	desc = "Records a set of fingerprints."
	desc_info = "A sample card for fingerprints. Risks putting your own prints on it if touched without gloves.\
	\nPlace the card in a microscope to examine the contents. \
	\nUse in hand to put your prints on it.\nTarget hands and click another creature to take their prints."
	icon = 'icons/obj/card.dmi'
	icon_state = "fingerprint0"
	item_state = "paper"

/obj/item/sample/print/attack_self(var/mob/user)
	if(LAZYLEN(evidence))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.gloves)
		to_chat(user, SPAN_WARNING("Take \the [H.gloves] off first."))
		return

	to_chat(user, SPAN_NOTICE("You firmly press your fingertips onto the card."))
	var/fullprint = H.get_full_print()
	LAZYSET(evidence, fullprint, fullprint)
	LAZYADD(source, "[H.name]")
	name = "[initial(name)] (\the [H])"
	icon_state = "fingerprint1"

/obj/item/sample/print/attack(var/mob/living/M, var/mob/user, var/target_zone)

	if(!ishuman(M))
		return ..()

	if(LAZYLEN(evidence))
		return 0

	var/mob/living/carbon/human/H = M

	if(H.gloves)
		to_chat(user, SPAN_WARNING("\The [H] is wearing gloves."))
		return 1

	if(user != H && H.a_intent != "help" && !H.lying)
		user.visible_message(SPAN_DANGER("\The [user] tries to take prints from \the [H], but they move away."))
		return 1

	if(target_zone == BP_R_HAND || target_zone == BP_L_HAND)
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name[BP_R_HAND]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name[BP_L_HAND]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			to_chat(user, SPAN_WARNING("They don't have any hands."))
			return 1
		user.visible_message("[user] takes a copy of \the [H]'s fingerprints.")
		var/fullprint = H.get_full_print()
		LAZYSET(evidence, fullprint, fullprint)
		copy_evidence(src)
		LAZYADD(source, "[H.name]")
		name = "[initial(name)] (\the [H])"
		icon_state = "fingerprint1"
		return 1
	return 0

/obj/item/sample/print/copy_evidence(var/atom/supplied)
	if(supplied.fingerprints && supplied.fingerprints.len)
		for(var/print in supplied.fingerprints)
			LAZYSET(evidence, print, supplied.fingerprints[print])
		supplied.fingerprints.Cut()

/obj/item/forensics/sample_kit
	name = "fiber collection kit"
	desc = "A magnifying glass and tweezers. Used to lift suit fibers."
	desc_info = "Click drag it on to an object to collect evidence. Alternatively click on non-help intent."
	icon_state = "m_glass"
	w_class = ITEMSIZE_SMALL
	flags = NOBLUDGEON
	var/evidence_type = "fiber"
	var/evidence_path = /obj/item/sample/fibers

/obj/item/forensics/sample_kit/proc/can_take_sample(var/mob/user, var/atom/supplied)
	return (supplied.suit_fibers && supplied.suit_fibers.len)

/obj/item/forensics/sample_kit/proc/take_sample(var/mob/user, var/atom/supplied)
	var/obj/item/sample/S = new evidence_path(get_turf(user), supplied)
	to_chat(user, SPAN_NOTICE("You transfer [S.evidence.len] [evidence_type]\s to \the [S]."))

/obj/item/forensics/sample_kit/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return
	add_fingerprint(user)
	if(can_take_sample(user, A))
		take_sample(user,A)
		return 1
	else
		to_chat(user, SPAN_WARNING("You are unable to locate any [evidence_type]s on \the [A]."))
		return ..()

/obj/item/forensics/sample_kit/resolve_attackby(atom/A, mob/user, var/click_parameters)
	if(user.a_intent != I_HELP)
		return FALSE
	. = ..()

/obj/item/forensics/sample_kit/MouseDrop(atom/over)
	var/mob/M = loc
	if(ismob(M) && (M.get_active_hand() == src || M.get_inactive_hand() == src))
		afterattack(over, usr, TRUE)

/obj/item/forensics/sample_kit/powder
	name = "fingerprint powder"
	desc = "A jar containing aluminum powder and a specialized brush."
	icon_state = "dust"
	evidence_type = "fingerprint"
	evidence_path = /obj/item/sample/print

/obj/item/forensics/sample_kit/powder/can_take_sample(var/mob/user, var/atom/supplied)
	return (supplied.fingerprints && supplied.fingerprints.len)
