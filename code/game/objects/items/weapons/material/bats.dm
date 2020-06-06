/obj/item/material/twohanded/baseballbat
	name = "bat"
	desc = "HOME RUN!"
	icon_state = "metalbat0"
	base_icon = "metalbat"
	item_state = "metalbat"
	throwforce = 7
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'
	default_material = "wood"
	force_divisor = 1.1           // 22 when wielded with weight 20 (steel)
	unwielded_force_divisor = 0.7 // 15 when unwielded based on above.
	slot_flags = SLOT_BACK

//Predefined materials go here.
/obj/item/material/twohanded/baseballbat/metal/New(var/newloc)
	..(newloc, MATERIAL_STEEL)

/obj/item/material/twohanded/baseballbat/uranium/New(var/newloc)
	..(newloc, MATERIAL_URANIUM)

/obj/item/material/twohanded/baseballbat/gold/New(var/newloc)
	..(newloc, MATERIAL_GOLD)

/obj/item/material/twohanded/baseballbat/platinum/New(var/newloc)
	..(newloc, MATERIAL_PLATINUM)

/obj/item/material/twohanded/baseballbat/diamond/New(var/newloc)
	..(newloc, MATERIAL_DIAMOND)