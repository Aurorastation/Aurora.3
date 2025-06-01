/obj/machinery/appliance/cooker/still
	name = "still"
	desc = "Alright, so, t'make some moonshine, fust yo' gotta combine some of this hyar egg wif th' deep fried sausage."
	icon = 'icons/obj/machinery/cooking_machines.dmi'
	icon_state = "still_off"
	on_icon = "still_on"
	off_icon = "still_off"
	appliancetype = STILL
	active_power_usage = 12 KILO WATTS
	heating_power = 12000
	optimal_power = 1.35
	idle_power_usage = 3.6 KILO WATTS
	//Power used to maintain temperature once it's heated.
	//Going with 25% of the active power. This is a somewhat arbitrary value
	resistance = 10000	// Approx. 4 minutes.
	max_contents = 2
	stat = NOPOWER//Starts turned off
	starts_with = list(
		/obj/item/reagent_containers/cooking_container/pot,
	)

