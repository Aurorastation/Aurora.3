//A harvest item for serviceborgs.
/obj/item/robot_harvester
	name = "auto harvester"
	desc = "A hand-held harvest tool that resembles a sickle. It uses energy to cut plant matter very efficently."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "autoharvester"

/obj/item/robot_harvester/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target || !proximity)
		return
	if(istype(target, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		if(T.harvest) //Try to harvest, assuming it's alive.
			T.harvest(user)
		else if(T.dead) //It's probably dead otherwise.
			T.remove_dead(user)
	else
		to_chat(user, SPAN_WARNING("ERROR: Harvesting \a [target] is not the purpose of this tool. \The [src] is for plants being grown."))
