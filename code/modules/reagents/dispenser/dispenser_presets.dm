/obj/machinery/chemical_dispenser/full
	spawn_cartridges = list(
		)

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	spawn_cartridges = list(
		)

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soda machine."
	icon_state = "soda_dispenser"
	ui_title = "Soda Dispenser"
	accept_drinking = 1
	density = 0//It's a half-height machine that sits on a table, this allows small things to walk under that table

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
		)

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	ui_title = "Booze Dispenser"
	accept_drinking = 1
	density = 0//It's a half-height machine that sits on a table, this allows small things to walk under that table

/obj/machinery/chemical_dispenser/bar_alc/full
	spawn_cartridges = list(
		)

/obj/machinery/chemical_dispenser/coffee
	name = "Coffee Machine"
	desc = "The only thing that can get some workers though the day, the coffee maker is the stations most valuable resource."
	icon_state = "coffee_machine"
	ui_title = "Morning Glory Coffee Mate"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/coffee/full
	spawn_cartridges = list(
		)
