/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/wardrobe/red/fill()
	..()
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/under/rank/cadet(src)
	new /obj/item/clothing/under/rank/cadet(src)
	new /obj/item/clothing/under/rank/cadet(src)
	new /obj/item/clothing/shoes/black_boots(src)
	new /obj/item/clothing/shoes/black_boots(src)
	new /obj/item/clothing/shoes/black_boots(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/soft/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec/alt(src)
	new /obj/item/clothing/head/beret/sec/alt(src)
	new /obj/item/clothing/head/beret/sec/alt(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/shoes/jackboots/toeless(src)

	return

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

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
	icon_state = "black"
	icon_closed = "black"

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
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/chaplain_black/fill()
	..()
	new /obj/item/clothing/under/rank/chaplain(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/suit/nun(src)
	new /obj/item/clothing/head/nun_hood(src)
	new /obj/item/clothing/suit/chaplain_hoodie(src)
	new /obj/item/clothing/head/chaplain_hood(src)
	new /obj/item/clothing/suit/holidaypriest(src)
	new /obj/item/clothing/under/wedding/bride_white(src)
	new /obj/item/storage/backpack/cultpack (src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/deck/tarot(src)
	new /obj/item/device/radio/headset/headset_service(src)
	new /obj/item/spirit_board(src)
	new /obj/item/mesmetron(src)
	new /obj/item/toy/plushie/therapy(src)
	new /obj/item/book/manual/psych(src)
	return


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

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
	icon_state = "green"
	icon_closed = "green"

/obj/structure/closet/wardrobe/xenos/fill()
	..()
	new /obj/item/clothing/suit/unathi/mantle(src)
	new /obj/item/clothing/suit/unathi/robe(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	new /obj/item/clothing/shoes/sandal(src)
	return


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

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
	icon_state = "yellow"
	icon_closed = "yellow"

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
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/atmospherics_yellow/fill()
	..()
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/under/rank/atmospheric_technician(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/red(src)
	new /obj/item/clothing/head/hardhat/dblue(src)
	new /obj/item/clothing/head/hardhat/dblue(src)
	new /obj/item/clothing/head/hardhat/dblue(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	return



/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

/obj/structure/closet/wardrobe/engineering_yellow/fill()
	..()
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer(src)
	new /obj/item/clothing/under/rank/engineer/apprentice(src)
	new /obj/item/clothing/under/rank/engineer/apprentice(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/shoes/orange(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/hardhat(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	return


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"

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
	icon_state = "white"
	icon_closed = "white"

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
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/toxins_white/fill()
	..()
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/science(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	new /obj/item/clothing/shoes/slippers(src)
	return


/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

/obj/structure/closet/wardrobe/robotics_black/fill()
	..()
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/under/rank/roboticist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/gloves/black(src)
	new /obj/item/clothing/gloves/black(src)
	return


/obj/structure/closet/wardrobe/pharmacy_white
	name = "pharmacy wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/pharmacy_white/fill()
	..()
	new /obj/item/clothing/under/rank/pharmacist(src)
	new /obj/item/clothing/under/rank/pharmacist(src)
	new /obj/item/clothing/shoes/chemist(src)
	new /obj/item/clothing/shoes/chemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/pharmacist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/pharmacist(src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/genetics_white/fill()
	..()
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/under/rank/geneticist(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/genetics(src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/virology_white/fill()
	..()
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/under/rank/virologist(src)
	new /obj/item/clothing/shoes/biochem(src)
	new /obj/item/clothing/shoes/biochem(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/biochemist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/biochemist(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	return


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_white/fill()
	..()
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical(src)
	new /obj/item/clothing/under/rank/medical/blue(src)
	new /obj/item/clothing/under/rank/medical/green(src)
	new /obj/item/clothing/under/rank/medical/purple(src)
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/clothing/shoes/medical(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	return


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

/obj/structure/closet/wardrobe/grey/fill()
	..()
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/under/color/grey(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	new /obj/item/clothing/head/soft/grey(src)
	return


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/mixed/fill()
	..()
	new /obj/item/clothing/under/color/blue(src)
	new /obj/item/clothing/under/color/yellow(src)
	new /obj/item/clothing/under/color/green(src)
	new /obj/item/clothing/under/color/orange(src)
	new /obj/item/clothing/under/color/pink(src)
	new /obj/item/clothing/under/skirt/plaid_blue(src)
	new /obj/item/clothing/under/skirt/plaid_red(src)
	new /obj/item/clothing/under/skirt/plaid_purple(src)
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
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

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
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/wardrobe/suit/fill()
	..()
	new /obj/item/clothing/under/assistantformal(src)
	new /obj/item/clothing/under/suit_jacket/charcoal(src)
	new /obj/item/clothing/under/suit_jacket/navy(src)
	new /obj/item/clothing/under/suit_jacket/burgundy(src)
	new /obj/item/clothing/under/suit_jacket/checkered(src)
	new /obj/item/clothing/under/suit_jacket/tan(src)
	new /obj/item/clothing/under/sl_suit(src)
	new /obj/item/clothing/under/suit_jacket(src)
	new /obj/item/clothing/under/suit_jacket/female(src)
	new /obj/item/clothing/under/suit_jacket/really_black(src)
	new /obj/item/clothing/under/suit_jacket/red(src)
	new /obj/item/clothing/under/scratch(src)
