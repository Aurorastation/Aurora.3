/datum/psi_complexus/proc/update(var/force)
	set waitfor = FALSE

	if(force || last_psionic_rank != psionic_rank)
		if(psionic_rank <= 1)
			if(psionic_rank == 0)
				qdel(src)
			return
		else
			sound_to(owner, 'sound/effects/psi/power_unlock.ogg')
			cost_modifier = 1
			if(psionic_rank > 1)
				cost_modifier -= min(1, max(0.1, (psionic_rank-1) / 10))
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
					aura_color = "#cc3333"
				else if(psionic_rank == PSI_RANK_HARMONIOUS)
					aura_color = "#3333cc"

	if(!announced && owner && owner.client && !QDELETED(src))
		announced = TRUE
		to_chat(owner, "<hr>")
		to_chat(owner, SPAN_NOTICE("<font size = 3>You are <b>psionic</b>, touched by powers beyond understanding.</font>"))
		to_chat(owner, SPAN_NOTICE("<b>Shift-left-click your Psi icon</b> on the bottom right to <b>view a summary of how to use them</b>, or <b>left click</b> it to <b>suppress or unsuppress</b> your psionics. Beware: overusing your gifts can have <b>deadly consequences</b>."))
		to_chat(owner, "<hr>")

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
			update_hud = TRUE
		return

	else if(stamina < max_stamina)
		if(owner?.stat == CONSCIOUS)
			stamina = min(max_stamina, stamina + rand(1,3))
		else if(owner?.stat == UNCONSCIOUS)
			stamina = min(max_stamina, stamina + rand(3,5))

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
