
/obj/structure/closet/sol
	name = "sol navy uniform closet"
	desc = "It's a storage unit for Sol Alliance navy uniforms."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

/obj/structure/closet/sol/navy/fill()
	..()
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/head/navy(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/marine
	name = "sol marines uniform closet"
	desc = "It's a storage unit for Sol Alliance marine uniforms."

/obj/structure/closet/sol/marine/fill()
	..()
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/fatigues/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/under/rank/service/marine(src)
	new /obj/item/clothing/head/navy/marine(src)
	new /obj/item/clothing/head/navy/marine(src)
	new /obj/item/clothing/head/navy/garrison(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/navy_dress
	name = "sol navy dress uniform closet"
	desc = "It's a storage unit for Sol Alliance navy dress uniforms."

/obj/structure/closet/sol/navy_dress/fill()
	..()
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/under/rank/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/head/dress(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)

/obj/structure/closet/sol/marine_dress
	name = "sol marine dress uniform closet"
	desc = "It's a storage unit for Sol Alliance marine dress uniforms."

/obj/structure/closet/sol/marine_dress/fill()
	..()
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/under/rank/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/head/dress/marine(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)

/obj/structure/closet/secure_closet/soll_officer
	name = "sol alliance officer locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/soll_officer/fill()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/captain(src)
	else
		new /obj/item/storage/backpack/satchel_cap(src)
	new /obj/item/clothing/under/rank/dress/officer(src)
	new /obj/item/clothing/head/dress/officer(src)
	new /obj/item/clothing/suit/storage/vest(src)
	new /obj/item/cartridge/captain(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/gun/energy/pistol(src)
	new /obj/item/device/flash(src)
	new /obj/item/melee/telebaton(src)
	new /obj/item/melee/ceremonial_sword(src)
	new /obj/item/clothing/under/rank/fatigues(src)
	new /obj/item/clothing/under/rank/service(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/accessory/holster/armpit(src)
	return
