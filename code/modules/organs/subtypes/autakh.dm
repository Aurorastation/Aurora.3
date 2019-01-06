/obj/item/organ/external/head/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/chest/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/chest/autakh/Initialize()
	. = ..()

	mechassist()

/obj/item/organ/external/groin/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/arm/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/arm/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/leg/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/leg/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/foot/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/foot/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/hand/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/hand/right/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

//internal organs

/obj/item/organ/kidneys/autakh
	name = "toxin screen"
	robotic = 1

/obj/item/organ/anchor
	name = "soul anchor"
	icon_state = "brain-prosthetic"
	organ_tag = "anchor"
	parent_organ = "head"
	robotic = 2

/obj/item/organ/eyes/autakh
	name = "bionic eyeballs"
	icon_state = "eyes"
	singular_name = "bionic eye"
	action_button_name = "Toggle Bionic Eyes Sensors"

	var/static/list/hud_types = list(
		"Disabled",
		"Security",
		"Medical")

	var/selected_hud = "Disabled"
	var/disabled = FALSE


/obj/item/organ/eyes/autakh/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use your \the [src] in your current state!</span>")
			return

		if(disabled || is_broken())
			to_chat(owner, "<span class='danger'>\The [src] shudders and sparks, unable to change their sensors!</span>")
			return

		owner.last_special = world.time + 100
		to_chat(owner, "<span class='notice'>Insert message here!</span>")

		var/choice = input("Select the Sensor Type.", "Bionic Eyes Sensors") as null|anything in hud_types

		selected_hud = choice

/obj/item/organ/eyes/autakh/process()
	..()

	if(!owner)
		return
	if(disabled)
		return

	switch(selected_hud)

		if("Security")
			req_access = list(access_security)
			if(allowed(owner))
				process_sec_hud(owner, 1)

		if("Medical")
			req_access = list(access_medical)
			if(allowed(owner))
				process_med_hud(owner, 1)

/obj/item/organ/eyes/autakh/flash_act()
	if(owner)
		to_chat(owner, "<span class='notice'>\The [src]'s retinal overlays are overloaded by the strong light!</span>")
		owner.eye_blind = 5
		owner.eye_blurry = 5
		spark(get_turf(owner), 3)
	disabled = TRUE
	selected_hud = "Disabled"
	addtimer(CALLBACK(src, .proc/rearm), 40 SECONDS)
	return

/obj/item/organ/eyes/autakh/emp_act(severity)
	..()
	disabled = TRUE
	selected_hud = "Disabled"
	addtimer(CALLBACK(src, .proc/rearm), 40 SECONDS)

/obj/item/organ/eyes/autakh/proc/rearm()

	disabled = FALSE

	if(owner)
		to_chat(owner, "<span class='notice'>\The [src]'s retinal overlays clicks and shifts!</span>")

/obj/item/organ/adrenal
	name = "adrenal management system"
	icon_state = "brain-prosthetic"
	organ_tag = "adrenal"
	parent_organ = "chest"
	robotic = 2
	action_button_name = "Activate Adrenal Management System"

/obj/item/organ/adrenal/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "placeholder"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/adrenal/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		owner.last_special = world.time + 500
		to_chat(owner, "<span class='notice'>\The [src] activates, releasing a stream of chemicals into your veins!</span>")

		if(owner.reagents)

			if(is_bruised())
				owner.reagents.add_reagent("toxin", 10)

			if(is_broken())
				owner.reagents.add_reagent("toxin", 25)
				return

			owner.adjustBruteLoss(rand(5,25))
			owner.adjustToxLoss(rand(5,25))
			owner.reagents.add_reagent("tramadol", 5)
			owner.reagents.add_reagent("inaprovaline", 5)

/obj/item/organ/haemodynamic
	name = "haemodynamic control system"
	icon_state = "brain-prosthetic"
	organ_tag = "haemodynamic"
	parent_organ = "chest"
	robotic = 1
	action_button_name = "Activate Haemodynamic Control System"

/obj/item/organ/haemodynamic/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "placeholder"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/haemodynamic/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		owner.last_special = world.time + 500

		owner.adjustNutritionLoss(300)
		owner.adjustHydrationLoss(300)

		if(is_broken())
			owner.vessel.remove_reagent("blood",rand(50,75))
			return

		to_chat(owner, "<span class='notice'>\The [src] activates, releasing a stream of chemicals into your veins!</span>")

		if(is_bruised())
			owner.vessel.remove_reagent("blood",rand(25,50))

		if(owner.reagents)
			owner.reagents.add_reagent("coagulant", 15)

//limb implants

/obj/item/organ/external/hand/right/autakh/engineering
	name = "engineering grasper"
	action_button_name = "Deploy Mechanical Combitool"
	force = 5

/obj/item/organ/external/hand/right/autakh/engineering/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "digitool"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/engineering/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(owner.get_active_hand())
			to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		owner.last_special = world.time + 500
		var/obj/item/combitool/robotic/M = new /obj/item/combitool/robotic(owner)
		M.creator = owner
		owner.put_in_active_hand(M)
		owner.visible_message("<span class='notice'>\The [M] slides out of \the [owner]'s [src].</span>","<span class='notice'>You deploy \the [M]!</span>")

/obj/item/combitool/robotic
	name = "robotic combitool"
	desc = "An integrated combitool module."
	icon_state = "digitool"
	var/mob/living/creator

/obj/item/combitool/robotic/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/combitool/robotic/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/combitool/robotic/dropped(mob/user as mob)
	QDEL_IN(src, 1)

/obj/item/combitool/robotic/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)


/obj/item/organ/external/hand/right/autakh/mining
	name = "engineering grasper"
	action_button_name = "Deploy Mounted Drill"

/obj/item/organ/external/hand/right/autakh/mining/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "drill"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/mining/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(owner.get_active_hand())
			to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		owner.last_special = world.time + 500
		var/obj/item/weapon/pickaxe/drill/integrated/M = new /obj/item/weapon/pickaxe/drill/integrated(owner)
		M.creator = owner
		owner.put_in_active_hand(M)
		owner.visible_message("<span class='notice'>\The [M] slides out of \the [owner]'s [src].</span>","<span class='notice'>You deploy \the [M]!</span>")

/obj/item/weapon/pickaxe/drill/integrated
	name = "integrated mining drill"
	var/mob/living/creator

/obj/item/weapon/pickaxe/drill/integrated/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/weapon/pickaxe/drill/integrated/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/weapon/pickaxe/drill/integrated/dropped(mob/user as mob)
	QDEL_IN(src, 1)

/obj/item/weapon/pickaxe/drill/integrated/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/organ/external/hand/right/autakh/medical
	name = "medical grasper"
	action_button_name = "Deploy Mounted Health Scanner"

/obj/item/organ/external/hand/right/autakh/medical/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "health"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/medical/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use \the [src] in your current state!</span>")
			return

		if(owner.get_active_hand())
			to_chat(owner, "<span class='danger'>You must empty your active hand before enabling your [src]!</span>")
			return

		if(is_broken())
			to_chat(owner, "<span class='danger'>\The [src] is too damaged to be used!</span>")
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		var/obj/item/weapon/grab/G = owner.get_active_hand()
		if(!istype(G))
			to_chat(owner, "<span class='danger'>You must grab someone before trying to analyze their health!</span>")
			return

		owner.last_special = world.time + 250
		if(istype(G.affecting,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = G.affecting
			health_scan_mob(H, owner)