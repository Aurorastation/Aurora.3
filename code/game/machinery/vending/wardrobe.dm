/**
 * Drobes
 */


/obj/machinery/vending/wardrobe
	name = "Drobe - PARENT DO NOT USE"
	light_mask = "clothes_lightmask"
	random_itemcount = FALSE

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper SecDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "secdrobe"
	product_slogans = "Beat perps in style!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using SecDrobe!"
	products = list(
		// Generic departmental/SCC gear
		/obj/item/clothing/under/rank/cadet = 4,
		/obj/item/clothing/under/rank/security = 4,
		/obj/item/clothing/under/det = 1,
		/obj/item/clothing/under/rank/warden = 1,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 8,
		/obj/item/clothing/suit/storage/toggle/sec_dep_jacket = 4,
		/obj/item/clothing/head/softcap/security = 8,
		/obj/item/clothing/head/beret/security = 4,
		/obj/item/clothing/head/beret/security/officer = 4,
		/obj/item/clothing/head/bandana/security = 8,
		/obj/item/clothing/head/warden = 1,
		/obj/item/clothing/shoes/jackboots = 8,
		/obj/item/clothing/shoes/jackboots/toeless = 6,
		/obj/item/storage/backpack/security = 4,
		/obj/item/storage/backpack/duffel/sec = 4,
		/obj/item/clothing/gloves/black_leather = 8,
		/obj/item/clothing/accessory/holster/waist = 8,
		// Zavodskoi gear
		/obj/item/clothing/under/rank/cadet/zavod = 3,
		/obj/item/clothing/under/rank/security/zavod = 3,
		/obj/item/clothing/under/rank/security/zavod/zavodsec = 3,
		/obj/item/clothing/under/rank/security/zavod/zavodsec/alt = 3,
		/obj/item/clothing/under/det/zavod = 1,
		/obj/item/clothing/under/det/zavod/alt = 1,
		/obj/item/clothing/under/rank/warden/zavod = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/alt = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman/alt = 1,
		/obj/item/clothing/suit/storage/toggle/longcoat/zavodskoi = 1,
		/obj/item/clothing/suit/storage/toggle/corp/zavod = 2,
		/obj/item/clothing/suit/storage/toggle/corp/zavod/alt = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/ = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/alt = 2,
		/obj/item/clothing/head/beret/corporate/zavod = 3,
		/obj/item/clothing/head/beret/corporate/zavod/alt = 3,
		/obj/item/clothing/head/sidecap/zavod = 3,
		/obj/item/clothing/head/sidecap/zavod/alt = 3,
		/obj/item/clothing/head/wool/zavod = 2,
		/obj/item/clothing/head/wool/zavod/alt = 2,
		/obj/item/clothing/head/warden/zavod = 1,
		/obj/item/clothing/head/warden/zavod/alt = 1,
		/obj/item/storage/backpack/zavod = 4,
		/obj/item/storage/backpack/duffel/zavod = 4,
		// Idris gear
		/obj/item/clothing/under/rank/cadet/idris = 3,
		/obj/item/clothing/under/rank/security/idris = 3,
		/obj/item/clothing/under/rank/security/idris/idrissec = 3,
		/obj/item/clothing/under/rank/security/idris/idrissec/alt = 3,
		/obj/item/clothing/under/det/idris = 1,
		/obj/item/clothing/under/det/idris/alt = 1,
		/obj/item/clothing/under/rank/warden/idris = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/alt = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman/alt = 1,
		/obj/item/clothing/suit/storage/toggle/longcoat/idris = 1,
		/obj/item/clothing/suit/storage/toggle/corp/idris = 2,
		/obj/item/clothing/suit/storage/toggle/corp/idris/alt = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/idris/ = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/idris/alt = 2,
		/obj/item/clothing/head/beret/corporate/idris = 3,
		/obj/item/clothing/head/beret/corporate/idris/alt = 3,
		/obj/item/clothing/head/softcap/idris = 3,
		/obj/item/clothing/head/softcap/idris/alt = 3,
		/obj/item/clothing/head/wool/idris = 2,
		/obj/item/clothing/head/wool/idris/alt = 2,
		/obj/item/clothing/head/warden/idris = 1,
		/obj/item/storage/backpack/idris = 4,
		/obj/item/storage/backpack/duffel/idris = 4,
		// PMCG gear
		/obj/item/clothing/under/rank/cadet/pmc = 3,
		/obj/item/clothing/under/rank/security/pmc = 3,
		/obj/item/clothing/under/rank/security/pmc/pmcsec = 3,
		/obj/item/clothing/under/rank/security/pmc/pmcsec/alt = 3,
		/obj/item/clothing/under/det/pmc = 1,
		/obj/item/clothing/under/det/pmc/alt = 1,
		/obj/item/clothing/under/rank/warden/pmc = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/pmc = 1,
		/obj/item/clothing/suit/storage/toggle/labcoat/pmc/alt = 1,
		/obj/item/clothing/suit/storage/toggle/longcoat/pmc = 1,
		/obj/item/clothing/suit/storage/toggle/corp/pmc = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/pmc/ = 2,
		/obj/item/clothing/head/sidecap/pmcg = 6,
		/obj/item/clothing/head/wool/pmc = 4,
		/obj/item/clothing/head/warden/pmc = 1,
		/obj/item/storage/backpack/pmcg = 4,
		/obj/item/storage/backpack/duffel/pmcg = 4
	)
	premium = list(
		/obj/item/clothing/accessory/storage/bayonet = 4
	)
	contraband = list(
		/obj/item/clothing/under/rank/security/einstein = 4
	)
	light_color = COLOR_PALE_BLUE_GRAY
