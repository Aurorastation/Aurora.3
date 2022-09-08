//
// Operations Lockers
//

// Operations Manager
/obj/structure/closet/secure_closet/operations_manager
	name = "operations manager's locker"
	icon_state = "om"
	req_access = list(access_qm)

/obj/structure/closet/secure_closet/operations_manager/fill()
	new /obj/item/clothing/under/rank/operations_manager(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/operations_manager(src)
	new /obj/item/device/radio/headset/operations_manager/alt(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/head/softcap/cargo(src)
	new /obj/item/clothing/head/bandana/cargo(src)
	new /obj/item/clothing/head/beret/cargo(src)
	new /obj/item/modular_computer/handheld/preset/supply/cargo_delivery(src)
	new /obj/item/export_scanner(src)
	new /obj/item/device/orbital_dropper/drill(src)
	new /obj/item/device/megaphone/cargo(src)
	new /obj/item/storage/box/goldstar(src)
	new /obj/item/device/flashlight/marshallingwand(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)

// Hangar Technician
/obj/structure/closet/secure_closet/hangar_tech
	name = "hangar technician's locker"
	icon_state = "hangar_tech"
	req_access = list(access_cargo)

/obj/structure/closet/secure_closet/hangar_tech/fill()
	..()
	new /obj/item/clothing/under/rank/hangar_technician(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/device/radio/headset/headset_cargo/alt(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/head/softcap/cargo(src)
	new /obj/item/clothing/head/bandana/cargo(src)
	new /obj/item/clothing/head/beret/cargo(src)
	new /obj/item/modular_computer/handheld/preset/supply/cargo_delivery(src)
	new /obj/item/export_scanner(src)
	new /obj/item/device/flashlight/marshallingwand(src)

// Machinist
/obj/structure/closet/secure_closet/machinist
	name = "machinist's locker"
	icon_state = "machinist"
	req_access = list(access_robotics)

/obj/structure/closet/secure_closet/machinist/fill()
	..()
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	new /obj/item/clothing/under/rank/machinist/orion(src)
	new /obj/item/clothing/under/rank/machinist/heph(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/multitool(src)
	new /obj/item/ipc_tag_scanner(src)
	new /obj/item/device/robotanalyzer(src)

// Miner
/obj/structure/closet/secure_closet/miner
	name = "miner's locker"
	icon_state = "miner"
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/fill()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/device/radio/headset/headset_cargo(src)
	new /obj/item/clothing/under/rank/miner(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/device/analyzer(src)
	new /obj/item/storage/bag/ore(src)
	new /obj/item/shovel(src)
	new /obj/item/pickaxe(src)
	new /obj/item/gun/custom_ka/frame01/prebuilt(src)
	new /obj/item/ore_detector(src)
	new /obj/item/key/minecarts(src)
	new /obj/item/device/gps/mining(src)
	new /obj/item/book/manual/ka_custom(src)
	new /obj/item/clothing/accessory/storage/overalls/mining(src)
	new /obj/item/clothing/head/bandana/miner(src)
	new /obj/item/clothing/head/hardhat/orange(src)
	new /obj/item/device/radio(src)
	new /obj/item/device/flashlight/lantern(src)

// Merchant
/obj/structure/closet/secure_closet/merchant
	name = "merchant's locker"
	req_access = list(access_merchant)