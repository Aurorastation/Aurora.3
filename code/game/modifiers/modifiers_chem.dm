//Stimulant modifier. Applied in varying strengths by hyperzine and caffienated drinks
//Increases sprinting speed, walk speed, and stamina regen
/datum/modifier/stimulant
	var/sprint_speed_added = 0
	var/regen_added = 0
	var/delay_added = 0

/datum/modifier/stimulant/activate()
	..()
	if (isliving(target))
		var/mob/living/L = target

		sprint_speed_added = 0.2 * strength
		L.sprint_speed_factor += sprint_speed_added

		regen_added = L.stamina_recovery * 0.3 * strength
		L.stamina_recovery += regen_added

		delay_added = -1.5 * strength
		L.move_delay_mod += delay_added



/datum/modifier/stimulant/deactivate()
	..()
	if (isliving(target))
		var/mob/living/L = target
		L.sprint_speed_factor -= sprint_speed_added
		L.stamina_recovery -= regen_added
		L.move_delay_mod -= delay_added



//Adrenaline, granted by synaptizine and inaprovaline, with different strengths for each
//Allows the body to endure more, increasing speed a little, stamina a lot, stamina regen a lot,
//and reducing sprint costs
//Synaptizine applies it at strength 1, inaprovaline applies it at strength 0.6
//Is applied using strengthen override mode, so synaptizine will replace inaprovaline if both are present
/datum/modifier/adrenaline
	var/speed_added = 0
	var/stamina_added = 0
	var/cost_added = 0
	var/regen_added = 0

/datum/modifier/adrenaline/activate()
	..()
	if (isliving(target))
		var/mob/living/L = target
		speed_added += 0.1*strength
		L.sprint_speed_factor += speed_added

		stamina_added = L.max_stamina * strength
		L.max_stamina += stamina_added

		cost_added = -0.35 * strength
		L.sprint_cost_factor += cost_added

		regen_added = max ((L.stamina_recovery * 0.7 * strength), 5)
		L.stamina_recovery += regen_added

/datum/modifier/adrenaline/deactivate()
	..()
	if (isliving(target))
		var/mob/living/L = target

		L.stamina_recovery -= regen_added
		L.max_stamina -= stamina_added
		L.sprint_cost_factor -= cost_added
		L.sprint_speed_factor -= speed_added

/datum/modifier/luminous
	var/lightrange = 0

/datum/modifier/luminous/activate()
	..()
	if (isliving(target))
		var/mob/living/L = target
		lightrange = strength
		L.set_light(lightrange, 1, LIGHT_COLOR_FIRE)

/datum/modifier/luminous/deactivate()
	..()
	if (isliving(target))
		var/mob/living/L = target
		L.set_light(0)


//Mental fortitude, applied in various strengths by mindchems to resist brain traumas.
/datum/modifier/brainchem/activate()
	..()
	var/brain_trauma_type
	var/brain_trauma_type2
	if(strength <= 1)
		brain_trauma_type = BRAIN_TRAUMA_MILD
		brain_trauma_type2 = BRAIN_TRAUMA_MILD
	else if(strength > 1)
		brain_trauma_type = BRAIN_TRAUMA_SEVERE
		brain_trauma_type2 = BRAIN_TRAUMA_MILD

	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/brain/B = H.organs_by_name["brain"]
		if(B)
			for(var/x in B.traumas)
				var/datum/brain_trauma/BT = x
				if((istype(BT, brain_trauma_type) || istype(BT, brain_trauma_type2) || istype(BT, BRAIN_TRAUMA_SPECIAL)) && !BT.permanent) //special traumas are always suppressed
					BT.on_lose(1)
					BT.suppressed = 1


/datum/modifier/brainchem/deactivate()
	..()
	var/brain_trauma_type
	var/brain_trauma_type2
	if(strength <= 1)
		brain_trauma_type = BRAIN_TRAUMA_MILD
		brain_trauma_type2 = BRAIN_TRAUMA_MILD
	else if(strength > 1)
		brain_trauma_type = BRAIN_TRAUMA_SEVERE
		brain_trauma_type2 = BRAIN_TRAUMA_MILD

	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/brain/B = H.organs_by_name["brain"]
		if(B)
			for(var/x in B.traumas)
				var/datum/brain_trauma/BT = x
				if((istype(BT, brain_trauma_type) || istype(BT, brain_trauma_type2) || istype(BT, BRAIN_TRAUMA_SPECIAL)) && BT.suppressed)
					BT.on_gain()
					BT.suppressed = 0