/obj/item/mech_component/propulsion/spider
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Xion Manufacturing Group's arachnid series boasts more leg per leg than the leading competitor. Useful for vehicles requiring tight, instant turning."
	icon_state = "spiderlegs"
	max_damage = 160
	move_delay = 4
	turn_delay = 1
	power_use = 2500
	trample_damage = 10

/obj/item/mech_component/propulsion/spider/heavy
	name = "industrial quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "A titan's take on the arachnid series from Xion Manufacturing Group. Much heavier than its smaller counterpart at the sacrifice of acceleration and power draw."
	icon_state = "spiderlegs-industrial"
	max_damage = 250
	move_delay = 5
	turn_delay = 1
	power_use = 7500
	trample_damage = 25

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A classic brought back. The Hephaestus' Landmaster class tracks are impervious to most damage and can maintain top speed regardless of load. Watch out for corners."
	icon_state = "tracks"
	max_damage = 450
	move_delay = 2 //Its fast
	turn_delay = 7
	power_use = 7500
	color = COLOR_WHITE
	mech_step_sound = 'sound/mecha/tanktread.ogg'
	trample_damage = 25