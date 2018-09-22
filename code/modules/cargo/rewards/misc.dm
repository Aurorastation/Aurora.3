/datum/bounty_reward/sunglasses
	name = "Sunglasses"
	id = "sunglasses"
	reward_description = "%COUNT pairs of regular sunglasses"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list()
	item_rewards_weight = list(
		/obj/item/clothing/glasses/sunglasses = 1,
		/obj/item/clothing/glasses/sunglasses/aviator = 1,
		/obj/item/clothing/glasses/sunglasses/big = 1
	)
	reward_count = 6


/datum/bounty_reward/combat_manuals
	name = "Combat Manuals"
	id = "combat_manuals"
	reward_description = "%COUNT combat manuals"
	spawn_crate = /obj/structure/closet/crate/secure
	crate_access = list(access_armory)
	item_rewards_weight = list(
		/obj/item/sol_combat_manual = 4,
		/obj/item/kis_khan_manual = 0.25,
		/obj/item/karak_virul_manual = 0.25,
		/obj/item/baghrar_manual = 0.25,
		/obj/item/vkutet_manual = 0.1
	)

	reward_count = 2
