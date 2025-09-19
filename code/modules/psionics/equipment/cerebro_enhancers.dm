//Psi-boosting item (antag only)
/obj/item/clothing/head/helmet/space/psi_amp
	name = "cerebro-energetic enhancer"
	desc = "A matte-black, eyeless cerebro-energetic enhancement helmet. It uses highly sophisticated, and illegal, techniques to drill into your brain and install psi-infected AIs into the fluid cavities between your lobes."
	action_button_name = "Install Boosters"
	icon = 'icons/obj/clothing/hats.dmi'
	contained_sprite = FALSE
	icon_state = "amp"

	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)

	var/operating = FALSE
	var/boosted_rank = PSI_RANK_HARMONIOUS
	var/boosted_psipower = 120

/obj/item/clothing/head/helmet/space/psi_amp/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Due to the nature of this headgear, it will also protect you from the pressure of space."
	. += "When installing the boosters, your chosen faculties will be boosted to the headgear's maximum potential, but the unchosen faculties will also be boosted somewhat."

/obj/item/clothing/head/helmet/space/psi_amp/lesser
	name = "psionic amplifier"
	desc = "A crown-of-thorns cerebro-energetic enhancer that interfaces directly with the brain, isolating and strengthening psionic signals. It kind of looks like a tiara."
	flags_inv = 0
	body_parts_covered = 0

	boosted_rank = PSI_RANK_HARMONIOUS
	boosted_psipower = 50

/obj/item/clothing/head/helmet/space/psi_amp/Initialize()
	. = ..()
	verbs += /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate

/obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate()
	set name = "Remove Psi-Amp"
	set desc = "Removes your psi-amp."
	set category = "Abilities"
	set src in usr

	if(operating)
		return

	if(canremove)
		return

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.head != src)
		canremove = TRUE
		return

	to_chat(H, SPAN_WARNING("You feel a strange tugging sensation as \the [src] begins removing the slave-minds from your brain..."))
	playsound(H, 'sound/weapons/circsawhit.ogg', 50, 1, -1)
	operating = TRUE

	sleep(80)

	if(H.psi)
		H.psi.reset()

	to_chat(H, SPAN_NOTICE("\The [src] chimes quietly as it finishes removing the slave-minds from your brain."))

	canremove = TRUE
	operating = FALSE

	verbs -= /obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate
	verbs |= /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate

	action_button_name = "Integrate Psionic Amplifier"
	H.update_action_buttons()

	set_light(0)

/obj/item/clothing/head/helmet/space/psi_amp/Move()
	var/lastloc = loc
	. = ..()
	if(.)
		var/mob/living/carbon/human/H = lastloc
		if(istype(H) && H.psi)
			H.psi.reset()
		H = loc
		if(!istype(H) || H.head != src)
			canremove = TRUE

/obj/item/clothing/head/helmet/space/psi_amp/proc/integrate()
	set name = "Integrate Psionic Amplifier"
	set desc = "Enhance your brainpower."
	set category = "Abilities"
	set src in usr

	if(operating)
		return

	if(!canremove)
		return

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.head != src)
		to_chat(usr, SPAN_WARNING("\The [src] must be worn on your head in order to be activated."))
		return

	canremove = FALSE
	operating = TRUE
	to_chat(H, SPAN_WARNING("You feel a series of sharp pinpricks as \the [src] anaesthetises your scalp before drilling down into your brain."))
	playsound(H, 'sound/weapons/circsawhit.ogg', 50, 1, -1)

	sleep(80)

	H.set_psi_rank(boosted_rank, temporary = TRUE)
	if(H.psi)
		H.psi.max_stamina = boosted_psipower
		H.psi.stamina = H.psi.max_stamina
		H.psi.update(force = TRUE)

	to_chat(H, SPAN_NOTICE("You experience a brief but powerful wave of deja vu as \the [src] finishes modifying your brain."))
	verbs |= /obj/item/clothing/head/helmet/space/psi_amp/proc/deintegrate
	verbs -= /obj/item/clothing/head/helmet/space/psi_amp/proc/integrate
	operating = FALSE
	action_button_name = "Remove Psionic Amplifier"
	H.update_action_buttons()
	H.client.init_verbs()

	set_light(0.5, 0.1, 3, 2, l_color = "#880000")

/obj/item/psionic_jumpstarter
	name = "psionic jumpstarter"
	desc = "Use this to jumpstart your psionic rank to Psionically Harmonious, enabling you to use the Psionic Point Shop and buy offensive psionic abilities. \
			This won't work on species with no Zona Bovinae, like synthetics, vaurcae or dionae! This item is definitely not canon."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "amp"
	contained_sprite = FALSE

/obj/item/psionic_jumpstarter/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.has_zona_bovinae())
		to_chat(H, SPAN_WARNING("You don't have a Zona Bovinae!"))
		return

	if(H.psi && H.psi.get_rank() >= PSI_RANK_HARMONIOUS)
		to_chat(H, SPAN_WARNING("You've already awakened your psionic potential!"))
		return

	H.set_psi_rank(PSI_RANK_HARMONIOUS)
	H.psi.psi_points = 8
	to_chat(H, SPAN_NOTICE("You've awakened your psionic potential. Note that you have a reduced point pool than usual."))
	qdel(src)
