/obj/machinery/chemical_dispenser/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/hydrazine,
			/obj/item/reagent_containers/chem_disp_cartridge/lithium,
			/obj/item/reagent_containers/chem_disp_cartridge/carbon,
			/obj/item/reagent_containers/chem_disp_cartridge/ammonia,
			/obj/item/reagent_containers/chem_disp_cartridge/acetone,
			/obj/item/reagent_containers/chem_disp_cartridge/sodium,
			/obj/item/reagent_containers/chem_disp_cartridge/aluminum,
			/obj/item/reagent_containers/chem_disp_cartridge/silicon,
			/obj/item/reagent_containers/chem_disp_cartridge/phosphorus,
			/obj/item/reagent_containers/chem_disp_cartridge/sulfur,
			/obj/item/reagent_containers/chem_disp_cartridge/hclacid,
			/obj/item/reagent_containers/chem_disp_cartridge/potassium,
			/obj/item/reagent_containers/chem_disp_cartridge/iron,
			/obj/item/reagent_containers/chem_disp_cartridge/copper,
			/obj/item/reagent_containers/chem_disp_cartridge/mercury,
			/obj/item/reagent_containers/chem_disp_cartridge/radium,
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ethanol,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/sacid,
			/obj/item/reagent_containers/chem_disp_cartridge/tungsten
		)

/obj/machinery/chemical_dispenser/ert
	name = "medicine dispenser"
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/inaprov,
			/obj/item/reagent_containers/chem_disp_cartridge/ryetalyn,
			/obj/item/reagent_containers/chem_disp_cartridge/perconol,
			/obj/item/reagent_containers/chem_disp_cartridge/mortaphenyl,
			/obj/item/reagent_containers/chem_disp_cartridge/oxycomorphine,
			/obj/item/reagent_containers/chem_disp_cartridge/sterilizine,
			/obj/item/reagent_containers/chem_disp_cartridge/leporazine,
			/obj/item/reagent_containers/chem_disp_cartridge/kelotane,
			/obj/item/reagent_containers/chem_disp_cartridge/butazoline,
			/obj/item/reagent_containers/chem_disp_cartridge/saline,
			/obj/item/reagent_containers/chem_disp_cartridge/dermaline,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin_p,
			/obj/item/reagent_containers/chem_disp_cartridge/tricord,
			/obj/item/reagent_containers/chem_disp_cartridge/dylovene,
			/obj/item/reagent_containers/chem_disp_cartridge/hyronalin,
			/obj/item/reagent_containers/chem_disp_cartridge/arithrazine,
			/obj/item/reagent_containers/chem_disp_cartridge/alkysine,
			/obj/item/reagent_containers/chem_disp_cartridge/oculine,
			/obj/item/reagent_containers/chem_disp_cartridge/peridaxon,
			/obj/item/reagent_containers/chem_disp_cartridge/bicaridine,
			/obj/item/reagent_containers/chem_disp_cartridge/thetamycin,
			/obj/item/reagent_containers/chem_disp_cartridge/coughsyrup,
			/obj/item/reagent_containers/chem_disp_cartridge/cetahydramine,
			/obj/item/reagent_containers/chem_disp_cartridge/ethylredox,
			/obj/item/reagent_containers/chem_disp_cartridge/sleeptox,
			/obj/item/reagent_containers/chem_disp_cartridge/chloral,
			/obj/item/reagent_containers/chem_disp_cartridge/cryoxadone,
			/obj/item/reagent_containers/chem_disp_cartridge/clonexadone
		)

/obj/machinery/chemical_dispenser/ert/attackby(obj/item/W, mob/user)
	if(W.iswrench())
		to_chat(user, SPAN_NOTICE("This dispenser is riveted to the floor and cannot be unanchored."))
		return
	else
		return ..()

/obj/machinery/chemical_dispenser/bar_soft
	name = "soft drink dispenser"
	desc = "A soda machine."
	icon_state = "soda_dispenser"
	icon_state_active = null
	ui_title = "Soda Dispenser"
	accept_drinking = 1
	density = 0//It's a half-height machine that sits on a table, this allows small things to walk under that table
	pass_flags = PASSTABLE // put it back on the table

/obj/machinery/chemical_dispenser/bar_soft/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/coffee{temperature_override = 369},
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/tea{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/icetea,
			/obj/item/reagent_containers/chem_disp_cartridge/cola,
			/obj/item/reagent_containers/chem_disp_cartridge/smw,
			/obj/item/reagent_containers/chem_disp_cartridge/dr_gibb,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceup,
			/obj/item/reagent_containers/chem_disp_cartridge/brownstar,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/apple,
			/obj/item/reagent_containers/chem_disp_cartridge/watermelon,
			/obj/item/reagent_containers/chem_disp_cartridge/clean_kois,
			/obj/item/reagent_containers/chem_disp_cartridge/banana,
			/obj/item/reagent_containers/chem_disp_cartridge/root_beer
		)

/obj/machinery/chemical_dispenser/bar_alc
	name = "booze dispenser"
	desc = "A beer machine. Like a soda machine, but more fun!"
	icon_state = "booze_dispenser"
	icon_state_active = null
	ui_title = "Booze Dispenser"
	accept_drinking = 1
	density = 0//It's a half-height machine that sits on a table, this allows small things to walk under that table
	pass_flags = PASSTABLE // put it back on the table

/obj/machinery/chemical_dispenser/bar_alc/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/reagent_containers/chem_disp_cartridge/wine,
			/obj/item/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/reagent_containers/chem_disp_cartridge/champagne,
			/obj/item/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/reagent_containers/chem_disp_cartridge/mead,
			/obj/item/reagent_containers/chem_disp_cartridge/grenadine,
			/obj/item/reagent_containers/chem_disp_cartridge/cream
		)

/obj/machinery/chemical_dispenser/bar_alc/full/space //Spacebar away site. Gets much more to make the best drinks, hassle-free.
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/lemon_lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/sodawater,
			/obj/item/reagent_containers/chem_disp_cartridge/tonic,
			/obj/item/reagent_containers/chem_disp_cartridge/beer,
			/obj/item/reagent_containers/chem_disp_cartridge/kahlua,
			/obj/item/reagent_containers/chem_disp_cartridge/whiskey,
			/obj/item/reagent_containers/chem_disp_cartridge/wine,
			/obj/item/reagent_containers/chem_disp_cartridge/vodka,
			/obj/item/reagent_containers/chem_disp_cartridge/gin,
			/obj/item/reagent_containers/chem_disp_cartridge/champagne,
			/obj/item/reagent_containers/chem_disp_cartridge/rum,
			/obj/item/reagent_containers/chem_disp_cartridge/tequila,
			/obj/item/reagent_containers/chem_disp_cartridge/vermouth,
			/obj/item/reagent_containers/chem_disp_cartridge/cognac,
			/obj/item/reagent_containers/chem_disp_cartridge/ale,
			/obj/item/reagent_containers/chem_disp_cartridge/mead,
			/obj/item/reagent_containers/chem_disp_cartridge/grenadine,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/ethanol,
			/obj/item/reagent_containers/chem_disp_cartridge/berryjuice,
			/obj/item/reagent_containers/chem_disp_cartridge/radium/small,
			/obj/item/reagent_containers/chem_disp_cartridge/uranium/small,
			/obj/item/reagent_containers/chem_disp_cartridge/toothpaste,
			/obj/item/reagent_containers/chem_disp_cartridge/iron
		)

/obj/machinery/chemical_dispenser/coffeemaster
	name = "Coffee Master 3000"
	desc = "The only thing that can get some workers though the day, a coffee maker on steroids!"
	icon_state = "coffee_master"
	icon_state_active = null
	ui_title = "Coffee Master 3000"
	accept_drinking = 1
	density = 0
	pass_flags = PASSTABLE // put it back on the table

/obj/machinery/chemical_dispenser/coffeemaster/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/coffee{temperature_override = 369},
			/obj/item/reagent_containers/chem_disp_cartridge/espresso{temperature_override = 369},
			/obj/item/reagent_containers/chem_disp_cartridge/tea{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/greentea{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/chaitea{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/ciderhot{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/reagent_containers/chem_disp_cartridge/soymilk,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco{temperature_override = 349},
			/obj/item/reagent_containers/chem_disp_cartridge/water{temperature_override = 373}
		)

/obj/machinery/chemical_dispenser/coffee
	name = "Coffee Machine"
	desc = "The only thing that can get some workers though the day, the coffee maker is the facilities most valuable resource."
	icon_state = "coffee_machine"
	ui_title = "Morning Glory Coffee Mate"
	icon_state_active = null
	accept_drinking = 1
	pass_flags = PASSTABLE // put it back on the table

/obj/machinery/chemical_dispenser/coffee/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/espresso{temperature_override = 369.15}
		)
