/obj/item/phylactery
	name = "phylactery"
	desc = "A twisted mummified heart."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cursedheart-off"
	origin_tech = list(TECH_BLUESPACE = 8, TECH_MATERIAL = 8, TECH_BIO = 8)
	w_class = ITEMSIZE_HUGE
	light_color = "#6633CC"
	light_power = 3
	light_range = 4
	reagents_to_add = list(/singleton/reagent/toxin/undead = 120)

	var/lich = null

/obj/item/phylactery/Initialize()
	. = ..()
	GLOB.world_phylactery += src

/obj/item/phylactery/Destroy()
	to_chat(lich, "<span class='danger'>Your phylactery was destroyed, your soul is cast into the abyss as your immortality vanishes away!</span>")
	GLOB.world_phylactery -= src
	lich = null
	return ..()

/obj/item/phylactery/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(!lich)
		. += "The heart is inert."
	else
		. += "The heart is pulsing slowly."

/obj/item/phylactery/attackby(obj/item/attacking_item, mob/user)
	..()
	if(istype(attacking_item, /obj/item/nullrod))
		src.visible_message("\The [src] twists violently and explodes!")
		gibs(src.loc)
		qdel(src)
		return

/obj/item/phylactery/pickup(mob/living/user as mob)
	..()
	to_chat(user, "<span class='warning'>As you pick up \the [src], you feel a wave of dread wash over you.</span>")
	for(var/obj/machinery/light/P in view(7, user))
		P.flicker(1)
