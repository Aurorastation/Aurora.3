/obj/item/clothing/head/beret
	name = "beret"
	desc = "A baguette munching, cheese eating, wine drinking artist's favorite headwear. Hon hon!"
	icon = 'icons/obj/clothing/hats/berets.dmi'
	icon_state = "beret"
	contained_sprite = TRUE
	siemens_coefficient = 0.9

/obj/item/clothing/head/beret/colorable
	icon_state = "beret_colorable"

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

/obj/item/clothing/head/beret/security/officer
	name = "officer beret"
	desc = "A beret in security navy blue, with a officer's rank emblem. For security personnel that are more inclined towards style than safety."
	icon_state = "beret_officer"
	item_state = "beret_officer"

/obj/item/clothing/head/beret/security/hos
	name = "blue commander beret"
	desc = "A beret in security navy blue beret with a commander's rank emblem. For heads of security that are more inclined towards style than safety."
	icon_state = "hosberet"

/obj/item/clothing/head/beret/security/hos/alt
	name = "black commander beret"
	desc = "A beret in corporate black with a commander's rank emblem. For heads of security that are more inclined towards style than safety."
	icon_state = "hosberet_corp"

/obj/item/clothing/head/beret/security/warden
	name = "warden beret"
	desc = "A beret in security navy blue with a warden's rank emblem. For wardens that are more inclined towards style than safety."
	icon_state = "beret_warden"

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
	desc =
	icon_state = "beret_hydro"
	item_state = "beret_hydro"

/obj/item/clothing/head/beret/cargo
	name = "cargo beret"
	desc =
	icon_state = "beret_cargo"
	item_state = "beret_cargo"

/obj/item/clothing/head/beret/miner
	name = "mining beret"
	desc =
	icon_state = "beret_miner"
	item_state = "beret_miner"

/obj/item/clothing/head/beret/janitor
	name = "janitor beret"
	desc = "A beret with the janitorial insignia emblazoned on it. Be proud to serve the great nation of Janitalia."
	icon_state = "beret_janitor"
	item_state = "beret_janitor"

// Corporate.

/obj/item/clothing/head/softcap/security/corp
	name = "corporate security beret"
	desc = "A beret in corporate black. For those who pledge allegiance to no flag nor banner, but their paycheck."
	icon_state = "corp"
	item_state = "corp"

/obj/item/clothing/head/beret/security/idris
	nse = "idris security beret"
	desc = "A beret with the Idris Incorporated insignia emblazoned on it."
	icon_state = "idrissec"

/obj/item/clothing/head/beret/security/zavodskoi
	name = "zavodskoi interstellar security beret"
	desc = "A brown beret with the Zavodskoi Interstellar insignia emblazoned on it."
	icon_state = "necrosec"

/obj/item/clothing/head/beret/security/zavodskoi/alt
	name = "zavodskoi interstellar security beret"
	desc = "A black beret with the Zavodskoi Interstellar insignia emblazoned on it."
	icon_state = "necrosecalt"

/obj/item/clothing/head/beret/security/eri
	name = "eridani security beret"
	desc = "A beret with the Eridani PMC insignia emblazoned on it."
	icon_state = "erisec"

/obj/item/clothing/head/beret/iac
	name = "IAC beret"
	desc = "A beret with the IAC insignia emblazoned on it."
	icon_state = "iac"
	item_state = "iac"

//berets




/obj/item/clothing/head/beret/engineering
	name = "engineering beret"

	icon_state = "e_beret"

/obj/item/clothing/head/beret/medical
	name = "medical beret"

	icon_state = "medberet"

/obj/item/clothing/head/beret/zeng
	name = "zeng-hu beret"
	desc = "A purple beret with the Zeng-Hu insignia emblazoned on it."
	icon_state = "zengberet"

/obj/item/clothing/head/beret/zeng/alt
	name = "zeng-hu beret"
	desc = "A white beret with the Zeng-Hu insignia emblazoned on it."
	icon_state = "zengaltberet"

/obj/item/clothing/head/beret/heph
	name = "hephaestus beret"
	desc = "A green beret with the Hephaestus insignia emblazoned on it."
	icon_state = "hephberet"



/obj/item/clothing/head/beret/liaison
	name = "corporate liaison beret"
	desc = "A stylish beret worn by corporate liaisons."
	icon_state = "centcomofficerberet"

/obj/item/clothing/head/beret/centcom/officer
	name = "officers beret"
	desc = "A black beret adorned with the shield - a silver kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "centcomofficerberet"

/obj/item/clothing/head/beret/centcom/officer/civilprotection
	name = "civil protection beret"
	desc = "A black beret adorned with the shield - a gold kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "civilprotection_beret"
	item_state = "civilprotection_beret"

/obj/item/clothing/head/beret/centcom/captain
	name = "captains beret"
	desc = "A white beret adorned with the shield - a silver kite shield with an engraved sword - of the NanoTrasen security forces."
	icon_state = "centcomcaptain"

/obj/item/clothing/head/beret/centcom/commander
	name = "commanders beret"
	desc = "A white beret adorned with the crest of an ERT detachment. Worn by commanders of Nanotrasen response teams."
	icon_state = "centcomcaptain"

/obj/item/clothing/head/beret/misc
	name = "beret"
	desc = "A colorful beret, treasured by artists and the French."
	icon_state = "miscberet"
	item_state = "miscberet"
