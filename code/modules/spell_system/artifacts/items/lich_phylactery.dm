/obj/item/phylactery
	name = "phylactery"
	desc = "A twisted mummified heart."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "cursedheart-off"
	origin_tech = list(TECH_BLUESPACE = 8, TECH_MATERIAL = 8, TECH_BIO = 8)
	w_class = 5
	light_color = "#6633CC"
	light_power = 3
	light_range = 4

	var/lich = null

/obj/item/phylactery/Initialize()
	. = ..()
	world_phylactery += src
	create_reagents(120)
	reagents.add_reagent("undead_ichor", 120)

/obj/item/phylactery/Destroy()
	to_chat(lich, "<span class='danger'>Your phylactery was destroyed, your soul is cast into the abyss as your immortality vanishes away!</span>")
	world_phylactery -= src
	lich = null
	return ..()

/obj/item/phylactery/examine(mob/user)
	..(user)
	if(!lich)
		to_chat(user, "The heart is inert.")
	else
		to_chat(user, "The heart is pulsing slowly.")

/obj/item/phylactery/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/nullrod))
		src.visible_message("\The [src] twists violently and explodes!")
		gibs(src.loc)
		qdel(src)
		return

/obj/item/phylactery/pickup(mob/living/user as mob)
	..()
	if(!user.is_wizard() && src.lich)
		to_chat(user, "<span class='warning'>As you pick up \the [src], you feel a wave of dread wash over you.</span>")
		for(var/obj/machinery/light/P in view(7, user))
			P.flicker(1)