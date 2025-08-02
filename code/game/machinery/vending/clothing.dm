/**
 * ClothesMate
 */

/obj/machinery/vending/clothing
	name = "ClothesMate"
	desc = "A vending machine for clothing."
	icon_state = "clothes"
	icon_vend = "clothes-vend"
	icon_deny = "clothes-deny"
	product_ads = "Dress for success!;Prepare to look swagalicious!;Look at all this swag!;Why leave style up to fate? Use the ClothesMate!"
	vend_reply = "Thank you for using ClothesMate!"
	vend_id = "wardrobe"
	products = list(
		// Suits
		/obj/item/clothing/under/color/black = 4,
		/obj/item/clothing/under/color/grey = 4,
		/obj/item/clothing/under/color/white = 4,
		/obj/item/clothing/under/color/red = 4,
		/obj/item/clothing/under/color/orange = 4,
		/obj/item/clothing/under/color/yellow = 4,
		/obj/item/clothing/under/color/green = 4,
		/obj/item/clothing/under/color/blue = 4,
		/obj/item/clothing/under/color/purple = 4,
		/obj/item/clothing/under/swimsuit/black = 2,
		/obj/item/clothing/under/swimsuit/blue = 2,
		/obj/item/clothing/under/swimsuit/red = 2,
		/obj/item/clothing/under/swimsuit/purple = 2,
		/obj/item/clothing/under/dressshirt/silversun = 8,
		// Pants
		/obj/item/clothing/pants/black = 8,
		/obj/item/clothing/pants/tan = 4,
		/obj/item/clothing/pants/jeans = 4,
		/obj/item/clothing/pants/jeansblack = 4,
		/obj/item/clothing/pants/striped = 4,
		/obj/item/clothing/pants/track = 4,
		/obj/item/clothing/pants/track/red = 4,
		/obj/item/clothing/pants/shorts/athletic/black = 2,
		/obj/item/clothing/pants/shorts/athletic/blue = 2,
		/obj/item/clothing/pants/shorts/athletic/red = 2,
		/obj/item/clothing/pants/shorts/athletic/green = 2,
		// Shoes
		/obj/item/clothing/shoes/sneakers/black = 8,
		/obj/item/clothing/shoes/sneakers/brown = 4,
		/obj/item/clothing/shoes/sneakers/black/tajara = 2,
		/obj/item/clothing/shoes/vaurca = 2,
		/obj/item/clothing/shoes/workboots = 8,
		/obj/item/clothing/shoes/workboots/toeless = 4,
		/obj/item/clothing/shoes/sandals = 4,
		/obj/item/clothing/shoes/winter = 8,
		/obj/item/clothing/shoes/winter/toeless = 4,
		/obj/item/clothing/shoes/footwraps = 2,
		// Headwear
		/obj/item/clothing/head/hijab = 2,
		/obj/item/clothing/head/turban = 2,
		/obj/item/clothing/head/kippah = 2,
		/obj/item/clothing/mask/trinary_mask = 2,
		// Eyewear
		/obj/item/clothing/glasses/regular = 4,
		/obj/item/clothing/glasses/regular/circle = 4,
		/obj/item/clothing/glasses/night/aviator = 8,
		/obj/item/clothing/glasses/sunglasses = 8,
		/obj/item/clothing/glasses/fakesunglasses = 4
	)
	contraband = list(
		/obj/item/clothing/head/bandana/pirate = 4,
		/obj/item/clothing/glasses/eyepatch = 4,
		/obj/item/clothing/under/rank/machinist/einstein = 4,
		/obj/item/clothing/under/rank/liaison/einstein = 4,
		/obj/item/clothing/glasses/sunglasses/blindfold = 4,
		/obj/item/clothing/mask/fakemoustache = 4
	)
	premium = list(
		/obj/item/clothing/head/fez = 2,
		/obj/item/clothing/head/bowlerhat = 2,
		/obj/item/clothing/head/that = 2
	)
	light_mask = "clothes-lightmask"
	light_color = COLOR_PALE_BLUE_GRAY
	restock_items = TRUE
