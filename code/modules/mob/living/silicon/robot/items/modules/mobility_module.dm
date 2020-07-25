/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/combat/mobility/on_module_activate(mob/living/silicon/robot/R)
	R.icon_state = "[R.module_sprites[R.icontype]]-roll"
	R.speed = -2

/obj/item/borg/combat/mobility/on_module_deactivate(mob/living/silicon/robot/R)
	R.icon_state = R.module_sprites[R.icontype]
	R.speed = initial(R.speed)