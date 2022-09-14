/obj/structure/closet/secure_closet/scientist
	name = "scientist's locker"
	req_access = list(access_tox_storage)
	icon_state = "science"

/obj/structure/closet/secure_closet/scientist/fill()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/device/radio/headset/headset_sci/alt(src)
	new /obj/item/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/taperoll/science(src)

/obj/structure/closet/secure_closet/RD
	name = "research director's locker"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD/fill()
	new /obj/item/clothing/suit/bio_suit/scientist(src)
	new /obj/item/clothing/head/bio_hood/scientist(src)
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/device/radio/headset/heads/rd/alt(src)
	new /obj/item/tank/air(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/device/flash(src)
	new /obj/item/storage/box/firingpinsRD(src)
	new /obj/item/device/pin_extractor(src)
	new /obj/item/storage/box/fancy/keypouch/sci(src)
	new /obj/item/storage/box/tethers(src)
	new /obj/item/taperoll/science(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)
	new /obj/item/device/memorywiper(src)

/obj/structure/closet/secure_closet/RD2
	name = "research director's attire"
	req_access = list(access_rd)
	icon_state = "rd"

/obj/structure/closet/secure_closet/RD2/fill()
	new /obj/item/clothing/under/rank/research_director(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/clothing/gloves/latex/nitrile(src)
	new /obj/item/device/radio/headset/heads/rd(src)
	new /obj/item/device/radio/headset/heads/rd/alt(src)
	new /obj/item/device/megaphone/sci(src)
