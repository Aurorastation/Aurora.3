/obj/item/organ/internal/augment/gustatorial
	name = "gustatorial centre"
	action_button_name = "Activate Gustatorial Centre (tongue)"
	action_button_icon = "augment"
	organ_tag = BP_AUG_GUSTATORIAL
	parent_organ = BP_HEAD
	activable = TRUE
	cooldown = 8

	var/taste_sensitivity = TASTE_NORMAL
	var/action_verb = "samples"
	var/self_action_verb = "sample"

/obj/item/organ/internal/augment/gustatorial/attack_self(var/mob/user)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/reagent_containers/food/F = user.get_active_hand()
	if(istype(F))
		if(!F.is_open_container())
			to_chat(user, SPAN_WARNING("\The [F] is closed!"))
			return
		user.visible_message("<b>[user]</b> [action_verb] \the [F].", SPAN_NOTICE("You [self_action_verb] \the [F]."))
		to_chat(user, SPAN_NOTICE("\The [src] reports that \the [F] tastes like: [F.reagents.generate_taste_message(user, taste_sensitivity)]"))
	else
		var/list/tastes = list("Hypersensitive" = TASTE_HYPERSENSITIVE, "Sensitive" = TASTE_SENSITIVE, "Normal" = TASTE_NORMAL, "Dull" = TASTE_DULL, "Numb" = TASTE_NUMB)
		var/taste_choice = input(user, "How well do you want to taste?", "Taste Sensitivity", "Normal") as null|anything in tastes
		if(taste_choice)
			to_chat(user, SPAN_NOTICE("\The [src] will now output taste as if you were <b>[taste_choice]</b>."))
			taste_sensitivity = tastes[taste_choice]

/obj/item/organ/internal/augment/gustatorial/hand
	parent_organ = BP_R_HAND
	action_button_name = "Activate Gustatorial Centre (hand)"

	action_verb = "sticks their finger in"
	self_action_verb = "stick your finger in"

/obj/item/organ/internal/augment/gustatorial/hand/left
	parent_organ = BP_L_HAND
