/*
Exercise Verbs
*/

/mob/living/carbon/human/verb/pushup()
	set name = "Do Pushup"
	set desc = "Makes you do a pushup."
	set category = "IC"

	do_pushups()

/mob/living/carbon/human/proc/do_pushups()
	if(!can_do_pushup())
		return

	set_face_dir(WEST)
	visible_message(SPAN_NOTICE("[src] gets down and prepares to do some pushups."), SPAN_NOTICE("You get down for some pushups."), SPAN_NOTICE("You hear rustling."))

	switch(alert(src, "Regular pushups or on your knees?", "Pushups", "Regular", "On Knees"))
		if("Regular")
			visible_message(SPAN_NOTICE("[src] shifts [get_pronoun("his")] weight onto [get_pronoun("his")] hands and feet."), SPAN_NOTICE("You move your weight onto your hands and feet."), SPAN_NOTICE("You hear rustling."))
			execute_pushups(on_knees = FALSE)
		if("On Knees")
			visible_message(SPAN_NOTICE("[src] shifts [get_pronoun("his")] weight onto [get_pronoun("his")] knees."), SPAN_NOTICE("You move your weight onto your knees."), SPAN_NOTICE("You hear rustling."))
			execute_pushups(on_knees = TRUE)

/mob/living/carbon/human/proc/stop_pushups()
	set_face_dir(null)

/mob/living/carbon/human/proc/execute_pushups(var/on_knees = FALSE)
	if(!can_do_pushup())
		return
	var/target_y = -5
	var/pushups_in_a_row
	var/matrix/matrix = matrix()
	matrix.Turn(270)
	transform = matrix

	while(species.has_stamina_for_pushup(src))
		if(!can_do_pushup())
			stop_pushups()
			return
		animate(src, pixel_y = target_y, time = 0.8 SECONDS, easing = QUAD_EASING) //down to the floor
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, display_progress = FALSE))
			visible_message(SPAN_NOTICE("[src] stops doing pushups."), SPAN_NOTICE("You stop doing pushups."), SPAN_NOTICE("You hear movements."))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		animate(src, pixel_y = 0, time = 0.8 SECONDS, easing = QUAD_EASING) //back up
		if(!lying || !do_after(src, 0.6 SECONDS, needhand = TRUE, display_progress = FALSE))
			visible_message(SPAN_NOTICE("[src] stops doing pushups."), SPAN_NOTICE("You stop doing pushups."), SPAN_NOTICE("You hear movements."))
			animate(src, pixel_y = 0, time = 0.2 SECONDS, easing = QUAD_EASING)
			stop_pushups()
			return
		pushups_in_a_row++
		visible_message(SPAN_NOTICE("[src] does a pushup - [pushups_in_a_row] done so far!"), SPAN_NOTICE("You do a pushup - [pushups_in_a_row] done so far!"), SPAN_NOTICE("You hear rustling."))
		species.drain_stamina(src, calculate_stamina_loss_per_pushup(on_knees))
	to_chat(src, SPAN_WARNING("You slump down to the floor, too tired to keep going."))
	stop_pushups()

/mob/living/carbon/human/proc/can_do_pushup()
	if(incapacitated(INCAPACITATION_RESTRAINED|INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT))
		return FALSE

	if(!resting)
		to_chat(src, SPAN_WARNING("You need to lie on the floor to do a pushup."))
		return FALSE

	if(buckled_to)
		to_chat(src, SPAN_WARNING("You need to lie on the floor to do a pushup."))
		return FALSE

	var/list/extremities = list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	for(var/zone in extremities)
		if(!get_organ(zone, TRUE))
			to_chat(src, SPAN_WARNING("You can't do pushups with missing limbs."))
			return FALSE

	if(!species.has_stamina_for_pushup(src))
		to_chat(src, SPAN_WARNING("You feel far too weak to do a pushup!"))
		return FALSE

	if(!isturf(loc))
		to_chat(src, SPAN_WARNING("You cannot do that here!"))
		return FALSE

	return TRUE

/mob/living/carbon/human/proc/calculate_stamina_loss_per_pushup(var/on_knees = FALSE)
	var/stamina_loss = 6 + (4 * sprint_cost_factor)
	if(wear_suit)
		stamina_loss += 2
	if(back)
		stamina_loss += 2
	if(get_shock() > 10)
		stamina_loss += 3
	var/nut_factor = max_nutrition ? Clamp(nutrition / max_nutrition, 0, 1) : 1
	if(nut_factor <= CREW_NUTRITION_HUNGRY)
		stamina_loss += 2
	if(on_knees)
		stamina_loss -= 2
	if(health <= ((maxHealth / 10) * 9))
		stamina_loss += 2
	return max(stamina_loss, 1)
