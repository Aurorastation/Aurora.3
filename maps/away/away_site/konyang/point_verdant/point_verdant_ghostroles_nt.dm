
// ----------------------------- BASE

/obj/outfit/admin/raccoon_city
	uniform = /obj/item/clothing/under/rank/liaison
	id = /obj/item/card/id
	back = list(
		/obj/item/storage/backpack/duffel,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/leather/withwallet,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/satchel/pocketbook,
	)
	glasses = list(
		/obj/item/clothing/glasses/fakesunglasses/aviator,
		/obj/item/clothing/glasses/fakesunglasses/prescription,
		/obj/item/clothing/glasses/sunglasses/aviator,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/safety/goggles,
	)
	r_pocket = /obj/item/storage/wallet/random
	shoes = /obj/item/clothing/shoes/laceup
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca
	)

/obj/outfit/admin/raccoon_city/get_id_access()
	return list(ACCESS_KONYANG_CORPORATE)

// ----------------------------- SCIENTIST

/datum/ghostspawner/human/nt_scientist
	name = "Nanotrasen Laboratory Scientist"
	desc = "Research Hylemnomil-Zeta, a dangerous but potentially miraculous and Spur-changing artificial chemical."
	short_name = "nt_sci"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "nt_sci"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Scientist"
	special_role = "Nanotrasen Laboratory Scientist"
	spawnpoints = list("nt_sci")
	outfit = /obj/outfit/admin/raccoon_city/nt_scientist
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_scientist
	name = "igs - NT Scientist"
	identifier = "nt_sci"

/obj/outfit/admin/raccoon_city/nt_scientist
	name = "NT Scientist"
	uniform = /obj/item/clothing/under/rank/scientist
	suit = list(
		/obj/item/clothing/suit/storage/toggle/labcoat/nt,
		/obj/item/clothing/suit/storage/toggle/labcoat/nt/letterman,
	)
	glasses = list(
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/safety/goggles,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/clothing/glasses/hud/health/aviator,
	)
	belt = list(
		/obj/item/storage/belt/medical/full,
		/obj/item/storage/belt/medical/full/inaprov,
		/obj/item/storage/belt/medical/paramedic/full,
		/obj/item/storage/belt/medical/paramedic/combat/full,
	)
	shoes = list(
		/obj/item/clothing/shoes/sneakers/tip,
		/obj/item/clothing/shoes/sneakers/hitops/tip,
		/obj/item/clothing/shoes/sneakers/medsci,
	)
	gloves = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/gloves/latex/nitrile,
	)
	backpack_contents = list(
		/obj/item/modular_computer/laptop/preset,
		/obj/item/storage/firstaid,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/bicaridine,
		/obj/item/reagent_containers/glass/bottle/dermaline,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus
	)

// ----------------------------- LABS DIRECTOR

/datum/ghostspawner/human/nt_labs_director
	name = "Nanotrasen Laboratory Director"
	desc = "Direct Nanotrasen Research Facility Omega's experiment on Hylemnomil."
	short_name = "nt_director"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 1
	password = "albertwesker"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Director"
	special_role = "Nanotrasen Laboratory Director"
	spawnpoints = list("nt_director")
	outfit = /obj/outfit/admin/raccoon_city/nt_scientist/nt_labs_director
	respawn_flag = null

/obj/outfit/admin/raccoon_city/nt_scientist/nt_labs_director
	name = "NT Facility Director"
	head = /obj/item/clothing/head/beret/red
	accessory = /obj/item/clothing/accessory/holster/thigh
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/cmoalt
	belt = null
	backpack_contents = list(
		/obj/item/gun/projectile/sec/lethal,
		/obj/item/reagent_containers/glass/bottle/trioxin,
		/obj/item/modular_computer/laptop/preset,
		/obj/item/stamp/rd,
		/obj/item/reagent_containers/hypospray/cmo,
		/obj/item/folder/white,
	)

/obj/effect/ghostspawpoint/nt_director
	name = "igs - NT Facility Director"
	identifier = "nt_director"

// ----------------------------- LABS LEAD

/datum/ghostspawner/human/nt_labs_lead
	name = "Nanotrasen Laboratory Project Lead"
	desc = "Supervise the Nanotrasen Research Facility Omega's experiment on Hylemnomil."
	short_name = "nt_plead"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 1
	password = "eelabslead"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Project Lead"
	special_role = "Nanotrasen Laboratory Project Lead"
	spawnpoints = list("nt_plead")
	outfit = /obj/outfit/admin/raccoon_city/nt_scientist/ee_lead_scientist
	respawn_flag = null

/obj/outfit/admin/raccoon_city/nt_scientist/ee_lead_scientist
	name = "NT Lead Scientist"
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/nt/letterman
	belt = null
	backpack_contents = list(
		/obj/item/modular_computer/laptop/preset,
		/obj/item/reagent_containers/hypospray,
		/obj/item/storage/firstaid/adv,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/reagent_containers/glass/bottle/perconol,
		/obj/item/reagent_containers/glass/bottle/butazoline,
		/obj/item/reagent_containers/glass/bottle/dermaline,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus,
		/obj/item/reagent_containers/glass/bottle/peridaxon
	)

/obj/effect/ghostspawpoint/ee_lead_scientist
	name = "igs - NT Lead Scientist"
	identifier = "nt_plead"

// ----------------------------- INTERN

/datum/ghostspawner/human/nt_intern
	name = "Nanotrasen Laboratory Intern"
	desc = "Serve coffee to your corporate overlords. Be noticed in the hopes for a promotion. Help out. Avoid dying a horrible death."
	short_name = "nt_intern"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 1
	password = "nt_intern"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Intern"
	special_role = "Nanotrasen Laboratory Intern"
	spawnpoints = list("nt_intern")
	outfit = /obj/outfit/admin/raccoon_city/nt_intern
	respawn_flag = null

/obj/outfit/admin/raccoon_city/nt_intern
	name = "NT Intern"

	backpack_contents = list(
		/obj/item/modular_computer/laptop/preset,
		/obj/item/storage/box/cups,
		/obj/item/reagent_containers/glass/beaker/pitcher/coffee
	)

/obj/effect/ghostspawpoint/nt_intern
	name = "igs - NT Intern"
	identifier = "nt_intern"

// ----------------------------- GUARD

/datum/ghostspawner/human/nt_guard
	name = "Nanotrasen Laboratory Guard"
	desc = "You want to think that you're going to prevent dangerous experiments from getting loose, but in reality you're just lounging around at the checkpoint. \
			Today will be just another one of those days. Right...?"
	short_name = "nt_guard"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "nt_guard"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Guard"
	special_role = "Nanotrasen Laboratory Facility Guard"
	spawnpoints = list("nt_guard")
	outfit = /obj/outfit/admin/raccoon_city/nt_guard
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_guard
	name = "igs - NT Guard"
	identifier = "nt_guard"

/obj/outfit/admin/raccoon_city/nt_guard
	name = "NT Guard"

	uniform = /obj/item/clothing/under/rank/security/pmc/nexus
	suit = /obj/item/clothing/suit/armor/carrier
	belt = list(
		/obj/item/storage/belt/security/full,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	accessory = /obj/item/clothing/accessory/holster/thigh
	belt = /obj/item/storage/belt/security
	backpack_contents = list(
		/obj/item/gun/projectile/sec/lethal,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/melee/baton/loaded,
		/obj/item/handcuffs,
		/obj/item/handcuffs
	)

// ----------------------------- ASHLEY

/*/datum/ghostspawner/human/ashley
	name = "Patient Zero"
	desc = "A girl with almost no friends or family, and the perfect target for an abduction. Nobody has noticed you're gone, but you want to live. Einstein \
			will try to do terrible things to you. Can someone as insignificant as you change the course of history still?"
	short_name = "ee_ashley"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "AshleyBestWaifu"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Patient Zero"
	special_role = "Patient Zero"
	spawnpoints = list("ee_ashley")
	outfit = /obj/outfit/admin/raccoon_city/patient_zero
	max_count = 1
	respawn_flag = null

/obj/outfit/admin/raccoon_city/patient_zero
	name = "Patient Zero"
	uniform = /obj/item/clothing/under/rank/medical/generic
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	id = null
	back = null
	l_pocket = /obj/item/clothing/head/pin/ribbon/back
	r_pocket = /obj/item/storage/wallet/random
	shoes = /obj/item/clothing/shoes/sneakers*/

/obj/effect/ghostspawpoint/ashley
	name = "igs - Ashley"
	identifier = "ee_ashley"

// ----------------------------- ENGINEER

/datum/ghostspawner/human/nt_engineer
	name = "Nanotrasen Laboratory Engineer"
	desc = "Be an engineer for the Nanotrasen laboratories."
	short_name = "nt_engineer"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "nt_engineer"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Engineer"
	special_role = "nt_engineer Facility Engineer"
	spawnpoints = list("nt_engineer")
	outfit = /obj/outfit/admin/raccoon_city/nt_engineer
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_engineer
	name = "igs - NT Engineer"
	identifier = "nt_engineer"

/obj/outfit/admin/raccoon_city/nt_engineer
	name = "NT Engineer"
	uniform = /obj/item/clothing/under/rank/scientist
	suit = list(
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/hazardvest/green,
		/obj/item/clothing/suit/storage/hazardvest/white,
	)
	gloves = list(
		/obj/item/clothing/gloves/brown,
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/yellow,
	)
	belt = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/very_full,
		/obj/item/storage/belt/utility/atmostech,
	)
	head = list(
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/hardhat/green,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	backpack_contents = list(

	)

// ----------------------------- MACHINIST

/datum/ghostspawner/human/nt_machinist
	name = "Nanotrasen Laboratory Machinist"
	desc = "Machinist for the Nanotrasen labs."
	short_name = "nt_machinist"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "nt_machinist"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Machinist"
	special_role = "nt_machinist Facility Machinist"
	spawnpoints = list("nt_machinist")
	outfit = /obj/outfit/admin/raccoon_city/nt_machinist
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_machinist
	name = "igs - NT Machinist"
	identifier = "nt_machinist"

/obj/outfit/admin/raccoon_city/nt_machinist
	name = "NT Machinist"
	uniform = /obj/item/clothing/under/rank/machinist
	belt = list(
		/obj/item/storage/belt/utility/full,
		/obj/item/storage/belt/utility/very_full,
		/obj/item/storage/belt/utility/atmostech,
	)
	gloves = list(
		/obj/item/clothing/gloves/green,
		/obj/item/clothing/gloves/black_leather,
		/obj/item/clothing/gloves/yellow,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
	)
	backpack_contents = list(
		/obj/item/device/robotanalyzer,
		/obj/item/clothing/gloves/latex,
	)

// ----------------------------- SYNTH

/datum/ghostspawner/human/nt_synth
	name = "Nanotrasen Laboratory Synthetic"
	desc = "The Director's personal bodyguard."
	short_name = "nt_synth"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human/shell
	tags = list("Nanotrasen Laboratory")
	max_count = 2
	password = "nt_synth"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Synth"
	special_role = "nt_synth Facility Synth"
	spawnpoints = list("nt_synth")
	outfit = /obj/outfit/admin/raccoon_city/nt_synth
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_synth
	name = "igs - NT Synth"
	identifier = "nt_synth"

/obj/outfit/admin/raccoon_city/nt_synth
	name = "NT Synth"
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = list(
		/obj/item/clothing/shoes/sneakers/tip,
		/obj/item/clothing/shoes/sneakers/hitops/tip,
		/obj/item/clothing/shoes/sneakers/medsci,
	)
	accessory = /obj/item/clothing/accessory/holster/thigh
	belt = /obj/item/storage/belt/security
	backpack_contents = list(
		/obj/item/gun/projectile/sec/lethal,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/ammo_magazine/c45m,
		/obj/item/melee/baton/loaded,
		/obj/item/handcuffs,
		/obj/item/handcuffs
	)

// ----------------------------- OUTFITS FOR LOCKERS

/obj/outfit/admin/raccoon_city/nt_locker
	id = null
	uniform = list(
		/obj/item/clothing/under/rank/scientist
	)
	suit = list(
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/longcoat,
		/obj/item/clothing/suit/storage/toggle/labcoat/nt,
		/obj/item/clothing/suit/storage/toggle/labcoat/nt/letterman,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
		/obj/item/clothing/shoes/sneakers/blue,
		/obj/item/clothing/shoes/sneakers/brown,
		/obj/item/clothing/shoes/sneakers/hitops/brown,
		/obj/item/clothing/shoes/laceup,
	)
	backpack_contents = list(
		/obj/item/storage/wallet/random,
		/obj/random/desk_clutter/office,
		/obj/random/desk_clutter/office,
		/obj/random/desk_clutter/office,
		/obj/random/desk_clutter/science,
	)

/obj/outfit/admin/raccoon_city/nt_locker/alt
	uniform = list(
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/green,
		/obj/random/suit,
	)
	uniform = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/random,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/longcoat,
		/obj/item/clothing/suit/storage/toggle/leather_jacket,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/designer/black,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/flight/white,
		/obj/item/clothing/suit/storage/toggle/leather_jacket/military/tan,
		/obj/item/clothing/suit/storage/toggle/highvis,
		/obj/item/clothing/suit/storage/toggle/highvis_alt,
		/obj/item/clothing/suit/storage/toggle/track,
		/obj/item/clothing/suit/storage/toggle/track/blue,
		/obj/item/clothing/suit/storage/toggle/trench/colorable/random,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/clothing/suit/wcoat,
	)

/obj/random/ee_locker_outfit
	name = "random NT labs locker outfit"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "outfit"
	problist = list(
		/obj/outfit/admin/raccoon_city/nt_locker,
		/obj/outfit/admin/raccoon_city/nt_locker/alt,
		/obj/outfit/admin/raccoon_city/nt_engineer,
		/obj/outfit/admin/raccoon_city/nt_guard,
		/obj/outfit/admin/raccoon_city/nt_intern,
		/obj/outfit/admin/raccoon_city/nt_machinist,
		/obj/outfit/admin/raccoon_city/nt_scientist,
		/obj/outfit/admin/raccoon_city/nt_synth,
	)

// -----------------------------
