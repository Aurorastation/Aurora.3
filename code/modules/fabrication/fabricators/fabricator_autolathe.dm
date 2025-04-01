/obj/machinery/fabricator/autolathe
	name = "autolathe"
	desc = "A large device loaded with various item schematics. It produces common day to day items from a variety of materials."
	icon = 'icons/obj/machinery/fabricators/autolathe.dmi'
	icon_state = "autolathe"

/obj/machinery/fabricator/autolathe/mounted
	name = "\improper mounted autolathe"
	density = FALSE
	anchored = FALSE
	idle_power_usage = FALSE
	active_power_usage = FALSE
	interact_offline = TRUE
	does_flick = FALSE

/obj/machinery/fabricator/mounted/ui_state(mob/user)
	return GLOB.heavy_vehicle_state
