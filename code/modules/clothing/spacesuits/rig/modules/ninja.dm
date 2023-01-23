/*
 * Contains
 * /obj/item/rig_module/stealth_field
 * /obj/item/rig_module/teleporter
 * /obj/item/rig_module/fabricator/energy_net
 * /obj/item/rig_module/self_destruct
 * /obj/item/rig_module/emp_shielding
 * /obj/item/rig_module/emergency_powergenerator
 * /obj/item/rig_module/emag_hand
 */

/obj/item/rig_module/stealth_field
	name = "active camouflage module"
	desc = "A robust hardsuit-integrated stealth module."
	icon_state = "cloak"

	toggleable = TRUE
	disruptable = TRUE
	disruptive = FALSE
	attackdisrupts = TRUE
	confined_use = TRUE

	use_power_cost = 75
	active_power_cost = 15
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Cloak"
	deactivate_string = "Disable Cloak"

	interface_name = "integrated stealth system"
	interface_desc = "An integrated active camouflage system."

	suit_overlay_active =   "stealth_active"
	suit_overlay_inactive = "stealth_inactive"

	category = MODULE_SPECIAL

/obj/item/rig_module/stealth_field/activate()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, SPAN_NOTICE("<b>You are now invisible to normal detection.</b>"))
	H.invisibility = INVISIBILITY_LEVEL_TWO

	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity", null, 20, null)

	H.visible_message(SPAN_NOTICE("[H] vanishes into thin air!"), SPAN_NOTICE("You vanish into thin air!"))

/obj/item/rig_module/stealth_field/deactivate()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, SPAN_NOTICE("<b>You are now visible.</b>"))
	H.invisibility = FALSE

	anim(get_turf(H), H, 'icons/mob/mob.dmi', ,"uncloak", , H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity", null, 20, null)

	H.visible_message(SPAN_NOTICE("[H] appears from thin air!"), SPAN_NOTICE("You appear from thin air!"))
	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 10, 1)

/obj/item/rig_module/teleporter
	name = "bluespace teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module that exploits bluespace energy to phase from one location to another instantaneously."
	icon_state = "teleporter"
	use_power_cost = 40
	redundant = 1
	usable = TRUE
	selectable = 1
	var/lastteleport
	var/phase_in_visual = /obj/effect/temp_visual/phase
	var/phase_out_visual = /obj/effect/temp_visual/phase/out

	engage_string = "Emergency Leap"

	interface_name = "VOID-shift bluespace phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

	category = MODULE_SPECIAL

/obj/item/rig_module/teleporter/proc/phase_in(var/mob/M, var/turf/T)
	if(!M || !T)
		return

	holder.spark_system.queue()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	new phase_in_visual(T, M.dir)

/obj/item/rig_module/teleporter/proc/phase_out(var/mob/M, var/turf/T)
	if(!M || !T)
		return

	playsound(T, /singleton/sound_category/spark_sound, 50, 1)
	new phase_out_visual(T, M.dir)

/obj/item/rig_module/teleporter/engage(atom/target, mob/user, var/notify_ai)
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(lastteleport + (5 SECONDS) > world.time)
		to_chat(user, SPAN_WARNING("The teleporter needs time to cool down!"))
		return FALSE

	if(!istype(H.loc, /turf))
		to_chat(user, SPAN_WARNING("You cannot teleport out of your current location."))
		return FALSE

	var/turf/T
	if(target)
		T = get_turf(target)
	else
		T = get_teleport_loc(get_turf(H), H, rand(5, 9))

	if(!T || T.density)
		to_chat(user, SPAN_WARNING("You cannot teleport into solid walls."))
		return FALSE

	if(isAdminLevel(T.z))
		to_chat(user, SPAN_WARNING("You cannot use your teleporter on this Z-level."))
		return FALSE

	if(T.contains_dense_objects())
		to_chat(user, SPAN_WARNING("You cannot teleport to a location with solid objects."))
		return FALSE

	if((T.z != H.z || get_dist(T, get_turf(H)) > world.view) && target)
		to_chat(user, SPAN_WARNING("You cannot teleport to such a distant object."))
		return FALSE

	phase_out(H,get_turf(H))
	do_teleport(H,T)
	phase_in(H,get_turf(H))

	if(T != get_turf(H))
		to_chat(user, SPAN_WARNING("Something interferes with your [src]!"))

	for(var/obj/item/grab/G in H.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			do_teleport(G.affecting,locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
			phase_in(G.affecting,get_turf(G.affecting))

	lastteleport = world.time
	return TRUE

/obj/item/rig_module/teleporter/skrell
	name = "nralakk teleportation module"

	phase_in_visual = /obj/effect/temp_visual/phase/rift
	phase_out_visual = /obj/effect/temp_visual/phase/rift

	interface_name = "starshift teleportation module"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

/obj/item/rig_module/fabricator/energy_net
	name = "net projector"
	desc = "Some kind of complex energy projector with a hardsuit mount."
	icon_state = "enet"

	interface_name = "energy net launcher"
	interface_desc = "An advanced energy-patterning projector used to capture targets."

	engage_string = "Fabricate Net"

	fabrication_type = /obj/item/energy_net
	use_power_cost = 60

	category = MODULE_SPECIAL

/obj/item/rig_module/fabricator/energy_net/engage(atom/target, mob/user)
	if(holder?.wearer && target)
		if(..())
			holder.wearer.Beam(target, "n_beam", , 10)
		return TRUE
	return FALSE

/obj/item/rig_module/self_destruct
	name = "self-destruct module"
	desc = "Oh my God, Captain. A bomb."
	icon_state = "deadman"
	usable = TRUE
	active = TRUE
	permanent = TRUE

	engage_string = "Detonate"

	interface_name = "dead man's switch"
	interface_desc = "An integrated self-destruct module. When the wearer dies, so does the surrounding area. Do not press this button."
	var/list/explosion_values = list(3, 4, 5, 6)

	category = MODULE_SPECIAL

/obj/item/rig_module/self_destruct/small
	explosion_values = list(1, 2, 3, 4)

/obj/item/rig_module/self_destruct/activate()
	return

/obj/item/rig_module/self_destruct/deactivate()
	return

/obj/item/rig_module/self_destruct/process()
	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return FALSE

	//OH SHIT.
	if(holder.wearer.stat == DEAD)
		do_engage(1)

/obj/item/rig_module/self_destruct/engage(var/skip_check)
	if(!skip_check && usr && alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") == "No")
		return
	explosion(get_turf(src), explosion_values[1], explosion_values[2], explosion_values[3], explosion_values[4])
	if(holder && holder.wearer)
		holder.wearer.gib()
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
	qdel(src)

/obj/item/rig_module/anti_theft
	name = "anti-theft system"
	desc = "An advanced anti-theft system that tracks the user's lifesigns."
	icon_state = "deadman"
	usable = FALSE
	active = FALSE
	permanent = FALSE

/obj/item/rig_module/anti_theft/process()
	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return FALSE

	if(holder && holder.wearer.stat == DEAD)
		holder.wearer.dust()
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
		qdel(src)

/obj/item/rig_module/emp_shielding
	name = "EMP dissipation module"
	desc = "A bewilderingly complex bundle of fiber optics and chips. Seems like it uses a good deal of power."
	active_power_cost = 10
	toggleable = TRUE
	usable = FALSE
	use_power_cost = 70
	module_cooldown = 30

	activate_string = "Enable Active EMP Shielding"
	deactivate_string = "Disable Active EMP Shielding"

	interface_name = "active EMP shielding system"
	interface_desc = "A highly experimental system that augments the hardsuit's existing EM shielding."
	var/protection_amount = 30

	category = MODULE_SPECIAL

/obj/item/rig_module/emp_shielding/activate()
	if(!..())
		return

	holder.emp_protection += protection_amount

/obj/item/rig_module/emp_shielding/deactivate()
	if(!..())
		return

	holder.emp_protection = max(0, (holder.emp_protection - protection_amount))

/obj/item/rig_module/emergency_powergenerator
	name = "emergency power generator"
	desc = "A high yield power generating device that takes a long time to recharge."
	active_power_cost = 0
	toggleable = FALSE
	usable = TRUE
	confined_use = TRUE
	var/cooldown = 0

	engage_string = "Use Emergency Power"

	interface_name = "emergency power generator"
	interface_desc = "A high yield power generating device that takes a long time to recharge."
	var/generation_amount = 3500

	category = MODULE_SPECIAL

/obj/item/rig_module/emergency_powergenerator/engage(atom/target, mob/user)
	if(!..())
		return
	var/mob/living/carbon/human/H = holder.wearer
	if(cooldown)
		to_chat(user, SPAN_DANGER("There isn't enough power stored up yet!"))
		return FALSE
	message_user(user, SPAN_NOTICE("You inject a burst of power into \the [holder]."), SPAN_NOTICE("Your suit emits a loud sound as power is rapidly injected into your suit's battery!"))
	playsound(H.loc, 'sound/effects/sparks2.ogg', 50, 1)
	holder.cell.give(generation_amount)
	cooldown = 1
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/rig_module/emergency_powergenerator, reset_cooldown)), 2 MINUTES)
	return TRUE

/obj/item/rig_module/emergency_powergenerator/proc/reset_cooldown()
	cooldown = 0

/obj/item/rig_module/device/emag_hand
	name = "integrated cryptographic sequencer"
	desc = "A complex uprade that allows the user to apply an EMAG effect to certain objects. High power cost."
	use_power_cost = 100
	module_cooldown = 4800

	interface_name = "integrated cryptographic sequencer"
	interface_desc = "A complex uprade that allows the user to apply an EMAG effect to certain objects. High power cost."

	device_type = /obj/item/robot_emag

	category = MODULE_SPECIAL

/obj/item/rig_module/stealth_field/advanced //credits to Burger BB
	name = "advanced active camouflage module"
	desc = "A robust hardsuit-integrated stealth module. This model sports a significantly lower cooldown between uses as well as a reduced charge cost."
	use_power_cost = 10
	active_power_cost = 2
	passive_power_cost = 0
	module_cooldown = 10

	category = MODULE_SPECIAL

/obj/item/rig_module/device/door_hack //credits to BurgerBB
	name = "advanced door hacking tool"
	desc = "An advanced door hacking tool that sports a low power cost and incredibly quick door hacking time. The device also supports hacking several signals at once remotely, and the last 10 doors hacked can be instantly accessed."
	use_power_cost = 10
	module_cooldown = 5

	usable = FALSE
	selectable = 0
	toggleable = TRUE

	interface_name = "advanced door hacking tool"
	interface_desc = "An advanced door hacking tool that sports a low power cost and incredibly quick door hacking time. The device also supports hacking several signals at once remotely, and the last 10 doors hacked can be instantly accessed."

	category = MODULE_SPECIAL

/obj/item/rig_module/device/door_hack/process()
	if(holder && holder.wearer)
		if(!(locate(/obj/item/device/multitool/hacktool/rig) in holder.wearer))
			deactivate()
			return FALSE

	return ..()

/obj/item/rig_module/device/door_hack/activate(mob/user)
	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		if(M == user)
			to_chat(M, SPAN_WARNING("Your hands are full."))
		else
			to_chat(user, SPAN_WARNING("[M]'s hands are full."))
		deactivate()
		return

	var/obj/item/device/multitool/hacktool/rig/hacktool = new(M)
	hacktool.creator = M
	M.put_in_hands(hacktool)

/obj/item/rig_module/device/door_hack/deactivate()
	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/device/multitool/hacktool/rig/hacktool in M.contents)
		qdel(hacktool)