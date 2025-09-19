//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	icon_state = "implant_freedom"
	implant_icon = "freedom"
	implant_color = "#88f2e0"
	origin_tech = list(TECH_MATERIAL = 1, TECH_ILLEGAL = 2, TECH_BIO = 3)
	default_action_type = /datum/action/item_action/hands_free/activate/implant/freedom
	action_button_name = "Activate Freedom Implant"
	hidden = TRUE
	var/uses = 1

/obj/item/implant/freedom/New()
	uses = rand(1, 5)
	..()

/obj/item/implant/freedom/activate()
	if(malfunction || !imp_in)
		return
	if(uses < 1)
		to_chat(imp_in, SPAN_WARNING("\The [src] gives a faint beep inside your [part], indicating that it's out of uses!"))
		return
	uses--
	to_chat(imp_in, SPAN_HEAR("You feel a faint click."))
	if(iscarbon(imp_in))
		var/mob/living/carbon/C_imp_in = imp_in
		if(C_imp_in.handcuffed)
			var/obj/item/W = C_imp_in.handcuffed
			C_imp_in.handcuffed = null
			if(C_imp_in.buckled_to && C_imp_in.buckled_to.buckle_require_restraints)
				C_imp_in.buckled_to.unbuckle()
			C_imp_in.update_inv_handcuffed()
			if(C_imp_in.client)
				C_imp_in.client.screen -= W
			if(W)
				W.forceMove(C_imp_in.loc)
				dropped(C_imp_in)
				if (W)
					W.layer = initial(W.layer)
		if(C_imp_in.legcuffed)
			var/obj/item/W = C_imp_in.legcuffed
			C_imp_in.legcuffed = null
			C_imp_in.update_inv_legcuffed()
			if(C_imp_in.client)
				C_imp_in.client.screen -= W
			if(W)
				W.forceMove(C_imp_in.loc)
				dropped(C_imp_in)
				if(W)
					W.layer = initial(W.layer)

/obj/item/implant/freedom/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Freedom Beacon<BR>
<b>Life:</b> optimum 5 uses<BR>
<b>Important Notes:</b> <span class='warning'>Illegal</span><BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
mechanisms<BR>
<b>Special Features:</b><BR>
<i>Neuro-Scan</i>- Analyzes certain shadow signals in the nervous system<BR>
<b>Integrity:</b> The battery is extremely weak and commonly after injection its
life can drive down to only 1 use.<HR>
No Implant Specifics"}
	return dat

/obj/item/implantcase/freedom
	name = "glass case - 'freedom'"
	imp = /obj/item/implant/freedom

/obj/item/implanter/freedom
	name = "implanter (F)"
	imp = /obj/item/implant/freedom

/**
 * # Teleport freedom implant
 *
 * This implant allows you to teleport to a linked teleporter in desperate times
 */
/obj/item/implant/telefreedom
	name = "telefreedom implant"
	desc = "Use this to teleport to a linked teleporter in desperate times. Melts after being used."

	//////Edit these when you can give it an unique sprite//////
	icon_state = "implant_freedom"
	implant_icon = "freedom"

	implant_color = "#15695b"
	hidden = TRUE
	default_action_type = /datum/action/item_action/hands_free/activate/implant/freedom
	action_button_name = "Activate Telefreedom Implant"

	/**
	 * The linked telepad to teleport to, a weakref to an `/obj/machinery/telepad` object
	 */
	var/datum/weakref/linked_telepad = null

/obj/item/implant/telefreedom/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Left-click a telepad to link your telefreedom implant to it before implanting."

/obj/item/implant/telefreedom/activate()
	if(!imp_in)
		return

	if(!linked_telepad)
		to_chat(imp_in, SPAN_NOTICE("You need to link a telepad first."))
		return

	if(malfunction)
		to_chat(imp_in, SPAN_WARNING("The telefreedom implant is malfunctioning!"))
		return

	//Effects
	spark(get_turf(imp_in), 5, GLOB.alldirs)
	var/datum/effect/effect/system/smoke_spread/smoke_effect = new /datum/effect/effect/system/smoke_spread
	smoke_effect.set_up(4, 1, get_turf(imp_in))
	smoke_effect.smoke_duration = 5 SECONDS
	smoke_effect.start()

	var/turf/T = get_turf(linked_telepad.resolve())
	if(!T)
		stack_trace("telefreedom implant: telepad turf is null")
		return

	imp_in.forceMove(T)
	meltdown()

/obj/item/implant/telefreedom/resolve_attackby(atom/A, mob/user, click_parameters)
	. = ..()
	if(istype(A, /obj/machinery/telepad))
		linked_telepad = WEAKREF(A)
		to_chat(user, SPAN_NOTICE("You link the telepad to your telefreedom implant."))
