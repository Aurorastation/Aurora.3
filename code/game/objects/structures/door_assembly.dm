#define STATE_UNWIRED 0
#define STATE_WIRED 1
#define STATE_ELECTRONICS_INSTALLED 2

/obj/structure/door_assembly
	name = "airlock assembly"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	anchored = 0
	density = 1
	w_class = ITEMSIZE_HUGE
	build_amt = 4
	obj_flags = OBJ_FLAG_ROTATABLE|OBJ_FLAG_MOVES_UNSUPPORTED
	var/state = STATE_UNWIRED
	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/airlock_electronics/electronics = null
	var/airlock_type = "" //the type path of the airlock once completed
	var/glass_type = "/glass"
	var/glass = FALSE // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null
	var/width = 1

/obj/structure/door_assembly/Initialize(mapload)
	. = ..()
	update_state()

/obj/structure/door_assembly/door_assembly_ser
	base_icon_state = "ser"
	base_name = "Service Airlock"
	glass_type = "/glass_service"
	airlock_type = "/service"

/obj/structure/door_assembly/door_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	glass_type = "/glass_command"
	airlock_type = "/command"

/obj/structure/door_assembly/door_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	glass_type = "/glass_security"
	airlock_type = "/security"

/obj/structure/door_assembly/door_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering Airlock"
	glass_type = "/glass_engineering"
	airlock_type = "/engineering"

/obj/structure/door_assembly/door_assembly_min
	base_icon_state = "min"
	base_name = "Mining Airlock"
	glass_type = "/glass_mining"
	airlock_type = "/mining"

/obj/structure/door_assembly/door_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	glass_type = "/glass_atmos"
	airlock_type = "/atmos"

/obj/structure/door_assembly/door_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	glass_type = "/glass_research"
	airlock_type = "/research"

/obj/structure/door_assembly/door_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	glass_type = "/glass_science"
	airlock_type = "/science"

/obj/structure/door_assembly/door_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	glass_type = "/glass_medical"
	airlock_type = "/medical"

/obj/structure/door_assembly/door_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = "/maintenance"
	glass = -1

/obj/structure/door_assembly/door_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = "/external"
	glass = -1

/obj/structure/door_assembly/door_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = "/freezer"
	glass = -1

/obj/structure/door_assembly/door_assembly_fma
	base_icon_state = "mai"
	base_name = "Freezer Maintenance Access"
	airlock_type = "/freezer_maint"
	glass = -1

/obj/structure/door_assembly/door_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airtight Hatch"
	airlock_type = "/hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Maintenance Hatch"
	airlock_type = "/maintenance_hatch"
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity
	base_icon_state = "highsec"
	base_name = "High Security Airlock"
	airlock_type = "/highsecurity"
	glass = -1

/obj/structure/door_assembly/door_assembly_vault
	base_icon_state = "vault"
	base_name = "Vault"
	airlock_type = "/vault"
	glass = -1

/obj/structure/door_assembly/door_assembly_lift
	base_icon_state = "lift"
	base_name = "Elevator Door"
	airlock_type = "/lift"
	glass = -1

/obj/structure/door_assembly/door_assembly_skrell
	base_icon_state = "skrell_purple"
	base_name = "Airlock"
	airlock_type = "/skrell"
	glass = -1

/obj/structure/door_assembly/door_assembly_skrell/grey
	base_icon_state = "skrell_grey"
	base_name = "Airlock"
	airlock_type = "/skrell/grey"

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/door_assembly2x1.dmi'
	icon_state = null //only have icons for the glass version
	dir = EAST
	width = 2

/*Temporary until we get sprites.
	glass_type = "/multi_tile/glass"
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = "/multi_tile/glass"
	glass = -1 //To prevent bugs in deconstruction process.

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
		if(!(istext(glass) || glass == TRUE || !anchored))
			to_chat(user, SPAN_WARNING("\The [src] isn't ready to be welded yet. It doesn't have any installed material to remove, and it has to be unsecured to deconstruct it."))
			return
		var/obj/item/weldingtool/WT = W
		if(WT.use(0, user))
			playsound(src.loc, 'sound/items/welder_pry.ogg', 50, 1)
			if(istext(glass))
				user.visible_message("<b>[user]</b> starts welding the [glass] plating off the airlock assembly.", SPAN_NOTICE("You start welding the [glass] plating off the airlock assembly."))
				if(W.use_tool(src, user, 40, volume = 50))
					if(!src || !WT.isOn())
						return
					to_chat(user, SPAN_NOTICE("You weld the [glass] plating off."))
					var/M = text2path("/obj/item/stack/material/[glass]")
					new M(src.loc, 2)
					glass = FALSE
			else if(glass == TRUE)
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

		playsound(src.loc, 'sound/items/wirecutter.ogg', 100, 1)
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
			playsound(src.loc, 'sound/items/screwdriver.ogg', 100, 1)
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
			log_debug("[src] had the ELECTRONICS_INSTALLED state, but didn't actually have electronics installed")
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

	else if(istype(W, /obj/item/stack/material))
		if(glass)
			to_chat(user, SPAN_WARNING("\The [src] already has material plating installed."))
			return
		var/obj/item/stack/S = W
		var/material_name = S.get_material_name()
		if(S)
			if(S.get_amount() >= 1)
				if(material_name == MATERIAL_GLASS_REINFORCED)
					user.visible_message("<b>[user]</b> starts installing \the [S] into the airlock assembly.", "You start installing \the [S] into the airlock assembly.")
					if(W.use_tool(src, user, 40, volume = 50) && !glass)
						if(S.use(1))
							to_chat(user, SPAN_NOTICE("You install reinforced glass windows into the airlock assembly."))
							glass = TRUE
				else if(material_name)
					// Ugly hack, will suffice for now. Need to fix it upstream as well, may rewrite mineral walls. ~Z
					if(!(material_name in list("gold", "silver", "diamond", "uranium", "phoron", "sandstone")))
						to_chat(user, SPAN_WARNING("You cannot make an airlock out of [S]."))
						return
					if(S.get_amount() >= 2)
						playsound(src.loc, /singleton/sound_category/crowbar_sound, 100, 1)
						user.visible_message("<b>[user]</b> starts installing [S] into the airlock assembly.", "You start installing [S] into the airlock assembly.")
						if(W.use_tool(src, user, 40, volume = 50) && !glass)
							if (S.use(2))
								to_chat(user, SPAN_NOTICE("You install [SSmaterials.material_display_name(material_name)] plating into the airlock assembly."))
								glass = material_name

	else if(W.isscrewdriver())
		if(state != STATE_ELECTRONICS_INSTALLED)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have any electronics installed."))
			return

		user.visible_message("<b>[user]</b> starts finishing \the [src].", SPAN_NOTICE("You start finishing \the [src]."))

		if(W.use_tool(src, user, 40, volume = 50))
			if(!src)
				return
			to_chat(user, SPAN_NOTICE("You finish the airlock!"))
			var/path
			if(istext(glass))
				path = text2path("/obj/machinery/door/airlock/[glass]")
			else if (glass == TRUE)
				path = text2path("/obj/machinery/door/airlock[glass_type]")
			else
				path = text2path("/obj/machinery/door/airlock[airlock_type]")

			SetBounds()
			new path(loc, dir, FALSE, src)
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
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, PROC_REF(CanChainsaw), W)))
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
	icon_state = "door_as_[glass == TRUE ? "g" : ""][istext(glass) ? glass : base_icon_state][state]"
	name = ""
	switch (state)
		if(STATE_UNWIRED)
			name = anchored ? "Secured " : "Unsecured "
		if(STATE_WIRED)
			name = "Wired "
		if(STATE_ELECTRONICS_INSTALLED)
			name = "Near-finished "
	name += "[glass == TRUE ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"
	if(created_name)
		name += " ([created_name])"

#undef STATE_UNWIRED
#undef STATE_WIRED
#undef STATE_ELECTRONICS_INSTALLED
