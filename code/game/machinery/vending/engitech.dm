/**
 *	Robotech Deluxe
 *	EngiVend
 *		Low Supply
 *	Robco Tool Maker
 *	YouTool
 *		Low Supply
 *	SCC Encryption Key Vendor
 *	Vendomat (Parts Vendor)
 *		Syndicate
 */

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_vend = "robotics-vend"
	req_access = list(ACCESS_ROBOTICS)
	vend_id = "robo-tools"
	products = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/device/flash/synthetic = 4,
		/obj/item/cell/high = 12,
		/obj/item/device/assembly/prox_sensor = 3,
		/obj/item/device/assembly/signaler = 3,
		/obj/item/device/healthanalyzer = 3,
		/obj/item/surgery/scalpel = 2,
		/obj/item/surgery/circular_saw = 2,
		/obj/item/screwdriver = 5,
		/obj/item/crowbar = 5
	)
	contraband = list(
		/obj/item/device/flash = 2
	)
	premium = list(
		/obj/item/device/paicard = 2
	)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/device/flash,
		/obj/item/light/tube
	)
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE
	manufacturer = "hephaestus"

/obj/item/device/vending_refill/robo
	name = "robo-tools resupply canister"
	vend_id = "robo-tools"
	charges = 38

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	req_access = list(ACCESS_ENGINE)
	vend_id = "tools"
	products = list(
		/obj/item/device/multitool = 4,
		/obj/item/taperoll/engineering = 4,
		/obj/item/clothing/glasses/safety/goggles = 4,
		/obj/item/airlock_electronics = 20,
		/obj/item/module/power_control = 10,
		/obj/item/airalarm_electronics = 10,
		/obj/item/firealarm_electronics = 10,
		/obj/item/cell/high = 10,
		/obj/item/grenade/chem_grenade/antifuel = 5,
		/obj/item/device/geiger = 5
	)
	contraband = list(
		/obj/item/cell/potato = 3
	)
	premium = list(
		/obj/item/storage/belt/utility = 3
	)
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/engivend/low_supply
	products = list(
		/obj/item/device/multitool = 2,
		/obj/item/taperoll/engineering = 2,
		/obj/item/clothing/glasses/safety/goggles = 3,
		/obj/item/airlock_electronics = 12,
		/obj/item/module/power_control = 7,
		/obj/item/airalarm_electronics = 7,
		/obj/item/firealarm_electronics = 8,
		/obj/item/cell/high = 4,
		/obj/item/grenade/chem_grenade/antifuel = 3,
		/obj/item/device/geiger = 1
	)

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_vend = "tool-vend"
	vend_id = "tools"
	//req_access = list(ACCESS_MAINT_TUNNELS) //Maintenance access
	products = list(
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/crowbar = 5,
		/obj/item/weldingtool = 3,
		/obj/item/wirecutters = 5,
		/obj/item/wrench = 5,
		/obj/item/device/analyzer = 5,
		/obj/item/device/t_scanner = 5,
		/obj/item/screwdriver = 5,
		/obj/item/tape_roll = 3,
		/obj/item/hammer = 5
	)
	contraband = list(
		/obj/item/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/yellow/budget = 2
	)
	premium = list(
		/obj/item/clothing/gloves/yellow = 1
	)
	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/weldingtool,
		/obj/item/weldingtool/hugetank
	)
	restock_items = TRUE
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/tool/low_supply
	products = list(
		/obj/item/stack/cable_coil/random = 4,
		/obj/item/crowbar = 3,
		/obj/item/weldingtool = 1,
		/obj/item/wirecutters = 2,
		/obj/item/wrench = 2,
		/obj/item/device/analyzer = 3,
		/obj/item/device/t_scanner = 2,
		/obj/item/screwdriver = 3,
		/obj/item/tape_roll = 1,
		/obj/item/hammer = 1
	)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_vend = "engi-vend"
	req_access = list(ACCESS_ENGINE_EQUIP)
	vend_id = "tools"
	products = list(
		/obj/item/clothing/head/hardhat = 4,
		/obj/item/storage/belt/utility = 5,
		/obj/item/clothing/glasses/safety/goggles = 4,
		/obj/item/clothing/gloves/yellow = 4,
		/obj/item/screwdriver = 8,
		/obj/item/crowbar = 8,
		/obj/item/wirecutters = 8,
		/obj/item/device/multitool = 8,
		/obj/item/wrench = 8,
		/obj/item/device/t_scanner = 8,
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/cell = 5,
		/obj/item/device/analyzer = 5,
		/obj/item/cell/high = 2,
		/obj/item/weldingtool = 8,
		/obj/item/clothing/head/welding = 8,
		/obj/item/light/tube = 10,
		/obj/item/clothing/head/hardhat/firefighter = 4,
		/obj/item/clothing/suit/fire = 4,
		/obj/item/stock_parts/scanning_module = 5,
		/obj/item/stock_parts/micro_laser = 5,
		/obj/item/stock_parts/matter_bin = 5,
		/obj/item/stock_parts/manipulator = 5,
		/obj/item/stock_parts/console_screen = 5,
		/obj/item/tape_roll = 5
	)

	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/weldingtool,
		/obj/item/light/tube
	)
	restock_items = TRUE
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/item/device/vending_refill/tools
	name = "tools resupply canister"
	vend_id = "tools"
	charges = 25


/obj/machinery/vending/encryption
	name = "SCC Encryption Key Vendor"
	desc = "Communications galore, at the tip of your fingers."
	product_ads = "Stop walkin, get talkin!;Get them keys!;Psst, got a minute?"
	icon_state = "wallencrypt"
	density = 0 //It is wall-mounted.
	req_access = list(ACCESS_HOP)
	vend_id = "encryption"
	products = list(
		/obj/item/device/encryptionkey/heads/captain = 1,
		/obj/item/device/encryptionkey/heads/ce = 1,
		/obj/item/device/encryptionkey/heads/cmo = 1,
		/obj/item/device/encryptionkey/heads/hos = 1,
		/obj/item/device/encryptionkey/heads/rd = 1,
		/obj/item/device/encryptionkey/heads/xo = 1,
		/obj/item/device/encryptionkey/headset_operations_manager = 1,
		/obj/item/device/encryptionkey/headset_com = 5,
		/obj/item/device/encryptionkey/headset_cargo = 5,
		/obj/item/device/encryptionkey/headset_eng = 5,
		/obj/item/device/encryptionkey/headset_med = 5,
		/obj/item/device/encryptionkey/headset_sci = 5,
		/obj/item/device/encryptionkey/headset_sec = 5,
		/obj/item/device/encryptionkey/headset_service = 5,
		/obj/item/device/encryptionkey/headset_warden = 5,
		/obj/item/device/encryptionkey/headset_xenology = 5,
	)

/obj/item/device/vending_refill/encryption
	name = "encryption key resupply canister"
	vend_id = "encryption"
	charges = 60


/obj/machinery/vending/assist
	vend_id = "tools"
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,
		/obj/item/device/assembly/igniter = 3,
		/obj/item/device/assembly/signaler = 4,
		/obj/item/wirecutters = 1
	)
	contraband = list(
		/obj/item/device/flashlight = 5,
		/obj/item/device/assembly/timer = 2,
		/obj/item/device/assembly/infra = 2,
		/obj/item/device/assembly/voice = 2
	)
	premium = list(
		/obj/item/device/multitool/ = 2
	)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	restock_items = TRUE
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/assist/synd
	name = "\improper Parts vendor"
	desc = "Just a normal vending machine - nothing to see here."
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
	contraband = null
	random_itemcount = 0
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,
		/obj/item/device/assembly/signaler = 4,
		/obj/item/device/assembly/infra = 4,
		/obj/item/device/assembly/prox_sensor = 4,
		/obj/item/handcuffs = 8,
		/obj/item/device/flash = 4,
		/obj/item/clothing/glasses/sunglasses = 4
	)
