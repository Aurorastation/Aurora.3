/obj/item/storage/belt/archaeology
	name = "excavation gear-belt"
	desc = "Can hold various excavation gear."
	icon_state = "gearbelt"
	item_state = "utility"
	storage_slots = 10
	can_hold = list(
		/obj/item/storage/box/samplebags,
		/obj/item/device/core_sampler,
		/obj/item/device/beacon_locator,
		/obj/item/device/radio/beacon,
		/obj/item/device/gps,
		/obj/item/device/radio,
		/obj/item/device/measuring_tape,
		/obj/item/device/flashlight,
		/obj/item/pickaxe,
		/obj/item/device/depth_scanner,
		/obj/item/device/camera,
		/obj/item/device/camera_film,
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/folder,
		/obj/item/pen,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/clipboard,
		/obj/item/anodevice,
		/obj/item/clothing/glasses,
		/obj/item/wrench,
		/obj/item/storage/box/excavation,
		/obj/item/anobattery,
		/obj/item/device/ano_scanner,
		/obj/item/ore_detector,
		/obj/item/device/spaceflare
		)

/obj/item/storage/belt/archaeology/full
	starts_with = list(
		/obj/item/device/core_sampler = 1,
		/obj/item/device/gps = 1,
		/obj/item/device/measuring_tape = 1,
		/obj/item/pickaxe/hand = 1,
		/obj/item/storage/box/excavation = 1,
		/obj/item/device/depth_scanner = 1,
		/obj/item/device/ano_scanner = 1,
		/obj/item/ore_detector = 1,
		/obj/item/wrench = 1
		)
