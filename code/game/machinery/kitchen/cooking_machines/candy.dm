/obj/machinery/appliance/mixer/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"
	appliancetype = CANDYMAKER
	cooking_coeff = 1.0

	output_options = list(
		"Jawbreaker" = /obj/item/reagent_containers/food/snacks/variable/jawbreaker,
		"Candy Bar" = /obj/item/reagent_containers/food/snacks/variable/candybar,
		"Sucker" = /obj/item/reagent_containers/food/snacks/variable/sucker,
		"Jelly" = /obj/item/reagent_containers/food/snacks/variable/jelly
	)

	component_types = list(
			/obj/item/circuitboard/candymachine,
			/obj/item/stock_parts/capacitor = 3,
			/obj/item/stock_parts/scanning_module,
			/obj/item/stock_parts/matter_bin = 2
		)

/obj/machinery/appliance/mixer/candy/change_product_appearance(var/obj/item/reagent_containers/food/snacks/cooked/product)
	food_color = get_random_colour(1)
	. = ..()
