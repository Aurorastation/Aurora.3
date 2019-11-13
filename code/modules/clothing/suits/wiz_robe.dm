/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	item_state_slots = list(
		slot_l_hand_str = "wizhat",
		slot_r_hand_str = "wizhat"
		)
	//Not given any special protective value since the magic robes are full-body protection --NEO
	siemens_coefficient = 0.75
	body_parts_covered = 0
	wizard_garb = 1

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	body_parts_covered = HEAD|FACE
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/marisa
	name = "witch Hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"

/obj/item/clothing/head/wizard/magus
	name = "magus Helm"
	desc = "A mysterious helmet that hums with an unearthly power"
	icon_state = "magus"
	item_state = "magus"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/wizard/amp
	name = "psychic amplifier"
	desc = "A crown-of-thorns psychic amplifier. Kind of looks like a tiara having sex with an industrial robot."
	icon_state = "amp"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet"
		)

/obj/item/clothing/head/wizard/cap
	name = "gentlemans cap"
	desc = "A checkered gray flat cap woven together with the rarest of threads."
	icon_state = "gentcap"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat"
		)

/obj/item/clothing/suit/wizrobe
	name = "wizard robe"
	desc = "A magnificant, gem-lined robe that seems to radiate power."
	icon_state = "wizard"
	item_state = "wizrobe"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(melee = 30, bullet = 20, laser = 20,energy = 20, bomb = 20, bio = 20, rad = 20)
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/teleportation_scroll,/obj/item/scrying,/obj/item/spellbook,/obj/item/device/soulstone,/obj/item/material/knife/ritual)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.75
	wizard_garb = 1

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/marisa
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "magus robe"
	desc = "A set of armoured robes that seem to radiate a dark power"
	icon_state = "magusblue"
	item_state = "magusblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/magusred
	name = "magus robe"
	desc = "A set of armoured robes that seem to radiate a dark power"
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/psypurple
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with psychic amplifiers and weird, bulbous lenses. Do not machine wash."
	icon_state = "psyamp"
	item_state = "psyamp"

/obj/item/clothing/suit/storage/toggle/wizrobe/gentlecoat
	name = "gentlemans coat"
	desc = "A heavy threaded tweed gray jacket. For a different sort of Gentleman."
	icon_state = "gentlecoat"
	item_state = "gentlecoat"
	icon_open = "gentlecoat_open"
	icon_closed = "gentlecoat"
	gas_transfer_coefficient = 0.01 // IT'S MAGICAL OKAY JEEZ +1 TO NOT DIE
	permeability_coefficient = 0.01
	armor = list(melee = 30, bullet = 20, laser = 20,energy = 20, bomb = 20, bio = 20, rad = 20)
	allowed = list(/obj/item/tank/emergency_oxygen,/obj/item/teleportation_scroll,/obj/item/scrying,/obj/item/spellbook,/obj/item/device/soulstone,/obj/item/material/knife/ritual)
	flags_inv = HIDEJUMPSUIT
	siemens_coefficient = 0.75
	wizard_garb = 1

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = 0

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	item_state = "wizrobe"
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/head/wizard/marisa/fake
	name = "witch hat"
	desc = "Strange-looking hat-wear, makes you want to cast fireballs."
	icon_state = "marisa"
	armor = null
	siemens_coefficient = 1.0

/obj/item/clothing/suit/wizrobe/marisa/fake
	name = "witch robe"
	desc = "Magic is all about the spell power, ZE!"
	icon_state = "marisa"
	item_state = "marisarobe"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = null
	siemens_coefficient = 1.0

//black robes

/obj/item/clothing/head/wizard/black
	name = "black wizard hat"
	desc = "Strange-looking, black, hat-wear that most certainly belongs to a real dark magic user."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "blackwizardhat"
	item_state = "blackwizardhat"
	contained_sprite = 1

/obj/item/clothing/suit/wizrobe/black
	name = "black wizard robe"
	desc = "An unnerving black gem-lined robe that reeks of death and decay."
	icon = 'icons/obj/necromancer.dmi'
	icon_state = "blackwizard"
	item_state = "blackwizard"
	contained_sprite = 1
