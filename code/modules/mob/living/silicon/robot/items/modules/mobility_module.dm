/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/rescue/mobility
	name = "mobility module"
	desc = "The Rescue Module has been outfitted with thrusters capable of retrieving injured Crew at speeds unheard of in other Stationbound modules."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/borg/combat/mobility/on_module_activate(mob/living/silicon/robot/R)
	R.icon_state = "[R.module_sprites[R.icontype][ROBOT_CHASSIS]]-roll"
	R.speed = -2
	R.setup_eye_cache()

/obj/item/borg/rescue/mobility/on_module_activate(mob/living/silicon/robot/R)
	R.speed = -1

/obj/item/borg/rescue/mobility/on_module_deactivate(mob/living/silicon/robot/R)
	R.speed = initial(R.speed)

/obj/item/borg/combat/mobility/on_module_deactivate(mob/living/silicon/robot/R)
	R.icon_state = "[R.module_sprites[R.icontype][ROBOT_CHASSIS]]"
	R.speed = initial(R.speed)
	R.setup_eye_cache()
