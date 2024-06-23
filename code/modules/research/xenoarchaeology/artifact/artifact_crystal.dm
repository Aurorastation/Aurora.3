
/obj/structure/crystal
	name = "large crystal"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "crystal"
	density = 1

/obj/structure/crystal/New()
	..()
	icon_state = "crystal[rand(1, 3)]"

	desc = pick(\
	"It shines faintly as it catches the light.",\
	"It appears to have a faint inner glow.",\
	"It seems to draw you inward as you look it at.",\
	"Something twinkles faintly as you look at it.",\
	"It's mesmerizing to behold.")

/obj/structure/crystal/Destroy()
	src.visible_message(SPAN_DANGER("[src] shatters!"))
	if(prob(75))
		new /obj/item/material/shard/phoron(src.loc)
	if(prob(50))
		new /obj/item/material/shard/phoron(src.loc)
	if(prob(25))
		new /obj/item/material/shard/phoron(src.loc)
	if(prob(75))
		new /obj/item/material/shard(src.loc)
	if(prob(50))
		new /obj/item/material/shard(src.loc)
	if(prob(25))
		new /obj/item/material/shard(src.loc)
	return ..()

//todo: laser_act
