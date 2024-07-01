/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(ACCESS_TOX_STORAGE)
	icon_state = "science"

/obj/structure/closet/secure_closet/scientist/fill()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/medsci(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/device/radio/headset/headset_sci/alt(src)
	new /obj/item/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/taperoll/science(src)
	new /obj/item/sampler(src)

/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(ACCESS_RD)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD/fill()
	new /obj/item/clothing/suit/hazmat/research(src)
	new /obj/item/clothing/head/hazmat/research(src)
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/rig/hazmat/equipped(src)
	new /obj/item/clothing/glasses/welding/superior(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/storage/box/gloves(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/device/radio/headset/heads/rd/alt(src)
	new /obj/item/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/device/flash(src)
	new /obj/item/storage/box/firingpinsRD(src)
	new /obj/item/device/pin_extractor(src)
	new /obj/item/storage/box/fancy/keypouch/sci(src)
	new /obj/item/aicard(src)
	new /obj/item/device/paicard(src)
	new /obj/item/storage/box/tethers(src)
	new /obj/item/taperoll/science(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/device/memorywiper(src)
	new /obj/item/storage/box/psireceiver(src)
	new /obj/item/device/megaphone/sci(src)
	new /obj/item/device/taperecorder(src)
	new /obj/item/sampler(src)

/// Used for when we want to populate the contents of this locker ourself. Good for away sites
/obj/structure/closet/secure_closet/RD/empty
	name = "research director's locker"
	req_access = list(ACCESS_RD)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD/empty/fill()

/obj/structure/closet/secure_closet/RD2
	name = "research director's attire"
	req_access = list(ACCESS_RD)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD2/fill()
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/sneakers/brown(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/device/radio/headset/heads/rd/alt(src)
	new /obj/item/device/megaphone/sci(src)
