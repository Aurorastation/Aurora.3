/obj/structure/cult/tome
	name = "arcanaeum desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	icon_state = "tomealtar"

/obj/structure/cult/tome/examine(mob/user)
	..(user)
	if(!iscultist(user))
		desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Looking at the text makes your skin crawl."
	else
		desc = "A desk covered with the scriptures of Nar-Sie, The One Who Sees, The Geometer of Blood. Most of them are beyond your current comprehension."