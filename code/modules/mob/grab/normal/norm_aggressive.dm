/singleton/grab/normal/aggressive
	name = "aggressive grab"
	upgrade = /singleton/grab/normal/neck
	downgrade = /singleton/grab/normal/passive
	shift = 12
	grab_flags = GRAB_STOP_MOVE | GRAB_CAN_THROW | GRAB_FORCE_HARM
	point_blank_mult = 1.5
	damage_stage = 1
	breakability = 3
	grab_icon_state = "reinforce1"
	break_chance_table = list(5, 20, 40, 80, 100)
	help_action = "wound pressure"

/singleton/grab/normal/aggressive/on_hit_help(obj/item/grab/G, atom/A, proximity)
	var/mob/living/carbon/human/victim = G.get_grabbed_mob()
	if(!istype(victim) || !proximity || (A && A != victim))
		return FALSE
	return victim.apply_pressure(G.grabber, G.target_zone)

/singleton/grab/normal/aggressive/process_effect(obj/item/grab/G)
	var/mob/living/grabbed_mob = G.get_grabbed_mob()
	if(istype(grabbed_mob))
		if(G.target_zone in list(BP_L_HAND, BP_R_HAND))
			grabbed_mob.drop_held_items()
		if(grabbed_mob.lying)
			grabbed_mob.Weaken(4)

/singleton/grab/normal/aggressive/can_upgrade(obj/item/grab/G)
	. = ..()
	if(.)
		if(!ishuman(G.grabbed))
			to_chat(G.grabber, SPAN_WARNING("You can only upgrade an aggressive grab when grappling a humanoid!"))
			return FALSE
		if(!(G.target_zone in list(BP_CHEST, BP_HEAD)))
			to_chat(G.grabber, SPAN_WARNING("You need to be grabbing their torso or head for this!"))
			return FALSE
		var/mob/living/carbon/human/grabbed_mob = G.get_grabbed_mob()
		if(istype(grabbed_mob))
			var/obj/item/clothing/C = grabbed_mob.get_equipped_item(slot_head_str)
			if(istype(C) && C.max_pressure_protection && LAZYACCESS(C.armor, MELEE) > ARMOR_MELEE_MEDIUM)
				to_chat(G.grabber, SPAN_WARNING("\The [C] is in the way!"))
				return FALSE
