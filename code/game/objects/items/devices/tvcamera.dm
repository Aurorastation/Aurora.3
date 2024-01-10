/obj/item/device/tvcamera
	name = "press camera drone"
	desc = "An Ingi Usang Entertainment Co. livestreaming press camera drone. Weapon of choice for war correspondents and reality show cameramen. It does not appear to have any internal memory storage."
	icon_state = "camcorder"
	item_state = "camcorder"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BELT
	var/channel = "General News Feed"
	var/obj/machinery/camera/network/news/camera
	var/obj/item/device/radio/radio

/obj/item/device/tvcamera/Destroy()
	GLOB.listening_objects -= src
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	. = ..()

/obj/item/device/tvcamera/Initialize()
	camera = new(src)
	camera.c_tag = channel
	camera.status = FALSE
	radio = new(src)
	radio.get_frequency(FALSE)
	radio.set_frequency(ENT_FREQ)
	GLOB.listening_objects += src
	. = ..()

/obj/item/device/tvcamera/examine(mob/user)
	. = ..()
	to_chat(user, "Video feed is currently: [camera.status ? "<span style='color: rgb(51, 204, 51);font-weight: bold;'>Online</span>" : "<span style='color: rgb(204, 0, 0); font-weight: bold;'>Offline</span>"]")
	to_chat(user, "Audio feed is currently: [radio.get_broadcasting() ? "<span style='color: rgb(51, 204, 51); font-weight: bold;'>Online</span>" : "<span style='color: rgb(204, 0, 0); font-weight: bold;'>Offline</span>"]")

/obj/item/device/tvcamera/attack_self(mob/user)
	add_fingerprint(user)
	user.set_machine(src)
	var/dat = list()
	dat += "Channel name is: <a href='?src=\ref[src];channel=1'>[channel ? channel : "unidentified broadcast"]</a><br>"
	dat += "Video streaming is: <a href='?src=\ref[src];video=1'>[camera.status ? "Online" : "Offline"]</a><br>"
	dat += "Microphone is: <a href='?src=\ref[src];sound=1'>[radio.get_broadcasting() ? "Online" : "Offline"]</a><br>"
	dat += "Sound is being broadcasted on frequency: [format_frequency(radio.get_frequency())] ([get_frequency_name(radio.get_frequency())])<br>"
	var/datum/browser/popup = new(user, "Press Camera Drone", "EyeBuddy", 300, 390, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/device/tvcamera/Topic(bred, href_list, state = physical_state)
	if(..())
		return 1
	if(href_list["channel"])
		var/nc = tgui_input_text(usr, "Select new channel name", "Channel Name", channel)
		if(nc)
			channel = nc
			camera.c_tag = channel
			to_chat(usr, SPAN_WARNING("New channel name: '[channel]' has been set."))
	if(href_list["video"])
		camera.set_status(!camera.status)
		if(camera.status)
			balloon_alert(usr, SPAN_NOTICE("Video streaming: Activated. Broadcasting on channel: [channel]"))
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
		else
			balloon_alert(usr, SPAN_NOTICE("Video streaming: Deactivated."))
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
		update_icon()
	if(href_list["sound"])
		radio.set_broadcasting(!radio.get_broadcasting())
		if(radio.get_broadcasting())
			balloon_alert(usr, SPAN_NOTICE("Audio streaming: Activated. Broadcasting on frequency: [format_frequency(radio.get_frequency())]."))
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1)
		else
			balloon_alert(usr, SPAN_NOTICE("Audio streaming: Deactivated."))
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 1)
	if(!href_list["close"])
		attack_self(usr)

/obj/item/device/tvcamera/update_icon()
	..()
	if(camera.status)
		icon_state = "camcorder_on"
		item_state = "camcorder_on"
	else
		icon_state = "camcorder"
		item_state = "camcorder"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_r_hand(0)
		H.update_inv_l_hand()

/* Assembly by a roboticist */
/obj/item/robot_parts/head/attackby(var/obj/item/device/assembly/S, mob/user as mob)
	if(!istype(S, /obj/item/device/assembly/infra))
		..()
		return
	var/obj/item/tv_assembly/A = new(user)
	qdel(S)
	user.put_in_hands(A)
	to_chat(user, SPAN_NOTICE("You add the infrared sensor to the robot head."))
	qdel(src)

/* Using camcorder icon as I can't sprite.
Using robohead because of restricting to roboticist */
/obj/item/tv_assembly
	name = "tv camera assembly"
	desc = "A robotic head with an infrared sensor inside."
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "head"
	item_state = "head"
	var/buildstep = 0
	w_class = ITEMSIZE_LARGE

/obj/item/tv_assembly/attackby(var/obj/item/W, var/mob/user)
	switch(buildstep)
		if(0)
			if(istype(W, /obj/item/robot_parts/robot_component/camera))
				to_chat(user, SPAN_NOTICE("You add the camera module to [src]."))
				qdel(W)
				desc = "This TV camera assembly has a camera module."
				buildstep++
		if(1)
			if(istype(W, /obj/item/device/taperecorder))
				qdel(W)
				buildstep++
				to_chat(user, SPAN_NOTICE("You add the tape recorder to [src]."))
				desc = "This TV camera assembly has a camera and audio module."
				return
		if(2)
			if(W.iscoil())
				var/obj/item/stack/cable_coil/C = W
				if(!C.use(3))
					to_chat(user, SPAN_NOTICE("You need three cable coils to wire the devices."))
					..()
					return
				buildstep++
				to_chat(user, SPAN_NOTICE("You wire the assembly."))
				desc = "This TV camera assembly has wires sticking out."
				return
		if(3)
			if(W.iswirecutter())
				to_chat(user, SPAN_NOTICE("You trim the wires."))
				buildstep++
				desc = "This TV camera assembly needs casing."
				return
		if(4)
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/S = W
				if(S.use(1))
					buildstep++
					to_chat(user, SPAN_NOTICE("You encase the assembly."))
					var/turf/T = get_turf(src)
					new /obj/item/device/tvcamera(T)
					qdel(src)
					return
	..()
