/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	default_material = "wood"
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	slot_flags = SLOT_BACK
	equip_sound = null

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_STEEL)

/obj/item/material/twohanded/baseballbat/uranium/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/Initialize(newloc, material_key)
	. = ..(newloc, MATERIAL_DIAMOND)
