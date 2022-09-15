/obj/item/clothing/head/bandana
	name = "bandana"
	desc = "It's a bandana with some fine nanotech lining."
	icon = 'icons/obj/item/clothing/hats/bandanas.dmi'
	icon_state = "bandana"
	item_state = "bandana"
	flags_inv = 0
	body_parts_covered = 0
	contained_sprite = TRUE

/obj/item/clothing/head/bandana/colorable
	icon_state = "bandana_colorable"
	item_state = "bandana_colorable"

/obj/item/clothing/head/bandana/colorable/random/Initialize()
	. = ..()
	color = get_random_colour(TRUE)

/obj/item/clothing/head/bandana/pirate // legacy antag item.
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "bandana_pirate"
	item_state = "bandana_pirate"

/obj/item/clothing/head/bandana/red // Antag red.
	name = "red bandana"
	desc = "It's a bandana with some fine nanotech lining. In a fine crimson."
	icon_state = "bandana_red"
	item_state = "bandana_red"

// Departmental bandanas. By Wowzewow (Wezzy).
/obj/item/clothing/head/bandana/security
	name = "security bandana"
	desc = "It's a security bandana with some fine nanotech lining. Great for holding back your thick mullet while chasing perps."
	icon_state = "bandana_sec"
	item_state = "bandana_sec"

/obj/item/clothing/head/bandana/medical
	name = "medical bandana"
	desc = "It's a medical bandana with some fine nanotech lining. The blood just wrings out!"
	icon_state = "bandana_med"
	item_state = "bandana_med"

/obj/item/clothing/head/bandana/science
	name = "science bandana"
	desc = "It's a science bandana with some fine nanotech lining. Smells of sulfuric acid."
	icon_state = "bandana_sci"
	item_state = "bandana_sci"

/obj/item/clothing/head/bandana/engineering
	name = "engineering bandana"
	desc = "It's an engineering bandana with some fine nanotech lining. In high-visibility yellow!"
	icon_state = "bandana_engi"
	item_state = "bandana_engi"

/obj/item/clothing/head/bandana/atmos
	name = "atmospherics bandana"
	desc = "It's an atmospherics bandana with some fine nanotech lining. Inflammable? Flammable? With this baby, your hair won't catch fire. Probably."
	icon_state = "bandana_atmos"
	item_state = "bandana_atmos"

/obj/item/clothing/head/bandana/hydro
	name = "hydroponics bandana"
	desc = "It's a hydroponics bandana with some fine nanotech lining. Did someone spill Plant-B-Gone on this?"
	icon_state = "bandana_hydro"
	item_state = "bandana_hydro"

/obj/item/clothing/head/bandana/hydro/nt
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "nt_gardener_headband"
	item_state = "nt_gardener_headband"

/obj/item/clothing/head/bandana/hydro/idris
	icon = 'icons/obj/item/clothing/department_uniforms/service.dmi'
	contained_sprite = TRUE
	icon_state = "idris_gardener_headband"
	item_state = "idris_gardener_headband"

/obj/item/clothing/head/bandana/cargo
	name = "operations bandana"
	desc = "It's a operations bandana with some fine nanotech lining. Wicks away the sweat from crate-pushing all day."
	icon_state = "bandana_cargo"
	item_state = "bandana_cargo"

/obj/item/clothing/head/bandana/miner
	name = "mining bandana"
	desc = "It's a mining bandana with some fine nanotech lining. Almost makes you want to go in a fey mood."
	icon_state = "bandana_miner"
	item_state = "bandana_miner"

/obj/item/clothing/head/bandana/janitor
	name = "janitor bandana"
	desc = "It's a janitor bandana with some fine nanotech lining. For the viscera cleaners of today!"
	icon_state = "bandana_janitor"
	item_state = "bandana_janitor"
