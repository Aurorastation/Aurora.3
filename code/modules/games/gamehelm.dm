/obj/item/gamehelm
	name = "\improper InUs game-helm"
	desc = "The latest device in any self respecting gamer's arsenal, brought to you by the Ingi Usang Entertainment Corporation. Remember to hide it under your desk if the captain walks by."
	desc_extended = "The Game-Helm was designed by a subsidiary of NanoTrasen, Ingi Usang Entertainment Co., with games \
	being able to be purchased from an online marketplace hosted by InUs. Thousands of popular and obscure titles are available on the \
	console. Besides being the perfect present, it's also capable of video streaming and sharing files over authorized \
	connections. A quick and easy way to upload your latest montage to the extranet."
	desc_info = "You can ALT-click the game-helm to open it up and turn it on. Click on the open device to play."
	icon = 'icons/obj/gamehelm.dmi'
	w_class = ITEMSIZE_SMALL
	var/open = "open_white"
	var/closed = "closed_white"

/obj/item/gamehelm/Initialize()
	. = ..()
	icon_state = closed

/obj/item/gamehelm/AltClick()
	if(use_check(usr))
		return
	if(icon_state == open) //Toggle the lid, turn it off.
		icon_state = closed
		cut_overlays()
		add_overlay("buttons_closed")
	else if(icon_state == closed) //Otherwise open it up
		icon_state = open
		cut_overlays()
		add_overlay("buttons_open")

/obj/item/gamehelm/attack_self(mob/user)
	if(icon_state == open)
		var/choice = input("What do you want to play?") as null|anything in list("anime game", "shooter game", "simulation game", "strategy game", "piloting game", "horror game", "exploration game", "video service", "music service", "turn off the system")
		cut_overlays()
		add_overlay("buttons_open")
		if(choice != "turn off the system")
			to_chat(user, "You start the application on your GameHelm and begin playing.")
		else
			to_chat(user, "You turn the GameHelm off.")
		if(choice == "anime game")
			add_overlay("screen_anime")
		if(choice == "shooter game")
			add_overlay("screen_shooter")
		if(choice == "strategy game")
			add_overlay("screen_strategy")
		if(choice == "piloting game")
			add_overlay("screen_pilot")
		if(choice == "horror game")
			add_overlay("screen_dread")
		if(choice == "simulation game")
			add_overlay("screen_emotive")
		if(choice == "exploration game")
			add_overlay("screen_exploration")
		if(choice == "music service")
			add_overlay("screen_music")
		if(choice == "video service")
			add_overlay("screen_video")
	else
		..()

//The colours!
/obj/item/gamehelm/blue
	open = "open_blue"
	closed = "closed_blue"
	icon_state = "closed_blue"

/obj/item/gamehelm/red
	open = "open_red"
	closed = "closed_red"
	icon_state = "closed_red"

/obj/item/gamehelm/black
	open = "open_black"
	closed = "closed_black"
	icon_state = "closed_black"

/obj/item/gamehelm/pink
	open = "open_pink"
	closed = "closed_pink"
	icon_state = "closed_pink"

/obj/item/gamehelm/purple
	open = "open_purple"
	closed = "closed_purple"
	icon_state = "closed_purple"

/obj/item/gamehelm/brown
	open = "open_brown"
	closed = "closed_brown"
	icon_state = "closed_brown"

/obj/item/gamehelm/green
	open = "open_green"
	closed = "closed_green"
	icon_state = "closed_green"

/obj/item/gamehelm/yellow
	open = "open_yellow"
	closed = "closed_yellow"
	icon_state = "closed_yellow"

/obj/item/gamehelm/turquoise
	open = "open_turquoise"
	closed = "closed_turquoise"
	icon_state = "closed_turquoise"

/obj/item/gamehelm/weathered
	open = "open_weathered"
	closed = "closed_weathered"
	icon_state = "closed_weathered"
