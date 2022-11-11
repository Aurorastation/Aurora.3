//
// Secure Engineering Lockers and Closets
//

// Chief Engineer
/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	icon_state = "ce"
	anchored = TRUE
	canbemoved = TRUE
	req_access = list(access_ce)

/obj/structure/closet/secure_closet/engineering_chief/fill()
	new /obj/item/storage/backpack/satchel/locker_clothing/ce(src)
	new /obj/item/storage/backpack/duffel/eng(src)
	new /obj/item/blueprints(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/device/megaphone/engi(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/flash(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/rfd/piping(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/device/gps/engineering(src)
	new /obj/item/pipewrench(src)
	new /obj/item/grenade/chem_grenade/large/phoroncleaner(src)
	new /obj/item/crowbar/rescue_axe/red(src)
	new /obj/item/device/radio/eng/off(src)

// Chief Engineer - Clothing Satchel
// This satchel is used nowhere except in conjunction with the locker above,
// thus the code is placed here rather than in the backpack code file.
/obj/item/storage/backpack/satchel/locker_clothing/ce
	name = "chief engineer's clothing satchel"
	desc = "A satchel filled with a chief engineer's spare clothing."
	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest = 1,
		/obj/item/clothing/under/rank/chief_engineer = 1,
		/obj/item/clothing/head/hardhat/white = 1,
		/obj/item/clothing/gloves/yellow = 1,
		/obj/item/clothing/gloves/yellow/specialu = 1,
		/obj/item/clothing/gloves/yellow/specialt = 1,
		/obj/item/clothing/shoes/brown = 1,
		/obj/item/device/radio/headset/heads/ce = 1,
		/obj/item/device/radio/headset/heads/ce/alt = 1,
		/obj/item/clothing/suit/storage/hazardvest/ce = 1,
		/obj/item/clothing/mask/gas/alt = 1,
		/obj/item/clothing/mask/gas/half = 1,
		/obj/item/clothing/accessory/storage/overalls/chief = 1,
		/obj/item/storage/box/fancy/keypouch/eng = 1
	)

// Engineer
/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "eng_secure"

/obj/structure/closet/secure_closet/engineering_personal/fill()
	new /obj/item/storage/backpack/duffel/eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng/alt(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/engineer(src)
	new /obj/item/device/radio/eng/off(src)
	new /obj/item/storage/belt/utility(src)
	new /obj/item/device/gps/engineering(src)
	new /obj/item/pipewrench(src)

	// Painters
	new /obj/item/device/floor_painter(src)
	new /obj/item/device/pipe_painter(src)

// Atmospherics Technician
/obj/structure/closet/secure_closet/atmos_personal
	name = "atmospheric technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "atmos"

/obj/structure/closet/secure_closet/atmos_personal/fill()
	new /obj/item/storage/backpack/duffel/eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/clothing/suit/fire/atmos(src)
	new /obj/item/clothing/head/hardhat/atmos(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/extinguisher(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/device/radio/headset/headset_eng/alt(src)
	new /obj/item/clothing/suit/storage/hazardvest/blue/atmos(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/engineer(src)
	new /obj/item/reagent_containers/extinguisher_refill(src)
	new /obj/item/rfd/piping(src)
	new /obj/item/device/radio/eng/off(src)
	new /obj/item/storage/belt/utility(src)
	new /obj/item/device/gps/engineering(src)
	new /obj/item/pipewrench(src)
	new /obj/item/crowbar/rescue_axe(src)
	new /obj/item/device/flashlight/heavy(src)

	// Painters
	new /obj/item/device/floor_painter(src)
	new /obj/item/device/pipe_painter(src)

// Electrical Supplies
/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/fill()
	// 4 Insulated Gloves (2 Xeno)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	// 3 Electrical Toolboxes
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/storage/toolbox/electrical(src)
	// 3 Power Control Boards
	new /obj/item/module/power_control(src)
	new /obj/item/module/power_control(src)
	new /obj/item/module/power_control(src)
	// 3 Multitools
	new /obj/item/device/multitool(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/multitool(src)
	// 2 Debuggers
	new /obj/item/device/debugger(src)
	new /obj/item/device/debugger(src)

// Welding Supplies
/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/fill()
	// 3 Welding Masks
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	// 3 Large Capacity Welding Tools
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	// 3 Backpack Welding Fuel Tanks
	new /obj/item/reagent_containers/weldpack(src)
	new /obj/item/reagent_containers/weldpack(src)
	new /obj/item/reagent_containers/weldpack(src)
	// 2 Welding Goggles
	new /obj/item/clothing/glasses/welding(src)
	new /obj/item/clothing/glasses/welding(src)