/// Please use its directional subtypes.
/obj/structure/suspension_cable
	name = "suspension cable"
	desc = "A lightweight, high-strength cable designed for robotic suspension."
	icon = 'icons/obj/power_cond_white.dmi'
	color = "#B6B64B"
	anchored = 1
	layer = ABOVE_OBJ_LAYER

/obj/structure/suspension_cable/right
	icon_state = "8-9"

/obj/structure/suspension_cable/left
	icon_state = "4-5"

/obj/structure/suspension_bar
	name = "suspension bar"
	desc = "A rigid bar that holds or supports other components."
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "intact"
	color = "#444444"
	anchored = 1
	layer = ABOVE_OBJ_LAYER

/obj/structure/decor_ladder
	name = "ladder"
	desc = "A ladder to meet your vertical access needs!"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder11"
	anchored = 1

/obj/structure/lift_control
	name = "lift control"
	icon = 'icons/obj/computer.dmi'
	icon_state = "lift"
	anchored = 1

/obj/structure/sign/lift_panel
	name = "elevator control panel"
	icon = 'icons/obj/turbolift.dmi'
	icon_state = "panel"
