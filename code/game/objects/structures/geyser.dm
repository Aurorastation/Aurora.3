/obj/structure/geyser
	name = "arctic geyser"
	desc = "A mound fuming with hot steam."
	icon = 'icons/obj/geyser.dmi'
	icon_state = "geyser_dormant"
	density = FALSE
	pixel_x = -32

/obj/structure/geyser/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "geyser_plume"

/obj/structure/geyser/Crossed(AM as mob|obj, var/ignore_deployment = FALSE)
	if(ishuman(AM))
		var/mob/living/carbon/human/L = AM
		if(prob(50))
			trigger(L)

	..()

/obj/structure/geyser/proc/trigger(mob/living/carbon/human/L)
	visible_message(SPAN_WARNING("\The [src] spews a cloud of hot steam!"))
	flick("geyser_fire", src)
	var/steam_temperature = pick(10,50,100,500)
	L.bodytemperature += steam_temperature
	if(steam_temperature >= 100)
		L.apply_damage(50, DAMAGE_BURN)
		to_chat(L, SPAN_WARNING("Your skin fizzes as the steam touches it!"))