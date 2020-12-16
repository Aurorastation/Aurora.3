/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "magivend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/clothing/head/wizard, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/suit/wizrobe, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/shoes/sandal, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/staff, 1, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/clothing/head/wizard/red, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/suit/wizrobe/red, 1, FALSE),
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/clothing/head/wizard/fake, 1, FALSE)
		)
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/tacticool //Tried not to go overboard with the amount of fun security has access to.
	name = "Tactical Express"
	desc = "Everything you need to ensure corporate bureaucracy makes it another day."
	icon_state = "tact"
	deny_time = 19
	req_access = list(access_security)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/storage/box/shotgunammo, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/shotgunshells, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/c45m, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/grenade/chem_grenade/teargas, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/mc9mmt, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/gas/tactical, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/handcuffs/ziptie, 3, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/grenade/flashbang/clusterbang, 1, FALSE) //this can only go well.
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/grenade/chem_grenade/gas, 2, FALSE)
		)
	)
	randomize_qty = FALSE
	light_color = COLOR_BROWN

/obj/machinery/vending/tacticool/ert //Slightly more !FUN!
	name = "Nanosecurity Plus"
	desc = "For when shit really goes down; the private contractor's personal armory."
	req_access = list(access_security)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/storage/box/shotgunammo, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/shotgunshells, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/grenade/chem_grenade/gas, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/gas/tactical, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/shield/riot/tact, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/handcuffs/ziptie, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/mc9mmt, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/mc9mmt/rubber, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/gun/projectile/automatic/x9, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/c45x, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/a556, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/ammo_magazine/a556/ap, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/material/knife/tacknife, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/firing_pin, 12, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/gun/bang/deagle, 1, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/shield/riot/tact, 2, FALSE)
		)
	)
	randomize_qty = FALSE
