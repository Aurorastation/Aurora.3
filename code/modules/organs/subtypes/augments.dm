var/list/augmentations = typesof(/datum/augment) - /datum/augment


/datum/augment
	var/name = "augment"
	var/linkedaugment = null

/datum/augment/timepiece
	name = "integrated timepiece"
	linkedaugment = /obj/item/organ/augment/timepiece

/datum/augment/pda
	name = "integrated PDA"
	linkedaugment = /obj/item/organ/augment/pda

/datum/augment/synthhair
	name = "synthetic multicolored hair"
	linkedaugment = /obj/item/organ/augment/multihair

/datum/augment/syntheye
	name = "synthetic eye color"
	linkedaugment = /obj/item/organ/augment/multieye

/datum/augment/brainaugment

	name = "Augmented Brain"
	linkedaugment = /obj/item/organ/augment/aci




/obj/item/organ/augment
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



/obj/item/organ/augment/Initialize()
	START_PROCESSING(SSfast_process, src)
	robotize()
	. = ..()


/obj/item/organ/augment/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = action_icon
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/attack_self(var/mob/user)
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

/obj/item/organ/augment/process()
	..()
	if(!online)
		return
	if(augmenthp <= 0)
		name = "Broken [src.name]"
		spark(owner.loc, 5)
		playsound(owner.loc, "sparks", 50, 1)
		owner.visible_message("<span class='notice'>\The [owner]'s [src.name] .</span>")
		src.forceMove(owner.loc)
		online = 0

/////////////////
/////////////////
/////////////////

/obj/item/organ/augment/aci
	name = "Augmented Cranial Implant"
	action_icon = "aci"
	icon_state = "aci"
	var/connected = FALSE
	var/useraccount = null

/obj/item/organ/augment/aci/proc/augmentbrain(var/mob/user)

	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/IO = H.internal_organs_by_name["brain"]
	IO.name = "Augmented Brain"
	IO.icon_state = "brain-prosthetic"
	H.add_language(LANGUAGE_ERDANICYBER)


/obj/item/organ/augment/aci/Initialize()
	augmentbrain()
	robotize()
	. = ..()


/obj/item/organ/augment/aci/attack_self(var/mob/user)
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
				var/obj/item/weapon/card/I = user.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					useraccount += I.associated_account_number
					to_chat(H, "<span class='warning'>Financial Info saved!</span>")

/obj/item/organ/augment/timepiece
	name = "integrated timepiece"
	action_icon = "time"

/obj/item/organ/augment/timepiece/attack_self(var/mob/user)
	. = ..()
	to_chat(user, "<span class='warning'>Hello [user], it is currently: '[worldtime2text()]'. Today's date is '[time2text(world.time, "Month DD")]. [game_year]'. Have a lovely day</span>")
	if (emergency_shuttle.get_status_panel_eta())
		to_chat(user, "<span class='warning'>Notice: You have one (1) scheduled flight, ETA: [emergency_shuttle.get_status_panel_eta()].</span>")

/obj/item/organ/augment/pda
	name = "integrated PDA"
	action_icon = "pda"
	var/obj/item/device/pda/P

/obj/item/organ/augment/pda/Initialize()
	. = ..()
	if(!P)
		P = new /obj/item/device/pda (src)
		P.canremove = 0

/obj/item/organ/augment/pda/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "teslaunit"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/pda/attack_self(var/mob/user)
	. = ..()
	if(P)
		if(!P.owner)
			var/obj/item/weapon/card/id/idcard = owner.get_active_hand()
			if(istype(idcard))
				P.owner = idcard.registered_name
				P.ownjob = idcard.assignment
				P.ownrank = idcard.rank
				P.name = "Integrated PDA-[P.owner] ([P.ownjob])"
				to_chat(user, "<span class='notice'>Card scanned.</span>")
				P.try_sort_pda_list()
			else
				to_chat(user, "<span class='notice'>No ID data loaded. Please hold your ID to be scanned.</span>")
				return

		P.attack_self(user)
	return

/obj/item/organ/augment/multihair
	name = "synthetic multicolored hair"
	install_locations = list(HEAD)

/obj/item/organ/augment/multihair/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(user))
		H.change_appearance(APPEARANCE_ALL_HAIR, usr, usr, check_species_whitelist = 1, state = z_state)
		owner.update_dna()
		owner.visible_message("<span class='notice'>\The [owner]'s hair rapidly shifts, forming into a new style.</span>")
		return 1

/obj/item/organ/augment/multieye
	name = "synthetic eye"
	action_icon = "eyecolor"
	install_locations = list(HEAD)

/obj/item/organ/augment/multieye/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(ishuman(user))
		H.change_appearance(APPEARANCE_EYE_COLOR, usr, usr, check_species_whitelist = 1, state = z_state)
		owner.update_dna()
		owner.visible_message("<span class='notice'>\The [owner]'s eyes rapidly shifts color.</span>")
		return 1

/////////////////
//TOOL AUGMENTS// - they spawn a tool when they operate
/////////////////

/obj/item/organ/augment/tool
	name = "retractable widget"
	action_button_name = "Deploy Widget"
	action_icon = "digitool"
	var/augment_type
	var/obj/item/augment
	var/deployed = 0
	var/cooldown = 100
	install_locations = list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)
	var/deployment_location
	var/deployment_string

/obj/item/organ/augment/tool/Initialize()
	. = ..()
	if(augment_type)
		augment = new augment_type(src)
		augment.canremove = 0

/obj/item/organ/augment/tool/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "digitool"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/tool/attack_self(var/mob/user)
	. = ..()

	if(.)
		if(!deployed)
			if(!deployment_location)
				if(owner.get_active_hand())
					to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
					return

				owner.last_special = world.time + cooldown
				owner.put_in_active_hand(augment)
				owner.visible_message("<span class='notice'>\The [augment] slides out of \the [owner]'s [src.loc].</span>","<span class='notice'>You deploy \the [augment]!</span>")
				deployed = 1

			else
				if(!owner.equip_to_slot_if_possible(augment, deployment_location))
					to_chat(owner, "<span class='danger'>You must remove your [deployment_string] before enabling your [src]!</span>")
					return

				owner.last_special = world.time + cooldown
				owner.visible_message("<span class='notice'>\The [augment] slides out of \the [owner]'s [src.loc].</span>","<span class='notice'>You deploy \the [augment]!</span>")
				deployed = 1

		else
			owner.last_special = world.time + cooldown
			user.drop_from_inventory(augment)
			augment.forceMove(src)
			owner.visible_message("<span class='notice'>\The [augment] slides into \the [owner]'s [src.loc].</span>","<span class='notice'>You retract \the [augment]!</span>")
			deployed = 0

/obj/item/organ/augment/tool/combitool
	name = "retractable combitool"
	action_button_name = "Deploy Combitool"
	augment_type = /obj/item/combitool/robotic

/obj/item/organ/augment/tool/combipen
	name = "retractable combipen"
	action_button_name = "Deploy Combipen"
	action_icon = "pen"
	augment_type = /obj/item/weapon/pen/multi
	cooldown = 10

/obj/item/organ/augment/tool/magfeet
	name = "magnetic soles"
	action_button_name = "Deploy Magnetic Soles"
	action_icon = "magboots"
	augment_type = /obj/item/clothing/shoes/magnetic
	deployment_location = slot_shoes
	deployment_string = "shoes"
	install_locations = list(FOOT_LEFT, FOOT_RIGHT)

/obj/item/clothing/shoes/magnetic
	name = "magnetic soles"
	magnetic = 1
	item_flags = NOSLIP

/obj/item/organ/augment/tool/maghands
	name = "magnetic palms"
	action_button_name = "Deploy Magnetic Palms"
	action_icon = "magnetichands"
	augment_type = /obj/item/clothing/gloves/magnetic
	deployment_location = slot_gloves
	deployment_string = "gloves"
	install_locations = list(HAND_LEFT, HAND_RIGHT)

/obj/item/clothing/gloves/magnetic
	name = "magnetic palms"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "magnetichands"
	magnetic = 1


/obj/item/organ/augment/integratedtesla
	name = "tesla unit"
	organ_tag = "tesla unit"
	parent_organ = "groin"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "surge"
	action_button_name = "Emmit Tesla Arc"
	vital = 0
	emp_coeff = 0.1
	install_locations = list(ARM_LEFT, ARM_RIGHT, HEAD)
	var/obj/item/weapon/cell/teslacell
	var/celldischarge = 1000

/obj/item/organ/augment/integratedtesla/Initialize()
	START_PROCESSING(SSfast_process, src)
	teslacell = new/obj/item/weapon/cell/high(src)
	robotize()
	. = ..()

/obj/item/organ/augment/integratedtesla/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "teslaunit"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/augment/integratedtesla/get_cell()
	return teslacell

/obj/item/organ/augment/integratedtesla/proc/teslacelldeduct(var/chargeremoveal)
	if(teslacell)
		if(teslacell.checked_use(chargeremoveal))
			return 1
		else
			status = 0
			return 0
	return null

/obj/item/organ/augment/integratedtesla/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
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

/obj/item/organ/augment/integratedtesla/attack_self(var/mob/user)
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
						for (var/obj/item/weapon/cell/B in APC.contents)
							B.charge += celldischarge
					for (var/mob/living/silicon/robot/M in range(6, T))
						for (var/obj/item/weapon/cell/D in M.contents)
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


