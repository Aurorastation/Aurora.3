// Police - access 218
// The local cops. Includes one patrolman, one senior patrolman to boss them about, and one superintendant to boss them both about.
/datum/ghostspawner/human/nhk_cop
	name = "New Hong Kong Patrolman"
	short_name = "nhk_cop"
	desc = "Keep the peace on the streets of New Hong Kong. Look the other way if no one gets hurt, but uphold the law when it is important."
	tags = list("External")
	spawnpoints = list("nhk_cop")
	max_count = 1
	outfit = /obj/outfit/admin/nhk/cop
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang National Police Patrolman"
	special_role = "Konyang National Police Patrolman"
	respawn_flag = null

/obj/outfit/admin/nhk/cop
	name = "Konyang Police Officer"
	uniform = /obj/item/clothing/under/rank/konyang/police
	accessory = /obj/item/clothing/accessory/holster/hip
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/konyang/police
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/security
	r_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/nhk_cop/senior
	name = "New Hong Kong Senior Patrolman"
	short_name = "nhk_senior_cop"
	desc = "Command the uniformed officers of New Hong Kong in the field. Get overruled by the superintendent anyway."
	max_count = 1
	assigned_role = "Konyang National Police Senior Patrolman"
	special_role = "Konyang National Police Senior Patrolman"

/datum/ghostspawner/human/nhk_cop/superintendent
	name = "New Hong Kong Police Superintendent"
	short_name = "nhk_superintendent"
	desc = "Oversee the local precinct. Get rich off of corporate money."
	max_count = 1
	assigned_role = "Konyang National Police Superintendent"
	special_role = "Konyang National Police Superintendent"
	outfit = /obj/outfit/admin/nhk/cop/superintendent

/obj/outfit/admin/nhk/cop/superintendent
	name = "Konyang Police Superintendent"
	uniform = /obj/item/clothing/under/rank/konyang/police/lieutenant
	head = /obj/item/clothing/head/konyang/police/lieutenant
	back = /obj/item/storage/backpack/satchel/leather

// --------------------------------

// Civilian - access 219
// All civilian roles. Includes two UP!Burger employees, one MiniMart vendor, and one Trinary priest.
/datum/ghostspawner/human/nhk_gwok
	name = "UP! Burger Employee"
	short_name = "nhk_gwok"
	desc = "Sell fast food and other Gwok-brand merchandise on the streets of New Hong Kong! Explain why the soft-serve machine is broken again."
	max_count = 2
	tags = list("External")
	spawnpoints = list("nhk_gwok")
	outfit = /obj/outfit/admin/nhk/vendor/gwok
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "UP! Burger Employee"
	special_role = "UP! Burger Employee"
	respawn_flag = null

/obj/outfit/admin/nhk/vendor/gwok
	name = "UP! Burger Employee"
	uniform = /obj/item/clothing/under/rank/konyang/burger
	shoes = /obj/item/clothing/shoes/workboots/dark
	suit = /obj/item/clothing/accessory/apron/chef
	head = /obj/item/clothing/head/konyang/burger
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/nhk_minimart
	name = "Minimart Employee"
	short_name = "nhk_minimart"
	desc = "Man a humble convenience store in the city of New Hong Kong. Sell goods to the visiting crewmembers and your fellow locals.\
	Do your best to stay on good terms with the local Benevolent Guild chapter."
	max_count = 1
	tags = list("External")
	spawnpoints = list("nhk_minimart")
	outfit = /obj/outfit/admin/nhk/vendor/minimart
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "New Hong Kong Vendor"
	special_role = "New Hong Kong Vendor"
	respawn_flag = null

/obj/outfit/admin/nhk/vendor/minimart
	name = "Minimart Employee"
	uniform = /obj/item/clothing/pants/jeans
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/storage/toggle/konyang/akira
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id

/datum/ghostspawner/human/nhk_trinarist
	name = "Trinarist Priest"
	short_name = "nhk_priest"
	desc = "You are a priest of the Trinary Perfection. Spread the word of the impending ascension to the residents of New Hong Kong, give aid and refuge\
	to the needy, and solicit donations from the sympathetic."
	max_count = 1
	tags = list("External")
	spawnpoints = list("nhk_trinarist")
	outfit = /obj/outfit/admin/nhk/vendor/trinarist
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Priest of the Trinary Perfection"
	special_role = "Priest of the Trinary Perfection"
	respawn_flag = null

/obj/outfit/admin/nhk/vendor/trinarist
	name = "Priest of the Trinary Perfection"
	uniform = /obj/item/clothing/suit/trinary_robes
	mask = /obj/item/clothing/mask/trinary_mask
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/accessory/poncho/trinary/shouldercape
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/device/versebook/trinary
	acessory = /obj/item/clothing/accessory/badge/trinary
	id = /obj/item/card/id

/obj/outfit/admin/nhk/vendor/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

// --------------------------------

// Benevolent Guild - access 249
// The dominant criminal organization of the city. Includes one goon, one boss, and one complicit bartender.
/datum/ghostspawner/human/benevolent_guild
	name = "Benevolent Guild Muscle"
	short_name = "benevolent_guild"
	desc = "You are a lowly member of the Benevolent Guild, the dominant criminal organization of New Hong Kong with strong ties to the local\
	working class community. Guard the hideout. Say goon phrases like 'sure thing, Boss.' Be big and scary so people listen to your boss.\
	Remember that you're not an antagonist."
	tags = list("External")
	spawnpoints = list("benevolent_guild")
	max_count = 1
	outfit = /obj/outfit/admin/nhk/benevolent_guild
	possible_species = list(SPECIES_HUMAN) // The Benevolent Guild does not accept synthetics.
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Benevolent Guild Muscle"
	special_role = "Benevolent Guild Muscle"
	respawn_flag = null

/obj/outfit/admin/nhk/benevolent_guild
	name = "Benevolent Guild Muscle"
	uniform = /obj/item/clothing/pants/tan
	shoes = /obj/item/clothing/shoes/sneakers/black
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/material/knife/butterfly/switchblade
	back = /obj/item/storage/backpack/satchel
	id = null

/datum/ghostspawner/human/benevolent_guild/boss
	name = "Benevolent Guild Lieutenant"
	short_name = "benevolent_guild_boss"
	desc = "Manage the local operations of Benevolent Guild. Keep your goons in line and away from the scrutiny of the police. Collect money from\
	guild owned enterprises. Lament that you cant abduct synthetics anymore because there's a Trinary church next door now."
	max_count = 1
	spawnpoints = list("benevolent_guild_boss")
	outfit = /obj/outfit/admin/nhk/benevolent_guild/boss
	assigned_role = "Benevolent Guild Lieutenant"
	special_role = "Benevolent Guild Lieutenant"

/obj/outfit/admin/nhk/benevolent_guild/boss
	name = "Benevolent Guild Lieutenant"
	uniform = /obj/item/clothing/under/suit_jacket/charcoal
	shoes = /obj/item/clothing/shoes/laceup
	wrist = /obj/item/clothing/wrists/watch/leather
	back = /obj/item/storage/backpack/satchel/leather

/datum/ghostspawner/human/benevolent_guild/bartender
	name = "Benevolent Guild Bartender"
	short_name = "konyang_bar"
	desc = "You are a bartender discreetly under the employ of the Benevolent Guild. You run an ostensibly legitimate and theoretically highly\
	profitable business. Sell alcohol to anyone willing to pay, obey your boss, and try to keep the fighting out of the bar when you can."
	max_count = 1
	tags = list("External")
	spawnpoints = list("benevolent_guild_bartender")
	outfit = /obj/outfit/admin/nhk/benevolent_guild/bartender
	assigned_role = "Bartender"
	special_role = "Bartender"

/obj/outfit/admin/nhk/benevolent_guild/bartender
	name = "Licensed Bartender"
	uniform = /obj/item/clothing/under/sl_suit
	shoes = /obj/item/clothing/shoes/sneakers/brown
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id

/obj/outfit/admin/nhk/benevolent_guild/get_id_access()
	return list(ACCESS_KONYANG_BENEVOLENT)

// --------------------------------

// Makes sure all tags show proper tag information.
/obj/outfit/admin/nhk/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_COALITION
