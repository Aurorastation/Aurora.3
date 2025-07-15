/obj/item/clothing/head/wide_hat
	name = "wide-brimmed sun hat"
	desc = "A large and light hat meant to block the sun from your precious eyes."
	icon = 'icons/obj/item/clothing/head/sun_hat.dmi'
	icon_state = "sun_hat"
	item_state = "sun_hat"
	contained_sprite = TRUE
	has_accents = TRUE

/obj/item/clothing/head/wide_hat/alt
	build_from_parts = TRUE
	worn_overlay = "over"

/obj/item/clothing/head/wide_hat/pointed
	icon_state = "pointed_large"
	item_state = "pointed_large"

/obj/item/clothing/head/wide_hat/pointed/alt
	build_from_parts = TRUE
	worn_overlay = "band"

/obj/item/clothing/head/cowboy
	name = "cowboy hat"
	desc = "A wide-brimmed hat, in the prevalent style of the frontier."
	icon = 'icons/obj/item/clothing/head/cowboy.dmi'
	contained_sprite = TRUE
	icon_state = "cowboyhat"
	item_state = "cowboyhat"
	protects_against_weather = TRUE

/obj/item/clothing/head/cowboy/wide
	name = "wide-brimmed cowboy hat"
	icon_state = "cowboy_wide"
	item_state = "cowboy_wide"

/obj/item/clothing/head/bucket
	name = "bucket hat"
	desc = "A basic, circular hat with a modest brim."
	icon = 'icons/obj/item/clothing/head/bucket_hat.dmi'
	contained_sprite = TRUE
	icon_state = "buckethat"
	item_state = "buckethat"

	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/helmet.dmi'
		)

/obj/item/clothing/head/bucket/boonie
	name = "boonie hat"
	desc = "A floppy boonie hat with an attached string."
	icon_state = "boonie"
	item_state = "boonie"
	build_from_parts = TRUE
	worn_overlay = "over"

/obj/item/clothing/head/bucket/boonie/camo
	icon_state = "camo_boonie"
	item_state = "camo_boonie"
	has_accents = TRUE

/obj/item/clothing/head/bucket/boonie/green
	icon_state = "green_boonie"
	item_state = "green_boonie"

/obj/item/clothing/head/bucket/boonie/blue
	icon_state = "blue_boonie"
	item_state = "blue_boonie"

/obj/item/clothing/head/fedora
	name = "fedora"
	icon_state = "fedora"
	item_state = "fedora"
	desc = "A sharp, stylish hat."
	icon = 'icons/obj/item/clothing/head/bucket_hat.dmi'
	contained_sprite = TRUE
	has_accents = TRUE

/obj/item/clothing/head/fedora/grey
	name = "grey fedora"

/obj/item/clothing/head/fedora/grey/Initialize()
	. = ..()
	color = "#5d6363"

/obj/item/clothing/head/top_hat
	name = "top hat"
	icon_state = "tophat"
	item_state = "tophat"
	desc = "A top hat worn by only the most prestigious hat collectors."
	icon = 'icons/obj/item/clothing/head/top_hat.dmi'
	contained_sprite = TRUE
	has_accents = TRUE
