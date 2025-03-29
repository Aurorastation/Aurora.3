
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
	desc = "Getmore research is so cool, guys!"
	short_name = "nt_sci"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 1
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
	desc = "Direct your band of merry chickens to cross the road safely. By which I mean... well, no spoilers."
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

// ----------------------------- GUARD

/datum/ghostspawner/human/nt_guard
	name = "Konyanger Army Guard"
	desc = "Your life for Konyang. Or is that really what's going on here?"
	short_name = "nt_guard"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human
	tags = list("Nanotrasen Laboratory")
	max_count = 1
	password = "nt_guard"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Guard"
	special_role = "Nanotrasen Laboratory Facility Guard"
	spawnpoints = list("nt_guard")
	outfit = /obj/outfit/admin/konyang/army
	respawn_flag = null

/obj/effect/ghostspawpoint/nt_guard
	name = "igs - NT Guard"
	identifier = "nt_guard"


/obj/effect/ghostspawpoint/ashley
	name = "igs - Ashley"
	identifier = "ee_ashley"

// ----------------------------- SYNTH

/datum/ghostspawner/human/konyang_assetpro
	name = "Konyang Asset Protection Lead"
	desc = "Today, you're not afraid to die..."
	short_name = "konyang_assetpro"
	loc_type = GS_LOC_POS
	spawn_mob = /mob/living/carbon/human/shell
	tags = list("Nanotrasen Laboratory")
	max_count = 1
	password = "konyang_assetpro"
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nanotrasen Laboratory Synth"
	special_role = "konyang_assetpro Facility Synth"
	spawnpoints = list("konyang_assetpro")
	outfit = /obj/outfit/admin/konyang/army_response/officer
	respawn_flag = null

/obj/effect/ghostspawpoint/konyang_assetpro
	name = "igs - Konyang Assetpro"
	identifier = "konyang_assetpro"

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
		/obj/outfit/job/engineer,
		/obj/outfit/admin/konyang/army_response,
		/obj/outfit/job/scientist,
		/obj/outfit/job/intern_sci,
		/obj/outfit/admin/konyang/army,
	)

// -----------------------------
