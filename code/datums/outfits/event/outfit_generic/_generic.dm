
/obj/outfit/admin/generic
	name = "Generic Outfit"

	uniform = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/purple,
		/obj/item/clothing/under/color/brown,
		/obj/item/clothing/under/color/darkblue,
		/obj/item/clothing/under/color/darkred,
		/obj/item/clothing/under/service_overalls,
		/obj/item/clothing/under/overalls,
		/obj/item/clothing/under/suit_jacket/charcoal,
	)
	suit = list(
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
	glasses = list(
		/obj/item/clothing/glasses/fakesunglasses/aviator,
		/obj/item/clothing/glasses/fakesunglasses/prescription,
		/obj/item/clothing/glasses/sunglasses/aviator,
		/obj/item/clothing/glasses/regular,
		/obj/item/clothing/glasses/safety/goggles,
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
		/obj/item/clothing/shoes/sneakers/blue,
		/obj/item/clothing/shoes/sneakers/brown,
		/obj/item/clothing/shoes/sneakers/hitops/brown,
	)
	back = list(
		/obj/item/storage/backpack/duffel,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/satchel/leather/withwallet,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/satchel/pocketbook,
	)
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
	)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_MSAI = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_TAJARA_ZHAN = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/workboots/toeless,
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca,
		SPECIES_VAURCA_ATTENDANT = /obj/item/clothing/shoes/vaurca
	)

/obj/outfit/admin/generic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/inhaler/phoron_special, slot_in_backpack)
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar_clean, slot_in_backpack)
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/clothing/accessory/offworlder/bracer, slot_in_backpack)
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)
		H.equip_or_collect(new /obj/item/rig/light/offworlder, slot_in_backpack)
