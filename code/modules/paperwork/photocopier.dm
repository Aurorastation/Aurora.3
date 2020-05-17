/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/library.dmi'
	icon_state = "photocopier"
	var/insert_anim = "photocopier_scan"
	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	var/obj/item/copyitem = null	//what's in the copier!
	var/toner = 30 //how much toner is left! woooooo~
	var/maxcopies = 10	//how many copies can be copied at once- idea shamelessly stolen from bs12's copier!

/obj/machinery/photocopier/attack_ai(mob/user as mob)
	return attack_hand(user)

VUEUI_MONITOR_VARS(/obj/machinery/photocopier, photocopiermonitor)
	watch_var("toner", "toner")
	watch_var("maxcopies", "maxcopies")
	watch_var("copyitem", "gotitem", CALLBACK(null, .proc/transform_to_boolean, FALSE))

/obj/machinery/photocopier/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data
	if(data && data["isAI"] != istype(user, /mob/living/silicon))
		data["isAI"] = istype(user, /mob/living/silicon)
		. = data
	if(data && !isnum(data["copies"]))
		data["copies"] = 1
		. = data

/obj/machinery/photocopier/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/photocopier/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "paperwork-photocopier", 300, 200, capitalize(src.name))
	ui.open()

/obj/machinery/photocopier/Topic(href, href_list)
	if(href_list["copy"])
		if(stat & (BROKEN|NOPOWER))
			return
		var/datum/vueui/ui = href_list["vueui"]
		if(!istype(ui))
			return
		var/copies = between(0, ui.data["copies"], maxcopies)

		for(var/i = 0, i < copies, i++)
			if(toner <= 0)
				break

			var/c_type = copy_type()

			if(!c_type) // if there's something that can't be copied
				break

			use_power(active_power_usage)
		SSvueui.check_uis_for_change(src)
	else if(href_list["remove"])
		if(copyitem)
			copyitem.forceMove(usr.loc)
			usr.put_in_hands(copyitem)
			to_chat(usr, span("notice", "You take \the [copyitem] out of \the [src]."))
			copyitem = null
			SSvueui.check_uis_for_change(src)
	else if(href_list["aipic"])
		if(!istype(usr,/mob/living/silicon)) return
		if(stat & (BROKEN|NOPOWER)) return

		if(toner >= 5)
			var/mob/living/silicon/tempAI = usr
			var/obj/item/device/camera/siliconcam/camera = tempAI.ai_camera

			if(!camera)
				return
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return

			var/obj/item/photo/p = photocopy(selection)
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			toner -= 5
			sleep(15)
		SSvueui.check_uis_for_change(src)

/obj/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copyitem)
			user.drop_from_inventory(O,src)
			copyitem = O
			to_chat(user, span("notice", "You insert \the [O] into \the [src]."))
			flick(insert_anim, src)
			playsound(loc, 'sound/bureaucracy/scan.ogg', 75, 1)
			SSvueui.check_uis_for_change(src)
		else
			to_chat(user, span("notice", "There is already something in \the [src]."))
	else if(istype(O, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			to_chat(user, span("notice", "You insert \the [O] into \the [src]."))
			flick("photocopier_toner", src)
			playsound(loc, "switchsounds", 50, 1)
			var/obj/item/device/toner/T = O
			toner += T.toner_amount
			user.drop_from_inventory(O,get_turf(src))
			qdel(O)
			SSvueui.check_uis_for_change(src)
		else
			to_chat(user, span("notice", "This cartridge is not yet ready for replacement! Use up the rest of the toner."))
			flick("photocopier_notoner", src)
			playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
	else if(O.iswrench())
		playsound(loc, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, span("notice", "You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/obj/machinery/photocopier/proc/copy_type(var/c_item = copyitem) // helper proc to reduce ctrl+c ctrl+v
	if (istype(c_item, /obj/item/paper))
		var/obj/item/paper/C = copy(c_item)
		sleep(20)
		return C
	else if (istype(c_item, /obj/item/photo))
		var/obj/item/photo/P = photocopy(c_item)
		sleep(20)
		return P
	else if (istype(c_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = bundlecopy(c_item)
		sleep(15*B.pages.len)
		return B
	else
		to_chat(usr, span("warning", "\The [c_item] can't be copied by \the [src]."))
		return FALSE

/obj/machinery/photocopier/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
		else
			if(prob(50))
				if(toner > 0)
					new /obj/effect/decal/cleanable/blood/oil(get_turf(src))
					toner = 0
	return

/obj/machinery/photocopier/proc/copy(var/obj/item/paper/copy, var/print = 1, var/use_sound = 1, var/delay = 10) // note: var/delay is the delay from copy to print, it should be less than the sleep in copy_type()
	var/obj/item/paper/c = new /obj/item/paper()
	var/info
	var/pname
	if (toner > 10)	//lots of toner, make it dark
		info = "<font color = #101010>"
	else			//no toner? shitty copies for you!
		info = "<font color = #808080>"
	var/copied = html_decode(copy.info)
	copied = replacetext(copied, "<font face=\"[c.deffont]\" color=", "<font face=\"[c.deffont]\" nocolor=")	//state of the art techniques in action
	copied = replacetext(copied, "<font face=\"[c.crayonfont]\" color=", "<font face=\"[c.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	info += copied
	info += "</font>"//</font>
	pname = copy.name // -- Doohl
	c.color = "#f0f0f0"
	c.fields = copy.fields
	c.stamps = copy.stamps
	c.stamped = copy.stamped
	c.ico = copy.ico
	c.offset_x = copy.offset_x
	c.offset_y = copy.offset_y
	var/list/temp_overlays = copy.overlays       //Iterates through stamps
	var/image/img                                //and puts a matching
	for (var/j = 1, j <= min(temp_overlays.len, copy.ico.len), j++) //gray overlay onto the copy
		if (findtext(copy.ico[j], "cap") || findtext(copy.ico[j], "cent"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
		else if (findtext(copy.ico[j], "deny"))
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
		else
			img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
		img.pixel_x = copy.offset_x[j]
		img.pixel_y = copy.offset_y[j]
		c.add_overlay(img)

	toner--
	if(toner == 0)
		visible_message(span("notice", "A red light on \the [src] flashes, indicating that it is out of toner."))
		flick("photocopier_notoner", src)
		playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
		return

	c.set_content_unsafe(pname, info)
	if (print)
		flick("photocopier_print", src)
		src.print(c, use_sound, 'sound/bureaucracy/print.ogg', delay)
	return c

/obj/machinery/photocopier/proc/photocopy(var/obj/item/photo/photocopy)
	var/obj/item/photo/p = photocopy.copy()
	p.forceMove(src.loc)

	var/icon/I = icon(photocopy.icon, photocopy.icon_state)
	if(toner > 10)	//plenty of toner, go straight greyscale
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))		//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	else			//not much toner left, lighten the photo
		I.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		p.tiny.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
	p.icon = I
	toner -= 5	//photos use a lot of ink!
	if(toner < 0)
		toner = 0
		visible_message(span("notice", "A red light on \the [src] flashes, indicating that it is out of toner."))
		flick("photocopier_notoner", src)
		playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/obj/machinery/photocopier/proc/bundlecopy(var/obj/item/paper_bundle/bundle, var/need_toner=1)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle (src)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			visible_message(span("notice", "A red light on \the [src] flashes, indicating that it is out of toner."))
			flick("photocopier_notoner", src)
			playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
			break


		W = copy_type(W)
		W.forceMove(p)
		p.pages += W

	p.forceMove(src.loc)
	p.update_icon()
	p.icon_state = "paper_words"
	p.name = bundle.name
	p.pixel_y = rand(-8, 8)
	p.pixel_x = rand(-9, 9)
	return p

/obj/item/device/toner
	name = "toner cartridge"
	desc = "A high-definition toner for colour photocopying and printer machines. Good thing it's a business expense."
	icon_state = "tonercartridge"
	var/toner_amount = 30
