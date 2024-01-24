/obj/machinery/photocopier
	name = "photocopier"
	icon = 'icons/obj/library.dmi'
	icon_state = "photocopier"
	anchored = 1
	density = 1
	idle_power_usage = 30
	active_power_usage = 200
	power_channel = EQUIP
	/// Item to copy.
	var/obj/item/copy_item
	/// How much toner is left.
	var/toner = 30
	/// Maximum amount of toner that can be stored at once.
	var/max_toner = 30
	/// How many copies can be copied at once.
	var/max_copies = 10
	/// How many copies will be printed with one click of the 'copy' button.
	var/num_copies = 1
	/// Item insert animation.
	var/insert_anim = "photocopier_scan"
	/// Print animation.
	var/print_animation = "photocopier_print"

/obj/machinery/photocopier/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/photocopier/ui_data(mob/user)
	var/list/data = list()
	data["toner"] = toner
	data["max_toner"] = max_toner
	data["max_copies"] = max_copies
	data["gotitem"] = !!copy_item
	data["is_silicon"] = issilicon(user)
	data["num_copies"] = num_copies
	return data

/obj/machinery/photocopier/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/photocopier/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Photocopier", "Nanocopier", 300, 300)
		ui.open()

/obj/machinery/photocopier/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("copy")
			if(stat & (BROKEN|NOPOWER))
				return

			for(var/i = 0, i < num_copies, i++)
				if(toner <= 0)
					break

				var/c_type = copy_type(src, copy_item, toner, user = ishuman(usr) ? usr : null)

				if(!c_type) // if there's something that can't be copied
					break

				use_power_oneoff(active_power_usage)
			return TRUE

		if("remove")
			if(copy_item)
				copy_item.forceMove(usr.loc)
				usr.put_in_hands(copy_item)
				to_chat(usr, SPAN_NOTICE("You take \the [copy_item] out of \the [src]."))
				copy_item = null
				return TRUE

		if("aipic")
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

				var/obj/item/photo/p = photocopy(src, selection)
				if (p.desc == "")
					p.desc += "Copied by [tempAI.name]"
				else
					p.desc += " - Copied by [tempAI.name]"
				sleep(15)
				return TRUE

		if("set_copies")
			num_copies = clamp(text2num(params["num_copies"]), 1, max_copies)
			return TRUE

/obj/machinery/photocopier/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo) || istype(O, /obj/item/paper_bundle))
		if(!copy_item)
			user.drop_from_inventory(O,src)
			copy_item = O
			to_chat(user, SPAN_NOTICE("You insert \the [O] into \the [src]."))
			flick(insert_anim, src)
			playsound(loc, 'sound/bureaucracy/scan.ogg', 75, 1)
			SStgui.update_uis(src)
		else
			to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))
	else if(istype(O, /obj/item/device/toner))
		if(toner <= 10) //allow replacing when low toner is affecting the print darkness
			to_chat(user, SPAN_NOTICE("You insert \the [O] into \the [src]."))
			flick("photocopier_toner", src)
			playsound(loc, /singleton/sound_category/switch_sound, 50, 1)
			var/obj/item/device/toner/T = O
			toner = min(toner + T.toner_amount, max_toner)
			user.drop_from_inventory(O,get_turf(src))
			qdel(O)
			SStgui.update_uis(src)
		else
			to_chat(user, SPAN_NOTICE("This cartridge is not yet ready for replacement! Use up the rest of the toner."))
			flick("photocopier_notoner", src)
			playsound(loc, 'sound/machines/buzz-two.ogg', 75, 1)
	else if(O.iswrench())
		playsound(loc, O.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You [anchored ? "wrench" : "unwrench"] \the [src]."))
	return

/proc/copy_type(var/obj/machinery/target, var/c_item, var/toner, var/do_print = TRUE, var/mob/user) // helper proc to reduce ctrl+c ctrl+v
	if (istype(c_item, /obj/item/paper))
		var/obj/item/paper/C = copy(target, c_item, do_print, do_print, 1 SECOND, toner, user)
		sleep(20)
		return C
	else if (istype(c_item, /obj/item/photo))
		var/obj/item/photo/P = photocopy(target, c_item, toner)
		sleep(20)
		return P
	else if (istype(c_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = bundlecopy(target, c_item, TRUE, toner)
		sleep(15*B.pages.len)
		return B
	else
		to_chat(usr, SPAN_WARNING("\The [c_item] can't be copied by \the [target]."))
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

/proc/copy(var/obj/machinery/target, var/obj/item/paper/copy, var/print = TRUE, var/use_sound = TRUE, var/delay = 10, var/toner, mob/user) // note: var/delay is the delay from copy to print, it should be less than the sleep in copy_type()
	var/obj/item/paper/c = new copy.type(target)
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
	c.desc = copy.desc
	if(istype(copy, /obj/item/paper/business_card))
		c.color = copy.color
	else
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

	if(!toner)
		target.visible_message(SPAN_NOTICE("A red light on \the [target] flashes, indicating that it is out of toner."))
		if(target.type == /obj/machinery/photocopier)
			flick("photocopier_notoner", target)
		playsound(target.loc, 'sound/machines/buzz-two.ogg', 75, 1)
		return

	c.set_content_unsafe(pname, info)
	if (print)
		if(istype(target, /obj/machinery/photocopier))
			var/obj/machinery/photocopier/T = target
			flick(T.print_animation, target)
			--T.toner
		target.print(c, use_sound, 'sound/bureaucracy/print.ogg', delay, user = user)
	return c

/proc/photocopy(var/obj/machinery/target, var/obj/item/photo/photocopy, var/toner)
	var/obj/item/photo/p = photocopy.copy()
	p.forceMove(target.loc)

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
		target.visible_message(SPAN_NOTICE("A red light on \the [target] flashes, indicating that it is out of toner."))
		if(target.type == /obj/machinery/photocopier)
			flick("photocopier_notoner", target)
		playsound(target.loc, 'sound/machines/buzz-two.ogg', 75, 1)
	if(target.type == /obj/machinery/photocopier)
		var/obj/machinery/photocopier/T = target
		T.toner -= 5
		flick("photocopier_print", target)
		playsound(target.loc, 'sound/bureaucracy/print.ogg', 75, 1)
	return p

//If need_toner is 0, the copies will still be lightened when low on toner, however it will not be prevented from printing. TODO: Implement print queues for fax machines and get rid of need_toner
/proc/bundlecopy(var/obj/machinery/target, var/obj/item/paper_bundle/bundle, var/need_toner = TRUE, var/toner, var/do_print = TRUE)
	var/obj/item/paper_bundle/p = new /obj/item/paper_bundle(target)
	for(var/obj/item/W in bundle.pages)
		if(toner <= 0 && need_toner)
			toner = 0
			target.visible_message(SPAN_NOTICE("A red light on \the [target] flashes, indicating that it is out of toner."))
			if(target.type == /obj/machinery/photocopier)
				var/obj/machinery/photocopier/T = target
				flick("photocopier_notoner", target)
				--T.toner
			playsound(target.loc, 'sound/machines/buzz-two.ogg', 75, 1)
			break


		W = copy_type(target, W, need_toner ? toner : 15, do_print)
		W.forceMove(p)
		p.pages += W

	p.forceMove(target.loc)
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
