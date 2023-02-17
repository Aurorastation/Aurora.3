// Custodial Locker
/obj/structure/closet/secure_closet/custodial
	name = "custodial closet"
	desc = "It's a storage unit for a custodian's clothes and gear."
	icon_state = "custodial"
	req_access = list(access_janitor)

/obj/structure/closet/secure_closet/custodial/fill()
	new /obj/item/clothing/head/softcap/nt/custodian(src)
	new /obj/item/clothing/head/softcap/idris/custodian(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/clothing/under/rank/janitor(src)
	new /obj/item/clothing/under/rank/janitor/idris(src)
	new /obj/item/storage/box/janitorgloves(src)
	new /obj/item/storage/belt/custodial(src)
	new /obj/item/clothing/accessory/holster/utility/custodial/hip(src)
	new /obj/item/clothing/accessory/holster/utility/custodial/armpit(src)
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
	new /obj/item/storage/box/lights/mixed(src)
	new /obj/item/storage/box/mousetraps(src)

// Away Ship/Site Custodial Locker
/obj/structure/closet/secure_closet/custodial/offship
	req_access = null

/obj/structure/closet/secure_closet/custodial/offship/fill()
	new /obj/item/storage/box/janitorgloves(src)
	new /obj/item/storage/belt/custodial(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/reagent_containers/spray/cleaner(src)
	new /obj/item/soap/red_soap(src)
	new /obj/item/reagent_containers/glass/rag(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/grenade/chem_grenade/cleaner(src)
	new /obj/item/taperoll/custodial(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/clothing/suit/caution(src)
	new /obj/item/storage/box/lights/mixed(src)
	new /obj/item/storage/box/mousetraps(src)