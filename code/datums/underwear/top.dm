/datum/category_item/underwear/top/none
	name = "None"
	always_last = TRUE

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra
	is_default = TRUE
	name = "Bra"
	icon_state = "bra"
	has_color = TRUE

/datum/category_item/underwear/top/bra/is_default(var/gender)
	return gender == FEMALE

/datum/category_item/underwear/top/bra_bikini
	name = "Bra, Bikini"
	icon_state = "bra_bikini"
	has_color = TRUE

/datum/category_item/underwear/top/bra_bralette
	name = "Bra, Bralette"
	icon_state = "bra_bralette"
	has_color = TRUE

/datum/category_item/underwear/top/bra_striped
	name = "Bra, Striped"
	icon_state = "bra_striped"
	has_color = TRUE

/datum/category_item/underwear/top/sports_bra
	name = "Sports Bra"
	icon_state = "sports_bra"
	has_color = TRUE

/datum/category_item/underwear/top/binder
	name = "Binder"
	icon_state = "binder"

/datum/category_item/underwear/top/binder_strapless
	name = "Binder, Strapless"
	icon_state = "binder_strapless"

/datum/category_item/underwear/top/tubetop
	name = "Tube Top"
	icon_state = "tubetop"
	has_color = TRUE

/datum/category_item/underwear/top/swimtop
	name = "Swimming Top"
	icon_state = "swimtop"
	has_color = TRUE
