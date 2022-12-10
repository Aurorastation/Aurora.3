
/obj/structure/closet/sol
	name = "sol navy uniform closet"
	desc = "It's a storage unit for Sol Alliance navy uniforms."
	icon_state = "syndicate1"

/obj/structure/closet/sol/navy/fill()
	..()
	new /obj/item/clothing/under/rank/sol(src)
	new /obj/item/clothing/under/rank/sol(src)
	new /obj/item/clothing/under/rank/sol(src)
	new /obj/item/clothing/under/rank/sol/service(src)
	new /obj/item/clothing/under/rank/sol/service(src)
	new /obj/item/clothing/under/rank/sol/service(src)
	new /obj/item/clothing/head/sol(src)
	new /obj/item/clothing/head/sol(src)
	new /obj/item/clothing/head/sol(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/marine
	name = "sol marines uniform closet"
	desc = "It's a storage unit for Sol Alliance marine uniforms."

/obj/structure/closet/sol/marine/fill()
	..()
	new /obj/item/clothing/under/rank/sol/marine(src)
	new /obj/item/clothing/under/rank/sol/marine(src)
	new /obj/item/clothing/under/rank/sol/marine(src)
	new /obj/item/clothing/under/rank/sol/service/marine(src)
	new /obj/item/clothing/under/rank/sol/service/marine(src)
	new /obj/item/clothing/under/rank/sol/service/marine(src)
	new /obj/item/clothing/head/sol/marine(src)
	new /obj/item/clothing/head/sol/marine(src)
	new /obj/item/clothing/head/sol/garrison(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)

/obj/structure/closet/sol/navy_dress
	name = "sol navy dress uniform closet"
	desc = "It's a storage unit for Sol Alliance navy dress uniforms."

/obj/structure/closet/sol/navy_dress/fill()
	..()
	new /obj/item/clothing/under/rank/sol/dress(src)
	new /obj/item/clothing/under/rank/sol/dress(src)
	new /obj/item/clothing/under/rank/sol/dress(src)
	new /obj/item/clothing/head/sol/dress(src)
	new /obj/item/clothing/head/sol/dress(src)
	new /obj/item/clothing/head/sol/dress(src)
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
	new /obj/item/clothing/under/rank/sol/dress/marine(src)
	new /obj/item/clothing/under/rank/sol/dress/marine(src)
	new /obj/item/clothing/under/rank/sol/dress/marine(src)
	new /obj/item/clothing/head/sol/dress/marine(src)
	new /obj/item/clothing/head/sol/dress/marine(src)
	new /obj/item/clothing/head/sol/dress/marine(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/clothing/gloves/white(src)

/obj/structure/closet/secure_closet/soll_officer
	name = "sol alliance officer locker"
	req_access = list(access_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/soll_officer/fill()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/captain(src)
	else
		new /obj/item/storage/backpack/satchel/cap(src)
	new /obj/item/clothing/under/rank/sol/dress/officer(src)
	new /obj/item/clothing/head/sol/dress/officer(src)
	new /obj/item/clothing/suit/storage/vest(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/clothing/gloves/white(src)
	new /obj/item/gun/energy/pistol(src)
	new /obj/item/device/flash(src)
	new /obj/item/melee/telebaton(src)
	new /obj/item/melee/ceremonial_sword(src)
	new /obj/item/clothing/under/rank/sol(src)
	new /obj/item/clothing/under/rank/sol/service(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/accessory/holster/armpit(src)
	return
