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
	layer = ABOVE_HUMAN_LAYER

/obj/effect/decal/battlemonsters_logo
	name = "battlemonsters logo"
	icon = 'icons/obj/battle_monsters/logo.dmi'
	icon_state = "logo"
	anchored = 1
	density = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

#define CELLS 8
#define CELLSIZE (world.icon_size/CELLS)

/obj/structure/dueling_table/attackby(obj/item/attacking_item, mob/user , params)
	if(user.unEquip(attacking_item, 0, src.loc))
		if(!attacking_item.center_of_mass)
			attacking_item.randpixel_xy()
			return

		if(!params)
			return

		var/list/mouse_control = mouse_safe_xy(params)
		var/mouse_x = mouse_control["icon-x"]
		var/mouse_y = mouse_control["icon-y"]

		if(isnum(mouse_x) && isnum(mouse_y))
			var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
			var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

			attacking_item.pixel_x = (CELLSIZE * (0.5 + cell_x)) - attacking_item.center_of_mass["x"]
			attacking_item.pixel_y = (CELLSIZE * (0.5 + cell_y)) - attacking_item.center_of_mass["y"]

		attacking_item.layer = src.layer + 0.1

#undef CELLS
#undef CELLSIZE
