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

	toggleable = 1
	disruptable = 1
	disruptive = 0
	confined_use = 1

	use_power_cost = 50
	active_power_cost = 10
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
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	H << "<font color='blue'><b>You are now invisible to normal detection.</b></font>"
	H.invisibility = INVISIBILITY_LEVEL_TWO

	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	H.visible_message("<span class='notice'>[H] vanishes into thin air!</span>", "<span class='notice'>You vanish into thin air!</span>")

/obj/item/rig_module/stealth_field/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	H << "<span class='danger'>You are now visible.</span>"
	H.invisibility = 0

	anim(get_turf(H), H,'icons/mob/mob.dmi',,"uncloak",,H.dir)
	anim(get_turf(H), H, 'icons/effects/effects.dmi', "electricity",null,20,null)

	for(var/mob/O in oviewers(H))
		O.show_message("[H.name] appears from thin air!",1)
	playsound(get_turf(H), 'sound/effects/stealthoff.ogg', 75, 1)


/obj/item/rig_module/teleporter

	name = "bluespace teleportation module"
	desc = "A complex, sleek-looking, hardsuit-integrated teleportation module that exploits bluespace energy to phase from one location to another instantaneously."
	icon_state = "teleporter"
	use_power_cost = 40
	redundant = 1
	usable = 1
	selectable = 1

	engage_string = "Emergency Leap"

	interface_name = "VOID-shift bluespace phase projector"
	interface_desc = "An advanced teleportation system. It is capable of pinpoint precision or random leaps forward."

	category = MODULE_SPECIAL

/obj/item/rig_module/teleporter/proc/phase_in(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	holder.spark_system.queue()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)

/obj/item/rig_module/teleporter/proc/phase_out(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	playsound(T, "sparks", 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

/obj/item/rig_module/teleporter/engage(var/atom/target, var/notify_ai)

	if(!..()) return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!istype(H.loc, /turf))
		H << "<span class='warning'>You cannot teleport out of your current location.</span>"
		return 0

	var/turf/T
	if(target)
		T = get_turf(target)
	else
		T = get_teleport_loc(get_turf(H), H, rand(5, 9))

	if(!T || T.density)
		H << "<span class='warning'>You cannot teleport into solid walls.</span>"
		return 0

	if(T.z in current_map.admin_levels)
		H << "<span class='warning'>You cannot use your teleporter on this Z-level.</span>"
		return 0

	if(T.contains_dense_objects())
		H << "<span class='warning'>You cannot teleport to a location with solid objects.</span>"
		return 0

	if(T.z != H.z || get_dist(T, get_turf(H)) > world.view)
		H << "<span class='warning'>You cannot teleport to such a distant object.</span>"
		return 0

	phase_out(H,get_turf(H))
	do_teleport(H,T)
	phase_in(H,get_turf(H))

	if(T != get_turf(H))
		to_chat(H,span("warning","Something interferes with your [src]!"))

	for(var/obj/item/weapon/grab/G in H.contents)
		if(G.affecting)
			phase_out(G.affecting,get_turf(G.affecting))
			do_teleport(G.affecting,locate(T.x+rand(-1,1),T.y+rand(-1,1),T.z))
			phase_in(G.affecting,get_turf(G.affecting))

	return 1

/obj/item/rig_module/fabricator/energy_net

	name = "net projector"
	desc = "Some kind of complex energy projector with a hardsuit mount."
	icon_state = "enet"

	interface_name = "energy net launcher"
	interface_desc = "An advanced energy-patterning projector used to capture targets."

	engage_string = "Fabricate Net"

	fabrication_type = /obj/item/weapon/energy_net
	use_power_cost = 60

	category = MODULE_SPECIAL

/obj/item/rig_module/fabricator/energy_net/engage(atom/target)

	if(holder && holder.wearer)
		if(..(target) && target)
			holder.wearer.Beam(target,"n_beam",,10)
		return 1
	return 0

/obj/item/rig_module/self_destruct

	name = "self-destruct module"
	desc = "Oh my God, Captain. A bomb."
	icon_state = "deadman"
	usable = 1
	active = 1
	permanent = 1

	engage_string = "Detonate"

	interface_name = "dead man's switch"
	interface_desc = "An integrated self-destruct module. When the wearer dies, so does the surrounding area. Do not press this button."
	var/list/explosion_values = list(3,4,5,6)

	category = MODULE_SPECIAL

/obj/item/rig_module/self_destruct/small
	explosion_values = list(1,2,3,4)

/obj/item/rig_module/self_destruct/activate()
	return

/obj/item/rig_module/self_destruct/deactivate()
	return

/obj/item/rig_module/self_destruct/process()

	// Not being worn, leave it alone.
	if(!holder || !holder.wearer || !holder.wearer.wear_suit == holder)
		return 0

	//OH SHIT.
	if(holder.wearer.stat == 2)
		engage(1)

/obj/item/rig_module/self_destruct/engage(var/skip_check)
	if(!skip_check && usr && alert(usr, "Are you sure you want to push that button?", "Self-destruct", "No", "Yes") == "No")
		return
	explosion(get_turf(src), explosion_values[1], explosion_values[2], explosion_values[3], explosion_values[4])
	if(holder && holder.wearer)
		holder.wearer.gib()
		holder.wearer.drop_from_inventory(src)
		qdel(holder)
	qdel(src)

/obj/item/rig_module/emp_shielding
	name = "EMP dissipation module"
	desc = "A bewilderingly complex bundle of fiber optics and chips. Seems like it uses a good deal of power."
	active_power_cost = 10
	toggleable = 1
	usable = 0
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

	holder.emp_protection = max(0,(holder.emp_protection - protection_amount))

/obj/item/rig_module/emergency_powergenerator
	name = "emergency power generator"
	desc = "A high yield power generating device that takes a long time to recharge."
	active_power_cost = 0
	toggleable = 0
	usable = 1
	confined_use = 1
	var/cooldown = 0

	engage_string = "Use Emergency Power"

	interface_name = "emergency power generator"
	interface_desc = "A high yield power generating device that takes a long time to recharge."
	var/generation_ammount = 1500

	category = MODULE_SPECIAL

/obj/item/rig_module/emergency_powergenerator/engage()
	if(!..())
		return
	var/mob/living/carbon/human/H = holder.wearer
	if(cooldown)
		H << "<span class='danger'>There isn't enough power stored up yet!</span>"
		return 0
	else
		H << "<span class='danger'>Your suit emits a loud sound as power is rapidly injected into your suits battery!</span>"
		playsound(H.loc, 'sound/effects/sparks2.ogg', 50, 1)
		holder.cell.give(generation_ammount)
		cooldown = 1
		addtimer(CALLBACK(src, /obj/item/rig_module/emergency_powergenerator/proc/reset_cooldown), 240)

/obj/item/rig_module/emergency_powergenerator/proc/reset_cooldown()
	cooldown = 0

/obj/item/rig_module/device/emag_hand
	name = "integrated cryptographic sequencer"
	desc = "A complex uprade that allows the user to apply an EMAG effect to certain objects. High power cost."
	use_power_cost = 100
	module_cooldown = 4800

	interface_name = "integrated cryptographic sequencer"
	interface_desc = "A complex uprade that allows the user to apply an EMAG effect to certain objects. High power cost."

	device_type = /obj/item/weapon/robot_emag

	category = MODULE_SPECIAL
