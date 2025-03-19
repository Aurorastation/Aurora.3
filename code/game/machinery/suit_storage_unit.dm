//////////////////////////////////////
// SUIT STORAGE UNIT /////////////////
//////////////////////////////////////


/obj/machinery/suit_storage_unit
	name = "Suit Storage Unit"
	desc = "An industrial U-Stor-It Storage unit designed to accomodate all kinds of space suits. Its on-board equipment also allows the user to decontaminate the contents through a UV-ray purging cycle. There's a warning label dangling from the control pad, reading \"STRICTLY NO BIOLOGICALS IN THE CONFINES OF THE UNIT\"."
	icon = 'icons/obj/machinery/suit_storage.dmi'
	icon_state = "classic"
	anchored = TRUE
	density = TRUE
	var/mob/living/carbon/human/OCCUPANT
	var/obj/item/clothing/suit/space/SUIT
	var/SUIT_TYPE
	var/obj/item/clothing/head/helmet/space/HELMET
	var/HELMET_TYPE
	var/obj/item/clothing/mask/MASK //All the stuff that's gonna be stored insiiiiiiiiiiiiiiiiiiide, nyoro~n
	var/MASK_TYPE //Erro's idea on standarising SSUs whle keeping creation of other SSU types easy: Make a child SSU, name it something then set the TYPE vars to your desired suit output. New() should take it from there by itself.
	var/isopen = FALSE
	var/islocked = FALSE
	var/isUV = FALSE
	var/ispowered = TRUE //starts powered
	var/isbroken = FALSE
	var/issuperUV = FALSE
	var/panelopen = FALSE
	var/safetieson = TRUE
	var/cycletime_left = 0

//The units themselves/////////////////

/obj/machinery/suit_storage_unit/standard_unit
	SUIT_TYPE = /obj/item/clothing/suit/space
	HELMET_TYPE = /obj/item/clothing/head/helmet/space
	MASK_TYPE = /obj/item/clothing/mask/breath


/obj/machinery/suit_storage_unit/Initialize()
	. = ..()
	update_icon()
	if(SUIT_TYPE)
		SUIT = new SUIT_TYPE(src)
	if(HELMET_TYPE)
		HELMET = new HELMET_TYPE(src)
	if(MASK_TYPE)
		MASK = new MASK_TYPE(src)

/obj/machinery/suit_storage_unit/update_icon()
	ClearOverlays()

	if(panelopen)
		AddOverlays("[initial(icon_state)]_panel")
	if(isopen)
		AddOverlays("[initial(icon_state)]_open")
		if(SUIT)
			AddOverlays("[initial(icon_state)]_suit")
		if(HELMET)
			AddOverlays("[initial(icon_state)]_helm")
		if(MASK)
			AddOverlays("[initial(icon_state)]_storage")
	if(!isbroken && ispowered)
		if(isopen)
			AddOverlays("[initial(icon_state)]_lights_open")
		else
			if(isUV)
				if(issuperUV)
					AddOverlays("[initial(icon_state)]_super")
				AddOverlays("[initial(icon_state)]_lights_red")
			else
				AddOverlays("[initial(icon_state)]_lights_closed")
		//top lights
		if(isUV)
			if(issuperUV)
				AddOverlays("[initial(icon_state)]_uvstrong")
			else
				AddOverlays("[initial(icon_state)]_uv")
		else if(islocked)
			AddOverlays("[initial(icon_state)]_locked")
		else
			AddOverlays("[initial(icon_state)]_ready")

/obj/machinery/suit_storage_unit/power_change()
	..()
	if( !(stat & NOPOWER) )
		src.ispowered = 1
		src.update_icon()
	else
		addtimer(CALLBACK(src, PROC_REF(handle_power_return)), rand(1, 15))


/obj/machinery/suit_storage_unit/proc/handle_power_return()
	src.ispowered = 0
	src.islocked = 0
	src.isopen = 1
	src.dump_everything()
	src.update_icon()

/obj/machinery/suit_storage_unit/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(50))
				src.dump_everything() //So suits dont survive all the time
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				src.dump_everything()
				qdel(src)
			return
		else
			return

/obj/machinery/suit_storage_unit/attack_hand(mob/user as mob)
	var/dat
	if(..())
		return
	if(stat & NOPOWER)
		return
	if(!user.IsAdvancedToolUser())
		return 0
	if(src.panelopen) //The maintenance panel is open. Time for some shady stuff
		dat+= ""
		dat+= "<Font color ='black'><B>Maintenance panel controls</B></font><HR>"
		dat+= "<font color ='grey'>The panel is ridden with controls, button and meters, labeled in strange signs and symbols that <BR>you cannot understand. Probably the manufactoring world's language.<BR> Among other things, a few controls catch your eye.<BR><BR></font>"
		dat+= "<font color ='black'>A small dial with a \"ë\" symbol embroidded on it. It's pointing towards a gauge that reads [(src.issuperUV ? "15nm" : "185nm")]</font>.<BR> <span class='notice'><A href='byond://?src=[REF(src)];toggleUV=1'> Turn towards [(src.issuperUV ? "185nm" : "15nm")]</A><BR></span>"
		dat+= "<font color ='black'>A thick old-style button, with 2 grimy LED lights next to it. The [(src.safetieson? "<font color='green'><B>GREEN</B></font>" : SPAN_WARNING("<B>RED</B>"))] LED is on.</font><BR><font color ='blue'><A href='byond://?src=[REF(src)];togglesafeties=1'>Press button</a></font>"
		dat+= "<HR><BR><A href='byond://?src=[REF(user)];mach_close=suit_storage_unit'>Close panel</A>"
		//user << browse(dat, "window=ssu_m_panel;size=400x500")
		//onclose(user, "ssu_m_panel")
	else if(src.isUV) //The thing is running its cauterisation cycle. You have to wait.
		dat += "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
		dat+= "<font color ='red'><B>Unit is cauterising contents with selected UV ray intensity. Please wait.</font></B><BR>"
		//dat+= "<font colr='black'><B>Cycle end in: [src.cycletimeleft()] seconds. </font></B>"
		//user << browse(dat, "window=ssu_cycling_panel;size=400x500")
		//onclose(user, "ssu_cycling_panel")

	else
		if(!src.isbroken)
			dat+= ""
			dat+= "<span class='notice'><font size = 4><B>U-Stor-It Suit Storage Unit, model DS1900</B></span><BR>"
			dat+= "<B>Welcome to the Unit control panel.</B></FONT><HR>"
			dat+= "<font color='black'>Helmet storage compartment: <B>[(src.HELMET ? HELMET.name : "</font><font color ='grey'>No helmet detected.")]</B></font><BR>"
			if(HELMET && src.isopen)
				dat += "<A href='byond://?src=[REF(src)];dispense_helmet=1'>Dispense helmet</A><BR>"
			dat+= "<font color='black'>Suit storage compartment: <B>[(src.SUIT ? SUIT.name : "</font><font color ='grey'>No exosuit detected.")]</B></font><BR>"
			if(SUIT && src.isopen)
				dat += "<A href='byond://?src=[REF(src)];dispense_suit=1'>Dispense suit</A><BR>"
			dat+= "<font color='black'>Breathmask storage compartment: <B>[(src.MASK ? MASK.name : "</font><font color ='grey'>No breathmask detected.")]</B></font><BR>"
			if(MASK && src.isopen)
				dat += "<A href='byond://?src=[REF(src)];dispense_mask=1'>Dispense mask</A><BR>"
			if(src.OCCUPANT)
				dat+= "<HR><B><font color ='red'>WARNING: Biological entity detected inside the Unit's storage. Please remove.</B></font><BR>"
				dat+= "<A href='byond://?src=[REF(src)];eject_guy=1'>Eject extra load</A>"
			dat += "<HR><font color='black'>Unit is: [(src.isopen ? "Open" : "Closed")] - <A href='byond://?src=[REF(src)];toggle_open=1'>[(src.isopen ? "Close" : "Open")] Unit</A></font> "
			if(src.isopen)
				dat+="<HR>"
			else
				dat += " - <A href='byond://?src=[REF(src)];toggle_lock=1'><font color ='orange'>*[(src.islocked ? "Unlock" : "Lock")] Unit*</A></font><HR>"
			dat+= "Unit status: [(src.islocked? "<font color ='red'><B>**LOCKED**</B></font><BR>" : "<font color ='green'><B>**UNLOCKED**</B></font><BR>")]"
			dat+= "<A href='byond://?src=[REF(src)];start_UV=1'>Start Disinfection cycle</A><BR>"
			dat += "<BR><BR><A href='byond://?src=[REF(user)];mach_close=suit_storage_unit'>Close control panel</A>"
			//user << browse(dat, "window=Suit Storage Unit;size=400x500")
			//onclose(user, "Suit Storage Unit")
		else //Ohhhh shit it's dirty or broken! Let's inform the guy.
			dat+= ""
			dat+= "<font color='maroon'><B>Unit chamber is too contaminated to continue usage. Please call for a qualified individual to perform maintenance.</font></B><BR><BR>"
			dat+= "<HR><A href='byond://?src=[REF(user)];mach_close=suit_storage_unit'>Close control panel</A>"
			//user << browse(dat, "window=suit_storage_unit;size=400x500")
			//onclose(user, "suit_storage_unit")


	user << browse(dat, "window=suit_storage_unit;size=400x500")
	onclose(user, "suit_storage_unit")
	return


/obj/machinery/suit_storage_unit/Topic(href, href_list) //I fucking HATE this proc
	if(..())
		return
	if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon/ai)))
		usr.set_machine(src)
		if (href_list["toggleUV"])
			src.toggleUV(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["togglesafeties"])
			src.togglesafeties(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_helmet"])
			src.dispense_helmet(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_suit"])
			src.dispense_suit(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["dispense_mask"])
			src.dispense_mask(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["toggle_open"])
			src.toggle_open(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["toggle_lock"])
			src.toggle_lock(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["start_UV"])
			src.start_UV(usr)
			src.updateUsrDialog()
			src.update_icon()
		if (href_list["eject_guy"])
			src.eject_occupant(usr)
			src.updateUsrDialog()
			src.update_icon()
	/*if (href_list["refresh"])
		src.updateUsrDialog()*/
	src.add_fingerprint(usr)
	return


/obj/machinery/suit_storage_unit/proc/toggleUV(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen)
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow))
				protected = 1

	if(!protected)
		playsound(src.loc, /singleton/sound_category/spark_sound, 75, 1, -1)
		to_chat(user, SPAN_WARNING("You try to touch the controls but you get zapped. There must be a short circuit somewhere."))
		return*/
	else  //welp, the guy is protected, we can continue
		if(src.issuperUV)
			to_chat(user, "You slide the dial back towards \"185nm\".")
			src.issuperUV = 0
		else
			to_chat(user, "You crank the dial all the way up to \"15nm\".")
			src.issuperUV = 1
		return


/obj/machinery/suit_storage_unit/proc/togglesafeties(mob/user as mob)
//	var/protected = 0
//	var/mob/living/carbon/human/H = user
	if(!src.panelopen) //Needed check due to bugs
		return

	/*if(istype(H)) //Let's check if the guy's wearing electrically insulated gloves
		if(H.gloves)
			var/obj/item/clothing/gloves/G = H.gloves
			if(istype(G,/obj/item/clothing/gloves/yellow) )
				protected = 1

	if(!protected)
		playsound(src.loc, /singleton/sound_category/spark_sound, 75, 1, -1)
		to_chat(user, SPAN_WARNING("You try to touch the controls but you get zapped. There must be a short circuit somewhere."))
		return*/
	else
		to_chat(user, "You push the button. The coloured LED next to it changes.")
		src.safetieson = !src.safetieson


/obj/machinery/suit_storage_unit/proc/dispense_helmet(mob/user as mob)
	if(!src.HELMET)
		return //Do I even need this sanity check? Nyoro~n
	else
		src.HELMET.forceMove(src.loc)
		src.HELMET = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_suit(mob/user as mob)
	if(!src.SUIT)
		return
	else
		src.SUIT.forceMove(src.loc)
		src.SUIT = null
		return


/obj/machinery/suit_storage_unit/proc/dispense_mask(mob/user as mob)
	if(!src.MASK)
		return
	else
		src.MASK.forceMove(src.loc)
		src.MASK = null
		return


/obj/machinery/suit_storage_unit/proc/dump_everything()
	src.islocked = 0 //locks go free
	if(src.SUIT)
		src.SUIT.forceMove(src.loc)
		src.SUIT = null
	if(src.HELMET)
		src.HELMET.forceMove(src.loc)
		src.HELMET = null
	if(src.MASK)
		src.MASK.forceMove(src.loc)
		src.MASK = null
	if(src.OCCUPANT)
		src.eject_occupant(OCCUPANT)
	return


/obj/machinery/suit_storage_unit/proc/toggle_open(mob/user as mob)
	if(src.islocked || src.isUV)
		to_chat(user, SPAN_WARNING("Unable to open unit."))
		return
	if(src.OCCUPANT)
		src.eject_occupant(user)
		return  // eject_occupant opens the door, so we need to return
	src.isopen = !src.isopen
	return


/obj/machinery/suit_storage_unit/proc/toggle_lock(mob/user as mob)
	if(src.OCCUPANT && src.safetieson)
		to_chat(user, SPAN_WARNING("The Unit's safety protocols disallow locking when a biological form is detected inside its compartments."))
		return
	if(src.isopen)
		return
	src.islocked = !src.islocked
	return


/obj/machinery/suit_storage_unit/proc/start_UV(mob/user as mob)
	if(src.isUV || src.isopen) //I'm bored of all these sanity checks
		return
	if(src.OCCUPANT && src.safetieson)
		to_chat(user, SPAN_WARNING("<B>WARNING:</B> Biological entity detected in the confines of the Unit's storage. Cannot initiate cycle."))
		return
	if(!src.HELMET && !src.MASK && !src.SUIT && !src.OCCUPANT ) //shit's empty yo
		to_chat(user, SPAN_WARNING("Unit storage bays empty. Nothing to disinfect -- Aborting."))
		return
	to_chat(user, "You start the Unit's cauterisation cycle.")
	src.cycletime_left = 20
	src.isUV = 1
	if(src.OCCUPANT && !src.islocked)
		src.islocked = 1 //Let's lock it for good measure
	src.update_icon()
	src.updateUsrDialog()

	var/i //our counter
	for(i=0,i<4,i++)
		sleep(50)
		if(src.OCCUPANT)
			OCCUPANT.apply_radiation(50)
			if (!OCCUPANT.is_diona())
				if(src.issuperUV)
					var/burndamage = rand(28,35)
					OCCUPANT.take_organ_damage(0,burndamage)
					if (OCCUPANT.can_feel_pain())
						OCCUPANT.emote("scream")
				else
					var/burndamage = rand(6,10)
					OCCUPANT.take_organ_damage(0,burndamage)
					if (OCCUPANT.can_feel_pain())
						OCCUPANT.emote("scream")
		if(i==3) //End of the cycle
			if(!src.issuperUV)
				if(src.HELMET)
					HELMET.clean_blood()
				if(src.SUIT)
					SUIT.clean_blood()
				if(src.MASK)
					MASK.clean_blood()
			else //It was supercycling, destroy everything
				if(src.HELMET)
					src.HELMET = null
				if(src.SUIT)
					src.SUIT = null
				if(src.MASK)
					src.MASK = null
				visible_message(SPAN_WARNING("With a loud whining noise, [src]'s door grinds open. Puffs of ashen smoke come out of its chamber."), range = 3)
				src.isbroken = 1
				src.isopen = 1
				src.islocked = 0
				src.eject_occupant(OCCUPANT) //Mixing up these two lines causes bug. DO NOT DO IT.
			src.isUV = 0 //Cycle ends
	src.update_icon()
	src.updateUsrDialog()
	return

/obj/machinery/suit_storage_unit/proc/cycletimeleft()
	if(src.cycletime_left >= 1)
		src.cycletime_left--
	return src.cycletime_left

/obj/machinery/suit_storage_unit/proc/eject_occupant(mob/user as mob)
	if (src.islocked)
		return

	if (!src.OCCUPANT)
		return

	if (src.OCCUPANT.client)
		if(user != OCCUPANT)
			to_chat(OCCUPANT, SPAN_NOTICE("The machine kicks you out!"))
		if(user.loc != src.loc)
			to_chat(OCCUPANT, SPAN_NOTICE("You leave the not-so-cozy confines of the SSU."))

		src.OCCUPANT.client.eye = src.OCCUPANT.client.mob
		src.OCCUPANT.client.perspective = MOB_PERSPECTIVE
	src.OCCUPANT.forceMove(src.loc)
	src.OCCUPANT = null
	if(!src.isopen)
		src.isopen = 1
	src.update_icon()
	return


/obj/machinery/suit_storage_unit/verb/get_out()
	set name = "Eject Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.eject_occupant(usr)
	add_fingerprint(usr)
	src.updateUsrDialog()
	src.update_icon()
	return


/obj/machinery/suit_storage_unit/verb/move_inside()
	set name = "Hide in Suit Storage Unit"
	set category = "Object"
	set src in oview(1)

	if (usr.stat != 0)
		return
	if (!src.isopen)
		to_chat(usr, SPAN_WARNING("The unit's doors are shut."))
		return
	if (!src.ispowered || src.isbroken)
		to_chat(usr, SPAN_WARNING("The unit is not operational."))
		return
	if ( (src.OCCUPANT) || (src.HELMET) || (src.SUIT) )
		to_chat(usr, SPAN_WARNING("It's too cluttered inside for you to fit in!"))
		return
	usr.visible_message(SPAN_NOTICE("[usr] starts squeezing into [src]!"),
						SPAN_NOTICE("You start squeezing into [src]!"), range = 3)

	if(do_after(usr, 1 SECOND, src, DO_UNIQUE))
		usr.stop_pulling()
		usr.client.perspective = EYE_PERSPECTIVE
		usr.client.eye = src
		usr.forceMove(src)
		src.OCCUPANT = usr
		src.isopen = 0 //Close the thing after the guy gets inside
		src.update_icon()

		src.add_fingerprint(usr)
		src.updateUsrDialog()
		return
	else
		src.OCCUPANT = null //Testing this as a backup sanity test
	return


/obj/machinery/suit_storage_unit/attackby(obj/item/attacking_item, mob/user)
	if(!src.ispowered)
		return TRUE
	if(attacking_item.isscrewdriver())
		src.panelopen = !src.panelopen
		attacking_item.play_tool_sound(get_turf(src), 100)
		to_chat(user, SPAN_NOTICE("You [src.panelopen ? "open up" : "close"] the unit's maintenance panel."))
		update_icon()
		src.updateUsrDialog()
		return TRUE
	if ( istype(attacking_item, /obj/item/grab) )
		var/obj/item/grab/G = attacking_item
		if( !(ismob(G.affecting)) )
			return TRUE
		if (!src.isopen)
			to_chat(usr, SPAN_WARNING("The unit's doors are shut."))
			return TRUE
		if (!src.ispowered || src.isbroken)
			to_chat(usr, SPAN_WARNING("The unit is not operational."))
			return TRUE
		if ( (src.OCCUPANT) || (src.HELMET) || (src.SUIT) ) //Unit needs to be absolutely empty
			to_chat(user, SPAN_WARNING("The unit's storage area is too cluttered."))
			return TRUE
		user.visible_message(SPAN_NOTICE("[user] starts putting [G.affecting] into [src]."),
								SPAN_NOTICE("You start putting [G.affecting] into [src]."),
								range = 3)

		if(do_after(user, 2 SECONDS, src, DO_UNIQUE))
			if(!G || !G.affecting) return TRUE //derpcheck
			var/mob/M = G.affecting
			if (M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src
			M.forceMove(src)
			src.OCCUPANT = M
			src.isopen = 0 //close ittt
			src.add_fingerprint(user)
			qdel(G)
			src.updateUsrDialog()
			src.update_icon()
			return TRUE
		return TRUE
	if( istype(attacking_item,/obj/item/clothing/suit/space) )
		if(!src.isopen)
			return TRUE
		var/obj/item/clothing/suit/space/S = attacking_item
		if(src.SUIT)
			to_chat(user, SPAN_NOTICE("The unit already contains a suit."))
			return TRUE
		to_chat(user, "You load the [S.name] into the storage compartment.")
		user.drop_from_inventory(S,src)
		src.SUIT = S
		src.update_icon()
		src.updateUsrDialog()
		return TRUE
	if( istype(attacking_item,/obj/item/clothing/head/helmet) )
		if(!src.isopen)
			return TRUE
		var/obj/item/clothing/head/helmet/H = attacking_item
		if(src.HELMET)
			to_chat(user, SPAN_NOTICE("The unit already contains a helmet."))
			return TRUE
		to_chat(user, "You load the [H.name] into the storage compartment.")
		user.drop_from_inventory(H,src)
		src.HELMET = H
		src.update_icon()
		src.updateUsrDialog()
		return TRUE
	if( istype(attacking_item,/obj/item/clothing/mask) )
		if(!src.isopen)
			return TRUE
		var/obj/item/clothing/mask/M = attacking_item
		if(src.MASK)
			to_chat(user, SPAN_NOTICE("The unit already contains a mask."))
			return TRUE
		to_chat(user, "You load the [M.name] into the storage compartment.")
		user.drop_from_inventory(M,src)
		src.MASK = M
		src.update_icon()
		src.updateUsrDialog()
		return TRUE
	src.update_icon()
	src.updateUsrDialog()


/obj/machinery/suit_storage_unit/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)
