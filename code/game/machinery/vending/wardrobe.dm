/**
 * Drobes
 */


/obj/machinery/vending/wardrobe
	name = "Drobe - PARENT DO NOT USE"
	light_mask = "clothes_lightmask"
	random_itemcount = FALSE

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "\improper EngiDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "engidrobe"
	product_ads = "Guaranteed to protect your feet from industrial accidents!;Afraid of radiation? Then wear yellow!;Hi-viz is in this year! No, really!;You're the smartest department on the ship, so dress that way too!"
	vend_reply = "Thank you for using EngiDrobe!"
	products = list(
		// Generic departmental gear
		/obj/item/clothing/suit/storage/toggle/engi_dep_jacket = 8,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 8,
		/obj/item/clothing/suit/storage/toggle/highvis = 3,
		/obj/item/clothing/suit/storage/toggle/highvis_alt = 3,
		/obj/item/clothing/suit/storage/toggle/highvis_red = 3,
		/obj/item/clothing/suit/storage/toggle/highvis_orange = 3,
		/obj/item/clothing/pants/highvis = 3,
		/obj/item/clothing/pants/highvis_alt = 3,
		/obj/item/clothing/pants/highvis_red = 3,
		/obj/item/clothing/pants/highvis_orange = 3,
		/obj/item/clothing/shoes/sneakers/orange = 6,
		/obj/item/clothing/shoes/workboots/dark = 6,
		/obj/item/clothing/shoes/workboots/toeless = 4,
		/obj/item/clothing/head/hardhat/orange = 4,
		/obj/item/clothing/head/beret/engineering = 4,
		/obj/item/clothing/head/bandana/engineering = 4,
		/obj/item/clothing/head/softcap/engineering = 4,
		/obj/item/clothing/glasses/safety/goggles = 6,
		// Heph gear
		/obj/item/clothing/under/rank/engineer/heph = 4,
		/obj/item/clothing/under/rank/engineer/apprentice/heph = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/heph = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/heph/alt = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/heph/letterman = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/heph/letterman/alt = 2,
		/obj/item/clothing/suit/storage/toggle/longcoat/heph = 2,
		/obj/item/clothing/suit/storage/toggle/corp/heph = 4,
		/obj/item/clothing/suit/storage/hooded/wintercoat/heph/ = 4,
		/obj/item/clothing/suit/storage/hazardvest/green = 2,
		/obj/item/clothing/head/hardhat/green = 2,
		/obj/item/clothing/head/beret/corporate/heph = 3,
		/obj/item/clothing/head/wool/heph = 4,
		/obj/item/storage/backpack/heph = 4,
		/obj/item/storage/backpack/duffel/heph = 4,
		// Zavodskoi Gear
		/obj/item/clothing/under/rank/engineer/zavod = 4,
		/obj/item/clothing/under/rank/engineer/apprentice/zavod = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/alt = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman/alt = 2,
		/obj/item/clothing/suit/storage/toggle/longcoat/zavodskoi = 2,
		/obj/item/clothing/suit/storage/toggle/corp/zavod = 2,
		/obj/item/clothing/suit/storage/toggle/corp/zavod/alt = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/ = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/alt = 2,
		/obj/item/clothing/suit/storage/hazardvest/red = 2,
		/obj/item/clothing/head/hardhat/red = 2,
		/obj/item/clothing/head/beret/corporate/zavod = 2,
		/obj/item/clothing/head/beret/corporate/zavod/alt = 2,
		/obj/item/clothing/head/sidecap/zavod = 3,
		/obj/item/clothing/head/sidecap/zavod/alt = 3,
		/obj/item/clothing/head/softcap/zavod = 2,
		/obj/item/clothing/head/softcap/zavod/alt = 2,
		/obj/item/clothing/head/wool/zavod = 2,
		/obj/item/clothing/head/wool/zavod/alt = 2,
		/obj/item/storage/backpack/zavod = 4,
		/obj/item/storage/backpack/duffel/zavod = 4,
	)
	contraband = list(
		/obj/item/clothing/under/rank/engineer/einstein = 4
	)
	light_color = COLOR_PALE_BLUE_GRAY

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper SecDrobe"
	desc = "A vending machine for security and security-related clothing!"
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using SecDrobe!"
	products = list(
		// Generic departmental gear
		/obj/item/clothing/under/rank/cadet = 4,
		/obj/item/clothing/under/rank/security = 4,
		/obj/item/clothing/under/det = 2,
		/obj/item/clothing/under/rank/warden = 2,
		/obj/item/clothing/suit/storage/toggle/sec_dep_jacket = 8,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 8,
		/obj/item/clothing/head/softcap/security = 8,
		/obj/item/clothing/head/beret/security = 4,
		/obj/item/clothing/head/beret/security/officer = 4,
		/obj/item/clothing/head/bandana/security = 8,
		/obj/item/clothing/mask/balaclava = 4,
		/obj/item/clothing/head/warden = 2,
		/obj/item/clothing/shoes/jackboots = 8,
		/obj/item/clothing/shoes/jackboots/toeless = 6,
		/obj/item/storage/backpack/security = 4,
		/obj/item/storage/backpack/duffel/sec = 4,
		/obj/item/clothing/gloves/black_leather = 8,
		/obj/item/clothing/accessory/holster/waist = 8,
		// Idris gear
		/obj/item/clothing/under/rank/cadet/idris = 3,
		/obj/item/clothing/under/rank/security/idris = 3,
		/obj/item/clothing/under/rank/security/idris/idrissec = 3,
		/obj/item/clothing/under/rank/security/idris/idrissec/alt = 3,
		/obj/item/clothing/under/det/idris = 2,
		/obj/item/clothing/under/det/idris/alt = 2,
		/obj/item/clothing/under/rank/warden/idris = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/alt = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/idris/letterman/alt = 2,
		/obj/item/clothing/suit/storage/toggle/longcoat/idris = 2,
		/obj/item/clothing/suit/storage/toggle/corp/idris = 2,
		/obj/item/clothing/suit/storage/toggle/corp/idris/alt = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/idris/ = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/idris/alt = 2,
		/obj/item/clothing/head/beret/corporate/idris = 2,
		/obj/item/clothing/head/beret/corporate/idris/alt = 2,
		/obj/item/clothing/head/softcap/idris = 2,
		/obj/item/clothing/head/softcap/idris/alt = 2,
		/obj/item/clothing/head/wool/idris = 2,
		/obj/item/clothing/head/wool/idris/alt = 2,
		/obj/item/clothing/head/warden/idris = 2,
		/obj/item/storage/backpack/idris = 4,
		/obj/item/storage/backpack/duffel/idris = 4,
		// PMCG gear
		/obj/item/clothing/under/rank/cadet/pmc = 3,
		/obj/item/clothing/under/rank/security/pmc = 3,
		/obj/item/clothing/under/rank/security/pmc/pmcsec = 3,
		/obj/item/clothing/under/rank/security/pmc/pmcsec/alt = 3,
		/obj/item/clothing/under/det/pmc = 2,
		/obj/item/clothing/under/det/pmc/alt = 2,
		/obj/item/clothing/under/rank/warden/pmc = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/pmc = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/pmc/alt = 2,
		/obj/item/clothing/suit/storage/toggle/longcoat/pmc = 2,
		/obj/item/clothing/suit/storage/toggle/corp/pmc = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/pmc/ = 2,
		/obj/item/clothing/head/sidecap/pmcg = 2,
		/obj/item/clothing/head/softcap/pmc = 2,
		/obj/item/clothing/head/wool/pmc = 2,
		/obj/item/clothing/head/warden/pmc = 2,
		/obj/item/storage/backpack/pmcg = 4,
		/obj/item/storage/backpack/duffel/pmcg = 4
		// Zavodskoi gear
		/obj/item/clothing/under/rank/cadet/zavod = 3,
		/obj/item/clothing/under/rank/security/zavod = 3,
		/obj/item/clothing/under/rank/security/zavod/zavodsec = 3,
		/obj/item/clothing/under/rank/security/zavod/zavodsec/alt = 3,
		/obj/item/clothing/under/det/zavod = 2,
		/obj/item/clothing/under/det/zavod/alt = 2,
		/obj/item/clothing/under/rank/warden/zavod = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/alt = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi/letterman/alt = 2,
		/obj/item/clothing/suit/storage/toggle/longcoat/zavodskoi = 2,
		/obj/item/clothing/suit/storage/toggle/corp/zavod = 2,
		/obj/item/clothing/suit/storage/toggle/corp/zavod/alt = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/ = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/zavod/alt = 2,
		/obj/item/clothing/head/beret/corporate/zavod = 2,
		/obj/item/clothing/head/beret/corporate/zavod/alt = 2,
		/obj/item/clothing/head/sidecap/zavod = 2,
		/obj/item/clothing/head/sidecap/zavod/alt = 2,
		/obj/item/clothing/head/softcap/zavod = 2,
		/obj/item/clothing/head/softcap/zavod/alt = 2,
		/obj/item/clothing/head/wool/zavod = 2,
		/obj/item/clothing/head/wool/zavod/alt = 2,
		/obj/item/clothing/head/warden/zavod = 2,
		/obj/item/clothing/head/warden/zavod/alt = 2,
		/obj/item/storage/backpack/zavod = 4,
		/obj/item/storage/backpack/duffel/zavod = 4,
	)
	premium = list(
		/obj/item/clothing/accessory/storage/bayonet = 4
	)
	contraband = list(
		/obj/item/clothing/under/rank/security/einstein = 4
	)
	light_color = COLOR_PALE_BLUE_GRAY
