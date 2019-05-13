/obj/item/clothing/shoes
	name = "shoes"
	icon_state = "white"
	desc = "A pair of shoes."
	drop_sound = 'sound/items/drop/shoes.ogg'

/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	desc = "A pair of black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/black/noslip
	item_flags = NOSLIP

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "mime"
	permeability_coefficient = 0.01

/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"
	drop_sound = 'sound/items/drop/leather.ogg'

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	var/obj/item/weapon/handcuffs/chained = null

/obj/item/clothing/shoes/flats
	desc = "A pair of black, low-heeled women's flats."
	name = "black dress flats"
	icon = 'icons/obj/clothing/cheongsams.dmi'
	icon_state = "dressflatsblack"
	item_state = "dressflatsblack"
	species_restricted = null
	contained_sprite = 1

/obj/item/clothing/shoes/flats/red
	desc = "A pair of red, low-heeled women's flats."
	name = "red dress flats"
	icon = 'icons/obj/clothing/cheongsams.dmi'
	icon_state = "dressflatsred"
	item_state = "dressflatsred"

/obj/item/clothing/shoes/flats/blue
	desc = "A pair of blue, low-heeled women's flats."
	name = "blue dress flats"
	icon_state = "dressflatsblue"
	item_state = "dressflatsblue"

/obj/item/clothing/shoes/flats/green
	desc = "A pair of green, low-heeled women's flats."
	name = "green dress flats"
	icon_state = "dressflatsgreen"
	item_state = "dressflatsgreen"

/obj/item/clothing/shoes/flats/purple
	desc = "A pair of purple, low-heeled women's flats."
	name = "purple dress flats"
	icon_state = "dressflatspurple"
	item_state = "dressflatspurple"

/obj/item/clothing/shoes/flats/white
	desc = "A pair of white, low-heeled women's flats."
	name = "white dress flats"
	icon_state = "dressflatswhite"
	item_state = "dressflatswhite"

/obj/item/clothing/shoes/orange/proc/attach_cuffs(var/obj/item/weapon/handcuffs/cuffs, mob/user as mob)
	if (src.chained) return

	user.drop_from_inventory(cuffs,src)
	src.chained = cuffs
	src.slowdown = 15
	src.icon_state = "orange1"

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if (!src.chained) return

	user.put_in_hands(src.chained)
	src.chained.add_fingerprint(user)

	src.slowdown = initial(slowdown)
	src.icon_state = "orange"
	src.chained = null

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(H as obj, mob/user as mob)
	..()
	if (istype(H, /obj/item/weapon/handcuffs))
		attach_cuffs(H, user)

/obj/item/clothing/shoes/hitops
	name = "white high-tops"
	desc = "A pair of shoes that extends past the ankle. Based on a centuries-old, timeless design."
	icon_state = "whitehi"
	item_state = "whitehi"

/obj/item/clothing/shoes/hitops/red
	name = "red high-tops"
	icon_state = "redhi"
	item_state = "redhi"

/obj/item/clothing/shoes/hitops/brown
	name = "brown high-tops"
	icon_state = "brownhi"
	item_state = "brownhi"

/obj/item/clothing/shoes/hitops/black
	name = "black high-tops"
	icon_state = "blackhi"
	item_state = "blackhi"

/obj/item/clothing/shoes/hitops/orange
	name = "orange high-tops"
	icon_state = "orangehi"
	item_state = "orangehi"

/obj/item/clothing/shoes/hitops/blue
	name = "blue high-tops"
	icon_state = "bluehi"
	item_state = "bluehi"

/obj/item/clothing/shoes/hitops/green
	name = "green high-tops"
	icon_state = "greenhi"
	item_state = "greenhi"

/obj/item/clothing/shoes/hitops/purple
	name = "purple high-tops"
	icon_state = "purplehi"
	item_state = "purplehi"

/obj/item/clothing/shoes/hitops/yellow
	name = "yellow high-tops"
	icon_state = "yellowhi"
	item_state = "yellowhi"