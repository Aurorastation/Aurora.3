#define CREVUS_GENERIC_SPECIES list(\
	SPECIES_TAJARA, \
	SPECIES_TAJARA_ZHAN, \
	SPECIES_TAJARA_MSAI, \
	SPECIES_HUMAN \
)

// ---------- Chef

/datum/ghostspawner/human/crevus_chef
	short_name = "crevus_chef"
	name = "Nikal'n Marr Diner Chef"
	desc = "Run Nikal'n Marr Diner's kitchen, cook whatever your guests request. Complain when your guests know all about pacojet."
	tags = list("External")
	spawnpoints = list("crevus_chef")
	max_count = 2
	outfit = /obj/outfit/admin/crevus/chef
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Placeholder Chef"
	special_role = "Placeholder Chef"
	respawn_flag = null

/obj/outfit/admin/crevus/chef
	name = "Crevus Chef"
	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	suit = /obj/item/clothing/suit/chef_jacket/nt
	r_pocket = /obj/item/storage/wallet/random

// ---------- Attendant

/datum/ghostspawner/human/crevus_attendant
	short_name = "crevus_attendant"
	name = "Nikal'n Marr Diner Attendant"
	desc = "Serve the guests of Nikal'n Marr Diner, either run the bar or serve the orders - or do both. Give dead eye to the non-tippers."
	tags = list("External")
	spawnpoints = list("crevus_attendant")
	max_count = 2
	outfit = /obj/outfit/admin/konyang/zh
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Nikal'n Marr Diner Attendant"
	special_role = "Nikal'n Marr Diner Attendant"
	respawn_flag = null

// ---------- General Store Vendor

/datum/ghostspawner/human/crevus_general_store_vendor
	short_name = "crevus_general_store_vendor"
	name = "Ane-Mart Vendor"
	desc = "Run the general store, maybe stock the shelves, hope that shoplifting will be the worst thing you'll have to deal with today."
	tags = list("External")
	spawnpoints = list("crevus_general_store_vendor")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Ane-Mart Vendor"
	special_role = "Ane-Mart Vendor"
	respawn_flag = null

// ---------- Automobile Salesperson
/datum/ghostspawner/human/crevus_car_salesperson
	short_name = "crevus_car_salesperson"
	name = "Automobile Salesperson"
	desc = "\
	Find potential customers, introduce your automobiles, try not to be too obvious when you try to sell them very above the market price. \
	Bargain like the autonomy of your soul depends on it. \
	"
	tags = list("External")
	spawnpoints = list("crevus_car_salesperson")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Automobile Salesperson"
	special_role = "Automobile Salesperson"
	respawn_flag = null

// ---------- Transit Centre Clerk

/datum/ghostspawner/human/crevus_clerk
	short_name = "crevus_clerk"
	name = "Transit Centre Clerk"
	desc = "\
	Welcome the guests, and more importantly the tourists, to the Free City of Crevus. Give them a brochure, run the gift shop. \
	Conduct tours, be subtle when you intentionally bring them to a gang's turf. \
	"
	tags = list("External")
	spawnpoints = list("crevus_clerk")
	max_count = 2
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Transit Centre Clerk"
	special_role = "Transit Centre Clerk"
	respawn_flag = null

// ---------- Clothing Store Vendor

/datum/ghostspawner/human/crevus_clothing_vendor
	short_name = "crevus_clothing_vendor"
	name = "Clothing Store Vendor"
	desc = "Display fashion, sell fashion and make fashion. Customize (recolour) your stock, don't let your customers see how you do it."
	tags = list("External")
	spawnpoints = list("crevus_clothing_vendor")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Clothing Store Vendor"
	special_role = "Clothing Store Vendor"
	respawn_flag = null

// ---------- Firearm Salesperson

/datum/ghostspawner/human/crevus_firearm_salesperson
	short_name = "crevus_firearm_salesperson"
	name = "Firearm Salesperson"
	desc = "\
	Sell your guns, sell memberships for your shooting range at the downstairs. Educate people about firearm safety, show them how they're doing it wrong. \
	Brag about for how many generations your family ran this store. \
	"
	tags = list("External")
	spawnpoints = list("crevus_firearm_salesperson")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Firearm Salesperson"
	special_role = "Firearm Salesperson"
	respawn_flag = null

// ---------- Artisan Shop Vendor

/datum/ghostspawner/human/crevus_artisan_shop_vendor
	short_name = "crevus_artisan_shop_vendor"
	name = "Artisan Shop Vendor"
	desc = "Sell your handmade goods and more. Advertise your liquor stock as a proud producer."
	tags = list("External")
	spawnpoints = list("crevus_artisan_shop_vendor")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Artisan Shop Vendor"
	special_role = "Artisan Shop Vendor"
	respawn_flag = null

// ---------- NanoTrasen Pharmacist

/datum/ghostspawner/human/crevus_nt_pharmacist
	short_name = "crevus_nt_pharmacist"
	name = "NanoTrasen Pharmacist"
	desc = "\
	Sell medicine out of the pharmacy, be convinced to forget checking prescripts for the right sum. \
	Produce drugs for any and every needs. Hope that the numbers at the end-of-month inventory report won't look too suspicious. \
	"
	tags = list("External")
	spawnpoints = list("crevus_nt_pharmacist")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "NanoTrasen Pharmacist"
	special_role = "NanoTrasen Pharmacist"
	respawn_flag = null

// ---------- Placeholder Casino Personnel

/datum/ghostspawner/human/crevus_casino_personnel
	short_name = "crevus_casino_personnel"
	name = "Keltra Zav Nikal Casino Personnel"
	desc = "Oversee the games, deal hands, take bets. Remember, the house always wins."
	tags = list("External")
	spawnpoints = list("crevus_casino_personnel")
	max_count = 2
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Keltra Zav Nikal Personnel"
	special_role = "Keltra Zav Nikal Personnel"
	respawn_flag = null

// ---------- The Lock Attendant

/datum/ghostspawner/human/crevus_the_lock_attendant
	short_name = "crevus_the_lock_attendant"
	name = "The Lock Attendant"
	desc = "\
	You are a member of the Cult of Raskara, either in the Door and Key or King of Maggots group. You are responsible with running the current location of The Lock. \
	Provide a safe space for the other members and potential members to party in. Let the drugs and booze flow, try not to be discovered and uprooted too early. \
	"
	tags = list("External")
	spawnpoints = list("crevus_the_lock_attendant")
	max_count = 3
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "The Lock Attendant"
	special_role = "The Lock Attendant"
	respawn_flag = null

// ---------- Gangs

/datum/ghostspawner/human/crevus_gang1_member
	short_name = "crevus_gang1_member"
	name = "Placeholder Gang Member"
	desc = "\
	You are a small-time punk, there are many like you in the streets. Expand your network, sell drugs, mug people, do business - but above all, do your best to be \
	noticed by the city's eyes. And who knows, maybe you can one day join a crime family proper. \
	Try not to bother much with where you stand on the moral compass. Despite your best efforts to avoid it, end up dying an untimely death. \
	"
	tags = list("External")
	spawnpoints = list("crevus_gang1_member")
	max_count = 20
	outfit = /obj/outfit/admin/crevus/gang_member
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Placeholder Gang Member"
	special_role = "Placeholder Gang Member"
	respawn_flag = null

/obj/outfit/admin/crevus/gang_member
	name = "Gang Member"
	uniform = list(
		/obj/item/clothing/under/dressshirt/tanktop,
		/obj/item/clothing/under/dressshirt/longsleeve_s,
		/obj/item/clothing/under/dressshirt/deepv
	)

	suit = list(
		/obj/item/clothing/suit/storage/toggle/greatcoat/recolor,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie/sleeveless
	)

	pants = list(
		/obj/item/clothing/pants/cargo,
		/obj/item/clothing/pants/mustang/colourable
	)

	gloves = /obj/item/clothing/gloves/fingerless

	shoes = list(
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark
	)

	species_shoes = list(
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
	)

	id = null
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/material/knife/butterfly/switchblade
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/crevus/gang_member/post_equip(mob/living/carbon/human/H)
	. = ..()

	// color the colorable stuff
	H.w_uniform?.color = get_random_colour(lower = 150)
	H.w_uniform?.update_worn_icon()
	H.wear_suit?.color = get_random_colour(lower = 150)
	H.wear_suit?.update_worn_icon()
	H.pants?.color = get_random_colour(lower = 150)
	H.pants?.update_worn_icon()

	// random equipment
	if(prob(50))
		H.equip_or_collect(new /obj/random/medical, slot_in_backpack)
	if(prob(50))
		H.equip_or_collect(new /obj/random/loot, slot_in_backpack)
	if(prob(55))
		H.equip_or_collect(new /obj/item/crowbar/red, slot_in_backpack)

/datum/ghostspawner/human/crevus_gang1_boss
	short_name = "crevus_gang1_boss"
	name = "Placeholder Gang Leader"
	desc = "\
	You are a leader of a small-time gang, or at least you were when you last checked. Look after your people, do whatever it takes to make you (and maybe your men) rich. \
	Never compromise your authority, end up seeing your men die an untimely death because of your hubris. \
	"
	tags = list("External")
	spawnpoints = list("crevus_gang1_boss")
	max_count = 1
	possible_species = CREVUS_GENERIC_SPECIES
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Placeholder Gang Leader"
	special_role = "Placeholder Gang Leader"
	respawn_flag = null

/obj/outfit/admin/crevus/gang_member/boss
	name = "Gang Leader"


#undef CREVUS_GENERIC_SPECIES
