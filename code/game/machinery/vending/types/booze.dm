/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	deny_time = 16
	refill_type = /obj/item/vending_refill/booze
	products = list(
        CAT_NORMAL = list(
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/bitters, 6, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/boukha, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/brandy, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/grenadine, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/tequila, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/rum, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/cognac, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/cremeyvette, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/wine, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/whitewine, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/drambuie, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/melonliquor, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/gin, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/vermouth, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/guinness, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/absinthe, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/bluecuracao, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/kahlua, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/champagne, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/vodka, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/fireball, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/whiskey, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/victorygin, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/makgeolli, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/soju, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/sake, 1, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/cremewhite, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/mintsyrup, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/small/ale, 6, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/small/beer, 6, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice, 8, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/cola, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/space_up, 5, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/adhomai_milk, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/grape_juice, 6, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/beetle_milk, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/sodawater, 15, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/tonic, 8, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/threetowns, 6, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/applejuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/cream, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/dynjuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/limejuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/lemonjuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/orangejuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/carton/tomatojuice, 4, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/flask/barflask, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/flask/vacuumflask, 2, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/ice, 9, FALSE),
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/drinkingglass, 30, FALSE)
        ),
        CAT_HIDDEN = list(
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/tea, 10, FALSE)
        ),
        CAT_COIN = list(
            VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing, 2, FALSE)
        )
	)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_access = list(access_bar)
	randomize_qty = FALSE
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	light_color = COLOR_PALE_BLUE_GRAY
	exclusive_screen = FALSE
	ui_size = 60

/obj/machinery/vending/boozeomat/ui_interact(mob/user, var/datum/topic_state/state = default_state)
	user.set_machine(src)

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "machinery-vending", 900, 600, capitalize(name), state=state)

	ui.open(v_asset)

/obj/item/vending_refill/booze
	name = "booze resupply canister"
	charges = 100
