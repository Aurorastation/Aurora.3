/obj/item/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"

	icon_screen = "comm_logs"
	icon_keyboard = "green_key"
	light_color = LIGHT_COLOR_GREEN
	density = 1
	anchored = 1.0
	circuit = /obj/item/circuitboard/atmoscontrol
	req_access = list(access_ce)
	var/list/monitored_alarm_ids = null
	var/datum/nano_module/atmos_control/atmos_control

/obj/machinery/computer/atmoscontrol/laptop
	name = "Atmospherics Laptop"
	desc = "A cheap laptop."
	icon = 'icons/obj/modular_laptop.dmi'
	icon_state = "laptop-open"
	light_color = LIGHT_COLOR_BLUE

	icon_screen = "atmos_control"
	density = 0

/obj/machinery/computer/atmoscontrol/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/computer/atmoscontrol/emag_act(var/remaining_carges, var/mob/user)
	if(!emagged)
		user.visible_message("<span class='warning'>\The [user] does something \the [src], causing the screen to flash!</span>",\
			"<span class='warning'>You cause the screen to flash as you gain full control.</span>",\
			"You hear an electronic warble.")
		atmos_control.emagged = 1
		return 1

/obj/machinery/computer/atmoscontrol/ui_interact(var/mob/user)
	if(!atmos_control)
		atmos_control = new(src, req_access, req_one_access, monitored_alarm_ids)
	atmos_control.ui_interact(user)
