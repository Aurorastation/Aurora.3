/datum/rune/blood_drain
	name = "blood draining rune"
	desc = "This rune is used to drain the blood of non-believers into a fellow acolyte. All must be standing on the rune."
	rune_flags = NO_TALISMAN
	var/list/mob/living/carbon/human/lambs
	var/mob/living/carbon/human/target

/datum/rune/blood_drain/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	LAZYCLEARLIST(lambs)
	target = null
	return ..()

/datum/rune/blood_drain/do_rune_action(mob/living/user, atom/movable/A)
	LAZYINITLIST(lambs)
	for(var/mob/living/carbon/human/H in get_turf(A))
		if(iscultist(H))
			if(!target)
				target = H
			continue
		if(H.stat == DEAD)
			continue
		if(H.species.flags & NO_BLOOD)
			continue
		LAZYADD(lambs, H)
	if(length(lambs))
		START_PROCESSING(SSprocessing, src)
	else
		fizzle(user, A)
	return TRUE

/datum/rune/blood_drain/process()
	if(target && length(lambs) && (get_turf(target) == get_turf(parent)))
		for(var/mob/living/carbon/human/H in lambs)
			if(get_turf(H) == get_turf(parent))
				if(REAGENT_VOLUME(target.vessel, /singleton/reagent/blood) + 10 > H.species.blood_volume)
					to_chat(target, SPAN_CULT("You feel refreshed!"))
					interrupt()
				target.whisper("Sa'ii, ble-nii...")
				H.vessel.trans_to_mob(target, 10, CHEM_BLOOD)
				H.take_overall_damage(10, 10)
				playsound(target, 'sound/magic/enter_blood.ogg', 50, 1)
			else
				interrupt()
	else
		interrupt()

/datum/rune/blood_drain/proc/interrupt()
	parent.visible_message(SPAN_CULT("\The [parent] suddenly disappears, the incantation broken!"))
	qdel(parent)
