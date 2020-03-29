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



//Adrenaline, granted by synaptizine and norepinephrine, with different strengths for each
//Allows the body to endure more, increasing speed a little, stamina a lot, stamina regen a lot,
//and reducing sprint costs
//Synaptizine applies it at strength 1, norepinephrine applies it at strength 0.6
//Is applied using strengthen override mode, so synaptizine will replace norepinephrine if both are present
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

//Doubleburn napalm modifier. Applied by Zo'rane Fire
//Increases damage dealt by burn sources
/datum/modifier/napalm
	var/added_burn_mod
	var/delta

/datum/modifier/napalm/activate()
	..()
	delta = strength
	if (isliving(target))
		var/mob/living/L = target
		added_burn_mod = L.burn_mod * delta - L.burn_mod
		L.burn_mod += added_burn_mod

/datum/modifier/napalm/deactivate()
	..()
	if (isliving(target))
		var/mob/living/L = target
		L.burn_mod -= added_burn_mod

/datum/modifier/napalm/custom_validity()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(L.fire_stacks)
			return 1
	return 0

//Berserk Modifier
//Causes a hulk like effect

/datum/modifier/berserk
	var/last_shock_stage = 0

/datum/modifier/berserk/activate()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		to_chat(H, "<span class='danger'>An uncontrollable rage overtakes your thoughts!</span>")
		H.add_client_color(/datum/client_color/berserk)

		last_shock_stage = H.shock_stage
		H.shock_stage = 0

		H.SetParalysis(0)
		H.SetStunned(0)
		H.SetWeakened(0)
		H.setHalLoss(0)
		H.lying = 0
		H.update_canmove()

/datum/modifier/berserk/process()
	if(..())
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.drowsyness = max(H.drowsyness - 5, 0)
			H.AdjustParalysis(-1)
			H.AdjustStunned(-1)
			H.AdjustWeakened(-1)
			H.adjustHalLoss(-1)

/datum/modifier/berserk/deactivate()
	..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		to_chat(H, "<span class='danger'>Your rage fades away, your thoughts are clear once more!</span>")
		H.remove_client_color(/datum/client_color/berserk)

		H.shock_stage = last_shock_stage