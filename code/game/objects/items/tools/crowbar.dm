/obj/item/crowbar
	name = "pocket crowbar"
	desc = "A small crowbar. This handy tool is useful for lots of things, such as prying floor tiles or opening unpowered doors."
	icon = 'icons/obj/tools.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_tools.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_tools.dmi',
		)
	icon_state = "crowbar"
	item_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	force = 18
	throwforce = 7
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	usesound = SFX_CROWBAR
	surgerysound = 'sound/items/surgery/retractor.ogg'
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	tool_behaviour = TOOL_CROWBAR
	toolspeed = 1
	var/force_opens = FALSE

/obj/item/crowbar/red
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar_red"
	item_state = "crowbar_red"

/// Imagine something like a crash axe found on airplanes or forcing tools used by emergency services. This is a tool first and foremost.
/obj/item/crowbar/rescue_axe
	name = "rescue axe"
	desc = "A short lightweight emergency tool meant to chop, pry and pierce. Most of the handle is insulated excepting the wedge at the very bottom. The axe head atop the tool has a short pick opposite of the blade."
	icon_state = "rescue_axe"
	item_state = "rescue_axe"
	w_class = WEIGHT_CLASS_NORMAL
	force = 18
	throwforce = 12
	obj_flags = null // Handle is insulated, so this means it won't conduct electricity and hurt you.
	sharp = TRUE
	edge = TRUE
	origin_tech = list(TECH_ENGINEERING = 2)

/// In practice this means it just does full damage to reinforced windows, which halve the force of attacks done against it already. That's just fine.
/obj/item/crowbar/rescue_axe/resolve_attackby(atom/A)
	if(istype(A, /obj/structure/window))
		force = initial(force) * 2
	else
		force = initial(force)
	. = ..()

/obj/item/crowbar/rescue_axe/can_woodcut()
	return TRUE

/obj/item/crowbar/rescue_axe/red
	icon_state = "rescue_axe_red"
	item_state = "rescue_axe_red"

/obj/item/crowbar/hydraulic_rescue_tool
	name = "hydraulic rescue tool"
	desc = "A hydraulic rescue tool that functions like a crowbar by applying strong amounts of hydraulic pressure to force open different things. Also known as jaws of life."
	icon = 'icons/obj/item/hydraulic_rescue_tool.dmi'
	icon_state = "jawspry"
	force = 15
	throwforce = 1
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "rammed", "battered", "bludgeoned")
	toolspeed = 0.7
	force_opens = TRUE

/obj/item/crowbar/robotic
	icon = 'icons/obj/robot_items.dmi'
	toolspeed = 0.5
