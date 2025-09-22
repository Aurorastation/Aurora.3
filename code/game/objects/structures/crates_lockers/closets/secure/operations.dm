//
// Operations Lockers
//

// Operations Manager
/obj/structure/closet/secure_closet/operations_manager
	name = "operations manager's locker"
	icon_state = "om"
	req_access = list(ACCESS_QM)

/obj/structure/closet/secure_closet/operations_manager/fill()
	new /obj/item/clothing/under/rank/operations_manager(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/device/radio/headset/operations_manager(src)
	new /obj/item/device/radio/headset/operations_manager/alt(src)
	new /obj/item/storage/box/fancy/keypouch/cargo(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/clothing/head/softcap/cargo(src)
	new /obj/item/clothing/head/bandana/cargo(src)
	new /obj/item/clothing/head/beret/cargo(src)
	new /obj/item/modular_computer/handheld/preset/supply/cargo_delivery(src)
	new /obj/item/export_scanner(src)
	new /obj/item/device/orbital_dropper/drill(src)
	new /obj/item/device/megaphone/cargo(src)
	new /obj/item/storage/stickersheet/goldstar(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/storage/belt/utility/full(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/memorywiper(src)
	new /obj/item/device/price_scanner(src)
	new /obj/item/device/robotanalyzer(src)

// Hangar Technician
/obj/structure/closet/secure_closet/hangar_tech
	name = "hangar technician's locker"
	icon_state = "hangar_tech"
	req_access = list(ACCESS_CARGO)

/obj/structure/closet/secure_closet/hangar_tech/fill()
	..()
	new /obj/item/clothing/under/rank/hangar_technician(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/device/radio/headset/headset_cargo/alt(src)
	new /obj/item/modular_computer/handheld/preset/supply/cargo_delivery(src)
	new /obj/item/export_scanner(src)
	new /obj/item/device/price_scanner(src)
	new /obj/item/device/cratescanner(src)
	new /obj/item/clipboard(src)
	new /obj/item/device/flashlight/marshallingwand(src)

// Machinist
/obj/structure/closet/secure_closet/machinist
	name = "machinist's locker"
	icon_state = "machinist"
	req_access = list(ACCESS_ROBOTICS)

/obj/structure/closet/secure_closet/machinist/fill()
	..()
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	new /obj/item/device/multitool(src)
	new /obj/item/ipc_tag_scanner(src)
	new /obj/item/device/robotanalyzer(src)

// Miner
/obj/structure/closet/secure_closet/miner
	name = "miner's locker"
	icon_state = "miner"
	req_access = list(ACCESS_MINING)

/obj/structure/closet/secure_closet/miner/fill()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/shovel(src)
	new /obj/item/pickaxe(src)
	new /obj/item/gun/custom_ka/frame01/prebuilt(src)
	new /obj/item/ore_detector(src)
	new /obj/item/key/minecarts(src)
	new /obj/item/device/gps/mining(src)
	new /obj/item/book/manual/ka_custom(src)
	new /obj/item/device/radio(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/sleeping_bag/mining(src)

// Merchant
/obj/structure/closet/secure_closet/merchant
	name = "merchant's locker"
	req_access = list(ACCESS_MERCHANT)

// Package Courier
/obj/structure/closet/secure_closet/package_courier
	name = "courier's locker"
	icon_state = "hangar_tech"
	req_access = list(ACCESS_CARGO)

/obj/structure/closet/secure_closet/package_courier/fill()
	..()
	// presumably the people taking them down to the exoplanet will give them proper suits
	// but in some kind of apocalyptic nightmare scenario where there aren't spare suits, these will do
	new /obj/item/clothing/head/helmet/space(src)
	new /obj/item/clothing/suit/space(src)
	new /obj/item/tank/oxygen(src)
	new /obj/item/cargo_backpack(src)
	new /obj/item/device/gps/mining(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/pickaxe(src)
