/obj/structure/anomaly_container
	name = "anomaly container"
	desc = "Used to safely contain and move anomalies."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anomaly_container"
	density = TRUE

	var/obj/structure/machinery/artifact/contained

/obj/structure/anomaly_container/Initialize()
	. = ..()

	var/obj/structure/machinery/artifact/A = locate() in loc
	if(A)
		contain(A)

/obj/structure/anomaly_container/attack_hand(var/mob/user)
	//Incapacitation guard
	if(use_check_and_message(user))
		return

	release()

/obj/structure/anomaly_container/attack_robot(var/mob/user)
	if(Adjacent(user))
		release()

/obj/structure/anomaly_container/proc/contain(var/obj/structure/machinery/artifact/artifact)
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

/obj/structure/machinery/artifact/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(istype(over, /obj/structure/anomaly_container))
		var/obj/structure/anomaly_container/box = over
		box.contain(src)
		return TRUE
	if(istype(over, /obj/structure/machinery/r_n_d/destructive_analyzer))
		if(!user || !Adjacent(user) || !over.Adjacent(user))
			return FALSE
		var/obj/structure/machinery/r_n_d/destructive_analyzer/DA = over
		return DA.load_object(src, user)
	. = ..()

/obj/structure/anomaly_container/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(istype(over, /obj/structure/machinery/r_n_d/destructive_analyzer))
		if(!user || !Adjacent(user) || !over.Adjacent(user))
			return FALSE
		if(!contained)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return FALSE
		var/obj/structure/machinery/r_n_d/destructive_analyzer/DA = over
		var/obj/structure/machinery/artifact/A = contained
		if(DA.load_object(A, user))
			contained = null
			underlays.Cut()
			desc = initial(desc)
			return TRUE
		return FALSE
	. = ..()
