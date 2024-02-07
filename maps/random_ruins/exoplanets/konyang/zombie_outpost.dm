/datum/map_template/ruin/exoplanet/konyang_zombie_outpost
	name = "Konyang Telecomms Outpost - Zombies"
	id = "konyang_zombie_outpost"
	description = "A remote telecommunications relay, assaulted by infected IPCs."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/zombie_outpost.dmm")
	ban_ruins = list(/datum/map_template/ruin/exoplanet/konyang_telecomms_outpost)

/obj/effect/landmark/corpse/konyang_army
	name = "Konyang Soldier"
	corpseuniform = /obj/item/clothing/under/rank/konyang
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/helmet/konyang
	corpsesuit = /obj/item/clothing/suit/armor/carrier/military
	corpsebelt = /obj/item/gun/projectile/pistol/sol
	corpseback = /obj/item/storage/backpack/rucksack/green
	corpseid = FALSE
	corpsepocket1 = /obj/item/storage/wallet/random
	species = SPECIES_HUMAN
