// used to debug malf AI apc's. Maybe in the future it can be used for computers.
/obj/item/device/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	flags = CONDUCT
	force = 5
	w_class = ITEMSIZE_SMALL
	throwforce = 5
	throw_range = 15
	throw_speed = 3

	matter = list(DEFAULT_WALL_MATERIAL = 50, MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)