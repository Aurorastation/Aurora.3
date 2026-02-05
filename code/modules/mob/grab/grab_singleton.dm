/singleton/grab
	var/name = "generic grab"
	var/desc

	var/singleton/grab/upgrade
	var/singleton/grab/downgrade

	var/grab_flags = 0

	var/point_blank_mult = 1
	var/damage_stage = 1

	var/grab_slowdown = 0.15
	var/shift = 0

	var/adjust_plane = TRUE
	var/adjust_layer = TRUE

	var/success_up              = "You get a better grip on $rep_affecting$."
	var/success_down            = "You adjust your grip on $rep_affecting$."
	var/fail_up                 = "You can't get a better grip on $rep_affecting$!"
	var/fail_down               = "You can't seem to relax your grip on $rep_affecting$!"

	var/grab_icon = 'icons/mob/screen/generic.dmi'
	var/grab_icon_state = "reinforce"

	var/upgrade_cooldown = 4 SECONDS
	var/action_cooldown = 4 SECONDS

	var/list/break_chance_table = list(100)
	var/breakability = 2

	var/help_action = "help intent"
	var/disarm_action = "disarm intent"
	var/grab_action = "grab intent"
	var/harm_action = "harm intent"

/singleton/grab/Initialize()
	if(ispath(upgrade, /singleton/grab))
		upgrade = GET_SINGLETON(upgrade)
	if(ispath(downgrade, /singleton/grab))
		downgrade = GET_SINGLETON(downgrade)
	return ..()

/singleton/grab/proc/process_string(obj/item/grab/G, to_write, obj/item/used_item)
	. = replacetext(to_write, "$rep_affecting$", G.grabbed)
	. = replacetext(., "$rep_assailant$", G.grabber)
	if (used_item)
		. = replacetext(., "$rep_item$", used_item)

/singleton/grab/proc/upgrade(obj/item/grab/G)
	if (can_upgrade(G) && upgrade_effect(G))
		to_chat(G.grabber, SPAN_WARNING("[process_string(G, success_up)]"))
		return upgrade
	to_chat(G.grabber, SPAN_WARNING("[process_string(G, fail_up)]"))

/singleton/grab/proc/downgrade(obj/item/grab/G)
	if (!downgrade)
		return let_go(G)
	if (can_downgrade(G) && downgrade_effect(G))
		to_chat(G.grabber, SPAN_NOTICE("[process_string(G, success_down)]"))
		return downgrade
	to_chat(G.grabber, SPAN_WARNING("[process_string(G, fail_down)]"))

/singleton/grab/proc/let_go(obj/item/grab/G)
	if(G.grabber && G.grabbed)
		to_chat(G.grabber, SPAN_NOTICE("You release \the [G.grabbed]."))
	let_go_effect(G)
	G.force_drop()

/singleton/grab/proc/on_target_change(obj/item/grab/G, old_zone, new_zone)
	G.special_target_functional = check_special_target(G)
	if(G.special_target_functional)
		special_target_change(G, old_zone, new_zone)
		special_target_effect(G)

/singleton/grab/proc/do_process(obj/item/grab/G)
	special_target_effect(G)
	process_effect(G)

/singleton/grab/proc/throw_held(obj/item/grab/G)
	if(G.grabber == G.grabbed)
		return
	if(grab_flags & GRAB_CAN_THROW)
		. = G.grabbed
		var/mob/thrower = G.loc
		qdel(G)
		for(var/obj/item/grab/inactive_grab as anything in thrower.get_inactive_held_items())
			qdel(inactive_grab)

/singleton/grab/proc/hit_with_grab(obj/item/grab/G, atom/A, P = TRUE)
	if(QDELETED(G) || !istype(G))
		return FALSE

	if(!G.check_action_cooldown() || G.resolving_hit)
		to_chat(G.grabber, SPAN_WARNING("You must wait before you can do that."))
		return FALSE

	G.resolving_hit = TRUE

	switch(G.grabber.a_intent)
		if(I_HELP)
			if(on_hit_help(G, A, P))
				. = help_action || TRUE
		if(I_DISARM)
			if(on_hit_disarm(G, A, P))
				. = disarm_action || TRUE
		if(I_GRAB)
			if(on_hit_grab(G, A, P))
				. = grab_action || TRUE
		if(I_HURT)
			if(on_hit_harm(G, A, P))
				. = harm_action || TRUE

	if(!QDELETED(G))
		G.resolving_hit = FALSE
		if(.)
			G.action_used()
			if(G.grabber)
				G.grabber.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				if(istext(.) && G.grabber)
					admin_attack_log(G.grabber, G.grabbed, "[.]s their victim,", "was [.]ed", "used [.] on")
			if(grab_flags & GRAB_DOWNGRADE_ACT)
				G.downgrade()

/singleton/grab/proc/grabber_moved(obj/item/grab/G)
	G.adjust_position()
	moved_effect(G)
	if(grab_flags & GRAB_DOWNGRADE_MOVE)
		G.downgrade()

/*
	Override these procs to set how the grab state will work. Some of them are best
	overriden in the parent of the grab set (for example, the behaviour for on_hit_intent()
	procs is determined in /decl/grab/normal and then inherited by each intent).
*/

/singleton/grab/proc/upgrade_effect(obj/item/grab/G)
	admin_attack_log(G.grabber, G.grabbed, "upgraded grab on their victim to [upgrade]", "was grabbed more tightly to [upgrade]", "upgraded grab to [upgrade] on")
	return TRUE

/singleton/grab/proc/can_upgrade(obj/item/grab/G)
	return !!upgrade && !!G.get_grabbed_mob()

/singleton/grab/proc/downgrade_effect(obj/item/grab/G)
	return TRUE

/singleton/grab/proc/can_downgrade(obj/item/grab/G)
	return !!downgrade

/singleton/grab/proc/let_go_effect(obj/item/grab/G)

/singleton/grab/proc/process_effect(obj/item/grab/G)

/singleton/grab/proc/special_target_effect(obj/item/grab/G)

/singleton/grab/proc/special_target_change(obj/item/grab/G, diff_zone)

/singleton/grab/proc/check_special_target(obj/item/grab/G)

/singleton/grab/proc/on_hit_help(obj/item/grab/G, atom/A, proximity)
	return TRUE

/singleton/grab/proc/on_hit_disarm(obj/item/grab/G, atom/A, proximity)
	return TRUE

/singleton/grab/proc/on_hit_grab(obj/item/grab/G, atom/A, proximity)
	return TRUE

/singleton/grab/proc/on_hit_harm(obj/item/grab/G, atom/A, proximity)
	return TRUE

/singleton/grab/proc/resolve_openhand_attack(obj/item/grab/G)
	return 0

/singleton/grab/proc/enter_as_up(obj/item/grab/G)

/singleton/grab/proc/item_attack(obj/item/grab/G, obj/item)
	return FALSE

/singleton/grab/proc/resolve_item_attack(obj/item/grab/G, mob/living/carbon/human/user, obj/item/I, target_zone)
	return FALSE

/singleton/grab/proc/handle_resist(obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	var/mob/living/grabber = G.grabber
	if(!grabbed)
		return
	if(grabbed.incapacitated(INCAPACITATION_KNOCKOUT | INCAPACITATION_STUNNED))
		to_chat(G.grabbed, SPAN_WARNING("You can't resist in your current state!"))
		return

	var/break_strength = breakability + (grabbed.mob_size - grabber.mob_size)
	if(ishuman(grabbed))
		var/mob/living/carbon/human/H = grabbed
		break_strength *= H.species.resist_mod
		break_strength *= H.species.grab_mod

	if(grabbed.incapacitated(INCAPACITATION_ALL))
		break_strength--
	if(grabbed.confused)
		break_strength--

	if(break_strength < 1)
		to_chat(G.grabbed, SPAN_WARNING("You try and break free, but unless something changes, you'll never escape!"))
		return

	var/break_chance = break_chance_table[clamp(break_strength, 1, break_chance_table.len)]
	if(prob(break_chance))
		if(!(grab_flags & GRAB_BLOCK_RESIST) && !prob((break_chance + 100) / 2))
			grabbed.visible_message(SPAN_WARNING("\The [grabbed] has loosened \the [grabber]'s grip!"))
			G.downgrade()
			return
		grabbed.visible_message(SPAN_WARNING("\The [grabbed] has broken free of \the [grabber]'s grip!"))
		let_go(G)

/singleton/grab/proc/moved_effect(obj/item/grab/G)
	return

