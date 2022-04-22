// Custodian
/obj/structure/closet/secure_closet/custodial
	name = "custodial closet"
	req_access = list(access_janitor)
	desc = "It's a storage unit for a custodian's clothes and gear."
	icon_state = "secure_custodiallocked"
	icon_closed = "secure_custodialunlocked"
	icon_locked = "secure_custodiallocked"
	icon_opened = "secure_custodialopen"
	icon_broken = "secure_custodialbroken"
	icon_off = "secure_custodialoff"

/obj/structure/closet/secure_closet/custodial/fill()
	new /obj/item/clothing/head/softcap/janitor(src)
	new /obj/item/clothing/head/beret/janitor(src)
	new /obj/item/clothing/head/bandana/janitor(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/under/rank/janitor/nt(src)
	new /obj/item/clothing/under/rank/janitor/idris(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/storage/belt/custodian(src)
	new /obj/item/clothing/accessory/holster/custodial/hip/brown(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/gun/energy/mousegun(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/reagent_containers/spray/cleaner(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/reagent_containers/glass/rag(src)
	new /obj/item/reagent_containers/glass/rag/advanced(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/device/gps/janitor(src)
	new /obj/item/taperoll/custodial(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/storage/box/lights/mixed(src)
	new /obj/item/storage/box/mousetraps(src)