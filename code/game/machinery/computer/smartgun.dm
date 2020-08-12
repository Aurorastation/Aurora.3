/obj/machinery/computer/smartguncontrol
	name = "smartgun control console"
	desc = "A console that can be used to track smartgun enabled firearms, and remotely control their activation."
	icon_screen = "explosive"
	light_color = LIGHT_COLOR_ORANGE
	req_access = list(access_armory)
	circuit = /obj/item/circuitboard/smartguncontrol
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed


	attack_ai(var/mob/user as mob)
		return src.attack_hand(user)

	attack_hand(var/mob/user as mob)
		if(..())
			return
		user.set_machine(src)
		var/dat
		dat += "<B>Smartgun Control System</B><BR>"
		if(screen == 0)
			dat += "<HR><A href='?src=\ref[src];lock=1'>Unlock Console</A>"
		else if(screen == 1)
			dat += "<HR>Detected Firearms<BR>"
			for(var/obj/item/device/firing_pin/security_level/P in smartguns)
				var/obj/item/device/firing_pin/security_level/thispin = new [smartguns[P]]
				dat += "[thispin] ----- [thispin.registered_user]<BR>"
				dat += "********************************<BR>"
			dat += "<HR><A href='?src=\ref[src];lock=1'>Lock Console</A>"

		user << browse(dat, "window=computer;size=400x500")
		onclose(user, "computer")
		return


	process()
		if(!..())
			src.updateDialog()
		return


	Topic(href, href_list)
		if(..())
			return
		if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
			usr.set_machine(src)

			if(href_list["lock"])
				if(src.allowed(usr))
					screen = !screen
				else
					to_chat(usr, "Unauthorized Access.")

			src.add_fingerprint(usr)
		src.updateUsrDialog()
		return