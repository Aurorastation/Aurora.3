/obj/item/clothing/head/softcap
	name = "softcap"
	desc = "It's a softcap in a tasteless color."
	icon_state = "softcap"
	var/flipped = FALSE
	siemens_coefficient = 0.9

/obj/item/clothing/head/softcap/dropped()
	icon_state = initial(icon_state)
	flipped = FALSE
	..()

/obj/item/clothing/head/softcap/attack_self(mob/user)
	flipped = !flipped
	icon_state = "[icon_state][flipped ? "_flipped" : ""]"
	to_chat(user, "You flip the hat [flipped ? "backwards" : "forwards"].")
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/softcap/colorable
	icon_state = "softcap_colorable"

/obj/item/clothing/head/softcap/colorable/random/Initialize()
	. = ..()
	color = get_random_colour(TRUE)

/obj/item/clothing/head/soft/rainbow
	name = "rainbow cap"
	desc = "It's a peaked cap in a bright rainbow of colors."
	icon_state = "rainbowsoft"

/obj/item/clothing/head/softcap/red // Antag red.
	name = "red softcap"
	desc = "It's a softcap in a menacing crimson red."
	icon_state = "softcap_red"
	item_state = "softcap_red"

// Departmental softcaps. By Wowzewow (Wezzy).

/obj/item/clothing/head/softcap/captain
	name = "captain's softcap"
	desc = "It's a peaked cap in a authoritative blue and yellow."
	icon_state = "softcap_captain"
	item_state = "softcap_captain"

/obj/item/clothing/head/softcap/security
	name = "security softcap"
	desc = "It's a peaked cap in a secure blue and grey."
	icon_state = "softcap_sec"
	item_state = "softcap_sec"

/obj/item/clothing/head/softcap/medical
	name = "medical softcap"
	desc = "It's a peaked cap in a sterile white and green."
	icon_state = "softcap_med"
	item_state = "softcap_med"

/obj/item/clothing/head/softcap/science
	name = "science softcap"
	desc = "It's a peaked cap in a analytical white and purple."
	icon_state = "softcap_sci"
	item_state = "softcap_sci"

/obj/item/clothing/head/softcap/engineering
	name = "engineering softcap"
	desc = "It's a peaked cap in a reflective yellow and orange."
	icon_state = "softcap_engi"
	item_state = "softcap_engi"

/obj/item/clothing/head/softcap/atmos
	name = "atmospherics softcap"
	desc = "It's a peaked cap in a refreshing yellow and blue."
	icon_state = "softcap_atmos"
	item_state = "softcap_atmos"

/obj/item/clothing/head/softcap/hydro
	name = "hydroponics softcap"
	desc = "It's a peaked cap in a fresh green and blue."
	icon_state = "softcap_hydro"
	item_state = "softcap_hydro"

/obj/item/clothing/head/softcap/cargo
	name = "cargo softcap"
	desc = "It's a peaked cap in a dusty yellow and grey."
	icon_state = "softcap_cargo"
	item_state = "softcap_cargo"

/obj/item/clothing/head/softcap/miner
	name = "mining softcap"
	desc = "It's a peaked cap in a chalky purple and brown."
	icon_state = "softcap_miner"
	item_state = "softcap_miner"

/obj/item/clothing/head/softcap/janitor
	name = "janitor softcap"
	desc = "It's a peaked cap in a sanitary purple and yellow."
	icon_state = "softcap_janitor"
	item_state = "softcap_janitor"

// Corporate.

/obj/item/clothing/head/soft/sec/corp
	name = "corporate security cap"
	desc = "It's field cap in corporate colors."
	icon_state = "corp"

/obj/item/clothing/head/soft/sec/idris
	name = "idris cap"
	desc = "It's an Idris cap."
	icon_state = "idris"

/obj/item/clothing/head/soft/iacberet
	name = "IAC soft cap"
	desc = "It's field cap in IAC colors."
	icon_state = "iac"

/obj/item/clothing/head/soft/eri
	name = "eridani cap"
	desc = "A grey EPMC fatigue cap with the symbol of the Eridani Corporate Federation on its front. For amoral mercenaries that prefer style over protection."
	icon_state = "eridani"
