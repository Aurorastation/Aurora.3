// Used to resolve throwing vendors without going directly into wiring.
/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment, debuggers come with a retractable data cable that can be plugged into most machines."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 11
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = 3
	hitsound = /singleton/sound_category/switch_sound

	matter = list(MATERIAL_PLASTIC = 50, DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/device/debugger/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The debugger can be used on vending machines and APCs to identify and resolve any viral infections."
