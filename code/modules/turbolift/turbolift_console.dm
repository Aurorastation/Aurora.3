// Base type, do not use.
/obj/structure/lift
	name = "turbolift control component"
	icon = 'icons/obj/turbolift.dmi'
	anchored = 1
	density = 0
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

	var/datum/turbolift/lift

/obj/structure/lift/set_dir(var/newdir)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	if(dir & NORTH)
		pixel_y = -32
	else if(dir & SOUTH)
		pixel_y = 32
	else if(dir & EAST)
		pixel_x = -32
	else if(dir & WEST)
		pixel_x = 32

/obj/structure/lift/proc/pressed(var/mob/user)
	if(!istype(user, /mob/living/silicon))
		if(user.a_intent == I_HURT)
			user.visible_message(SPAN_DANGER("\The [user] hammers on the lift button!"))
		else
			user.visible_message("<b>\The [user]</b> presses the lift button.")


/obj/structure/lift/Initialize(mapload, datum/turbolift/_lift)
	lift = _lift
	return ..(mapload)

/obj/structure/lift/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/structure/lift/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	return attack_hand(user)

/obj/structure/lift/attack_hand(var/mob/user)
	return ui_interact(user)

/obj/structure/lift/ui_interact(var/mob/user)
	if(!lift.is_functional())
		return FALSE
	return TRUE
// End base.

// Button. No HTML interface, just calls the associated lift to its floor.
/obj/structure/lift/button
	name = "elevator button"
	desc = "A call button for an elevator. Be sure to hit it three hundred times."
	icon_state = "button"
	var/light_up = FALSE
	var/datum/turbolift_floor/floor

/obj/structure/lift/button/Initialize(mapload, datum/turbolift/_lift)
	. = ..()
	AddComponent(/datum/component/turf_hand)

/obj/structure/lift/button/Destroy()
	if(floor && floor.ext_panel == src)
		floor.ext_panel = null
	floor = null
	return ..()

/obj/structure/lift/button/proc/reset()
	light_up = FALSE
	update_icon()

/obj/structure/lift/button/attack_ghost(var/mob/user)
	if(check_rights(R_ADMIN, FALSE, user))
		return ui_interact(user)

/obj/structure/lift/button/ui_interact(var/mob/user)
	if(!..())
		return
	light_up()
	pressed(user)
	if(floor == lift.current_floor)
		lift.open_doors()
		addtimer(CALLBACK(src, PROC_REF(reset)), 3)
		return
	lift.queue_move_to(floor)

/obj/structure/lift/button/proc/light_up()
	light_up = TRUE
	update_icon()

/obj/structure/lift/button/update_icon()
	if(light_up)
		icon_state = "button_lit"
	else
		icon_state = initial(icon_state)

// End button.

// Panel. Lists floors (HTML), moves with the elevator, schedules a move to a given floor.
/obj/structure/lift/panel
	name = "elevator control panel"
	icon_state = "panel"

/obj/structure/lift/panel/Initialize(mapload, datum/turbolift/_lift)
	. = ..()
	AddComponent(/datum/component/turf_hand)

/obj/structure/lift/panel/attack_ghost(var/mob/user)
	return ui_interact(user)

/obj/structure/lift/panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurboLift", ui_x=280, ui_y=200)
		ui.open()

/obj/structure/lift/panel/ui_data(mob/user)
	var/list/data = list()
	data["floors"] = lift.floors
	data["currentFloor"] = lift.floors.Find(lift.current_floor)
	data["doorsOpen"] = lift.doors_are_open()
	return data

/obj/structure/lift/panel/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "move_to_floor")
		add_fingerprint(usr)
		lift.queue_move_to(lift.floors[length(lift.floors) - text2num(params["floor"])])
		pressed(usr)
		return TRUE
	if(action == "toggle_doors")
		add_fingerprint(usr)
		if(lift.doors_are_open())
			lift.close_doors()
		else
			lift.open_doors()
		pressed(usr)
		return TRUE
	if(action == "emergency_stop")
		add_fingerprint(usr)
		lift.emergency_stop()
		pressed(usr)
		return TRUE

// End panel.
