//---- Bookcase

/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/New()
	..()
	new /obj/item/book/manual/excavation(src)
	new /obj/item/book/manual/mass_spectrometry(src)
	new /obj/item/book/manual/materials_chemistry_analysis(src)
	new /obj/item/book/manual/anomaly_testing(src)
	new /obj/item/book/manual/anomaly_spectroscopy(src)
	new /obj/item/book/manual/stasis(src)
	update_icon()

//---- Lockers and closets

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "xenoarchaeologist's locker"
	req_access = list(ACCESS_XENOARCH)
	icon_state = "science"

/obj/structure/closet/secure_closet/xenoarchaeologist/fill()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/medsci(src)
	new /obj/item/clothing/glasses/safety/goggles/science(src)
	new /obj/item/radio/headset/headset_sci(src)
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/box/unique/excavation(src)
	new /obj/item/taperoll/science(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/sampler(src)

/obj/structure/closet/excavation
	name = "excavation tools"
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/excavation/fill()
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/box/unique/excavation(src)
	new /obj/item/flashlight/lantern(src)
	new /obj/item/ano_scanner(src)
	new /obj/item/depth_scanner(src)
	new /obj/item/core_sampler(src)
	new /obj/item/gps/science(src)
	new /obj/item/beacon_locator(src)
	new /obj/item/radio/beacon(src)
	new /obj/item/pickaxe(src)
	new /obj/item/material/hatchet/machete/steel(src)
	new /obj/item/clothing/accessory/holster/utility/machete(src)
	new /obj/item/measuring_tape(src)
	new /obj/item/pickaxe/hand(src)
	new /obj/item/storage/bag/fossils(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/ore_detector(src)
	new /obj/item/spaceflare(src)
	new /obj/item/tent(src)

	// 2 Drills
	new /obj/item/pickaxe/drill(src)
	new /obj/item/pickaxe/drill(src)

//---- Isolation room air alarms

/obj/machinery/alarm/isolation
	req_one_access = list(ACCESS_RESEARCH, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)

/obj/machinery/alarm/monitor/isolation
	req_one_access = list(ACCESS_RESEARCH, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	locked = 0
	remote_control = 1
