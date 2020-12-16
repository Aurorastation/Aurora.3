/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/clothing/under/rank/scientist, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/suit/bio_suit, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/head/bio_hood, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/device/transfer_valve, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/timer, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/signaler, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/igniter, 6, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/device/assembly/prox_sensor, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/infra, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/mousetrap, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/voice, 4, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/clothing/head/collectable/petehat, 1, FALSE)
		)
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_BLUE_GRAY

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	deny_time = 14
	req_access = list(access_robotics)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/clothing/suit/storage/toggle/labcoat, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/under/rank/roboticist, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/stack/cable_coil, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/flash/synthetic, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/cell/high, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/prox_sensor, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/device/assembly/signaler, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/device/healthanalyzer, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/surgery/scalpel, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/surgery/circular_saw, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/tank/anesthetic, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/breath/medical, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/screwdriver, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/crowbar, 5, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/device/flash, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/device/paicard, 2, FALSE)
		)
	)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	restock_blacklist = list(
		/obj/item/stack/cable_coil,
		/obj/item/device/flash,
		/obj/item/light/tube,
		/obj/item/tank/anesthetic
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_BABY_BLUE

/obj/item/vending_refill/robo
	name = "robo-tools resupply canister"
	charges = 38
