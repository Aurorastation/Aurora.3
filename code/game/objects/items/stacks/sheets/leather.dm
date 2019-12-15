/obj/item/stack/material/animalhide
	name = "hide"
	desc = "The by-product of some animal farming."
	singular_name = "hide piece"
	icon_state = "sheet-hide"
	default_type = "hide"
	icon_has_variants = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'

/obj/item/stack/material/animalhide/human
	name = "human skin"
	desc = "The by-product of human farming."
	singular_name = "human skin piece"
	default_type = "human hide"

/obj/item/stack/material/animalhide/corgi
	name = "corgi hide"
	desc = "The by-product of corgi farming."
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	default_type = "corgi hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farming."
	icon_state = "sheet-cat"
	singular_name = "cat hide piece"
	default_type = "cat hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of monkey farming."
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	default_type = "monkey hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	default_type = "lizard hide"
	icon_has_variants = FALSE

/obj/item/stack/material/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	singular_name = "alien hide piece"
	icon_state = "sheet-xeno"
	default_type = "alien hide"
	icon_has_variants = FALSE

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/material/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/material/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tanning."
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"

/obj/item/stack/material/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	singular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to high temperautres
	var/drying_threshold_temperature = 500 //Kelvin to start drying
	icon_has_variants = TRUE

//Step one - dehairing.
/obj/item/stack/material/animalhide/attackby(obj/item/W as obj, mob/user as mob)
	if(	istype(W, /obj/item/material/knife) || \
		istype(W, /obj/item/material/kitchen/utensil/knife) || \
		istype(W, /obj/item/material/twohanded/fireaxe) || \
		istype(W, /obj/item/material/hatchet) )

		//visible message on mobs is defined as visible_message(var/message, var/self_message, var/blind_message)
		usr.visible_message("<span class='notice'>\The [usr] starts cutting hair off \the [src]</span>", "<span class='notice'>You start cutting the hair off \the [src]</span>", "You hear the sound of a knife rubbing against flesh")
		if(do_after(user,50))
			to_chat(usr, "<span class='notice'>You cut the hair from this [src.singular_name]</span>")
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/material/hairlesshide/HS in usr.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/material/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		..()


//Step two - washing..... it's actually in washing machine code.

//Step three - drying
/obj/item/stack/material/wetleather/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= drying_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locating an exisitng stack on the tile and add to there if possible
			for(var/obj/item/stack/material/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it gets to here it means it did not find a suitable stack on the tile.
			var/obj/item/stack/material/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)
