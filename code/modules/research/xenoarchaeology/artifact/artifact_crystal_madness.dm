
/obj/structure/crystal_madness
	name = "large crystal"
	desc = "\
		A large crystal, seemingly floating in the air, and giving off a light blue glow.\
		"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "crystal_madness"
	density = 1
	light_color = "#99eef3"
	light_range = 5

// /obj/structure/crystal_madness/laser_act()

// /obj/structure/crystal/New()
// 	..()
// 	icon_state = "crystal[rand(1, 3)]"

// 	desc = pick(
// 	"It shines faintly as it catches the light.",
// 	"It appears to have a faint inner glow.",
// 	"It seems to draw you inward as you look it at.",
// 	"Something twinkles faintly as you look at it.",
// 	"It's mesmerizing to behold.")

// /obj/structure/crystal/Destroy()
// 	src.visible_message("<span class='danger'>[src] shatters!</span>")
// 	if(prob(75))
// 		new /obj/item/material/shard/phoron(src.loc)
// 	if(prob(50))
// 		new /obj/item/material/shard/phoron(src.loc)
// 	if(prob(25))
// 		new /obj/item/material/shard/phoron(src.loc)
// 	if(prob(75))
// 		new /obj/item/material/shard(src.loc)
// 	if(prob(50))
// 		new /obj/item/material/shard(src.loc)
// 	if(prob(25))
// 		new /obj/item/material/shard(src.loc)
// 	return ..()

//todo: laser_act
