/obj/item/organ/external/head/autakh
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_AUTAKH

/obj/item/organ/external/head/autakh/Initialize()
	. = ..()
	mechassist()

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

/obj/item/organ/external/groin/autakh/Initialize()
	. = ..()
	mechassist()

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

/obj/item/organ/internal/kidneys/autakh
	name = "toxin screen"
	icon_state = "screen"
	robotic = 1
	robotic_name = null
	robotic_sprite = null

/obj/item/organ/internal/kidneys/autakh/Initialize()
	mechassist()
	. = ..()

/obj/item/organ/internal/anchor
	name = "soul anchor"
	icon_state = "anchor"
	organ_tag = "anchor"
	parent_organ = BP_HEAD
	robotic = 2

/obj/item/organ/internal/anchor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/eyes/autakh
	name = "bionic eyeballs"
	icon_state = "mk1eyes"
	singular_name = "bionic eye"
	action_button_name = "Toggle Bionic Eyes Sensors"
	robotic_name = null
	robotic_sprite = null
	robotic = 2

	var/static/list/hud_types = list(
		"Disabled",
		"Security",
		"Medical")

	var/selected_hud = "Disabled"
	var/disabled = FALSE

/obj/item/organ/internal/eyes/autakh/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/eyes/autakh/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "mk1eyes"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/internal/eyes/autakh/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, "<span class='danger'>\The [src] is still recharging!</span>")
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, "<span class='danger'>You can not use your \the [src] in your current state!</span>")
			return

		if(disabled || is_broken())
			to_chat(owner, "<span class='danger'>\The [src] shudders and sparks, unable to change its sensors!</span>")
			return

		owner.last_special = world.time + 100

		var/choice = input("Select the Sensor Type.", "Bionic Eyes Sensors") as null|anything in hud_types

		selected_hud = choice

/obj/item/organ/internal/eyes/autakh/process()
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

/obj/item/organ/internal/eyes/autakh/flash_act()
	if(owner)
		to_chat(owner, "<span class='notice'>Your [singular_name]'s retinal overlays are overloaded by the strong light!</span>")
		owner.eye_blind = 5
		owner.eye_blurry = 5
		spark(get_turf(owner), 3)
	disabled = TRUE
	selected_hud = "Disabled"
	addtimer(CALLBACK(src, .proc/rearm), 40 SECONDS)
	return

/obj/item/organ/internal/eyes/autakh/emp_act(severity)
	..()
	disabled = TRUE
	selected_hud = "Disabled"
	addtimer(CALLBACK(src, .proc/rearm), 40 SECONDS)

/obj/item/organ/internal/eyes/autakh/proc/rearm()
	if(!disabled)
		return
	disabled = FALSE

	if(owner)
		to_chat(owner, "<span class='notice'>\The [singular_name]'s retinal overlays clicks and shifts!</span>")

/obj/item/organ/internal/adrenal
	name = "adrenal management system"
	icon_state = "ams"
	organ_tag = "adrenal"
	parent_organ = BP_CHEST
	robotic = 2
	action_button_name = "Activate Adrenal Management System"

/obj/item/organ/internal/adrenal/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/adrenal/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "ams"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/internal/adrenal/attack_self(var/mob/user)
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

			owner.vessel.remove_reagent("blood",rand(15,30))
			owner.reagents.add_reagent("paracetamol", 5)
			owner.reagents.add_reagent("norepinephrine", 5)

/obj/item/organ/internal/haemodynamic
	name = "haemodynamic control system"
	icon_state = "stabilizer"
	organ_tag = "haemodynamic"
	parent_organ = BP_CHEST
	robotic = 1
	action_button_name = "Activate Haemodynamic Control System"

/obj/item/organ/internal/haemodynamic/Initialize()
	mechassist()
	. = ..()

/obj/item/organ/internal/haemodynamic/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/haemodynamic/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "stabilizer"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/internal/haemodynamic/attack_self(var/mob/user)
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

/obj/item/organ/external/hand/right/autakh/tool
	name = "engineering grasper"
	action_button_name = "Deploy Mechanical Combitool"
	var/augment_type = /obj/item/combitool/robotic

/obj/item/organ/external/hand/right/autakh/tool/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "digitool"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/tool/attack_self(var/mob/user)
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

		owner.last_special = world.time + 100
		var/obj/item/M = new augment_type(owner)
		owner.put_in_active_hand(M)
		owner.visible_message("<span class='notice'>\The [M] slides out of \the [owner]'s [src].</span>","<span class='notice'>You deploy \the [M]!</span>")

/obj/item/combitool/robotic
	name = "robotic combitool"
	desc = "An integrated combitool module."
	icon_state = "digitool"
	item_state = "digitool"
	
/obj/item/combitool/robotic/throw_at()
	usr.drop_from_inventory(src)

/obj/item/combitool/robotic/dropped()
	loc = null
	qdel(src)

/obj/item/organ/external/hand/right/autakh/tool/mining
	name = "mining grasper"
	action_button_name = "Deploy Mounted Drill"
	augment_type = /obj/item/pickaxe/drill/integrated

/obj/item/organ/external/hand/right/autakh/mining/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "drill"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/pickaxe/drill/integrated
	name = "integrated mining drill"
	icon_state = "integrateddrill"
	item_state = "integrateddrill"

/obj/item/pickaxe/drill/integrated/throw_at()
	usr.drop_from_inventory(src)

/obj/item/pickaxe/drill/integrated/dropped()
	loc = null
	qdel(src)

/obj/item/organ/external/hand/right/autakh/medical
	name = "medical grasper"
	action_button_name = "Deploy Mounted Health Scanner"

/obj/item/organ/external/hand/right/autakh/medical/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "health"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/medical/attack_self(var/mob/user)
	. = ..()

	if(.)

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

		var/obj/item/grab/G = owner.get_active_hand()
		if(!istype(G))
			to_chat(owner, "<span class='danger'>You must grab someone before trying to analyze their health!</span>")
			return

		owner.last_special = world.time + 50
		if(ishuman(G.affecting))
			var/mob/living/carbon/human/H = G.affecting
			health_scan_mob(H, owner)

/obj/item/organ/external/hand/right/autakh/security
	name = "security grasper"
	action_button_name = "Activate Integrated Electroshock Weapon"

/obj/item/organ/external/hand/right/autakh/security/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "baton"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/external/hand/right/autakh/security/attack_self(var/mob/user)
	. = ..()

	if(.)

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

		var/obj/item/grab/G = owner.get_active_hand()
		if(!istype(G))
			to_chat(owner, "<span class='danger'>You must grab someone before trying to use your [src]!</span>")
			return

		if(owner.nutrition <= 200)
			to_chat(owner, "<span class='danger'>Your energy reserves are too low to use your [src]!</span>")
			return

		if(ishuman(G.affecting))

			var/mob/living/carbon/human/H = G.affecting
			var/target_zone = check_zone(owner.zone_sel.selecting)

			owner.last_special = world.time + 100
			owner.adjustNutritionLoss(50)

			if(owner.a_intent == I_HURT)
				H.electrocute_act(10, owner, def_zone = target_zone)
			else
				H.stun_effect_act(0, 50, target_zone, owner)

			owner.visible_message("<span class='danger'>[H] has been prodded with [src] by [owner]!</span>")
			playsound(get_turf(owner), 'sound/weapons/Egloves.ogg', 50, 1, -1)
