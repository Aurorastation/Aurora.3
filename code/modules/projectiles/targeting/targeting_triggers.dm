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
	if(owner && owner.client && (owner.client.prefs.toggles_secondary & SAFETY_CHECK) && owner.a_intent != I_HURT) //Check this first to save time.
		to_chat(owner, "You refrain from firing, as you aren't on harm intent.")
		return
	if(!owner || !aiming_with || !aiming_at || !locked)
		return
	if(perm && (target_permissions & perm))
		return
	if(!owner.canClick())
		return
	owner.setClickCooldown(5) // Spam prevention, essentially.
	owner.visible_message("<span class='danger'>\The [owner] pulls the trigger reflexively!</span>")
	var/obj/item/gun/G = aiming_with
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
