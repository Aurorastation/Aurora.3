/mob/living/silicon/ai/death(gibbed)

	if(stat == DEAD)
		return

	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))

	remove_ai_verbs(src)

	for(var/obj/machinery/ai_status_display/O in SSmachinery.all_status_displays)
		spawn( 0 )
		O.mode = 2
		if (istype(loc, /obj/item/weapon/aicard))
			var/obj/item/weapon/aicard/card = loc
			card.update_icon()

	. = ..(gibbed,"gives one shrill beep before falling lifeless.")
	density = 1
