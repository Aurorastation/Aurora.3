GLOBAL_DATUM(loners, /datum/antagonist/loner)

/datum/antagonist/loner
	id = MODE_LONER
	role_text = "Loner"
	role_text_plural = "Loners"
	bantype = "loner"
	antag_indicator = "loner"
	landmark_id = "lonerspawn"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudloner"
	required_age = 7

	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

	faction = "syndicate"

	id_type = /obj/item/card/id/syndicate

	/// List of additional psi powers to give the loner.
	var/list/singleton/psionic_power/additional_powers = list(
		/singleton/psionic_power/zona_absorption,
		/singleton/psionic_power/awaken,
		/singleton/psionic_power/psi_drain)

/datum/antagonist/loner/New()
	..()
	welcome_text = "You are a Loner, someone underequipped to deal with the [station_name()]. You will probably not survive for the whole round, so don't sweat it if you die!<br> \
	You have a special psionic power that allows you to absorb a psionic energy from a being's Zona Bovinae, granting you an extra point to be used in the Point Shop."
	GLOB.loners = src

/datum/antagonist/loner/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for(var/obj/item/I in player)
		if(istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/obj/outfit/admin/syndicate/mercenary/loner, FALSE)
	player.equipOutfit(/obj/outfit/admin/syndicate/mercenary/loner, FALSE)
	player.set_psi_rank(PSI_RANK_HARMONIOUS)

	for (var/power in additional_powers)
		astype(GET_SINGLETON(power), /singleton/psionic_power)?.apply(player)

	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	// Offship antags wipe skill components so that they can bypass skill restrictions entirely.
	for(var/datum/component/skill/skill in player._datum_components)
		qdel(skill)

	return TRUE
