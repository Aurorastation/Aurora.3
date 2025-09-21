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

/obj/item/organ/internal/anchor
	name = "soul anchor"
	icon_state = "anchor"
	organ_tag = "anchor"
	parent_organ = BP_HEAD
	robotic = ROBOTIC_MECHANICAL
	var/suffered_revelation = FALSE

/obj/item/organ/internal/anchor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/anchor/process()

	..()

	if(!owner)
		return

	if(!suffered_revelation)
		if(prob(0.1))
			revelation()
			suffered_revelation = TRUE

/obj/item/organ/internal/anchor/emp_act(severity)
	. = ..()

	revelation()

/obj/item/organ/internal/anchor/proc/revelation()
	if(owner)
		owner.hallucination += 20

/obj/item/organ/internal/augment/calf_override
	name = "calf overdrive"
	icon_state = "ams"
	organ_tag = BP_AUG_CALF_OVERRIDE
	parent_organ = BP_GROIN
	action_button_icon = "ams"
	action_button_name = "Activate Calf Override"
	cooldown = 30
	var/online = FALSE
	activable = TRUE

/obj/item/organ/internal/augment/calf_override/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(!online)
		online = TRUE
		to_chat(owner, SPAN_NOTICE("\The [src] activates!"))
	else
		online = FALSE
		to_chat(owner, SPAN_NOTICE("\The [src] deactivates!"))

/obj/item/organ/internal/augment/calf_override/proc/do_run_act()
	owner.apply_damage(1, DAMAGE_BRUTE, BP_GROIN, armor_pen = 100)

/obj/item/organ/internal/augment/protein_valve
	name = "protein breakdown valve"
	icon_state = "screen"
	organ_tag = "protein valve"
	parent_organ = BP_CHEST
	action_button_icon = "screen"
	action_button_name = "Activate Protein Breakdown Valve"
	cooldown = 300
	activable = TRUE
	var/expended = FALSE

/obj/item/organ/internal/augment/protein_valve/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(expended)
		to_chat(owner, SPAN_WARNING("\The [src] has already been used up!"))
		return

	if(owner.reagents)
		to_chat(owner, SPAN_NOTICE("\The [src] activates, releasing a stream of chemicals into your veins!"))
		owner.reagents.add_reagent(/singleton/reagent/adrenaline, 15)
		expended = TRUE

/obj/item/organ/internal/augment/venomous_rest
	name = "venomous rest implant"
	icon_state = "stabilizer"
	organ_tag = "venomous rest"
	parent_organ = BP_CHEST
	action_button_name = "Activate Venomous Rest Implant"
	action_button_icon = "stabilizer"
	cooldown = 300
	activable = TRUE
	var/expended = FALSE

/obj/item/organ/internal/augment/venomous_rest/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(expended)
		to_chat(owner, SPAN_WARNING("\The [src] has already been used up!"))
		return

	if(owner.reagents)
		owner.reagents.add_reagent(/singleton/reagent/inaprovaline, 10)
		owner.reagents.add_reagent(/singleton/reagent/tricordrazine, 10)
		owner.reagents.add_reagent(/singleton/reagent/soporific, 15)
		to_chat(owner, SPAN_NOTICE("\The [src] activates, releasing a stream of chemicals into your veins!"))
		expended = TRUE

/obj/item/organ/internal/augment/farseer_eye
	name = "farseer eye"
	icon_state = "hunterseye"
	organ_tag = "farseer eye"
	parent_organ = BP_HEAD
	action_button_name = "Activate Farseer Eye"
	action_button_icon = "hunterseye"
	cooldown = 30
	activable = TRUE

/obj/item/organ/internal/augment/farseer_eye/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(zoom)
		owner.visible_message("<b>[user]'s</b> eyes whirrs loudly as the zoom lenses retract.", range = 3)
	else
		owner.visible_message("<b>[user]'s</b> eyes whirrs loudly as the zoom lenses begin sliding into place...", range = 3)
		if(!do_after(user, 1.5 SECONDS))
			return
		owner.visible_message("<b>[user]'s</b> eyes clicks loudly as they focus ahead.", range = 3)

	zoom(owner, 6, 7, FALSE, FALSE)

/obj/item/organ/internal/augment/eye_flashlight
	name = "eye flashlight"
	icon_state = "mk1eyes"
	organ_tag = "eye flashlight"
	parent_organ = BP_HEAD
	action_button_name = "Activate Eye Flashlight"
	action_button_icon = "mk1eyes"
	cooldown = 50
	activable = TRUE
	var/online = FALSE
	var/warning_level = 0

/obj/item/organ/internal/augment/eye_flashlight/attack_self(var/mob/user)
	. = ..()

	if(!.)
		return FALSE

	if(!online)
		set_light(3, 2, LIGHT_COLOR_RED, uv = 0, angle = LIGHT_WIDE)
		owner.change_eye_color(250, 130, 130)
		owner.update_eyes()
		online = TRUE
		addtimer(CALLBACK(src, PROC_REF(add_warning)), 5 MINUTES)
		addtimer(CALLBACK(src, PROC_REF(add_warning)), 6 MINUTES)
	else
		turn_off()

/obj/item/organ/internal/augment/eye_flashlight/proc/turn_off()
	online = FALSE
	set_light(0)
	if(owner.client)
		owner.change_eye_color(owner.client.prefs.r_eyes, owner.client.prefs.g_eyes, owner.client.prefs.b_eyes)
		owner.update_eyes()
	warning_level = 0

/obj/item/organ/internal/augment/eye_flashlight/emp_act(severity)
	. = ..()

	turn_off()

/obj/item/organ/internal/augment/eye_flashlight/proc/add_warning()
	if(online)

		warning_level = min(warning_level+1,2)

		if(warning_level >= 1)
			to_chat(owner, SPAN_DANGER ("Your eyes are feeling warm!"))

/obj/item/organ/internal/augment/eye_flashlight/process()

	..()

	if(!owner)
		return

	if(warning_level >= 2)
		var/obj/item/organ/internal/eyes/E = owner.get_eyes()
		if(!E)
			return
		E.take_damage(1)

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
			action.button.update_icon()

/obj/item/organ/external/hand/right/autakh/tool/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_DANGER("\The [src] is still recharging!"))
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, SPAN_DANGER("You can not use \the [src] in your current state!"))
			return

		if(owner.get_active_hand())
			to_chat(owner, SPAN_DANGER("You must empty your active hand before enabling your [src]!"))
			return

		if(is_broken())
			to_chat(owner, SPAN_DANGER("\The [src] is too damaged to be used!"))
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		owner.last_special = world.time + 100
		var/obj/item/M = new augment_type(owner)
		owner.put_in_active_hand(M)
		owner.visible_message(SPAN_NOTICE("\The [M] slides out of \the [owner]'s [src]."),
								SPAN_NOTICE("You deploy \the [M]!"))

/obj/item/combitool/robotic
	name = "robotic combitool"
	desc = "An integrated combitool module."
	icon_state = "digitool"
	item_state = "digitool"
	w_class = WEIGHT_CLASS_BULKY
	tools = list(
		"crowbar",
		"screwdriver",
		"wrench",
		"wirecutters"
		)

/obj/item/combitool/robotic/throw_at()
	usr.drop_from_inventory(src)

/obj/item/combitool/robotic/dropped()
	. = ..()
	loc = null
	qdel(src)

/obj/item/organ/external/hand/right/autakh/tool/mining
	name = "mining grasper"
	action_button_name = "Deploy Mounted Drill"
	augment_type = /obj/item/pickaxe/drill/integrated

/obj/item/organ/external/hand/right/autakh/tool/mining/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "drill"
		if(action.button)
			action.button.update_icon()

/obj/item/pickaxe/drill/integrated
	name = "integrated mining drill"
	desc = "A integrated mining drill that is installed on the hand of the user, it can retract at the user's command."
	icon_state = "integrateddrill"
	item_state = "integrateddrill"

/obj/item/pickaxe/drill/integrated/throw_at()
	usr.drop_from_inventory(src)

/obj/item/pickaxe/drill/integrated/dropped()
	. = ..()
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
			action.button.update_icon()

/obj/item/organ/external/hand/right/autakh/medical/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_DANGER("\The [src] is still recharging!"))
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, SPAN_DANGER("You can not use \the [src] in your current state!"))
			return

		if(is_broken())
			to_chat(owner, SPAN_DANGER("\The [src] is too damaged to be used!"))
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		var/obj/item/grab/G = owner.get_active_hand()
		if(!istype(G))
			to_chat(owner, SPAN_DANGER("You must grab someone before trying to analyze their health!"))
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
			action.button.update_icon()

/obj/item/organ/external/hand/right/autakh/security/attack_self(var/mob/user)
	. = ..()

	if(.)

		if(owner.last_special > world.time)
			to_chat(owner, SPAN_DANGER("\The [src] is still recharging!"))
			return

		if(owner.stat || owner.paralysis || owner.stunned || owner.weakened)
			to_chat(owner, SPAN_DANGER("You can not use \the [src] in your current state!"))
			return

		if(is_broken())
			to_chat(owner, SPAN_DANGER("\The [src] is too damaged to be used!"))
			return

		if(is_bruised())
			spark(get_turf(owner), 3)

		var/obj/item/grab/G = owner.get_active_hand()
		if(!istype(G))
			to_chat(owner, SPAN_DANGER("You must grab someone before trying to use your [src]!"))
			return

		if(owner.nutrition <= 200)
			to_chat(owner, SPAN_DANGER("Your energy reserves are too low to use your [src]!"))
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

			owner.visible_message(SPAN_DANGER("[H] has been prodded with [src] by [owner]!"))
			playsound(get_turf(owner), 'sound/weapons/Egloves.ogg', 50, 1, -1)

/obj/item/organ/external/hand/right/autakh/tool/nullrod
	name = "blessed prosthesis"
	action_button_name = "Deploy Blessed Prosthesis"
	augment_type = /obj/item/nullrod/autakh

/obj/item/organ/external/hand/right/autakh/tool/nullrod/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "anchor"
		if(action.button)
			action.button.update_icon()
