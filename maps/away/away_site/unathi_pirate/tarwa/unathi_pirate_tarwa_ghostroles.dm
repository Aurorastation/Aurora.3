/datum/ghostspawner/human/tarwa
	short_name = "tarwa_crew"
	name = "Tarwa Conglomerate Crewman"
	desc = "You are a pirate, serving with the enigmetic Tarwa Conglomerate - also called the living-dead fleet. Obey your captain, defend your ship and crew, and survive another day. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")

	spawnpoints = list("tarwa_crew")
	max_count = 3
	uses_species_whitelist = FALSE

	outfit = /datum/outfit/admin/tarwa
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tarwa Conglomerate Crewman"
	special_role = "Tarwa Conglomerate Crewman"
	respawn_flag = null
	extra_languages = list(LANGUAGE_AZAZIBA)
	away_site = TRUE
	welcome_message = "The Tarwa Conglomerate is a pirate group, largely operating towards the southeastern edge of the Spur. Little is known of them to others, and your ship likely thrives on this mystique. The wiki page for Unathi Piracy contains more information on this group, and how they operate. NOTE - If you spawned with a Diona limb and are missing a hand or foot, use the 'Detach Nymph' verb and then reattach the nymph to fix this."

/datum/ghostspawner/human/tarwa/diona
	short_name = "tarwa_diona"
	name = "Tarwa Conglomerate Diona Crewman"
	desc = "You are a diona gestalt serving with the pirate crew of the Tarwa Conglomerate, and likely grown among their number. Obey your captain, defend your ship and crew, and survive another day. NOT AN ANTAGONIST! Do not act as such."
	max_count = 1
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = TRUE
	spawnpoints = list("tarwa_diona")
	outfit = /datum/outfit/admin/tarwa/diona
	welcome_message = "As a diona gestalt of the Tarwa Conglomerate, most of the blood you have consumed would likely be from Unathi pirates, meaning that your gestalt would likely resemble an Unathi to some degree. Remember, even though you are a pirate, you are still \
	a diona gestalt, and should roleplay diona conditional pacifism accordingly."

/datum/ghostspawner/human/tarwa/captain
	short_name = "tarwa_captain"
	name = "Tarwa Conglomerate Captain"
	desc = "You are the captain of a pirate crew of the Tarwa Conglomerate - also called the living-dead fleet. Lead your crew to profit and glory, for the sake of your fleet. NOT AN ANTAGONIST! Do not act as such. NOTE - If you spawned with a Diona limb and are missing a hand or foot, use the 'Detach Nymph' verb and then reattach the nymph to fix this."
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Tarwa Conglomerate Captain"
	special_role = "Tarwa Conglomerate Captain"
	spawnpoints = list("tarwa_captain")
	outfit = /datum/outfit/admin/tarwa/captain

/datum/outfit/admin/tarwa
	name = "Tarwa Conglomerate Crew"
	uniform = /obj/item/clothing/under/unathi
	shoes = /obj/item/clothing/shoes/caligae
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	accessory = /obj/item/clothing/accessory/storage/webbing
	gloves = /obj/item/clothing/gloves/unathi
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1
	)

/datum/outfit/admin/tarwa/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(!istype(H))
		return
	for(var/organ in H.organs_by_name)
		var/obj/item/organ/external/O = H.organs_by_name[organ]
		if(!O || organ == BP_HEAD || organ == BP_CHEST || organ == BP_GROIN)
			continue
		if(prob(25))
			O.AddComponent(/datum/component/nymph_limb)
			var/datum/component/nymph_limb/D = O.GetComponent(/datum/component/nymph_limb)
			if(D)
				D.nymphize(H, O.limb_name, TRUE)

/datum/outfit/admin/tarwa/get_id_access()
	return list(access_unathi_pirate, access_external_airlocks)

/datum/outfit/admin/tarwa/diona
	name = "Tarwa Conglomerate Diona"
	suit = /obj/item/clothing/accessory/poncho/green
	head = /obj/item/clothing/head/bandana/pirate
	backpack_contents = list(/obj/item/device/uv_light = 1)

/datum/outfit/admin/tarwa/diona/post_equip(mob/living/carbon/human/H, visualsOnly) //don't give a diona a diona nymph limb. idiot.
	return

/datum/outfit/admin/tarwa/captain
	name = "Tarwa Conglomerate Captain"
	suit = /obj/item/clothing/suit/storage/toggle/asymmetriccoat
	gloves = /obj/item/clothing/gloves/green/unathi
	accessory = /obj/item/clothing/accessory/holster/thigh
	accessory_contents = list(/obj/item/gun/energy/pistol/hegemony = 1)
