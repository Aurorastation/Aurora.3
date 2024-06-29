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
	enabled = TRUE
	password = "thissucks"

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
	welcome_message = "The Horizon's crew has learned of your lord's betrayal of the Nralakk mission. Ensure no witnesses escape Izilukh."

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
		/obj/item/ammo_magazine/spitterpistol = 2,
		/obj/item/ammo_magazine/tempestsmg = 2
	)

/obj/outfit/admin/izaku_killsquad/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	new /obj/vehicle/bike/motor/sand(get_turf(H))

/datum/ghostspawner/human/izaku_killsquad/second
	name = "Killsquad Second Wave"
	short_name = "killsquad_2"

/datum/ghostspawner/human/izaku_escort
	name = "Izaku Escort"
	short_name = "izaku_escort"
	desc = "Escort the Horizon humanitarian crew. Avoid any complications."
	tags = list("External")
	spawnpoints = list("escort")
	welcome_message = "The Horizon's crew has arrived. Keep them out of trouble, and ensure they don't learn anything they shouldn't."
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/izaku_escort
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	max_count = 4

	assigned_role = "Izaku Escort"
	special_role = "Izaku Escort"
	respawn_flag = null

	uses_species_whitelist = FALSE
	enabled = TRUE
	password = "nothingtoseehere"

/obj/outfit/admin/izaku_escort
	uniform = /obj/item/clothing/under/unathi/zazali
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	suit = /obj/item/clothing/suit/armor/unathi/hegemony
	head = /obj/item/clothing/head/helmet/unathi/hegemony
	shoes = /obj/item/clothing/shoes/sandals/caligae
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	id = /obj/item/card/id/goon
	l_ear = /obj/item/device/radio/headset/syndicate
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/satchel/leather
	belt_contents = list(
		/obj/item/ammo_magazine/spitterpistol = 2,
		/obj/item/melee/energy/sword/hegemony = 1,
		/obj/item/grenade/frag = 2
	)

/obj/outfit/admin/izaku_escort/get_id_access(mob/living/carbon/human/H)
	return list(ACCESS_SYNDICATE)

/datum/ghostspawner/human/izaku_escort/guard
	name = "Izaku Guard"
	short_name = "izaku_guard"
	desc = "Escort the Horizon humanitarian crew. Avoid any complications."
	tags = list("External")
	spawnpoints = list("guard")
	welcome_message = "Your lord has ordered you to learn the true intent of these nefarious Skrell. Guard your surviving prisoner, and ensure no complications."
	max_count = 2
	assigned_role = "Guard"
	special_role = "Guard"
	enabled = FALSE
	password = "warcrimes"

/datum/ghostspawner/human/skrurvivor
	name = "Nralakk Survivor"
	short_name = "skrurvivor"
	desc = "The last survivor of the Federation team."
	tags = list("External")
	spawnpoints = list("warble")
	max_count = 1
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nralakk Humanitarian Worker"
	special_role = "Nralakk Humanitarian Worker"
	respawn_flag = null
	outfit = /obj/outfit/admin/skrurvivor

	uses_species_whitelist = FALSE
	enabled = FALSE
	password = "warble"

/obj/outfit/admin/skrurvivor
	uniform = /obj/item/clothing/under/skrell/nralakk/oqi/med
	shoes = /obj/item/clothing/shoes/jackboots/kala
	id = /obj/item/card/id

/obj/outfit/admin/skrurvivor/get_id_access()
	return list(ACCESS_SKRELL)
