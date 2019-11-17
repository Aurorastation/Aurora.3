/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_broken = "hydrosecurebroken"
	icon_off = "hydrosecureoff"

	fill()
		..()
		switch(rand(1,2))
			if(1)
				new /obj/item/clothing/suit/apron(src)
			if(2)
				new /obj/item/clothing/suit/apron/overalls/blue(src)
		new /obj/item/storage/bag/plants(src)
		new /obj/item/clothing/under/rank/hydroponics(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
		new /obj/item/device/radio/headset/headset_service(src)
		new /obj/item/clothing/head/greenbandana(src)
		new /obj/item/material/minihoe(src)
		new /obj/item/material/hatchet(src)
		new /obj/item/wirecutters/clippers(src)
		new /obj/item/reagent_containers/spray/plantbgone(src)
		new /obj/item/storage/belt/hydro(src)
//		new /obj/item/bee_net(src) //No more bees, March 2014

/obj/structure/closet/secure_closet/xenobotany
	name = "xenobotanist's locker"
	req_access = list(access_xenobiology)
	icon_state = "xenobotsecure1"
	icon_closed = "xenobotsecure"
	icon_locked = "xenobotsecure1"
	icon_opened = "xenobotsecureopen"
	icon_broken = "xenobotsecurebroken"
	icon_off = "xenobotsecureoff"

	fill()
		..()
		switch(rand(1,2))
			if(1)
				new /obj/item/clothing/suit/apron(src)
			if(2)
				new /obj/item/clothing/suit/apron/overalls/blue(src)
		new /obj/item/clothing/under/rank/scientist/botany(src)
		new /obj/item/storage/bag/plants(src)
		new /obj/item/clothing/under/rank/scientist(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
		new /obj/item/device/radio/headset/headset_sci(src)
		new /obj/item/clothing/head/greenbandana(src)
		new /obj/item/material/minihoe(src)
		new /obj/item/material/hatchet(src)
		new /obj/item/wirecutters/clippers(src)
		new /obj/item/reagent_containers/spray/plantbgone(src)
		new /obj/item/clothing/mask/gas/alt(src)
		new /obj/item/watertank(src)
		new /obj/item/storage/belt/hydro(src)
