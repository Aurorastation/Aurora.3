/datum/rune/cult_mech
	name = "cult mech rune"
	desc = "This rune is used to convert a mech into a cult mech."
	max_number_allowed = 1

	///How many times it was used
	var/times_used = 0

/datum/rune/cult_mech/do_rune_action(mob/living/user, atom/movable/A)
	if(times_used >= 1)
		to_chat(user, SPAN_WARNING("You have already used this rune to its full potential!"))
		return

	var/mob/living/heavy_vehicle/mech_on_us = locate() in get_turf(A)

	if(!mech_on_us)
		to_chat(user, SPAN_WARNING("\The [A] fizzles, dark mechanical energy tentacles try to find a mech to convert on the rune, but in vain..."))
		return

	if(istype(mech_on_us, /mob/living/heavy_vehicle/premade/cult))
		to_chat(user, SPAN_WARNING("The rune fizzles... This offering is already ours, why are you offering to the Geometer of Blood what is already his?"))
		return

	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("Your form is too simple to convert a mech into a cult mech!"))
		return

	var/mob/living/carbon/human/human_user = user

	to_chat(human_user, SPAN_NOTICE("You start to orchestrate the dark mechanical energy tentacles in a quasi-symphony, to convert \the [mech_on_us] into a cult mech!"))
	to_chat(human_user, SPAN_INFO("This action will take approximately 2 minutes to perform."))



	if(!do_after(human_user, 2 MINUTES, mech_on_us, extra_checks = CALLBACK(src, PROC_REF(check_conversion_possible), mech_on_us, A, human_user)))
		to_chat(human_user, SPAN_WARNING("The rune fizzles... You have failed to convert the mech into a cult mech!"))
		return


	//Conversion successful, give a message, delete the old mech, put down a cult mech, increment the rune's use count
	to_chat(human_user, SPAN_NOTICE("You have converted \the [mech_on_us] into a cult mech! The Geometer of Blood is pleased with your offering!"))

	qdel(mech_on_us)

	//20% chance of a super cult mech
	var/cult_mech_type = prob(80) ? /mob/living/heavy_vehicle/premade/cult : /mob/living/heavy_vehicle/premade/cult/super

	new cult_mech_type(get_turf(A))

	times_used++

/datum/rune/cult_mech/proc/check_conversion_possible(mob/living/heavy_vehicle/mech_on_us, atom/movable/A, mob/living/carbon/human/user)
	//In case someone steals or moves it while it's being converted
	if(get_turf(mech_on_us) != get_turf(A))
		to_chat(user, SPAN_WARNING("The rune fizzles... You have failed to convert the mech into a cult mech! The mech was moved!"))
		return FALSE

	if(length(mech_on_us.pilots))
		to_chat(user, SPAN_WARNING("The rune fizzles... The mech isn't pure, a living being is inside it. The offerings must be separated..."))
		return FALSE

	return TRUE
