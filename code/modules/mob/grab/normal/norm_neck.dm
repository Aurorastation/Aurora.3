/singleton/grab/normal/neck
	name = "chokehold"
	upgrade = /singleton/grab/normal/kill
	downgrade = /singleton/grab/normal/aggressive
	drop_headbutt = FALSE
	shift = -10
	grab_flags = GRAB_STOP_MOVE | GRAB_REVERSE_FACING | GRAB_SHIELDS_YOU | GRAB_SHARE_TILE | GRAB_CAN_THROW | GRAB_FORCE_HARM | GRAB_RESTRAINS
	point_blank_mult = 2
	damage_stage = 2
	grab_icon_state = "kill"
	break_chance_table = list(3, 18, 45, 100)

/singleton/grab/normal/neck/process_effect(obj/item/grab/G)
	var/mob/living/grabbed = G.get_grabbed_mob()
	if(!istype(grabbed))
		return
	grabbed.drop_held_items()
	if(grabbed.lying)
		grabbed.Weaken(4)
	grabbed.adjustOxyLoss(1)
