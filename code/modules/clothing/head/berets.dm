/obj/item/clothing/head/beret
	name = "beret"
	desc = "A baguette munching, cheese eating, wine drinking artist's favorite headwear. Hon hon!"
	icon = 'icons/obj/clothing/hats/berets.dmi'
	icon_state = "beret"
	item_state = "beret"
	item_flags = SHOWFLAVORTEXT
	contained_sprite = TRUE
	siemens_coefficient = 0.9

/obj/item/clothing/head/beret/colorable
	icon_state = "beret_colorable"
	item_state = "beret_colorable"

/obj/item/clothing/head/beret/colorable/random/Initialize()
	. = ..()
	color = get_random_colour(TRUE)

/obj/item/clothing/head/beret/red // Antag red.
	name = "red beret"
	desc = "It's a beret in a menacing crimson red."
	icon_state = "beret_red"
	item_state = "beret_red"

// Departmental berets. By Wowzewow (Wezzy).

/obj/item/clothing/head/beret/captain
	name = "captain's beret"
	desc = "A beret in command blue, with the captain's emblem. Serving in the navy just isn't the same without one."
	icon_state = "beret_captain"
	item_state = "beret_captain"

/obj/item/clothing/head/beret/security //also used by cadets
	name = "security beret"
	desc = "A beret in security navy blue, general purpose due to the lack an emblem. For security personnel that are more inclined towards style than safety."
	icon_state = "beret_sec"
	item_state = "beret_sec"

/obj/item/clothing/head/beret/medical
	name = "medical beret"
	desc = "A beret with the medical insignia emblazoned on it. For medical members that want to crush their brains after college left them in massive debt."
	icon_state = "beret_med"
	item_state = "beret_med"

/obj/item/clothing/head/beret/science
	name = "science beret"
	desc = "A beret with the science insignia emblazoned on it. Warning : Corporate does not reimburse clothing items damaged by polynitric acid. Not after an incident involving a certain cat. You know who you are."
	icon_state = "beret_sci"
	item_state = "beret_sci"

/obj/item/clothing/head/beret/engineering
	name = "engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. OSHA? I don't even know her!"
	icon_state = "beret_engi"
	item_state = "beret_engi"

/obj/item/clothing/head/beret/atmos
	name = "atmospherics beret"
	desc = "A beret with the engineering insignia emblazoned on it. Whoever wears this is pretty damn confident in not suffocating themselves to death."
	icon_state = "beret_atmos"
	item_state = "beret_atmos"

/obj/item/clothing/head/beret/hydro
	name = "hydroponics beret"
	desc = "A beret with the civillian insignia emblazoned on it. Unfortunately does not contain a pocket to hide your ambrosia vulgaris."
	icon_state = "beret_hydro"
	item_state = "beret_hydro"

/obj/item/clothing/head/beret/cargo
	name = "operations beret"
	desc = "A beret with the operations insignia emblazoned on it."
	icon_state = "beret_cargo"
	item_state = "beret_cargo"

/obj/item/clothing/head/beret/miner
	name = "mining beret"
	desc = "A beret with the cargo insignia emblazoned on it. Fall to your death - in style! If you manage to wear this with your EVA suit, though. At least medical's going to enjoy your cadaver."
	icon_state = "beret_miner"
	item_state = "beret_miner"

/obj/item/clothing/head/beret/janitor
	name = "janitor beret"
	desc = "A beret with the janitorial insignia emblazoned on it. Be proud to serve the great nation of Janitalia."
	icon_state = "beret_janitor"
	item_state = "beret_janitor"

// alt. sec stuff, because security needs berets for every link in the chain of command for some reason

/obj/item/clothing/head/beret/security/officer
	name = "officer beret"
	desc = "A beret in security navy blue, with a officer's rank emblem. For security personnel that are more inclined towards style than safety."
	icon_state = "beret_officer"
	item_state = "beret_officer"

/obj/item/clothing/head/beret/security/hos
	name = "commander beret"
	desc = "A beret in security navy blue with a commander's rank emblem. For heads of security that are more inclined towards style than safety."
	icon_state = "beret_hos"
	item_state = "beret_hos"

/obj/item/clothing/head/beret/security/warden
	name = "warden beret"
	desc = "A beret in security navy blue with a warden's rank emblem. For wardens that are more inclined towards style than safety."
	icon_state = "beret_warden"
	item_state = "beret_warden"

// Corporate.

/obj/item/clothing/head/beret/iac
	name = "IAC beret"
	desc = "A beret with the IAC insignia emblazoned on it."
	icon_state = "iac"
	item_state = "iac"

/obj/item/clothing/head/beret/corporate
	name = "nanotrasen beret"
	desc = "A beret with the NanoTrasen insignia emblazoned on it."
	icon_state = "nt"
	item_state = "nt"

/obj/item/clothing/head/beret/corporate/zeng
	name = "zeng-hu beret"
	desc = "A beret with the Zeng-Hu insignia emblazoned on it."
	icon_state = "zenghu"
	item_state = "zenghu"

/obj/item/clothing/head/beret/corporate/zeng/alt
	icon_state = "zenghualt"
	item_state = "zenghualt"

/obj/item/clothing/head/beret/corporate/zavod
	name = "zavodskoi interstellar beret"
	desc = "A beret with the Zavodskoi Interstellar insignia emblazoned on it."
	icon_state = "zav"
	item_state = "zav"

/obj/item/clothing/head/beret/corporate/zavod/alt
	icon_state = "zavalt"
	item_state = "zavalt"

/obj/item/clothing/head/beret/corporate/heph
	name = "hephaestus beret"
	desc = "A green beret with the Hephaestus insignia emblazoned on it."
	icon_state = "heph"
	item_state = "heph"

/obj/item/clothing/head/beret/corporate/pmc
	name = "PMCG beret"
	desc = "A beret with the PMCG insignia emblazoned on it."
	icon_state = "pmc"
	item_state = "pmc"

/obj/item/clothing/head/beret/corporate/pmc/epmc
	name = "epmc beret"
	desc = "A beret with the Eridani Private Military Contractor logo emblazoned on it."
	icon_state = "epmc"
	item_state = "epmc"

/obj/item/clothing/head/beret/corporate/idris
	name = "idris beret"
	desc = "A beret with the Idris Incorporated insignia emblazoned on it."
	icon_state = "idris"
	item_state = "idris"

/obj/item/clothing/head/beret/corporate/idris/alt
	icon_state = "idrisalt"
	item_state = "idrisalt"

/obj/item/clothing/head/beret/corporate/orion
	name = "orion express beret"
	desc = "A beret with the Orion Express insignia emblazoned on it."
	icon_state = "orion"
	item_state = "orion"

// TCFL

/obj/item/clothing/head/beret/legion
	name = "TCFL dress beret"
	desc = "A pale blue dress beret with a rubber insignia of a torch, surrounded by red stars and the letters \"TCFL\". A common good luck charm among former legionaires."
	icon_state = "tcfl_dress"
	item_state = "tcfl_dress"

/obj/item/clothing/head/beret/legion/field
	name = "TCFL field beret"
	desc = "A hardy, stark red field beret with a rubber insignia of a torch, surrounded by red stars and the letters \"TCFL\"."
	icon_state = "tcfl_field"
	item_state = "tcfl_field"

/obj/item/clothing/head/beret/legion/sentinel
	name = "TCFL sentinel beret"
	desc = "A hardy, stark purple sentinel beret with a rubber insignia of a torch, surrounded by red stars and the letters \"TCFL\"."
	icon_state = "tcfl_sentinel"
	item_state = "tcfl_sentinel"

//centcom

/obj/item/clothing/head/beret/centcom/officer
	name = "officers beret"
	desc = "A black beret adorned with the shield - a silver kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "centcomofficer"
	item_state = "centcomofficer"

/obj/item/clothing/head/beret/centcom/civilprotection
	name = "civil protection beret"
	desc = "A black beret adorned with the shield - a gold kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "civilprotection"
	item_state = "civilprotection"

/obj/item/clothing/head/beret/centcom/captain
	name = "captain's beret"
	desc = "A black beret adorned with the shield - a silver kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "centcomcaptain"
	item_state = "centcomcaptain"

/obj/item/clothing/head/beret/centcom/commander
	name = "commander's beret"
	desc = "A black beret adorned with the crest of an ERT detachment. Worn by commanders of NanoTrasen response teams."
	icon_state = "centcomcaptain"
	item_state = "centcomcaptain"
