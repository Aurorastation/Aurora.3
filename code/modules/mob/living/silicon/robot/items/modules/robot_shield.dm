//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield1" //placeholder for now // four fucking years alberyk. FOUR
	var/shield_level = 0.5 //Percentage of damage absorbed by the shield.

/obj/item/borg/combat/shield/on_module_activate(mob/living/silicon/robot/R)
	R.shield_overlay = image(R.icon, "[R.module_sprites[R.icontype][ROBOT_CHASSIS]]-shield")
	R.add_overlay(R.shield_overlay)

/obj/item/borg/combat/shield/on_module_deactivate(mob/living/silicon/robot/R)
	R.cut_overlay(R.shield_overlay)

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = input(usr, "How much damage should the shield absorb?") in list("5", "10", "25", "50", "75", "100")
	if(N)
		shield_level = text2num(N)/100
