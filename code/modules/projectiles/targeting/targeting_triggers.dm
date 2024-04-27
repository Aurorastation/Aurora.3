//as core click code exists at the mob level
/mob/proc/trigger_aiming(trigger_type)
	return

/mob/living/trigger_aiming(trigger_type)
	for(var/obj/aiming_overlay/AO as anything in aimed_at_by)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/mob/living/proc/aim_at(atom/target, obj/item/with)

	if(!ismob(target) || !istype(with) || incapacitated())
		return FALSE

	if(!aiming)
		aiming = new(src)

	face_atom(target)
	aiming.aim_at(target, with)
	return TRUE

/obj/aiming_overlay/proc/trigger(var/perm)
	var/obj/item/gun/G = aiming_with
	if(istype(G) && G.safety())
		if(owner.a_intent == I_HURT)
			G.toggle_safety()
		else
			G.handle_click_empty(owner)
			to_chat(owner, SPAN_WARNING("Your [G]'s safety prevents firing."))
	if(!owner || !aiming_with || !aiming_at || !locked)
		return FALSE
	if(perm && (target_permissions & perm))
		return FALSE
	if(!owner.canClick())
		return FALSE

	owner.setClickCooldown(DEFAULT_QUICK_COOLDOWN) // Spam prevention, essentially.
	owner.visible_message(
		SPAN_DANGER("\The [owner] pulls the trigger reflexively!"),
		SPAN_DANGER("You pull the trigger reflexively!")
	)

	G.Fire(aiming_at, owner)

	cancel_aiming()
	aim_cooldown(3)
	toggle_active(FALSE)
	if(owner.client)
		owner.client.remove_gun_icons()
