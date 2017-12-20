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