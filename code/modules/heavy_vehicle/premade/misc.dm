/obj/item/mech_component/propulsion/spider
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Xion Industrial's arachnid series boasts more leg per leg than the leading competitor."
	icon_state = "spiderlegs"
	max_damage = 80
	move_delay = 4
	turn_delay = 1
	power_use = 2500

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A classic brought back. The Hephaestus' Landmaster class tracks are impervious to most damage and can maintain top speed regardless of load. Watch out for corners."
	icon_state = "tracks"
	max_damage = 150
	move_delay = 2 //Its fast
	turn_delay = 7
	power_use = 7500
	color = COLOR_WHITE
	mech_step_sound = 'sound/mecha/tanktread.ogg'

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	transparent_cabin = TRUE
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "A simple spherical exosuit cockpit commonly used in space pods."