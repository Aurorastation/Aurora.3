/obj/machinery/vending/assist
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/device/assembly/prox_sensor, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/igniter, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/signaler, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/wirecutters, 1, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/device/flashlight, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/timer, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/infra, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/voice, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/device/multitool/, 2, FALSE)
		)
	)
	restock_items = TRUE
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	deny_time = 6
	//req_access = list(access_maint_tunnels) //Maintenance access
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/stack/cable_coil/random, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/crowbar, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/weldingtool, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/wirecutters, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/wrench, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/analyzer, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/t_scanner, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/screwdriver, 5, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/weldingtool/hugetank, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/gloves/fyellow, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/clothing/gloves/yellow, 1, FALSE)
		)
	)
	restock_blacklist = list(
		/obj/item/stack/cable_coil,
		/obj/item/weldingtool,
		/obj/item/weldingtool/hugetank
	)
	restock_items = TRUE
	light_color = COLOR_GOLD

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	deny_time = 6
	req_access = list(access_engine)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/device/multitool, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/powerdrill, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/glasses/safety/goggles, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/airlock_electronics, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/module/power_control, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/airalarm_electronics, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/firealarm_electronics, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/cell/high, 10, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/cell/potato, 3, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/storage/belt/utility, 3, FALSE)
		)
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_GOLD

/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	deny_time = 6
	req_access = list(access_engine_equip)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/clothing/under/rank/chief_engineer, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/under/rank/engineer, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/shoes/orange, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/head/hardhat, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/belt/utility, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/glasses/safety/goggles, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/gloves/yellow, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/screwdriver, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/crowbar, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/wirecutters, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/device/multitool, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/wrench, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/device/t_scanner, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/cable_coil/heavyduty, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/cell, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/weldingtool, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/head/welding, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/light/tube, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/suit/fire, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/stock_parts/scanning_module, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stock_parts/micro_laser, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stock_parts/matter_bin, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stock_parts/manipulator, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/stock_parts/console_screen, 5, FALSE)
		)
	)
	restock_blacklist = list(
		/obj/item/stack/cable_coil/heavyduty,
		/obj/item/weldingtool,
		/obj/item/light/tube
	)
	restock_items = TRUE
	light_color = COLOR_GOLD

/obj/item/vending_refill/tools
	name = "tools resupply canister"
	charges = 25
