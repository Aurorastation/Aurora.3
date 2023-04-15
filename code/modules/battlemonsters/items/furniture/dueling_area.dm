/obj/structure/dueling_table
	name = "dueling table"
	icon = 'icons/obj/battle_monsters/furniture.dmi'
	anchored = 1
	density = 1
	climbable = TRUE
	throwpass = 1

/obj/structure/dueling_table/no_collide
	density = 0

/obj/structure/dueling_table/no_collide/above_layer
	layer = ABOVE_MOB_LAYER

/obj/effect/decal/battlemonsters_logo
	name = "battlemonsters logo"
	icon = 'icons/obj/battle_monsters/logo.dmi'
	icon_state = "logo"
	anchored = 1
	density = 0
	mouse_opacity = 0

#define CELLS 8
#define CELLSIZE (world.icon_size/CELLS)

/obj/structure/dueling_table/attackby(obj/item/W as obj, mob/user as mob, var/click_parameters)
	if(user.unEquip(W, 0, src.loc))
		if(!W.center_of_mass)
			W.randpixel_xy()
			return

		if(!click_parameters)
			return

		var/list/mouse_control = mouse_safe_xy(click_parameters)
		var/mouse_x = mouse_control["icon-x"]
		var/mouse_y = mouse_control["icon-y"]

		if(isnum(mouse_x) && isnum(mouse_y))
			var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
			var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

			W.pixel_x = (CELLSIZE * (0.5 + cell_x)) - W.center_of_mass["x"]
			W.pixel_y = (CELLSIZE * (0.5 + cell_y)) - W.center_of_mass["y"]

		W.layer = src.layer + 0.1

#undef CELLS
#undef CELLSIZE
