/*
 *	Generic Clothing Vendor
 *	Actor Vendor
 **/

/obj/machinery/vending/actor
	name = "\improper Actor Vendor"
	desc = "Has all your odyssey actor items, to let you effectively do your odysseying and actoring."
	vend_id = "actor"
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
	products = list(
		/obj/item/device/radio/headset/ship/odyssey = 12,
		/obj/item/portable_map_reader/odyssey = 12,
		/obj/item/card/id/syndicate = 12,
		/obj/item/storage/box/syndie_kit/chameleon = 12,
	)
	light_color = COLOR_GUNMETAL
	random_itemcount = FALSE

/*
Generic clothing vendor used in antagonist areas. For now, this almost entirely contains generic items. Prioritises recolourable items.
Intended to take some pressure off admins asked regularly to spawn in clothing by allowing players to spawn and colour their clothes themselves.
Only contains very few origin-specific items, as otherwise the list would get so long it'd be entirely incomprehensible.
If you want to expand this to more than primarily generic items, I recommend designing a UI that supports switching between categories.
*/
/obj/machinery/vending/generic_clothing
	name = "\improper Generic Clothing Vendor"
	desc = "Contains a large number of generic clothing items. Comes with hand-held dyers to dye its contents however the user wishes."
	vend_id = "generic_clothing"
	icon_state = "robotics"
	icon_vend = "robotics-vend"
	light_mask = "robotics-light-mask"
	light_color = COLOR_GREEN
	random_itemcount = FALSE
	products = list (
		// This item allows players to change the colour of recolourable items from this vendor without needing admin intervention.
		/obj/item/device/clothes_dyer = 6,

		// Generic suits.
		/obj/item/clothing/suit/storage/toggle/labcoat = 6,
		/obj/item/clothing/suit/storage/hazardvest/colorable = 6,
		/obj/item/clothing/suit/storage/hooded/wintercoat/colorable = 6,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie = 6,
		/obj/item/clothing/suit/storage/surgical_gown = 6,
		/obj/item/clothing/suit/storage/toggle/suitjacket = 6,
		/obj/item/clothing/suit/storage/toggle/trench/colorable = 6,
		/obj/item/clothing/suit/storage/toggle/bomber = 6,
		/obj/item/clothing/suit/storage/toggle/cardigan = 6,
		/obj/item/clothing/suit/storage/toggle/dominia/bomber = 6,
		/obj/item/clothing/suit/storage/toggle/greatcoat/brown = 6,

		// Generic shirts.
		/obj/item/clothing/under/dressshirt/alt = 6,
		/obj/item/clothing/under/dressshirt/polo = 6,
		/obj/item/clothing/under/dressshirt/silversun= 6,
		/obj/item/clothing/under/dressshirt/tanktop = 6,
		/obj/item/clothing/under/dressshirt/puffyblouse = 6,

		// Generic pants & skirts.
		/obj/item/clothing/pants/shorts/colourable = 6,
		/obj/item/clothing/pants/mustang/colourable = 6,
		/obj/item/clothing/pants/dress = 6,
		/obj/item/clothing/pants/skirt = 6,
		/obj/item/clothing/pants/skirt/high = 6,
		/obj/item/clothing/pants/skirt/pencil = 6,

		// Generic uniforms.
		/obj/item/clothing/under/color/colorable = 6,
		/obj/item/clothing/under/syndicate = 6,
		/obj/item/clothing/under/syndicate/tracksuit = 6,
		/obj/item/clothing/under/dress/colorable/longsleeve = 6,
		/obj/item/clothing/under/dress/colorable/sleeveless = 6,
		/obj/item/clothing/under/librarian = 6,
		/obj/item/clothing/under/rank/medical/generic = 6,
		/obj/item/clothing/under/dominia/imperial_suit = 6,
		/obj/item/clothing/under/suit_jacket = 6,
		/obj/item/clothing/under/tajaran = 6,

		// Generic hats.
		/obj/item/clothing/head/bandana/colorable = 6,
		/obj/item/clothing/head/beanie = 6,
		/obj/item/clothing/head/beret/colorable = 6,
		/obj/item/clothing/head/bucket/boonie = 6,
		/obj/item/clothing/head/cowboy/wide = 6,
		/obj/item/clothing/head/cowboy = 6,
		/obj/item/clothing/head/fedora = 6,
		/obj/item/clothing/head/flatcap/colourable = 6,
		/obj/item/clothing/head/wool = 6,
		/obj/item/clothing/head/sidecap = 6,
		/obj/item/clothing/head/plain_hood = 6,

		// Generic gloves.
		/obj/item/clothing/gloves/black_leather/colour = 6,
		/obj/item/clothing/gloves/fingerless/colour = 6,
		/obj/item/clothing/gloves/evening = 6,

		// Generic accessories.
		/obj/item/clothing/accessory/wcoat_rec = 6,
		/obj/item/clothing/accessory/bandanna/colorable = 6,
		/obj/item/clothing/accessory/apron = 6,
		/obj/item/clothing/accessory/tie/colourable = 6,
		/obj/item/clothing/accessory/tie/ribbon/neck = 6,
		/obj/item/clothing/accessory/poncho/colorable/gradient = 6,
		/obj/item/clothing/accessory/poncho/dominia_cape = 6,
		/obj/item/clothing/accessory/scarf = 6,

		// Bags.
		/obj/item/storage/backpack/duffel/eng = 6,
		/obj/item/storage/backpack/industrial = 6,
		/obj/item/storage/backpack/messenger = 6,
		/obj/item/storage/backpack/satchel = 6,
		/obj/item/storage/backpack/satchel/leather/recolorable = 6,
		/obj/item/storage/backpack/satchel/leather = 6,

		// Sunglasses and other eyewear.
		/obj/item/clothing/glasses/regular = 6,
		/obj/item/clothing/glasses/sunglasses = 6,
		/obj/item/clothing/glasses/sunglasses/blindfold = 6,
		/obj/item/clothing/glasses/monocle = 6,
		/obj/item/clothing/glasses/eyepatch = 6,

		// Shoes and boots.
		/obj/item/clothing/shoes/jackboots = 6,
		/obj/item/clothing/shoes/jackboots/cavalry = 6,
		/obj/item/clothing/shoes/jackboots/toeless = 6,
		/obj/item/clothing/shoes/sneakers/black = 6,
		/obj/item/clothing/shoes/laceup/colourable = 6,
		/obj/item/clothing/shoes/heels = 6,
		/obj/item/clothing/shoes/winter = 6,
	)
