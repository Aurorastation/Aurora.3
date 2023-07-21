/datum/psi_complexus/proc/update(var/force)
	set waitfor = FALSE

	if(force || last_psionic_rank != psionic_rank)
		if(psionic_rank == 0)
			qdel(src)
			return
		else
			sound_to(owner, 'sound/effects/psi/power_unlock.ogg')
			cost_modifier = 1
			if(psionic_rank > 1)
				cost_modifier -= min(1, max(0.1, psionic_rank / 10))
			if(!ui)
				ui = new(owner)
				if(owner.client)
					owner.client.screen += ui
			else
				if(owner.client)
					owner.client.screen |= ui
			if(!suppressed && owner.client)
				for(var/thing in SSpsi.all_aura_images)
					owner.client.images |= thing

			var/image/aura_image = get_aura_image()
			if(psionic_rank >= PSI_RANK_APEX) // spooky boosters
				aura_color = "#aaffaa"
				aura_image.blend_mode = BLEND_SUBTRACT
			else
				aura_image.blend_mode = BLEND_ADD
				if(psionic_rank == PSI_RANK_SENSITIVE)
					aura_color = "#cccc33"
				else if(psionic_rank == PSI_RANK_HARMONIOUS)
					aura_color = "#cc3333"

	if(psionic_rank > PSI_RANK_SENSITIVE && last_psionic_rank < PSI_RANK_HARMONIOUS)
		switch(psionic_rank)
			if(PSI_RANK_HARMONIOUS)
				psi_points = PSI_POINTS_HARMONIOUS
			if(PSI_RANK_APEX)
				psi_points = PSI_POINTS_APEX
			if(PSI_RANK_LIMITLESS)
				psi_points = PSI_POINTS_LIMITLESS
		wipe_user_abilities()

	if(last_psionic_rank > PSI_RANK_SENSITIVE && psionic_rank < PSI_RANK_HARMONIOUS)
		psi_points = 0
		wipe_user_abilities()

	if(!announced && owner && owner.client && !QDELETED(src))
		announced = TRUE
		to_chat(owner, "<hr>")
		to_chat(owner, SPAN_NOTICE("<font size = 3>You are <b>psionic</b>, touched by powers beyond understanding.</font>"))
		to_chat(owner, SPAN_NOTICE("<b>Left click</b> your psi icon to <b>suppress or unsuppress</b> your psionics. <b>Shift click</b> it to open your Psionic Point Shop. Beware: overusing your gifts can have <b>deadly consequences</b>."))
		to_chat(owner, "<hr>")

	if(get_rank() >= PSI_RANK_SENSITIVE)
		for(var/singleton/psionic_power/P in GET_SINGLETON_SUBTYPE_LIST(/singleton/psionic_power))
			if((P.ability_flags & PSI_FLAG_FOUNDATIONAL) || (P.ability_flags & PSI_FLAG_APEX && get_rank() >= PSI_RANK_APEX) || (P.ability_flags & PSI_FLAG_LIMITLESS && get_rank() >= PSI_RANK_LIMITLESS))
				if(!(P.type in psionic_powers))
					P.apply(owner)

/datum/psi_complexus/proc/wipe_user_abilities()
	for(var/obj/screen/ability/obj_based/psionic/P in owner.ability_master.ability_objects)
		if((P.connected_power.ability_flags & PSI_FLAG_APEX) && get_rank() < PSI_RANK_APEX)
			owner.ability_master.remove_ability(P)
		if((P.connected_power.ability_flags & PSI_FLAG_LIMITLESS) && get_rank() < PSI_RANK_LIMITLESS)
			owner.ability_master.remove_ability(P)

/datum/psi_complexus/process()

	var/update_hud

	if(stun)
		stun--
		if(stun)
			if(!suppressed)
				suppressed = TRUE
				update_hud = TRUE
		else
			to_chat(owner, SPAN_NOTICE("You have recovered your mental composure."))
			suppressed = FALSE
			update_hud = TRUE
		return

	else if(stamina < max_stamina)
		if(owner?.stat == CONSCIOUS)
			stamina = min(max_stamina, stamina + rand(1,3))
		else if(owner?.stat == UNCONSCIOUS)
			stamina = min(max_stamina, stamina + rand(3,5))

	if(armor_component)
		spend_power(1)

	var/next_aura_size = max(0.1,((stamina/max_stamina)*min(3,psionic_rank))/5)
	var/next_aura_alpha = round(((suppressed ? max(0,psionic_rank - 2) : psionic_rank)/5)*255)

	if(next_aura_alpha != last_aura_alpha || next_aura_size != last_aura_size || aura_color != last_aura_color)
		last_aura_size =  next_aura_size
		last_aura_alpha = next_aura_alpha
		last_aura_color = aura_color
		var/matrix/M = matrix()
		if(next_aura_size != 1)
			M.Scale(next_aura_size)
		animate(get_aura_image(), alpha = next_aura_alpha, transform = M, color = aura_color, time = 3)

	if(update_hud)
		ui.update_icon()
