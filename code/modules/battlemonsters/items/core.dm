/obj/item/battle_monsters/
	icon = 'icons/obj/battle_monsters/card.dmi'
	icon_state = ""
	var/list/center_of_mass = list("x"=16, "y"=16)
	var/facedown = TRUE
	var/rotated = FALSE

/obj/item/battle_monsters/MouseDrop(mob/user) //Dropping the card onto yourself.
	user.put_in_active_hand(src)

/obj/item/battle_monsters/MouseDrop_T(var/atom/movable/C, mob/user) //Dropping C onto the card
	if(istype(C,/obj/item/battle_monsters))
		src.attackby(C,user)

/obj/item/battle_monsters/proc/RotateCard(var/mob/user,var/rotation)
	dir = turn(dir,rotation)
	update_icon()

/obj/item/battle_monsters/AltClick(var/mob/user)
	if(!rotated)
		dir = user.dir
		RotateCard(user,90)
		rotated = TRUE
	else
		dir = user.dir
		rotated = FALSE

/obj/item/battle_monsters/CtrlClick(var/mob/user)
	attack_self(user)

#define CELLS_X 4
#define CELLSIZE_X (32/CELLS_X)

#define CELLS_Y 2
#define CELLSIZE_Y (32/CELLS_Y)

/obj/item/battle_monsters/afterattack(atom/A, mob/user, proximity, params) //Copy and pasted from foodcode.
	if(proximity && params && istype(A, /obj/structure/table) && center_of_mass.len)
		//Places the item on a grid
		var/list/mouse_control = params2list(params)

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS_X-1, round(mouse_x/CELLSIZE_X)))
		var/cell_y = max(0, min(CELLS_Y-1, round(mouse_y/CELLSIZE_Y)))

		pixel_x = Ceiling((CELLSIZE_X * (0.5 + cell_x)) - center_of_mass["x"],1)
		pixel_y = Ceiling((CELLSIZE_Y * (0.5 + cell_y)) - center_of_mass["y"],1)

	. = ..()

#undef CELLS_X
#undef CELLSIZE_X

#undef CELLS_Y
#undef CELLSIZE_Y