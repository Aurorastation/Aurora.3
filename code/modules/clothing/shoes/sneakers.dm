/obj/item/clothing/shoes/sneakers
	name = "white shoes"
	desc = "A pair of classy white shoes."
	icon = 'icons/obj/item/clothing/shoes/sneakers.dmi'
	icon_state = "white"
	item_state = "white"
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	contained_sprite = TRUE

/obj/item/clothing/shoes/sneakers/red
	name = "red shoes"
	desc = "A pair of stylish red shoes."
	icon_state = "red"
	item_state = "red"

/obj/item/clothing/shoes/sneakers/orange
	name = "orange shoes"
	desc = "A pair of easily noticed, reflective orange shoes."
	icon_state = "orange"
	item_state = "orange"
	var/obj/item/handcuffs/chained = null

/obj/item/clothing/shoes/sneakers/orange/proc/attach_cuffs(var/obj/item/handcuffs/cuffs, mob/user)
	if (src.chained) return

	user.drop_from_inventory(cuffs,src)
	src.chained = cuffs
	src.slowdown = 15
	src.icon_state = "orange1"
	src.item_state = "orange1"
	if(ismob(src.loc))
		var/mob/holder_user = src.loc
		holder_user.update_equipment_speed_mods()

/obj/item/clothing/shoes/sneakers/orange/proc/remove_cuffs(mob/user as mob)
	if (!src.chained) return

	user.put_in_hands(src.chained)
	src.chained.add_fingerprint(user)

	src.slowdown = initial(slowdown)
	src.icon_state = "orange"
	src.item_state = "orange"
	src.chained = null
	if(ismob(src.loc))
		var/mob/holder_user = src.loc
		holder_user.update_equipment_speed_mods()

/obj/item/clothing/shoes/sneakers/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/sneakers/orange/attackby(obj/item/attacking_item, mob/user)
	..()
	if (istype(attacking_item, /obj/item/handcuffs))
		attach_cuffs(attacking_item, user)

/obj/item/clothing/shoes/sneakers/yellow
	name = "yellow shoes"
	desc = "A pair of garish yellow shoes."
	icon_state = "yellow"
	item_state = "yellow"

/obj/item/clothing/shoes/sneakers/green
	name = "green shoes"
	desc = "A pair of gaudy green shoes."
	icon_state = "green"
	item_state = "green"

/obj/item/clothing/shoes/sneakers/blue
	name = "blue shoes"
	desc = "A pair of light blue shoes."
	icon_state = "blue"
	item_state = "blue"

/obj/item/clothing/shoes/sneakers/purple
	name = "purple shoes"
	desc = "A pair of vibrant purple shoes."
	icon_state = "purple"
	item_state = "purple"

/obj/item/clothing/shoes/sneakers/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"
	item_state = "brown"

/obj/item/clothing/shoes/sneakers/black
	name = "black shoes"
	desc = "A pair of black shoes."
	icon_state = "black"
	item_state = "black"

/obj/item/clothing/shoes/sneakers/black/noslip
	item_flags = ITEM_FLAG_NO_SLIP

/obj/item/clothing/shoes/sneakers/rainbow
	name = "rainbow shoes"
	desc = "A pair of overly colorful shoes."
	icon_state = "rain_bow"

/obj/item/clothing/shoes/sneakers/tip
	worn_overlay = "over"
	build_from_parts = TRUE

/obj/item/clothing/shoes/sneakers/medsci
	name = "treated shoes"
	desc = "A pair of treated shoes for safety around patients. Resistant to chemical and gas spills."
	icon_state = "nt"
	item_state = "nt"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(
		BIO = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/shoes/sneakers/medsci/zeng
	icon_state = "zeng"
	item_state = "zeng"

/obj/item/clothing/shoes/sneakers/medsci/zavod
	icon_state = "zavod"
	item_state = "zavod"

/obj/item/clothing/shoes/sneakers/medsci/pmc
	icon_state = "pmc"
	item_state = "pmc"

// flats

/obj/item/clothing/shoes/flats
	desc = "A pair of black, low-heeled women's flats."
	name = "black dress flats"
	icon = 'icons/obj/item/clothing/shoes/flats.dmi'
	icon_state = "blackdf"
	item_state = "blackdf"
	species_restricted = list("exclude",BODYTYPE_VAURCA_BREEDER,BODYTYPE_VAURCA_WARFORM,BODYTYPE_TESLA_BODY)
	icon_auto_adapt = TRUE
	contained_sprite = TRUE
	icon_supported_species_tags = list("taj")

/obj/item/clothing/shoes/flats/red
	desc = "A pair of red, low-heeled women's flats."
	name = "red dress flats"
	icon_state = "reddf"
	item_state = "reddf"

/obj/item/clothing/shoes/flats/blue
	desc = "A pair of blue, low-heeled women's flats."
	name = "blue dress flats"
	icon_state = "bluedf"
	item_state = "bluedf"

/obj/item/clothing/shoes/flats/green
	desc = "A pair of green, low-heeled women's flats."
	name = "green dress flats"
	icon_state = "greendf"
	item_state = "greendf"

/obj/item/clothing/shoes/flats/purple
	desc = "A pair of purple, low-heeled women's flats."
	name = "purple dress flats"
	icon_state = "purpledf"
	item_state = "purpledf"

/obj/item/clothing/shoes/flats/white
	desc = "A pair of white, low-heeled women's flats."
	name = "white dress flats"
	icon_state = "whitedf"
	item_state = "whitedf"

/obj/item/clothing/shoes/flats/color
	desc = "A pair of low-heeled women's dress flats, in a variety of colors."
	name = "dress flats"
	icon_state = "colordf"
	item_state = "colordf"

//hi-tops

/obj/item/clothing/shoes/sneakers/hitops
	name = "white high-tops"
	desc = "A pair of shoes that extends past the ankle. Based on a centuries-old, timeless design."
	icon_state = "whitehi"
	item_state = "whitehi"

/obj/item/clothing/shoes/sneakers/hitops/thightops
	name = "white thigh-tops"
	desc = "A pair of shoes that extends to the thigh. Based on a centuries-old, timeless design."
	icon_state = "whiteth"
	item_state = "whiteth"

/obj/item/clothing/shoes/sneakers/hitops/red
	name = "red high-tops"
	icon_state = "redhi"
	item_state = "redhi"

/obj/item/clothing/shoes/sneakers/hitops/orange
	name = "orange high-tops"
	icon_state = "orangehi"
	item_state = "orangehi"

/obj/item/clothing/shoes/sneakers/hitops/yellow
	name = "yellow high-tops"
	icon_state = "yellowhi"
	item_state = "yellowhi"

/obj/item/clothing/shoes/sneakers/hitops/green
	name = "green high-tops"
	icon_state = "greenhi"
	item_state = "greenhi"

/obj/item/clothing/shoes/sneakers/hitops/blue
	name = "blue high-tops"
	icon_state = "bluehi"
	item_state = "bluehi"

/obj/item/clothing/shoes/sneakers/hitops/purple
	name = "purple high-tops"
	icon_state = "purplehi"
	item_state = "purplehi"

/obj/item/clothing/shoes/sneakers/hitops/brown
	name = "brown high-tops"
	icon_state = "brownhi"
	item_state = "brownhi"

/obj/item/clothing/shoes/sneakers/hitops/black
	name = "black high-tops"
	icon_state = "blackhi"
	item_state = "blackhi"

/obj/item/clothing/shoes/sneakers/hitops/rainbow
	name = "rainbow high-tops"
	icon_state = "rain_bowhi"
	item_state = "rain_bowhi"

/obj/item/clothing/shoes/sneakers/hitops/tip
	worn_overlay = "over"
	build_from_parts = TRUE

/obj/item/clothing/shoes/sneakers/hitops/thightops/tip
	worn_overlay = "overth"
	build_from_parts = TRUE
