/obj/item/organ/internal/augment
	name = "augment"
	icon = 'icons/obj/organs/augments.dmi'
	icon_state = "augment"
	parent_organ = BP_CHEST
	organ_tag = "augment"
	robotic = ROBOTIC_MECHANICAL
	emp_coeff = 2
	is_augment = TRUE

	species_restricted = list(
		SPECIES_HUMAN_OFFWORLD,
		SPECIES_HUMAN,
		SPECIES_IPC_BISHOP,
		SPECIES_IPC_G1,
		SPECIES_IPC_G2,
		SPECIES_IPC_SHELL,
		SPECIES_IPC_XION,
		SPECIES_IPC_ZENGHU,
		SPECIES_IPC,
		SPECIES_SKRELL_AXIORI,
		SPECIES_SKRELL,
		SPECIES_TAJARA_MSAI,
		SPECIES_TAJARA_ZHAN,
		SPECIES_TAJARA,
		SPECIES_UNATHI,
	)

	robotic_sprite = FALSE

	var/cooldown = 150
	var/action_button_icon = "augment"
	var/activable = FALSE
	var/bypass_implant = FALSE
	/// If true, will make parent limb not count as broken, as long as it's not bruised (40%) and not broken (0%)
	var/supports_limb = FALSE

/obj/item/organ/internal/augment/Initialize()
	if(robotic == ROBOTIC_MECHANICAL)
		robotize()
	. = ..()

/obj/item/organ/internal/augment/refresh_action_button()
	. = ..()
	if(.)
		if(activable)
			action.button_icon_state = action_button_icon
			if(action.button)
				action.button.update_icon()

/obj/item/organ/internal/augment/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_WARNING("\The [src] is still recharging!"))
			return FALSE

		if(use_check_and_message(owner))
			return FALSE

		if(is_bruised())
			if(do_bruised_act())
				return FALSE

		if(is_broken())
			if(do_broken_act())
				return FALSE

		if(!bypass_implant)
			for (var/obj/item/implant/anti_augment/I in owner)
				if (I.implanted)
					return FALSE

		owner.last_special = world.time + cooldown
		return TRUE

/obj/item/organ/internal/augment/proc/do_broken_act()
	spark(get_turf(owner), 3)
	return TRUE

/obj/item/organ/internal/augment/proc/do_bruised_act()
	spark(get_turf(owner), 3)
	return FALSE

/obj/item/organ/internal/augment/bioaug
	name = "bioaugment"
	icon = 'icons/obj/organs/bioaugs.dmi'
	icon_state = "boosted_heart"
	robotic = FALSE
	species_restricted = list(
		SPECIES_HUMAN_OFFWORLD,
		SPECIES_HUMAN,
	)
