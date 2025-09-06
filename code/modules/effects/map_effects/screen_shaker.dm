// Makes the screen shake for nearby players every so often.
/obj/effect/map_effect/interval/screen_shaker
	name = "screen shaker"
	icon_state = "screen_shaker"

	interval_lower_bound = 1 SECOND
	interval_upper_bound = 2 SECONDS

	var/shake_radius = 7 // How far the shaking effect extends to. By default it is one screen length.
	var/shake_duration = 2 // How long the shaking lasts.
	var/shake_strength = 1 // How much it shakes.
	/// If true, each time screen is shaken an earthquake sound will play.
	var/play_rumble_sound = FALSE

/obj/effect/map_effect/interval/screen_shaker/trigger()
	for(var/A in GLOB.player_list)
		var/mob/M = A
		if(M.z == src.z && get_dist(src, M) <= shake_radius)
			shake_camera(M, shake_duration, shake_strength)
			if(play_rumble_sound)
				playsound(M, 'sound/effects/earthquake_rumble.ogg', 80)
	..()
