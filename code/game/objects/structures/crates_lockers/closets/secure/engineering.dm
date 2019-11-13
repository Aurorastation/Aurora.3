/obj/structure/closet/secure_closet/engineering_chief
	name = "chief engineer's locker"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

/obj/structure/closet/secure_closet/engineering_chief/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	if (prob(70))
		new /obj/item/clothing/accessory/storage/brown_vest(src)
	else
		new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/blueprints(src)
	new /obj/item/clothing/under/rank/chief_engineer(src)
	new /obj/item/clothing/head/hardhat/white(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/gloves/yellow(src)
	new /obj/item/clothing/gloves/yellow/specialu(src)
	new /obj/item/clothing/gloves/yellow/specialt(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/cartridge/ce(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson/aviator(src)
	new /obj/item/device/multitool(src)
	new /obj/item/device/flash(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/chief(src)

/obj/structure/closet/secure_closet/engineering_chief2
	name = "chief engineer's attire"
	req_access = list(access_ce)
	icon_state = "securece1"
	icon_closed = "securece"
	icon_locked = "securece1"
	icon_opened = "secureceopen"
	icon_broken = "securecebroken"
	icon_off = "secureceoff"

/obj/structure/closet/secure_closet/engineering_chief2/fill()
	new /obj/item/storage/backpack/industrial(src)
	new /obj/item/storage/backpack/satchel_eng(src)
	new /obj/item/clothing/accessory/storage/brown_vest(src)
	new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/clothing/under/rank/chief_engineer(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/device/radio/headset/heads/ce(src)
	new /obj/item/clothing/accessory/storage/overalls/chief(src)

/obj/structure/closet/secure_closet/engineering_electrical
	name = "electrical supplies"
	req_access = list(access_engine_equip)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"

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
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"

/obj/structure/closet/secure_closet/engineering_welding/fill()
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/clothing/head/welding(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/weldpack(src)
	new /obj/item/weldpack(src)
	new /obj/item/weldpack(src)

/obj/structure/closet/secure_closet/engineering_personal
	name = "engineer's locker"
	req_access = list(access_engine_equip)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengbroken"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/engineering_personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	if (prob(70))
		new /obj/item/clothing/accessory/storage/brown_vest(src)
	else
		new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/storage/toolbox/mechanical(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/clothing/glasses/meson/aviator(src)
	new /obj/item/cartridge/engineering(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/engineer(src)

/obj/structure/closet/secure_closet/atmos_personal
	name = "atmospheric technician's locker"
	req_access = list(access_atmospherics)
	icon_state = "secureatm1"
	icon_closed = "secureatm"
	icon_locked = "secureatm1"
	icon_opened = "secureatmopen"
	icon_broken = "secureatmbroken"
	icon_off = "secureatmoff"

/obj/structure/closet/secure_closet/atmos_personal/fill()
	if(prob(50))
		new /obj/item/storage/backpack/industrial(src)
	else
		new /obj/item/storage/backpack/satchel_eng(src)
	if (prob(70))
		new /obj/item/clothing/accessory/storage/brown_vest(src)
	else
		new /obj/item/clothing/accessory/storage/webbing(src)
	new /obj/item/clothing/suit/fire/atmos(src)
	new /obj/item/clothing/head/hardhat/red/atmos(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/extinguisher(src)
	new /obj/item/device/radio/headset/headset_eng(src)
	new /obj/item/clothing/suit/storage/hazardvest/blue/atmos(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/cartridge/atmos(src)
	new /obj/item/taperoll/engineering(src)
	new /obj/item/clothing/accessory/storage/overalls/engineer(src)
