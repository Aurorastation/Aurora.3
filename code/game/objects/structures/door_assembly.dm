#define STATE_UNWIRED 0
#define STATE_WIRED 1
#define STATE_ELECTRONICS_INSTALLED 2

/obj/structure/door_assembly
	name = "airlock assembly"
	desc = "An airlock assembly."
	desc_info = "To create a glass airlock, add two reinforced glass sheets."
	icon = 'icons/obj/doors/basic/single/generic/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	density = TRUE
	w_class = ITEMSIZE_HUGE
	build_amt = 4
	obj_flags = OBJ_FLAG_ROTATABLE|OBJ_FLAG_MOVES_UNSUPPORTED
	pixel_x = -16
	pixel_y = -16
	var/state = STATE_UNWIRED
	var/base_name = "airlock"
	var/obj/item/airlock_electronics/electronics
	/// The type path of the airlock once completed.
	var/airlock_type
	/// Glass version of this airlock.
	var/glass_type
	/// If glass is installed.
	var/glass = FALSE
	var/created_name
	var/width = 1

/obj/structure/door_assembly/Initialize(mapload)
	. = ..()
	update_state()

/obj/structure/door_assembly/examine(mob/user)
	. = ..()
	to_chat(user, "It is currently facing [dir2text(dir)].")

/obj/structure/door_assembly/door_assembly_generic
	base_name = "airlock"
	airlock_type = /obj/machinery/door/airlock
	glass_type = /obj/machinery/door/airlock/glass

/obj/structure/door_assembly/door_assembly_mai
	base_name = "maintenance airlock"
	airlock_type = /obj/machinery/door/airlock/maintenance

/obj/structure/door_assembly/door_assembly_ext
	base_name = "external airlock"
	airlock_type = /obj/machinery/door/airlock/external

/obj/structure/door_assembly/door_assembly_hatch
	base_name = "airtight hatch"
	icon = 'icons/obj/doors/basic/single/external/door.dmi'
	airlock_type = /obj/machinery/door/airlock/hatch

/obj/structure/door_assembly/door_assembly_mhatch
	base_name = "maintenance hatch"
	icon = 'icons/obj/doors/basic/single/external/door.dmi'
	airlock_type = /obj/machinery/door/airlock/maintenance_hatch

/obj/structure/door_assembly/door_assembly_highsecurity
	base_name = "high security airlock"
	icon = 'icons/obj/doors/basic/single/secure/door.dmi'
	airlock_type = /obj/machinery/door/airlock/highsecurity

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/basic/double/generic/door.dmi'
	dir = EAST
	pixel_x = -32
	pixel_y = -32
	width = 2
	airlock_type = /obj/machinery/door/airlock/multi_tile
	glass_type = /obj/machinery/door/airlock/multi_tile/glass

/obj/structure/door_assembly/multi_tile/Initialize()
	. = ..()
	update_state()

/obj/structure/door_assembly/proc/SetBounds() // dont update with move or init, makes dragging impossible. do it just before airlock spawns
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

/obj/structure/door_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(W.ispen())
		var/door_name = sanitizeSafe(input(user, "Enter the name for the door.", src.name, src.created_name), MAX_NAME_LEN)
		if(!door_name)
			return
		if(!Adjacent(user))
			return
		created_name = door_name

	else if(W.iswelder())
		if(!glass || anchored)
			to_chat(user, SPAN_WARNING("\The [src] isn't ready to be welded yet. It doesn't have any installed glass to remove, and it has to be unsecured to deconstruct it."))
			return
		var/obj/item/weldingtool/WT = W
		if(WT.use(0, user))
			playsound(src.loc, 'sound/items/welder_pry.ogg', 50, 1)
			if(glass)
				user.visible_message("<b>[user]</b> starts welding the glass panel out of the airlock assembly.", SPAN_NOTICE("You start welding the glass panel out of the airlock assembly."))
				if(W.use_tool(src, user, 40, volume = 50))
					if(!src || !WT.isOn())
						return
					to_chat(user, SPAN_NOTICE("You weld the glass panel out."))
					new /obj/item/stack/material/glass/reinforced(src.loc)
					glass = FALSE
			else if(!anchored)
				user.visible_message("<b>[user]</b> starts disassembling the airlock assembly.", SPAN_NOTICE("You start disassembling the airlock assembly."))
				if(W.use_tool(src, user, 40, volume = 50))
					if(!src || !WT.isOn())
						return
					to_chat(user, SPAN_NOTICE("You disassemble the airlock assembly."))
					dismantle()
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel."))
			return

	else if(W.iswrench())
		if(state != STATE_UNWIRED)
			to_chat(user, SPAN_WARNING("You have to remove the wiring before you can use the wrench on \the [src]."))
			return

		if(anchored)
			user.visible_message("<b>[user]</b> begins unsecuring the airlock assembly from the floor.", \
								SPAN_NOTICE("You start unsecuring the airlock assembly from the floor."))
		else
			user.visible_message("<b>[user]</b> begins securing the airlock assembly to the floor.", \
								SPAN_NOTICE("You start securing the airlock assembly to the floor."))

		if(W.use_tool(src, user, 40, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You [anchored? "un" : ""]secure \the [src]."))
			anchored = !anchored

	else if(W.iscoil())
		if(state > STATE_UNWIRED)
			to_chat(user, SPAN_WARNING("\The [src] has already been wired."))
			return
		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be anchored before it can be wired."))
			return
		var/obj/item/stack/cable_coil/C = W
		if (C.get_amount() < 3)
			to_chat(user, SPAN_WARNING("You need three lengths of coil to wire the airlock assembly."))
			return
		user.visible_message("<b>[user]</b> starts wiring the airlock assembly.", SPAN_NOTICE("You start wiring the airlock assembly."))
		if(W.use_tool(src, user, 40, volume = 50) && state == STATE_UNWIRED && anchored)
			if(C.use(3))
				state = STATE_WIRED
				to_chat(user, SPAN_NOTICE("You wire the airlock."))

	else if(W.iswirecutter())
		if(state == STATE_UNWIRED)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any wires to remove."))
			return
		else if(state > STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src]'s wires cannot be reached, take out the electronics first."))
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("<b>[user]</b> starts cutting the wires from the airlock assembly.", SPAN_NOTICE("You start cutting the wires from airlock assembly."))

		if(W.use_tool(src, user, 40, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You cut the airlock wires."))
			new /obj/item/stack/cable_coil(src.loc, 1)
			state = STATE_UNWIRED

	else if(istype(W, /obj/item/airlock_electronics))
		if(state == STATE_UNWIRED)
			to_chat(user, SPAN_WARNING("\The [src] must be wired before you can install electronics into it."))
			return
		else if(state > STATE_WIRED)
			to_chat(user, SPAN_WARNING("\The [src] already has electronics installed."))
			return
		var/obj/item/airlock_electronics/EL = W
		if(!EL.is_installed)
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user.visible_message("<b>[user]</b> starts installing \the [EL] into the airlock assembly.", SPAN_NOTICE("You start installing \the [EL] into the airlock assembly."))
			EL.is_installed = TRUE
			if(W.use_tool(src, user, 40, volume = 50) && state == STATE_WIRED)
				EL.is_installed = FALSE
				if(!src)
					return
				user.drop_from_inventory(EL, src)
				to_chat(user, SPAN_NOTICE("You finish installing \the [EL]."))
				state = STATE_ELECTRONICS_INSTALLED
				electronics = EL
			else
				EL.is_installed = FALSE

	else if(W.iscrowbar())
		if(state != STATE_ELECTRONICS_INSTALLED)
			to_chat(user, SPAN_WARNING("\The [src] has no electronics to remove."))
			return

		//This should never happen, but just in case I guess
		if(!electronics)
			to_chat(user, SPAN_WARNING("There was nothing to remove."))
			LOG_DEBUG("[src] had the ELECTRONICS_INSTALLED state, but didn't actually have electronics installed")
			state = STATE_WIRED
			return

		user.visible_message("<b>[user]</b> starts removing the electronics from \the [src].", SPAN_NOTICE("You start removing the electronics from \the [src]."))

		if(W.use_tool(src, user, 40, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You remove \the [electronics]."))
			state = STATE_WIRED
			electronics.forceMove(src.loc)
			electronics = null

	else if(istype(W, /obj/item/stack/material) && glass_type)
		if(glass)
			to_chat(user, SPAN_WARNING("\The [src] already has glass installed."))
			return
		var/obj/item/stack/S = W
		var/material_name = S.get_material_name()
		if(S.get_amount() >= 2)
			if(material_name == MATERIAL_GLASS_REINFORCED)
				user.visible_message("<b>[user]</b> starts installing \the [S] into the airlock assembly.", SPAN_WARNING("You start installing \the [S] into the airlock assembly."))
				if(W.use_tool(src, user, 40, volume = 50) && !glass)
					if(S.use(2))
						to_chat(user, SPAN_NOTICE("You install reinforced glass windows into the airlock assembly."))
						glass = TRUE

	else if(W.isscrewdriver())
		if(state != STATE_ELECTRONICS_INSTALLED)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any electronics installed."))
			return

		user.visible_message("<b>[user]</b> starts finishing \the [src].", SPAN_NOTICE("You start finishing \the [src]."))

		if(W.use_tool(src, user, 40, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You finish the airlock!"))
			SetBounds()
			if(glass && glass_type)
				new glass_type(loc, dir, FALSE, src)
			else
				new airlock_type(loc, dir, FALSE, src)
			qdel(src)

	else if(istype(W, /obj/item/material/twohanded/chainsaw))
		var/obj/item/material/twohanded/chainsaw/ChainSawVar = W
		if(!ChainSawVar.wielded)
			to_chat(user, SPAN_WARNING("Cutting the airlock requires the strength of two hands."))
		else if(ChainSawVar.cutting)
			to_chat(user, SPAN_WARNING("You are already cutting an airlock open."))
		else if(!ChainSawVar.powered)
			to_chat(user, SPAN_WARNING("\The [W] needs to be on in order to tear \the [src] apart."))
		else
			ChainSawVar.cutting = TRUE
			user.visible_message(\
				SPAN_DANGER("[user] starts cutting \the [src] apart with \the [W]!"), \
				SPAN_NOTICE("You start cutting \the [src] apart..."), \
				SPAN_WARNING("You hear a loud buzzing sound and metal grinding on metal...") \
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, user, extra_checks = CALLBACK(src, PROC_REF(CanChainsaw), W)))
				user.visible_message(\
					SPAN_DANGER("[user] finishes cutting \the [src] apart with the [W]."), \
					SPAN_NOTICE("You finish cutting \the [src] apart."), \
					SPAN_WARNING("You hear a metal clank and some sparks.") \
				)
				new /obj/item/stack/material/steel(src.loc, 2)
				ChainSawVar.cutting = FALSE
				qdel(src)
			else
				ChainSawVar.cutting = FALSE
	else
		..()
	update_state()

/obj/structure/door_assembly/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered)

/obj/structure/door_assembly/proc/update_state()
	name = ""
	switch (state)
		if(STATE_UNWIRED)
			name = anchored ? "secured " : "unsecured "
		if(STATE_WIRED)
			name = "wired "
		if(STATE_ELECTRONICS_INSTALLED)
			name = "near-finished "
	name += "[glass == TRUE ? "window " : ""][glass ? "glass airlock" : base_name] assembly"
	if(created_name)
		name += " ([created_name])"

#undef STATE_UNWIRED
#undef STATE_WIRED
#undef STATE_ELECTRONICS_INSTALLED
