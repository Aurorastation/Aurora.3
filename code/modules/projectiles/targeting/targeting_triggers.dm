/mob/living/proc/trigger_aiming(var/trigger_type)
	if(!aimed.len)
		return
	for(var/obj/aiming_overlay/AO in aimed)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/obj/aiming_overlay/proc/trigger(var/perm)
	var/obj/item/gun/G = aiming_with
	if(istype(G) && G.safety())
		if(owner.a_intent == I_HURT)
			G.toggle_safety()
		else
			G.handle_click_empty(owner)
			to_chat(owner, span("warning", "Your [G]'s safety prevents firing."))
	if(!owner || !aiming_with || !aiming_at || !locked)
		return
	if(perm && (target_permissions & perm))
		return
	if(!owner.canClick())
		return
	owner.setClickCooldown(5) // Spam prevention, essentially.
	owner.visible_message("<span class='danger'>\The [owner] pulls the trigger reflexively!</span>")
	if(istype(G))
		G.Fire(aiming_at, owner)
	cancel_aiming()//if you can't remove it, nerf it
	aim_cooldown(3)
	toggle_active()
	if (owner.client)
		owner.client.remove_gun_icons()

/mob/living/ClickOn(var/atom/A, var/params)
	. = ..()
	trigger_aiming(TARGET_CAN_CLICK)
