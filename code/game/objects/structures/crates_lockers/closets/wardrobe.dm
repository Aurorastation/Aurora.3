/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	icon_door = "blue"

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_door = "blue"

/obj/structure/closet/wardrobe/red/fill()
	..()
	new /obj/item/clothing/under/rank/security/zavod(src)
	new /obj/item/clothing/under/rank/security/pmc(src)
	new /obj/item/clothing/under/rank/security/idris(src)
	new /obj/item/clothing/under/rank/cadet/zavod(src)
	new /obj/item/clothing/under/rank/cadet/pmc(src)
	new /obj/item/clothing/under/rank/cadet/idris(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/head/softcap/security(src)
	new /obj/item/clothing/head/softcap/security(src)
	new /obj/item/clothing/head/softcap/security(src)
	new /obj/item/clothing/head/beret/security(src)
	new /obj/item/clothing/head/beret/security(src)
	new /obj/item/clothing/head/beret/security(src)
	new /obj/item/clothing/head/beret/security/officer(src)
	new /obj/item/clothing/head/beret/security/officer(src)
	new /obj/item/clothing/head/beret/security/officer(src)
	new /obj/item/clothing/head/bandana/security(src)
	new /obj/item/clothing/head/bandana/security(src)
	new /obj/item/clothing/head/bandana/security(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots/knee(src)
	new /obj/item/clothing/shoes/jackboots/knee(src)
	new /obj/item/clothing/shoes/jackboots/toeless(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/holster/waist(src)

	return

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_door = "pink"

/obj/structure/closet/wardrobe/pink/fill()
	..()
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/brown(src)
	return

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_door = "black"

/obj/structure/closet/wardrobe/black/fill()
	..()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	new /obj/item/clothing/head/that(src)
	return


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	icon_door = "black"

/obj/structure/closet/wardrobe/chaplain_black/fill()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/storage/box/fancy/candle_box(src)
	new /obj/item/storage/box/fancy/candle_box(src)
	new /obj/item/deck/tarot(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/spirit_board(src)
	new /obj/item/mesmetron(src)
	new /obj/item/toy/plushie/therapy(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/green/fill()
	..()
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	return

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	icon_door = "green"

/obj/structure/closet/wardrobe/xenos/fill()
	..()
	new /obj/item/clothing/accessory/poncho/unathimantle(src)
	new /obj/item/clothing/suit/unathi/robe/beige(src)
	new /obj/item/clothing/shoes/footwraps(src)
	new /obj/item/clothing/shoes/footwraps(src)
	new /obj/item/clothing/shoes/caligae(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	icon_door = "orange"

/obj/structure/closet/wardrobe/orange/fill()
	..()
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	return


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/yellow/fill()
	..()
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	return


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow/fill()
	..()
	new /obj/item/clothing/under/rank/atmospheric_technician/heph(src)
	new /obj/item/clothing/under/rank/atmospheric_technician/zavod(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/green(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/corporate/heph(src)
	new /obj/item/clothing/head/beret/corporate/zavod(src)
	new /obj/item/clothing/head/bandana/atmos(src)
	new /obj/item/clothing/suit/storage/hazardvest/green(src)
	new /obj/item/clothing/suit/storage/hazardvest/red(src)
	new /obj/item/clothing/suit/storage/hazardvest/blue/atmos(src)
	return


/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_door = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/fill()
	..()
	new /obj/item/clothing/under/rank/engineer/heph(src)
	new /obj/item/clothing/under/rank/engineer/zavod(src)
	new /obj/item/clothing/under/rank/engineer/apprentice/heph(src)
	new /obj/item/clothing/under/rank/engineer/apprentice/zavod(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/green(src)
	new /obj/item/clothing/head/hardhat/green(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/corporate/heph(src)
	new /obj/item/clothing/head/beret/corporate/zavod(src)
	new /obj/item/clothing/head/bandana/engineering(src)
	new /obj/item/clothing/head/bandana/engineering(src)
	new /obj/item/clothing/suit/storage/toggle/highvis(src)
	new /obj/item/clothing/suit/storage/toggle/highvis(src)
	new /obj/item/clothing/suit/storage/hazardvest/green(src)
	new /obj/item/clothing/suit/storage/hazardvest/red(src)


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/white/fill()
	..()
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/under/color/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	return


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/pjs/fill()
	..()
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/red(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/under/pj/blue(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	return


/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/toxins_white/fill()
	..()
	new /obj/item/clothing/under/rank/scientist/zavod(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist/zeng(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/head/bandana/science(src)
	new /obj/item/clothing/head/bandana/science(src)
	new /obj/item/clothing/head/bandana/science(src)
	return

/obj/structure/closet/wardrobe/pharmacy_white
	name = "pharmacy wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/pharmacy_white/fill()
	..()
	new /obj/item/storage/backpack/duffel/pharm(src)
	new /obj/item/clothing/under/rank/medical/pharmacist/zeng(src)
	new /obj/item/clothing/under/rank/medical/pharmacist(src)
	new /obj/item/clothing/under/rank/medical/pharmacist/pmc(src)
	new /obj/item/clothing/shoes/chemist(src)
	new /obj/item/clothing/shoes/chemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/nt(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/zeng(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/pmc(src)
	return

/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/virology_white/fill()
	..()
	new /obj/item/clothing/shoes/biochem(src)
	new /obj/item/clothing/shoes/biochem(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	return


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_door = "white"

/obj/structure/closet/wardrobe/medic_white/fill()
	..()
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical/surgeon/pmc(src)
	new /obj/item/clothing/under/rank/medical/surgeon/idris(src)
	new /obj/item/clothing/under/rank/medical/surgeon/zeng(src)
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/head/bandana/medical(src)
	new /obj/item/clothing/head/bandana/medical(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_door = "grey"

/obj/structure/closet/wardrobe/grey/fill()
	..()
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/softcap(src)
	new /obj/item/clothing/head/softcap(src)
	new /obj/item/clothing/head/softcap(src)
	new /obj/item/clothing/head/bandana(src)
	new /obj/item/clothing/head/bandana(src)
	new /obj/item/clothing/head/bandana(src)
	return


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/mixed/fill()
	..()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/shoes/blue(src)
	new /obj/item/clothing/shoes/yellow(src)
	new /obj/item/clothing/shoes/green(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/purple(src)
	new /obj/item/clothing/shoes/red(src)
	new /obj/item/clothing/accessory/silversun/random(src)
	new /obj/item/clothing/accessory/silversun/random(src)
	return

/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_state = "syndicate1"

/obj/structure/closet/wardrobe/tactical/fill()
	..()
	new /obj/item/clothing/under/tactical(src)
	new /obj/item/clothing/suit/armor/tactical(src)
	new /obj/item/clothing/head/helmet/tactical(src)
	new /obj/item/clothing/mask/balaclava/white(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/tactical(src)
	new /obj/item/storage/belt/security/tactical(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/gloves/black(src)
	return

/obj/structure/closet/wardrobe/suit
	name = "suit locker"
	icon_door = "mixed"

/obj/structure/closet/wardrobe/suit/fill()
	..()
	new /obj/item/clothing/under/suit_jacket/charcoal(src)
	new /obj/item/clothing/under/suit_jacket/navy(src)
	new /obj/item/clothing/under/suit_jacket/burgundy(src)
	new /obj/item/clothing/under/suit_jacket/checkered(src)
	new /obj/item/clothing/under/suit_jacket/tan(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/suit_jacket(src)
	new /obj/item/clothing/under/suit_jacket/really_black(src)
	new /obj/item/clothing/under/suit_jacket/red(src)
	new /obj/item/clothing/under/suit_jacket/white(src)
