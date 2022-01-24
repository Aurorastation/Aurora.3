// These objects are used by cyborgs to get around a lot of the limitations on stacks
// and the weird bugs that crop up when expecting borg module code to behave sanely.
/obj/item/stack/material/cyborg
	uses_charge = 1
	charge_costs = list(1000)
	gender = NEUTER

	// Don't shove it in the autholathe
	recyclable = FALSE
	matter = null

/obj/item/stack/material/cyborg/New()
	if(..())
		name = "[material.display_name] synthesiser"
		desc = "A device that synthesises [material.display_name]."
		matter = null

/obj/item/stack/material/cyborg/plastic
	icon_state = "sheet-plastic"
	default_type = MATERIAL_PLASTIC

/obj/item/stack/material/cyborg/steel
	icon_state = "sheet-metal"
	default_type = MATERIAL_STEEL

/obj/item/stack/material/cyborg/plasteel
	icon_state = "sheet-plasteel"
	default_type = MATERIAL_PLASTEEL

/obj/item/stack/material/cyborg/wood
	icon_state = "sheet-wood"
	default_type = MATERIAL_WOOD

/obj/item/stack/material/cyborg/cloth
	icon_state = "sheet-cloth"
	default_type = MATERIAL_CLOTH

/obj/item/stack/material/cyborg/glass
	desc_info = "Use in your hand to build a window.  Can be upgraded to reinforced glass by adding metal rods, which are made from metal sheets.<br>\
	As a synthetic, you can acquire more sheets of glass by recharging."
	icon_state = "sheet-glass"
	default_type = MATERIAL_GLASS

/obj/item/stack/material/cyborg/glass/reinforced
	desc_info = "Use in your hand to build a window. Reinforced glass is much stronger against damage.<br>\
	As a synthetic, you can gain more reinforced glass by recharging."
	icon_state = "sheet-rglass"
	default_type = MATERIAL_GLASS_REINFORCED
	charge_costs = list(500, 1000)
