/obj/item/battle_monsters/
	icon = 'icons/obj/battle_monsters/card.dmi'
	icon_state = ""
	var/list/center_of_mass = list("x"=16, "y"=16)
	var/facedown = TRUE
	var/rotated = FALSE

/obj/item/battle_monsters/dropped(mob/user as mob)
	set_dir(user.dir)
	if(rotated)
		set_dir(turn(dir,90))
	update_icon()
	. = ..()

/obj/item/battle_monsters/pickup(mob/user as mob)
	set_dir(NORTH)
	if(rotated)
		set_dir(turn(dir,90))
	update_icon()
	. = ..()

/obj/item/battle_monsters/MouseDrop(mob/user) //Dropping the card onto something else.
	if(istype(user))
		user.put_in_active_hand(src)
		src.pickup(user)
		return

	. = ..()

/obj/item/battle_monsters/MouseDrop_T(var/atom/movable/C, mob/user) //Dropping C onto the card
	if(istype(C,/obj/item/battle_monsters))
		src.attackby(C,user)
		return

	. = ..()

/obj/item/battle_monsters/AltClick(var/mob/user)
	RotateCard(user)

/obj/item/battle_monsters/CtrlClick(var/mob/user)
	attack_self(user)

/obj/item/battle_monsters/proc/RotateCard(var/mob/user)

	rotated = !rotated

	if(rotated)
		if(src.loc == user)
			to_chat(user,span("notice", "You prepare \the [name] to be played horizontally."))
			set_dir(turn(NORTH,90))
		else
			set_dir(turn(user.dir,90))
			user.visible_message(\
				span("notice","\The [user] adjusts the orientation of \the [src] horizontally."),\
				span("notice","You adjust the orientation of \the [src] horizontally.")\
			)
	else
		if(src.loc == user)
			to_chat(user,span("notice", "You prepare \the [name] to be played vertically."))
			set_dir(NORTH)
		else
			set_dir(user.dir)
			user.visible_message(\
				span("notice","\The [user] adjusts the orientation of \the [src] vertically."),\
				span("notice","You adjust the orientation of \the [src] vertically.")\
			)

	update_icon()


#define CELLS_X 6
#define CELLSIZE_X (32/CELLS_X)

#define CELLS_Y 6
#define CELLSIZE_Y (32/CELLS_Y)

/obj/item/battle_monsters/afterattack(atom/A, mob/user, proximity, params) //Copy and pasted from foodcode.
	if(proximity && params && (istype(A, /obj/structure/table) || (istype(A,/obj/structure/dueling_table) && A.density)) && center_of_mass.len)

		user.visible_message(\
			span("notice","\The [user] plays \the [src]."),\
			span("notice","You play \the [src].")\
		)

		//Places the item on a grid
		var/list/mouse_control = mouse_safe_xy(params)

		var/mouse_x = mouse_control["icon-x"]
		var/mouse_y = mouse_control["icon-y"]

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS_X-1, round(mouse_x/CELLSIZE_X)))
		var/cell_y = max(0, min(CELLS_Y-1, round(mouse_y/CELLSIZE_Y)))

		pixel_x = (CELLSIZE_X * (0.5 + cell_x)) - center_of_mass["x"]
		pixel_y = (CELLSIZE_Y * (0.5 + cell_y)) - center_of_mass["y"]

		layer = A.layer + 0.1

	. = ..()

#undef CELLS_X
#undef CELLSIZE_X

#undef CELLS_Y
#undef CELLSIZE_Y
