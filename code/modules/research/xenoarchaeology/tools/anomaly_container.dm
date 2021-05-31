/obj/structure/anomaly_container
	name = "anomaly container"
	desc = "Used to safely contain and move anomalies."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anomaly_container"
	density = TRUE

	var/obj/structure/artifact/contained

/obj/structure/anomaly_container/Initialize()
	. = ..()

	var/obj/structure/artifact/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/anomaly_container/attack_hand(var/mob/user)
	release()

/obj/structure/anomaly_container/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/anomaly_container/proc/contain(var/obj/structure/artifact/artifact)
	if(contained)
		return
	contained = artifact
	artifact.forceMove(src)
	underlays += image(artifact)
	desc = "Used to safely contain and move anomalies. \The [contained] is kept inside."

/obj/structure/anomaly_container/proc/release()
	if(!contained)
		return
	contained.dropInto(src)
	contained = null
	underlays.Cut()
	desc = initial(desc)

/obj/structure/artifact/MouseDrop(atom/over)
	if(istype(over, /obj/structure/anomaly_container))
		var/obj/structure/anomaly_container/box = over
		box.contain(src)
		return TRUE
	. = ..()