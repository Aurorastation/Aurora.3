/singleton/grab/normal/struggle
	name = "struggle grab"
	upgrade = /singleton/grab/normal/aggressive
	downgrade = /singleton/grab/normal/passive
	shift = 8
	grab_flags = GRAB_STOP_MOVE | GRAB_BLOCK_RESIST
	point_blank_mult = 1
	breakability = 3
	grab_slowdown = 0.35
	upgrade_cooldown = 2 SECONDS
	grab_icon_state = "reinforce"
	break_chance_table = list(5, 20, 30, 80, 100)

/singleton/grab/normal/struggle/process_effect(var/obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	var/mob/living/grabber = G.grabber
	if(!grabbed)
		return
	if(grabbed.incapacitated(INCAPACITATION_UNRESISTING) || grabbed.a_intent == I_HELP)
		grabbed.visible_message(SPAN_DANGER("\The [grabbed] isn't prepared to fight back as [grabber] tightens [grabber.get_pronoun("his")] grip!"))
		G.done_struggle = TRUE
		G.upgrade(TRUE)

/singleton/grab/normal/struggle/enter_as_up(var/obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	var/mob/living/grabber = G.grabber
	if(!grabbed)
		return
	if(grabber == grabbed)
		G.done_struggle = TRUE
		G.upgrade(TRUE)
		return

	if(grabbed.incapacitated(INCAPACITATION_UNRESISTING) || grabbed.a_intent == I_HELP)
		grabbed.visible_message(SPAN_DANGER("\The [grabbed] isn't prepared to fight back as [grabbed] tightens [grabber.get_pronoun("his")] grip!"))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		grabbed.visible_message(SPAN_WARNING("[grabbed] struggles against [grabber]!"))
		G.done_struggle = FALSE
		addtimer(CALLBACK(G, PROC_REF(handle_resist)), 1 SECOND)
		resolve_struggle(G)

/singleton/grab/normal/struggle/proc/resolve_struggle(var/obj/item/grab/G)
	set waitfor = FALSE
	if(do_after(G.grabber, upgrade_cooldown, G, DO_USER_CAN_MOVE))
		G.done_struggle = TRUE
		G.upgrade(TRUE)
	else
		G.downgrade()

/singleton/grab/normal/struggle/can_upgrade(var/obj/item/grab/G)
	. = ..() && G.done_struggle

/singleton/grab/normal/struggle/on_hit_disarm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to pin."))
	return FALSE

/singleton/grab/normal/struggle/on_hit_grab(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to jointlock."))
	return FALSE

/singleton/grab/normal/struggle/on_hit_harm(var/obj/item/grab/G, var/atom/A, var/proximity)
	if(proximity)
		to_chat(G.grabber, SPAN_WARNING("Your grip isn't strong enough to dislocate."))
	return FALSE

/singleton/grab/normal/struggle/resolve_openhand_attack(var/obj/item/grab/G)
	return FALSE
