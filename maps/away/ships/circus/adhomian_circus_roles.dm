//adhomian circus roles

/datum/outfit/admin/adhomian_circus
	id = /obj/item/card/id

	l_ear = /obj/item/device/radio/headset/ship
	r_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/adhomian_circus/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/adhomian_circus/ringmaster
	short_name = "adhomian_circus_ringmaster"
	name = "Adhomian Circus Ringmaster"
	desc = "Be the master of ceremonies for the adhomian circus."
	tags = list("External")

	spawnpoints = list("adhomian_circus_ringmaster")
	max_count = 1

	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/ringmaster

	assigned_role = "Adhomian Circus Ringmaster"
	special_role = "Adhomian Circus Ringmaster"

	uses_species_whitelist = TRUE

/datum/outfit/admin/adhomian_circus/ringmaster
	name = "Adhomian Circus Ringmaster"

	uniform = /obj/item/clothing/under/ringmaster
	shoes = /obj/item/clothing/shoes/tajara/jackboots/ringmaster
	head = /obj/item/clothing/head/that/ringmaster
	suit = /obj/item/clothing/suit/storage/ringmaster

	r_hand = /obj/item/cane


/datum/ghostspawner/human/adhomian_circus/strongman
	short_name = "adhomian_circus_strongman"
	name = "Adhomian Circus Strongzhan"
	desc = "Show the galaxy your might by performing feats of strength."
	tags = list("External")

	spawnpoints = list("adhomian_circus_strongman")
	max_count = 1

	possible_species = list(SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/strongman

	assigned_role = "Adhomian Circus Strongzhan"
	special_role = "Adhomian Circus Strongzhan"

/datum/outfit/admin/adhomian_circus/strongman
	name = "Adhomian Circus Ringmaster"

	uniform = /obj/item/clothing/under/strongman
	shoes = /obj/item/clothing/shoes/sandal/strongman


/datum/ghostspawner/human/adhomian_circus/tamer
	short_name = "adhomian_circus_tamer"
	name = "Adhomian Circus Tamer"
	desc = "Control Adhomian animals and make them do tricks."
	tags = list("External")

	spawnpoints = list("adhomian_circus_tamer")
	max_count = 1

	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/tamer

	assigned_role = "Adhomian Circus Tamer"
	special_role = "Adhomian Circus Tamer"

/datum/outfit/admin/adhomian_circus/tamer
	name = "Adhomian Circus Tamer"

	uniform = /obj/item/clothing/under/tamer
	shoes = /obj/item/clothing/shoes/tajara/jackboots
	belt = /obj/item/melee/whip
	accessory = /obj/item/clothing/accessory/holster/hip/brown

	accessory_contents = list(/obj/item/gun/projectile/pistol/adhomai = 1)


/datum/ghostspawner/human/adhomian_circus/fortune_teller
	short_name = "adhomian_circus_fortune_teller"
	name = "Adhomian Circus Fortune Teller"
	desc = "Read the future of the circus-goers."
	tags = list("External")

	spawnpoints = list("adhomian_circus_fortune_teller")
	max_count = 1

	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/fortune_teller

	assigned_role = "Adhomian Circus Fortune Teller"
	special_role = "Adhomian Circus Fortune Teller"


/datum/outfit/admin/adhomian_circus/fortune_teller
	name = "Adhomian Circus Fortune Teller"

	uniform = /obj/item/clothing/under/dress/tajaran/fortune
	shoes = /obj/item/clothing/shoes/sandal


/datum/ghostspawner/human/adhomian_circus/clown
	short_name = "adhomian_circus_clown"
	name = "Adhomian Circus clown"
	desc = "Try to be funny (or annoying) as the circus clown."
	tags = list("External")

	spawnpoints = list("adhomian_circus_clown")
	max_count = 1

	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/clown

	assigned_role = "Adhomian Circus Clown"
	special_role = "Adhomian Circus Clown"


/datum/outfit/admin/adhomian_circus/clown
	name = "Adhomian Circus Clown"

	uniform = /obj/item/clothing/under/clown
	head = /obj/item/clothing/head/clown
	shoes = /obj/item/clothing/shoes/clown
	mask = /obj/item/clothing/mask/clown
	l_pocket = /obj/item/bikehorn


/datum/ghostspawner/human/adhomian_circus/crew
	short_name = "adhomian_circus_crew"
	name = "Adhomian Circus Crew"
	desc = "Crew the circus, help its crew, and serve the circus-goers."
	tags = list("External")

	spawnpoints = list("adhomian_circus_crew")
	max_count = 3

	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	outfit = /datum/outfit/admin/adhomian_circus/ringmaster

	assigned_role = "Adhomian Circus Crew"
	special_role = "Adhomian Circus Crew"

/datum/outfit/admin/adhomian_circus/crew
	name = "Adhomian Circus Crew"

	uniform = /obj/item/clothing/under/serviceoveralls
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/tajara/jackboots

