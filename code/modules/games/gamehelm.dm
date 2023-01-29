/obj/item/gamehelm
	name = "\improper InUs Game-Helm"
	desc = "The latest device in any self respecting gamer's arsenal, brought to you by the Ingi Usang Entertainment Corporation. Remember to hide it under your desk if the captain walks by."
	desc_extended = "The Game-Helm was designed by a subsidiary of NanoTrasen, Ingi Usang Entertainment Co., with games \
	being able to be purchased from an online marketplace hosted by InUs. Thousands of popular and obscure titles are available on the \
	console. Besides being the perfect present, it's also capable of video streaming and sharing files over authorized \
	connections. A quick and easy way to upload your latest montage to the extranet."
	desc_info = "You can ALT-click the game-helm to open it up and turn it on. Click on the open device to play."
	icon = 'icons/obj/gamehelm.dmi'
	w_class = ITEMSIZE_SMALL
	update_icon_on_init = TRUE

	var/case_color = "white"
	var/open = FALSE

	var/playing_game = FALSE
	var/current_screen_state = null
	var/static/list/game_type_to_state = list(
		"anime game" = "screen_anime",
		"shooter game" = "screen_shooter",
		"strategy game" = "screen_strategy",
		"piloting game" = "screen_pilot",
		"horror game" = "screen_dread",
		"simulation game" = "screen_emotive",
		"exploration game" = "screen_exploration",
		"music service" = "screen_music",
		"video service" = "screen_video",
		"turn off the system" = null
	)
	var/static/list/non_game_states = list(
		"screen_music",
		"screen_video"
	)

	var/static/list/game_actions = list(
		"hits all the buttons at the same time" = "hit all the buttons at the same time",
		"rapidly hits a bunch of buttons" = "rapidly hit a bunch of buttons",
		"tilts the InUs Game-Helm to the right" = "tilt the InUs Game-Helm to the right",
		"tilts the InUs Game-Helm to the left" = "tilt the InUs Game-Helm to the left",
		"swipes across the InUs Game-Helm's screen" = "swipe across the InUs Game-Helm's screen"
	)

/obj/item/gamehelm/update_icon()
	cut_overlays()
	if(open)
		icon_state = "open_[case_color]"
		add_overlay("buttons_open")
	else
		icon_state = "closed_[case_color]"
		add_overlay("buttons_closed")
	if(current_screen_state)
		add_overlay(current_screen_state)

/obj/item/gamehelm/process()
	if(playing_game)
		playsound(loc, /singleton/sound_category/quick_arcade, 45)
		if(ismob(loc))
			var/picked_action = pick(game_actions)
			var/self_action = game_actions[picked_action]
			loc.visible_message("<b>[loc]</b> [picked_action]!", SPAN_NOTICE("You [self_action]!"), range = 3)
			loc.quick_jitter(5)
	else
		playsound(loc, /singleton/sound_category/computerbeep_sound, 45)

/obj/item/gamehelm/AltClick(mob/user)
	if(use_check(user))
		return
	toggle_state(user)

/obj/item/gamehelm/proc/toggle_state(mob/user)
	open = !open
	update_icon()
	if(open)
		user.visible_message("<b>[user]</b> flips open \the [src] with a satisfying snap!", SPAN_NOTICE("You flip open \the [src] with a satisfying snap!"), range = 3)
	else
		user.visible_message("<b>[user]</b> flips \the [src] shut with a satisfying snap!", SPAN_NOTICE("You flip \the [src] shut with a satisfying snap!"), range = 3)
		set_game(null)
	playsound(user, 'sound/items/penclick.ogg', 25)

/obj/item/gamehelm/proc/set_game(var/screen_type)
	current_screen_state = screen_type
	playing_game = !(current_screen_state in non_game_states)
	update_icon()
	if(current_screen_state)
		START_PROCESSING(SSprocessing, src)
	else
		STOP_PROCESSING(SSprocessing, src)

/obj/item/gamehelm/attack_self(mob/user)
	if(open)
		var/choice = input("What do you want to play?") as null|anything in game_type_to_state
		if(choice == "turn off the system")
			user.visible_message("<b>[user]</b> hits the power button on \the [src] and it quickly shuts down.", SPAN_NOTICE("You hit the power button on \the [src] and it quickly shuts down."), range = 3)
			playsound(loc, 'sound/machines/softbeep.ogg', 40)
			set_game(null)
			return
		if(current_screen_state)
			user.visible_message("<b>[user]</b> taps on a few buttons and \the [src] swaps to a different application!", SPAN_NOTICE("You tap on a few buttons and \the [src] swaps to a different application!"), range = 3)
		else
			user.visible_message("<b>[user]</b> taps on a few buttons and \the [src] springs to life!", SPAN_NOTICE("You tap on a few buttons and \the [src] springs to life!"), range = 3)
		playsound(loc, /singleton/sound_category/boops, 45)
		set_game(game_type_to_state[choice])
	return ..()

/obj/item/gamehelm/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

//The colours!
/obj/item/gamehelm/blue
	case_color = "blue"

/obj/item/gamehelm/red
	case_color = "red"

/obj/item/gamehelm/black
	case_color = "black"

/obj/item/gamehelm/pink
	case_color = "pink"

/obj/item/gamehelm/purple
	case_color = "purple"

/obj/item/gamehelm/brown
	case_color = "brown"

/obj/item/gamehelm/green
	case_color = "green"

/obj/item/gamehelm/yellow
	case_color = "yellow"

/obj/item/gamehelm/turquoise
	case_color = "turqoise"

/obj/item/gamehelm/weathered
	case_color = "weathered"
