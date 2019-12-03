var/list/augmentations = typesof(/datum/augment) - /datum/augment


/datum/augment
	var/name = "augment"
	var/linkedaugment = null

/datum/augment/brainaugment

	name = "Augmented Brain"
	linkedaugment = /obj/item/organ/internal/augment/aci




/obj/item/organ/internal/augment
	name = "aug"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "screen"
	var/action_icon = "ams"
	action_button_name = "Toggle Augment"
	var/augmenthp = 50

	robotic = 2

	emp_coeff = 1

	var/online = 0
	var/list/install_locations = list()



/obj/item/organ/internal/augment/Initialize()
	START_PROCESSING(SSfast_process, src)
	robotize()
	. = ..()


/obj/item/organ/internal/augment/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = action_icon
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/internal/augment/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(!online)
			return

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

/obj/item/organ/internal/augment/process()
	..()
	if(!online)
		return
	if(damage >= max_damage)
		die()

/////////////////
/////////////////
/////////////////

/obj/item/organ/internal/augment/aci
	name = "Augmented Cranial Implant"
	action_icon = "aci"
	icon_state = "aci"
	var/connected = FALSE
	var/useraccount = null

/obj/item/organ/internal/augment/aci/proc/augmentbrain(var/mob/user)

	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/IO = H.internal_organs_by_name["brain"]
	IO.name = "Augmented Brain"
	IO.icon_state = "brain-prosthetic"
	H.add_language(LANGUAGE_ERDANICYBER)


/obj/item/organ/internal/augment/aci/Initialize()
	augmentbrain()
	robotize()
	. = ..()


/obj/item/organ/internal/augment/aci/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/userid = H.mind.holonetname
	if(.)


		var/list/acisettings = list("Toggle Connection", "Change ID","Insert ID","Shop For Augments", "Cancel")

		var/acimode = input("Select A.C.I Operation.", "Hephaestus Industries ACI os.V335") as null|anything in acisettings

		switch(acimode)

			if("Toggle Connection")
				if(!connected)
					to_chat(H, "<span class='warning'>Disconnected from the HoloNet, goodbye [userid] </span>")
					connected = TRUE
					H.remove_language(LANGUAGE_ERDANICYBER)
				if(connected)
					to_chat(H, "<span class='warning'>Now connected to the HoloNet, welcome [userid] </span>")
					connected = FALSE
					H.add_language(LANGUAGE_ERDANICYBER)

			if("Change ID")
				if(connected == 0)
					to_chat(H, "<span class='warning'>You must be connected to change your ID</span>")
					return
				if(connected == 1)
					var/idinput = sanitize(input("Enter Username.", "Set Name") as text|null)
					H.mind.holonetname = idinput
					to_chat(H, "<span class='warning'>Your HoloChat name is now [idinput], restarting connection</span>")

			if("Insert ID")
				var/obj/item/card/I = user.get_active_hand()
				if (istype(I, /obj/item/card/id))
					useraccount += I.associated_account_number
					to_chat(H, "<span class='warning'>Financial Info saved!</span>")


/obj/item/organ/internal/augment/integratedtesla
	name = "tesla unit"
	organ_tag = "tesla unit"
	parent_organ = "groin"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "surge"
	action_button_name = "Emmit Tesla Arc"
	vital = 0
	emp_coeff = 0.1
	install_locations = list(ARM_LEFT, ARM_RIGHT, HEAD)
	var/obj/item/cell/teslacell
	var/celldischarge = 1000

/obj/item/organ/internal/augment/integratedtesla/Initialize()
	START_PROCESSING(SSfast_process, src)
	teslacell = new/obj/item/cell/high(src)
	robotize()
	. = ..()

/obj/item/organ/internal/augment/integratedtesla/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "teslaunit"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/internal/augment/integratedtesla/get_cell()
	return teslacell

/obj/item/organ/internal/augment/integratedtesla/proc/teslacelldeduct(var/chargeremoveal)
	if(teslacell)
		if(teslacell.checked_use(chargeremoveal))
			return 1
		else
			status = 0
			return 0
	return null

/obj/item/organ/internal/augment/integratedtesla/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell))
		if(!teslacell)
			user.drop_from_inventory(W,src)
			teslacell = W
			to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
		else
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")

	else if(W.isscrewdriver())
		if(teslacell)
			teslacell.update_icon()
			teslacell.forceMove(get_turf(src))
			teslacell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			return
		..()
	return

/obj/item/organ/internal/augment/integratedtesla/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(.)


		var/list/teslasettings = list("Emmit Tesla", "Set Tesla Volts", "Cancel")

		var/teslamode = input("Select tesla Operation.", "Uncle Kalvins Zapp-A-Do(TM)") as null|anything in teslasettings


		switch(teslamode)


			if("Emmit Tesla")
				if(teslacell && teslacell.charge > celldischarge)
					var/turf/T = get_turf(owner)
					if(!T.density)
						for(var/mob/A in T)
							playsound(loc, "sparks", 75, 1, -1)
							tesla_zap(T, 6, celldischarge)
							tesla_zap(owner, 6, celldischarge)
							tesla_zap(A, 3, celldischarge)
							update_icon()
					for (var/obj/machinery/power/apc/APC in range(25, T))
						for (var/obj/item/cell/B in APC.contents)
							B.charge += celldischarge
					for (var/mob/living/silicon/robot/M in range(6, T))
						for (var/obj/item/cell/D in M.contents)
							D.charge += celldischarge
					teslacelldeduct(celldischarge)
					H.nutrition -= celldischarge
				else
					return
			if("Set Tesla Volts")
				var/teslainput = input(owner, "Enter Tesla output.", "Uncle Kalvins Zapp-A-Do(TM)", "") as num
				if(teslainput > teslacell.charge)
					to_chat(H, "<span class='warning'>\The [src]'s input is higher then the cells charge!</span>")
					return
				else
					celldischarge = teslainput
					to_chat(H, "<span class='notice'>The Tesla output is now at [celldischarge]</span>")

			if("Charge Tesla")
				var/teslacharge = input(owner, "Enter Tesla Charge.", "Uncle Kalvins Zapp-A-Do(TM)", "") as num
				if(H.nutrition >= teslacharge)
					to_chat(H, "<span class='warning'>\The [src]'s You cant drain more power then you have!</span>")
					return
				if(H.nutrition >= 0)
					to_chat(H, "<span class='warning'>You have no power!!</span>")
					return
				else
					teslacell.charge += teslacharge
					H.nutrition -= teslacharge

					to_chat(H, "<span class='notice'>The Tesla cell is now at [teslacell.charge]</span>")


