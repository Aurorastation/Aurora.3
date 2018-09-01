/datum/bounty_reward/guns
	name = "Guns for Security"
	id = "guns"
	reward_description = "%COUNT random old guns"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_armory)
	item_rewards_weight = list(
		/obj/item/weapon/gun/projectile/colt = 2,
		/obj/item/weapon/gun/projectile/automatic/wt550 = 1,
		/obj/item/weapon/gun/projectile/revolver/deckard = 0.5,
		/obj/item/weapon/gun/projectile/revolver/detective = 1
	)
	reward_count = 2

/datum/bounty_reward/kas
	name = "KAs for Miners"
	id = "miner_ka"
	reward_description = "%COUNT prebuilt kinetic accelerators"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_mining)
	item_rewards_weight = list(
		/obj/random/prebuilt_ka = 1,
	)
	reward_count = 2

/datum/bounty_reward/swords
	name = "Swords for Heads"
	id = "swords"
	reward_description = "%COUNT random swords"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_heads)
	item_rewards_weight = list(
		/obj/random/sword = 1,
	)
	reward_count = 3

/datum/bounty_reward/high_value
	name = "High Value Items"
	id = "high_value"
	reward_description = "%COUNT high value items"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_heads)
	item_rewards_weight = list(
		/obj/random/highvalue = 1,
	)
	reward_count = 2

/datum/bounty_reward/shotguns
	name = "Combat Shotguns"
	id = "shotguns"
	reward_description = "2 combat shotguns, %COUNT boxes of shotgun shells"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_armory)
	item_rewards_flat = list(
		/obj/item/weapon/gun/projectile/shotgun/pump/combat,
		/obj/item/weapon/gun/projectile/shotgun/pump/combat
	)
	item_rewards_weight = list(
		/obj/item/weapon/storage/box/shotgunshells = 1
	)
	reward_count = 4