/datum/ghostspawner/human/zaza_villager
	name = "Unathi Villager"
	short_name = "zaza_villager"
	desc = "Live your life in a rural village on Moghes."
	tags = list("External")
	welcome_message = "You are an Unathi peasant in the Zazalai Mountains. Survive another day against the encroaching Wasteland."

	spawnpoints = list("zaza_villager")
	max_count = 8

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/unathi_village
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Moghresian Villager"
	special_role = "Moghresian Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE
	enabled = FALSE

/datum/ghostspawner/human/zaza_villager/post_spawn(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return
	H.apply_damage(rand(1,20), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	if(prob(25))
		var/obj/item/organ/internal/stomach/stomach = H.internal_organs_by_name[BP_STOMACH]
		if(stomach)
			stomach.ingested.add_reagent(/singleton/reagent/toxin/phoron, rand(0.3,5))

/datum/ghostspawner/human/izaku_killsquad
	name = "Izaku Warrior"
	short_name = "izaku_killsquad"
	desc = "As a warrior of the Izaku Clan, destroy the aliens who defile Moghes with their presence!"
	tags = list("External")
	welcome_message = "You are an Unathi peasant in the Zazalai Mountains. Survive another day against the encroaching Wasteland."

	spawnpoints = list("izaku_killsquad")
	max_count = 12

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/izaku_killsquad
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Izaku Warrior"
	special_role = "Izaku Warrior"
	respawn_flag = null

	uses_species_whitelist = FALSE
	enabled = FALSE

/obj/outfit/admin/izaku_killsquad
	name = "Izaku Warrior"

	uniform = /obj/item/clothing/under/unathi/zazali
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	suit = /obj/item/clothing/suit/armor/unathi
	head = /obj/item/clothing/head/helmet/unathi
	suit_store = /obj/item/gun/projectile/automatic/tempestsmg
	back = /obj/item/material/sword/longsword
	shoes = /obj/item/clothing/shoes/sandals/caligae
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	id = null
	l_ear = /obj/item/device/radio/headset/syndicate
	belt = /obj/item/storage/belt/military
	belt_contents = list(
		/obj/item/ammo_magazine/spitterpistol = 1,
		/obj/item/ammo_magazine/tempestsmg = 2
	)

/obj/outfit/admin/izaku_killsquad/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	new /obj/vehicle/bike/motor/sand(H.loc)
