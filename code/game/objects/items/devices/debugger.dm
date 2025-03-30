// Used to resolve throwing vendors without going directly into wiring.
/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 11
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = 3
	hitsound = 'sound/machines/switch1.ogg'

	matter = list(MATERIAL_PLASTIC = 50, DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
