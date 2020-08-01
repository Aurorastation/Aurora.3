var/datum/antagonist/deathsquad/mercenary/commandos

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."
	id_type = /obj/item/card/id/syndicate_ert

	faction = "syndicate"

	bantype = "syndicate-commando"

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/deathsquad/mercenary/New()
	..(1)
	commandos = src

/datum/antagonist/deathsquad/mercenary/equip(var/mob/living/carbon/human/player)
	if(!..())
		return FALSE

	for (var/obj/item/I in player)
		if (istype(I, /obj/item/implant))
			continue
		player.drop_from_inventory(I)
		if(I.loc != player)
			qdel(I)

	player.preEquipOutfit(/datum/outfit/admin/deathsquad/syndicate, FALSE)
	player.equipOutfit(/datum/outfit/admin/deathsquad/syndicate, FALSE)
	player.force_update_limbs()
	player.update_eyes()
	player.regenerate_icons()

	give_codewords(player)
	return TRUE