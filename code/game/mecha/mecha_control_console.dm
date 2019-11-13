//Note: This console is deprecated.
//The exosuit control program in modular computers is its successor

/obj/machinery/computer/mecha
	name = "Exosuit Control"

	icon_screen = "mecha"
	light_color = "#a97faa"
	req_access = list(access_robotics)
	circuit = /obj/item/circuitboard/mecha_control
	var/list/located = list()
	var/screen = 0
	var/stored_data

/obj/machinery/computer/mecha/attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

/obj/machinery/computer/mecha/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat = "<html><head><title>[src.name]</title><style>h3 {margin: 0px; padding: 0px;}</style></head><body>"
	if(screen == 0)
		dat += "<h3>Tracking beacons data</h3>"
		for(var/obj/item/mecha_parts/mecha_tracking/TR in world)
			var/answer = TR.get_mecha_info()
			if(answer)
				dat += {"<hr>[answer]<br/>
						  <a href='?src=\ref[src];send_message=\ref[TR]'>Send message</a><br/>
						  <a href='?src=\ref[src];get_log=\ref[TR]'>Show exosuit log</a> | <a style='color: #f00;' href='?src=\ref[src];shock=\ref[TR]'>(EMP pulse)</a><br>"}

	if(screen==1)
		dat += "<h3>Log contents</h3>"
		dat += "<a href='?src=\ref[src];return=1'>Return</a><hr>"
		dat += "[stored_data]"

	dat += "<A href='?src=\ref[src];refresh=1'>(Refresh)</A><BR>"
	dat += "</body></html>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/mecha/Topic(href, href_list)
	if(..())
		return
	var/datum/topic_input/old_filter = new /datum/topic_input(href,href_list)
	if(href_list["send_message"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("send_message")
		var/message = sanitize(input(usr,"Input message","Transmit message") as text)
		var/obj/mecha/M = MT.in_mecha()
		if(message && M)
			M.occupant_message(message)
		return
	if(href_list["shock"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("shock")
		MT.shock()
	if(href_list["get_log"])
		var/obj/item/mecha_parts/mecha_tracking/MT = old_filter.getObj("get_log")
		stored_data = MT.get_mecha_log()
		screen = 1
	if(href_list["return"])
		screen = 0
	src.updateUsrDialog()
	return



