/obj/item/clothing/head/wizard
	name = "wizard hat"
	desc = "Strange-looking hat-wear that most certainly belongs to a real magic user."
	icon_state = "wizard"
	item_state_slots = list(
		slot_l_hand_str = "wizhat",
		slot_r_hand_str = "wizhat"
		)
	body_parts_covered = 0

/obj/item/clothing/head/wizard/red
	name = "red wizard hat"
	desc = "Strange-looking, red, hat-wear that most certainly belongs to a real magic user."
	icon_state = "redwizard"

/obj/item/clothing/head/wizard/fake
	name = "wizard hat"
	desc = "It has WIZZARD written across it in sequins. Comes with a cool beard."
	icon_state = "wizard-fake"
	body_parts_covered = HEAD|FACE

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
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/material/knife/ritual)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/wizrobe/red
	name = "red wizard robe"
	desc = "A magnificant, red, gem-lined robe that seems to radiate power."
	icon_state = "redwizard"
	item_state = "redwizrobe"

/obj/item/clothing/suit/wizrobe/magusblue
	name = "magus robe"
	desc = "A set of armored robes that seem to radiate a dark power"
	icon_state = "magusblue"
	item_state = "magusblue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/wizrobe/magusred
	name = "magus robe"
	desc = "A set of armored robes that seem to radiate a dark power"
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
	allowed = list(/obj/item/tank/emergency_oxygen, /obj/item/material/knife/ritual)
	flags_inv = HIDEJUMPSUIT

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = 0

/obj/item/clothing/suit/wizrobe/fake
	name = "wizard robe"
	desc = "A rather dull, blue robe meant to mimick real wizard robes."
	icon_state = "wizard-fake"
	item_state = "wizrobe"

//black robes

/obj/item/clothing/head/wizard/black
	name = "black wizard hat"
	desc = "Strange-looking, black, hat-wear that most certainly belongs to a real dark magic user."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "blackwizardhat"
	item_state = "blackwizardhat"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/black
	name = "black wizard robe"
	desc = "An unnerving black gem-lined robe that reeks of death and decay."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "blackwizard"
	item_state = "blackwizard"
	contained_sprite = TRUE

// - Kyres and Geeves -
// Storm Outfit
/obj/item/clothing/head/wizard/storm
	name = "storm cowl"
	desc = "A grey cowl exuding potent magickal energy, or maybe it just hides your identity well."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "storm_cowl"
	item_state = "storm_cowl"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/storm
	name = "storm robes"
	desc = "A fashionable set of robes that makes your hair stand on end. Positively electrifying."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "storm_robes"
	item_state = "storm_robes"
	contained_sprite = TRUE

// Nature Outfit
/obj/item/clothing/head/wizard/nature
	name = "nature crown"
	desc = "Simple, sleek, elegant. Smells a bit like honey and aloe."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "nature_crown"
	item_state = "nature_crown"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/nature
	name = "nature robes"
	desc = "A green set of robes that sets the wearer apart from the rest. Doesn't itch! Somehow. Must be magic."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "nature_robes"
	item_state = "nature_robes"
	contained_sprite = TRUE

/obj/item/clothing/accessory/poncho/nature
	name = "nature scarf"
	desc = "A beautiful scarf that threatens to puncture the wearer's neck with thorns."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "nature_scarf"
	item_state = "nature_scarf"
	icon_override = null
	contained_sprite = TRUE

// Techno Outfit
/obj/item/clothing/head/wizard/techno
	name = "techno headwear"
	desc = "A glowing set of eyes on the sides of this helmet makes you positively look like a pillock. On the plus side, you can see a lot."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "techno_headwear"
	item_state = "techno_headwear"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/techno
	name = "techno robes"
	desc = "A heavy set of robes made of some metallic material, who knows really. Comes with a useless LED strapped to the side as well."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "techno_robes"
	item_state = "techno_robes"
	contained_sprite = TRUE
	flags_inv = 0

/obj/item/clothing/under/techo
	name = "techno suit"
	desc = "A fantastically complex suit with a million moving parts, and it even glows faintly enough to not cast any light. Truly magical."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "techno_suit"
	worn_state = "techno_suit"
	item_state = "techno_suit"
	contained_sprite = TRUE

/obj/item/clothing/shoes/techno
	name = "techno shoes"
	desc = "Shoes! Nothing special, they just complete the techno look."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "techno_shoes"
	item_state = "techno_shoes"
	contained_sprite = TRUE

// Cobra Outfit
/obj/item/clothing/head/wizard/cobra
	name = "cobra hood"
	desc = "A badass red hood, worn by badass people, in badass places, like Skrellpop conventions."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "cobra_hood"
	item_state = "cobra_hood"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/cobra
	name = "cobra robes"
	desc = "A set of red robes that has nothing to do with actual cobras. Looks cool though."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "cobra_robes"
	item_state = "cobra_robes"
	contained_sprite = TRUE

// Brawler Outfit
/obj/item/clothing/head/wizard/brawler
	name = "brawler mask"
	desc = "A brawler MASK that goes onto your HEAD. It makes you look like an insane plonker, and that's probably what you want."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "brawler_mask"
	item_state = "brawler_mask"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/brawler
	name = "brawler robes"
	desc = "A set of so-called robes that makes the wearer look like a ruthless gladiatorial warrior. Give them hell."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "brawler_robes"
	item_state = "brawler_robes"
	contained_sprite = TRUE

// Shimmer Outfit
/obj/item/clothing/head/wizard/shimmer
	name = "shimmer helm"
	desc = "A cool off-gold helmet that makes the wearer look like they control fate. Wait, do they actually control fate?"
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "shimmer_helm"
	item_state = "shimmer_helm"
	flags_inv = BLOCKHAIR|BLOCKHEADHAIR
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/shimmer
	name = "shimmer robes"
	desc = "A set of off-gold robes that shimmers in the light, making the wearer to harder and easier see. Must be very well polished."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "shimmer_robes"
	item_state = "shimmer_robes"
	contained_sprite = TRUE

// Sorceress Outfit
/obj/item/clothing/head/wizard/sorceress
	name = "sorceress crown"
	desc = "A spikey crown that looks like it came directly off the set of an under-budget over-produced film. Looks great though."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "blackwizardhat"
	item_state = "blackwizardhat"
	contained_sprite = TRUE

/obj/item/clothing/suit/wizrobe/sorceress
	name = "sorceress robes"
	desc = "A set of black and red robes, when the director gives up and buys off the New Hai Phong exports list."
	icon = 'icons/obj/wizard_gear.dmi'
	icon_state = "sorceress_robes"
	item_state = "sorceress_robes"
	contained_sprite = TRUE