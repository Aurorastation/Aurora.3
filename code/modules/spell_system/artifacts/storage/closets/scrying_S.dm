/obj/structure/closet/wizard/scrying
	name = "scrying orb"
	desc = "An incandescent orb of crackling energy, using it will allow you to ghost while alive, allowing you to spy upon the station with ease. In addition, buying it will permanently grant you x-ray vision."

/obj/structure/closet/wizard/scrying/fill()
	..()
	new /obj/item/scrying(src)
	new /obj/item/contract/wizard/xray(src)