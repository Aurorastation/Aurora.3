/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "ce"

/obj/structure/closet/secure_closet/engineering_chief/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/storage/backpack/duffel/eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/blueprints(src)
	new /obj/item/clothing/under/rank/chief_engineer(src)
	new /obj/item/clothing/head/hardhat/white(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/device/radio/headset/heads/ce/alt(src)
	new /obj/item/device/megaphone/engi(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/clothing/suit/storage/hazardvest/ce(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/flash(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/chief(src)
	new /obj/item/rfd/piping(src)
	new /obj/item/storage/box/fancy/keypouch/eng(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)

/obj/structure/closet/secure_closet/engineering_chief2
	name = "chief engineer's attire"
	req_access = list(access_ce)
	icon_state = "ce"

/obj/structure/closet/secure_closet/engineering_chief2/fill()
	new /obj/item/storage/backpack/industrial(src)
	new /obj/item/storage/backpack/satchel/eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/clothing/under/rank/chief_engineer(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/device/radio/headset/heads/ce/alt(src)
	new /obj/item/clothing/accessory/storage/overalls/chief(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "eng"
	icon_door = "eng_elec"

/obj/structure/closet/secure_closet/engineering_electrical/fill()
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/storage/toolbox/electrical(src)
	new /obj/item/module/power_control(src)
	new /obj/item/module/power_control(src)
	new /obj/item/module/power_control(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/multitool(src)

/obj/structure/closet/secure_closet/engineering_welding
	name = "welding supplies"
	req_access = list(access_construction)
	icon_state = "eng"
	icon_door = "eng_weld"

/obj/structure/closet/secure_closet/engineering_welding/fill()
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/reagent_containers/weldpack(src)
	new /obj/item/reagent_containers/weldpack(src)
	new /obj/item/reagent_containers/weldpack(src)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "eng_secure"

/obj/structure/closet/secure_closet/engineering_personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
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

/obj/structure/closet/secure_closet/atmos_personal
	name = "atmospheric technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "atmos"

/obj/structure/closet/secure_closet/atmos_personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel/eng(src)
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
