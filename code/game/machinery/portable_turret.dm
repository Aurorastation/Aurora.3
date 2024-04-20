/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/


#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "cover_0"
	anchored = 1

	density = 0
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	power_channel = EQUIP	//drains power from the EQUIPMENT channel

	req_one_access = list(ACCESS_SECURITY, ACCESS_HEADS)

	light_range = 3
	light_power = 2

	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raising= 0			//if the turret is currently opening or closing its cover
	var/health = 80			//the turret's health
	var/maxhealth = 80		//turrets maximal health.
	var/auto_repair = 0		//if 1 the turret slowly repairs itself.
	var/locked = 1			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/obj/item/gun/energy/installation = /obj/item/gun/energy/gun //the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/reqpower = 500		//holder for power needed
	var/lethal_icon = 0		//holder for the icon_state. 1 for lethal sprite, null for stun sprite.
	var/egun = 1			//holder to handle certain guns switching modes
	var/sprite_set = "carbine"	//set of gun sprites the turret will use
	var/cover_set = 0		//set of cover sprites the turret will use
	var/name_override = FALSE

	var/last_fired = 0		//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		//1.5 seconds between each shot

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_wildlife = 1	//checks if it can shoot at simple animals or anything that passes issmall
	var/check_synth	 = 0	//if active, will shoot at anything not an AI or cyborg
	var/target_borgs = FALSE//if active, will shoot at borgs
	var/ailock = 0 			// AI cannot use this

	var/immobile = FALSE	// If TRUE, the turret cannot be detached from the ground with a wrench.
	var/no_salvage = FALSE	// If TRUE, the turret cannot be salvaged for parts when broken.

	var/attacked = 0		//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = 1			//determines if the turret is on
	var/lethal = 0			//whether in lethal or stun mode
	var/disabled = 0

	var/projectile =/obj/item/projectile/beam/stun	//holder for stun (main) mode beam
	var/eprojectile = /obj/item/projectile/beam		//holder for lethal (secondary) mode beam

	var/shot_sound = 'sound/weapons/Taser.ogg'		//what sound should play when the turret fires
	var/eshot_sound	= 'sound/weapons/laser1.ogg'		//what sound should play when the lethal turret fires

	var/datum/effect_system/sparks/spark_system		//the spark system, used for generating... sparks?

	var/wrenching = 0
	var/last_target			//last target fired at, prevents turrets from erratically firing at all valid targets in range
	var/list/targets = list()			//list of primary targets
	var/list/secondarytargets = list()	//targets that are least important
	var/resetting
	var/fast_processing = FALSE

	var/old_angle = 0

/obj/machinery/porta_turret/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	var/msg = ""
	if(!health)
		msg += SPAN_DANGER("\The [src] is destroyed!")
	else if(health / maxhealth < 0.35)
		msg += SPAN_DANGER("\The [src] is critically damaged!")
	else if(health / maxhealth < 0.6)
		msg += SPAN_WARNING("\The [src] is badly damaged!")
	else if(health / maxhealth < 1)
		msg += SPAN_NOTICE("\The [src] is slightly damaged!")
	else
		msg += SPAN_GOOD("\The [src] is not damaged!")
	. +=  msg

/obj/machinery/porta_turret/crescent
	enabled = FALSE
	ailock = TRUE
	check_synth	 = FALSE
	target_borgs = FALSE
	check_access = TRUE
	check_arrest = TRUE
	check_records = TRUE
	check_weapons = TRUE
	check_wildlife = TRUE
	immobile = TRUE
	no_salvage = TRUE
	req_one_access = list(ACCESS_CENT_SPECOPS, ACCESS_CENT_GENERAL)

	var/admin_emag_override = FALSE	// Set to true to allow emagging of this turret.

/obj/machinery/porta_turret/crescent/emag_act()
	if (admin_emag_override)
		return ..()
	else
		return NO_EMAG_ACT

/obj/machinery/porta_turret/stationary
	ailock = 1
	lethal = 1
	lethal_icon = 1
	egun = 0
	installation = /obj/item/gun/energy/laser
	sprite_set = "laser"

/obj/machinery/porta_turret/Initialize(mapload)
	. = ..()
	//Sets up a spark system
	spark_system = bind_spark(src, 5)
	if(!istype(installation, /obj/item/gun/energy))
		installation = new installation(src)
	if(installation)
		if(installation.fire_delay_wielded > 0)
			shot_delay = max(installation.fire_delay_wielded, 4)
		else
			shot_delay = max(installation.fire_delay, 4)
		if(!name_override)
			name = "[installation.name] [name]"

	var/area/control_area = get_area(src)
	if(istype(control_area))
		LAZYADD(control_area.turrets, src)
		if(!mapload)
			for(var/obj/machinery/turretid/aTurretID in control_area.turret_controls)
				aTurretID.turretModes()
		if(LAZYLEN(control_area.turret_controls))
			var/obj/machinery/turretid/SOME_TURRET_ID = control_area.turret_controls[1]
			var/datum/turret_checks/SOME_TC = SOME_TURRET_ID.getState() // this helper should honestly fucking exist why doesn't it :ree:
			if(SOME_TC.lethal != lethal && !egun)
				SOME_TC.enabled = 0
			src.setState(SOME_TC)

	add_to_target_grid()

/obj/machinery/porta_turret/Destroy()
	var/area/control_area = get_area(src)
	if(istype(control_area))
		LAZYREMOVE(control_area.turrets, src)
		for(var/obj/machinery/turretid/aTurretID in control_area.turret_controls)
			aTurretID.turretModes()
	qdel(spark_system)
	spark_system = null
	if(fast_processing)
		STOP_PROCESSING(SSfast_process, src)

	clear_from_target_grid()

	. = ..()


/obj/machinery/porta_turret/update_icon()
	cut_overlays()
	underlays.Cut()

	if(stat & BROKEN)
		icon_state = "turret_[sprite_set]_broken"
		underlays += "cover_open_[cover_set]"
		set_light(0)
	else if(raised || raising)
		if(powered() && enabled)
			if(!lethal_icon)
				icon_state = "turret_[sprite_set]_stun"
				underlays += "cover_open_[cover_set]"
			else
				icon_state = "turret_[sprite_set]_lethal"
				underlays += "cover_open_[cover_set]"
		else
			icon_state = "turret_[sprite_set]_off"
			underlays += "cover_open_[cover_set]"
	else
		icon_state = "cover_[cover_set]"

	if(stat & NOPOWER)
		set_light(0)
	else
		set_light(light_range, light_power)

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_WARNING("There seems to be a firewall preventing you from accessing this device."))
		return TRUE

	if(!issilicon(user))
		if(locked && !allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return TRUE

	return FALSE

/obj/machinery/porta_turret/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/porta_turret/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/porta_turret/ui_data(mob/user)
	var/list/data = list()
	data["locked"] = locked
	data["enabled"] = enabled
	data["is_lethal"] = TRUE
	data["lethal"] = lethal
	data["can_switch"] = egun
	data["settings"] = get_settings()
	return data

/obj/machinery/porta_turret/proc/get_settings()
	. = list()

	var/usedSettings = list(
		"check_synth" = "Neutralize All Non-Synthetics",
		"target_borgs" = "Neutralize All Cyborg-likes",
		"check_wildlife" = "Neutralize All Wildlife",
		"check_weapons" = "Check Weapon Authorization",
		"check_records" = "Check Security Records",
		"check_arrest" = "Check Arrest Status",
		"check_access" = "Check Access Authorization"
	)

	for(var/v in usedSettings)
		var/name = usedSettings[v]
		. += list(list("category" = name, "value" = vars[v], "variable_name" = v))

/obj/machinery/porta_turret/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TurretControl", "Defense Systems Control Panel", 375, 725)
		ui.open()

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(HasController())
		to_chat(user, "<span class='notice'>Turrets can only be controlled using the assigned turret controller.</span>")
		return UI_CLOSE

	if(isLocked(user))
		return UI_CLOSE

	if(!anchored)
		to_chat(usr, "<span class='notice'>\The [src] has to be secured first!</span>")
		return UI_CLOSE

	return ..()

/obj/machinery/porta_turret/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "command" && !isnull(params["value"]))
		var/value = text2num(params["value"])
		if(params["command"] == "enable")
			enabled = value
			if (enabled)
				START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
				fast_processing = FALSE
			else if(fast_processing)
				STOP_PROCESSING(SSfast_process, src)
				fast_processing = FALSE
				popDown()
			else
				STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
				popDown()
		else if(params["command"] == "lethal")
			lethal = value
			lethal_icon = value
		else if(params["command"] == "check_synth")
			check_synth = value
		else if(params["command"] == "target_borgs")
			target_borgs = value
		else if(params["command"] == "check_weapons")
			check_weapons = value
		else if(params["command"] == "check_records")
			check_records = value
		else if(params["command"] == "check_arrest")
			check_arrest = value
		else if(params["command"] == "check_access")
			check_access = value
		else if(params["command"] == "check_wildlife")
			check_wildlife = value
		. = TRUE

/obj/machinery/porta_turret/power_change()
	..()
	if(powered())
		queue_icon_update()
	else
		addtimer(CALLBACK(src, PROC_REF(lose_power)), rand(1, 15))

/obj/machinery/porta_turret/proc/lose_power()
	stat |= NOPOWER
	queue_icon_update()

/obj/machinery/porta_turret/attackby(obj/item/attacking_item, mob/user)
	if(stat & BROKEN)
		if(attacking_item.iscrowbar())
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, "<span class='notice'>You begin prying the metal coverings off.</span>")
			if(attacking_item.use_tool(src, user, 20, volume = 50))
				if(prob(70) && !no_salvage)
					to_chat(user, "<span class='notice'>You remove the turret and salvage some components.</span>")
					if(installation)
						installation.forceMove(loc)
						installation = null
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/device/assembly/prox_sensor(loc)
				else
					to_chat(user, "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>")
				qdel(src) // qdel
			return TRUE

	else if((attacking_item.iswrench()))
		if (immobile)
			to_chat(user, "<span class='notice'>[src] is firmly attached to the ground with some form of epoxy.</span>")
			return TRUE

		if(enabled || raised)
			to_chat(user, "<span class='warning'>You cannot unsecure an active turret!</span>")
			return TRUE
		if(wrenching)
			to_chat(user, "<span class='warning'>Someone is already [anchored ? "un" : ""]securing the turret!</span>")
			return TRUE
		if(!anchored && isinspace())
			to_chat(user, "<span class='warning'>Cannot secure turrets in space!</span>")
			return TRUE

		user.visible_message( \
				"<span class='warning'>[user] begins [anchored ? "un" : ""]securing the turret.</span>", \
				"<span class='notice'>You begin [anchored ? "un" : ""]securing the turret.</span>" \
			)

		wrenching = 1
		if(attacking_item.use_tool(src, user, 50, volume = 50))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				attacking_item.play_tool_sound(get_turf(src), 100)
				anchored = 1
				update_icon()
				to_chat(user, "<span class='notice'>You secure the exterior bolts on the turret.</span>")
			else if(anchored)
				attacking_item.play_tool_sound(get_turf(src), 100)
				anchored = 0
				to_chat(user, "<span class='notice'>You unsecure the exterior bolts on the turret.</span>")
				update_icon()
		wrenching = 0
		return TRUE

	else if(attacking_item.GetID())
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			to_chat(user, "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>")
			updateUsrDialog()
		else
			to_chat(user, "<span class='notice'>Access denied.</span>")
		return TRUE

	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if (!WT.welding)
			to_chat(user, "<span class='danger'>\The [WT] must be turned on!</span>")
		else if (health == maxhealth)
			to_chat(user, "<span class='notice'>\The [src] is fully repaired.</span>")
			return
		else if (WT.use(3, user))
			to_chat(user, "<span class='notice'>Now welding \the [src].</span>")
			if(WT.use_tool(src, user, 5, volume = 50))
				if(QDELETED(src) || !WT.isOn())
					return TRUE
				playsound(src.loc, 'sound/items/welder_pry.ogg', 50, 1)
				health += maxhealth / 3
				health = min(maxhealth, health)
			else
				to_chat(user, "<span class='notice'>You fail to complete the welding.</span>")
		else
			to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
		return TRUE
	else
		//if the turret was attacked with the intention of harming it:
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(attacking_item.force * 0.5)
		if(attacking_item.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				addtimer(CALLBACK(src, PROC_REF(reset_attacked)), 1 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		return ..()

/obj/machinery/porta_turret/proc/reset_attacked()
	attacked = FALSE

/obj/machinery/porta_turret/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		to_chat(user, "<span class='warning'>You short out [src]'s threat assessment circuits.</span>")
		visible_message("[src] hums oddly...")
		emagged = 1
		lethal_icon = 1
		controllock = 1
		shot_delay = shot_delay / 2
		enabled = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		enabled = 1 //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here
		return 1

/obj/machinery/porta_turret/proc/take_damage(var/force)
	if(!raised && !raising)
		force = force / 8
		if(force < 5)
			return

	health -= force
	if (force > 5 && prob(45))
		spark_system.queue()
	if(health <= 0)
		die()	//the death process :(

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	if(!damage)
		return

	if(enabled)
		if(!attacked && !emagged)
			attacked = 1
			addtimer(CALLBACK(src, PROC_REF(reset_attacked)), 60, TIMER_UNIQUE | TIMER_OVERRIDE)
	..()

	take_damage(damage)

/obj/machinery/porta_turret/emp_act(severity)
	. = ..()

	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_wildlife = prob(50)
		if(prob(5))
			emagged = TRUE

		enabled = FALSE
		addtimer(CALLBACK(src, PROC_REF(post_emp_act)), rand(60, 600))


/obj/machinery/porta_turret/proc/post_emp_act()
	enabled = TRUE

/obj/machinery/porta_turret/ex_act(severity)
	switch (severity)
		if (1)
			qdel(src)
		if (2)
			if (prob(25))
				qdel(src)
			else
				take_damage(initial(health) * 8) //should instakill most turrets
		if (3)
			take_damage(initial(health) * 8 / 3)

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	stat |= BROKEN	//enables the BROKEN bit
	spark_system.queue()	//creates some sparks because they look cool
	update_icon()

/obj/machinery/porta_turret/process()
	//the main machinery process
	if(stat & (NOPOWER|BROKEN))
		//if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!enabled)
		//if the turret is off, make it pop down
		popDown()
		return

	if(auto_repair && (health < maxhealth))
		use_power_oneoff(20000)
		health = min(health+1, maxhealth) // 1HP for 20kJ

	if(raising)
		return // Don't try to do target acquisition while we're resetting

	targets = list()
	secondarytargets = list()

	var/list/potentials = get_hearers_in_LOS(world.view, src)

	if(potentials.len)
		for(var/mob/living/L in potentials)
			assess_and_assign_living(L, targets, secondarytargets)

		if(targets.len || secondarytargets.len)
			fastscan(TRUE)

			if(!tryToShootAt(targets))
				tryToShootAt(secondarytargets)

	if(!targets.len && !secondarytargets.len)
		resetting = addtimer(CALLBACK(src, PROC_REF(reset)), 6 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE) // no valid targets, close the cover
	else if(resetting)
		deltimer(resetting)
		resetting = null

/obj/machinery/porta_turret/proc/fastscan(on)
	if(on == fast_processing)
		return

	if(on && !fast_processing)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		START_PROCESSING(SSfast_process, src)
	else if(fast_processing)
		STOP_PROCESSING(SSfast_process, src)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

	fast_processing = on

/obj/machinery/porta_turret/proc/reset()
	if(!targets.len && !secondarytargets.len)
		fastscan(FALSE)
		popDown()

/obj/machinery/porta_turret/proc/assess_and_assign_living(var/mob/living/L, var/list/targets, var/list/secondarytargets)
	switch(assess_living(L))
		if(TURRET_PRIORITY_TARGET)
			targets += L
		if(TURRET_SECONDARY_TARGET)
			secondarytargets += L

/obj/machinery/porta_turret/proc/assess_and_assign_closet(var/obj/structure/closet/C, var/list/targets, var/list/secondarytargets)
	if(is_type_in_list(C,list(/obj/structure/closet/statue,/obj/structure/closet/walllocker/firecloset,/obj/structure/closet/walllocker)))
		return
	if(!lethal)
		return

	//If someone in the locker is a primary target, we assign the locker as a primary target and return immediately.
	//If someone in the locker is a secondary target, we remember that and only assign the locker as a secondary target, if there is no other primary target in the locker.
	var/found_secondary = FALSE
	for(var/O in C.contents)
		if(!isliving(O))
			continue
		switch(assess_living(O))
			if(TURRET_PRIORITY_TARGET)
				targets += C
				return
			if(TURRET_SECONDARY_TARGET)
				found_secondary = TRUE
	if(found_secondary)
		secondarytargets += C

/obj/machinery/porta_turret/proc/assess_living(var/mob/living/L)
	if(!istype(L))
		return TURRET_NOT_TARGET

	if(!L)
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(!emagged && !target_borgs && issilicon(L))	// Don't target silica
		return TURRET_NOT_TARGET

	if(isbrain(L) && !isturf(L.loc)) // Don't target cyborg brains / MMIs
		return TURRET_NOT_TARGET

	if(L.stat && !emagged)		//if the perp is dead/dying, no need to bother really
		return TURRET_NOT_TARGET	//move onto next potential victim!

	if(get_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TARGET

	var/flags =  PASSTABLE|PASSTRACE|PASSRAILING
	if(ispath(projectile, /obj/item/projectile/beam) || ispath(eprojectile, /obj/item/projectile/beam))
		flags |= PASSTABLE|PASSGLASS|PASSGRILLE|PASSRAILING

	if(!(L in check_trajectory(L, src, pass_flags=flags)))	//check if we have true line of sight
		return TURRET_NOT_TARGET

	if(emagged)		// If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(target_borgs && isAI(L))		//don't shoot the AI if we're shooting silica!
		return TURRET_NOT_TARGET

	if(lethal && locate(/mob/living/silicon/ai) in get_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TARGET

	if(check_synth)	//If it's set to attack all non-silicons, target them!
		if(L.lying)
			return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L) || issmall(L)) // Animals are not so dangerous
		return check_wildlife ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(isalien(L)) // Xenos are dangerous
		return check_wildlife ? TURRET_PRIORITY_TARGET	: TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
		return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(ismech(L))
		var/mob/living/heavy_vehicle/M = L
		if(!M.pilots?.len)
			return TURRET_NOT_TARGET
		for(var/mob/pilot in M.pilots)
			if(allowed(pilot)) // don't shoot if the mech contains at least one person with access
				return TURRET_NOT_TARGET
	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/assess_perp(var/mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

/obj/machinery/porta_turret/proc/tryToShootAt(var/list/targets)
	if(targets.len && last_target && (last_target in targets) && target(last_target))
		return 1

	while(targets.len > 0)
		var/T = pick(targets)
		targets -= T
		if(target(T))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	set waitfor = FALSE
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popup_[cover_set]", flick_holder)
	playsound(loc, 'sound/machines/turrets/turret_deploy.ogg', 100, 1)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(1, 0)
	update_icon()

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	set waitfor = FALSE

	last_target = null
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown_[cover_set]", flick_holder)
	playsound(loc, 'sound/machines/turrets/turret_retract.ogg', 100, 1)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(0, 0)
	set_angle(0)
	update_icon()

/obj/machinery/porta_turret/proc/set_raised_raising(var/raised, var/raising)
	src.raised = raised
	src.raising = raising
	density = raised || raising

/obj/machinery/porta_turret/proc/target(var/target)
	if(disabled)
		return
	if(target)
		last_target = target
		popUp()				//pop the turret up if it's not already up.
		var/new_angle = Get_Angle(src, target)
		if(new_angle > old_angle + 30 || new_angle < old_angle - 30)
			playsound(loc, 'sound/machines/turrets/turret_rotate.ogg', 100, 1)
		set_angle(new_angle)
		old_angle = new_angle
		shootAt(target)
		return 1
	return

/obj/machinery/porta_turret/proc/reset_last_fired()
	last_fired = FALSE

/obj/machinery/porta_turret/proc/shootAt(var/target)
	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
		return

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	update_icon()
	var/obj/item/projectile/A

	if(emagged || lethal)
		A = new eprojectile(loc)
		playsound(loc, eshot_sound, 75, 1)
	else
		A = new projectile(loc)
		playsound(loc, shot_sound, 75, 1)

	A.accuracy = max(installation.accuracy * 0.25 , installation.accuracy_wielded * 0.25, A.accuracy * 0.25)  // Because turrets should be better at shooting.

	// Lethal/emagged turrets use twice the power due to higher energy beams
	// Emagged turrets again use twice as much power due to higher firing rates
	use_power_oneoff(reqpower * (2 * (emagged || lethal)) * (2 * emagged))

	//Turrets aim for the center of mass by default.
	//If the target is grabbing someone then the turret smartly aims for extremities
	var/def_zone = get_exposed_defense_zone(target)
	//Shooting Code:
	A.launch_projectile(target, def_zone)
	last_fired = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_last_fired)), shot_delay, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/target_borgs
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_wildlife
	var/ailock

/obj/machinery/porta_turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return
	src.enabled = TC.enabled
	if (enabled)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		fast_processing = FALSE
	else if(fast_processing)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		fast_processing = FALSE
	else
		STOP_PROCESSING(SSfast_process, src)
	if(egun) //If turret can switch modes.
		src.lethal = TC.lethal
		src.lethal_icon = TC.lethal

	check_synth = TC.check_synth
	target_borgs = TC.target_borgs
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_wildlife = TC.check_wildlife
	ailock = TC.ailock

	src.power_change()
	update_icon()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame_0_0"
	density = 1
	var/target_type = /obj/machinery/porta_turret	// The type we intend to build
	var/build_step = 0			//the current step in the building process
	var/finish_name = "turret"	//the name applied to the product turret
	var/obj/item/gun/energy/installation = null		//the gun type installed
	var/case_sprite_set = 0		//sprite set the turret case will use
	var/obj/item/gun/energy/E = null

/obj/machinery/porta_turret_construct/dark
	icon_state = "turret_frame_0_1"
	case_sprite_set = 1

/obj/machinery/porta_turret_construct/attackby(obj/item/attacking_item, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(attacking_item.iswrench() && !anchored)
				attacking_item.play_tool_sound(get_turf(src), 100)
				to_chat(user, "<span class='notice'>You secure the external bolts.</span>")
				anchored = 1
				build_step = 1
				icon_state = "turret_frame_1_[case_sprite_set]"
				return TRUE

			else if(attacking_item.iscrowbar() && !anchored)
				attacking_item.play_tool_sound(get_turf(src), 75)
				to_chat(user, "<span class='notice'>You dismantle the turret construction.</span>")
				new /obj/item/stack/material/steel( loc, 5)
				qdel(src)
				return TRUE

		if(1)
			if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == DEFAULT_WALL_MATERIAL)
				var/obj/item/stack/M = attacking_item
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the interior frame.</span>")
					build_step = 2
					icon_state = "turret_frame_2_[case_sprite_set]"
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return TRUE

			else if(attacking_item.iswrench())
				attacking_item.play_tool_sound(get_turf(src), 75)
				to_chat(user, "<span class='notice'>You unfasten the external bolts.</span>")
				anchored = 0
				build_step = 0
				icon_state = "turret_frame_0_[case_sprite_set]"
				return TRUE


		if(2)
			if(attacking_item.iswrench())
				attacking_item.play_tool_sound(get_turf(src), 100)
				to_chat(user, "<span class='notice'>You bolt the metal armor into place.</span>")
				build_step = 3
				icon_state = "turret_frame_3_[case_sprite_set]"
				return TRUE

			else if(attacking_item.iswelder())
				var/obj/item/weldingtool/WT = attacking_item
				if(!WT.isOn())
					return TRUE
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					to_chat(user, "<span class='notice'>You need more fuel to complete this task.</span>")
					return TRUE

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/welder_pry.ogg'), 50, 1)
				if(attacking_item.use_tool(src, user, 20, volume = 50))
					if(!src || !WT.use(5, user)) return TRUE
					build_step = 1
					to_chat(user, "You remove the turret's interior metal armor.")
					new /obj/item/stack/material/steel( loc, 2)
					icon_state = "turret_frame_1_[case_sprite_set]"
				return TRUE


		if(3)
			if(istype(attacking_item, /obj/item/gun/energy)) //the gun installation part
				E = attacking_item //typecasts the item to a gun
				if(E.can_turret)
					if(isrobot(user))
						return TRUE
					if(!user.unEquip(attacking_item))
						to_chat(user, "<span class='notice'>\the [attacking_item] is stuck to your hand, you cannot put it in \the [src]</span>")
						return TRUE
					to_chat(user, "<span class='notice'>You install [attacking_item] into the turret.</span>")
					user.drop_from_inventory(E,src)
					target_type = /obj/machinery/porta_turret
					installation = attacking_item //installation becomes I.type
					build_step = 4
					icon_state = "turret_frame_4_[case_sprite_set]"
					add_overlay("turret_[E.turret_sprite_set]_off")
				return TRUE

			else if(attacking_item.iswrench())
				attacking_item.play_tool_sound(get_turf(src), 100)
				to_chat(user, "<span class='notice'>You remove the turret's metal armor bolts.</span>")
				build_step = 2
				icon_state = "turret_frame_2_[case_sprite_set]"
				return TRUE

		if(4)
			if(isprox(attacking_item))
				build_step = 5
				if(!user.unEquip(attacking_item))
					to_chat(user, "<span class='notice'>\the [attacking_item] is stuck to your hand, you cannot put it in \the [src]</span>")
					return TRUE
				to_chat(user, "<span class='notice'>You add the prox sensor to the turret.</span>")
				qdel(attacking_item)
				return TRUE

			//attack_hand() removes the gun

		if(5)
			if(attacking_item.isscrewdriver())
				attacking_item.play_tool_sound(get_turf(src), 100)
				build_step = 6
				to_chat(user, "<span class='notice'>You close the access hatch.</span>")
				icon_state = "turret_frame_5a_[case_sprite_set]"
				add_overlay("turret_[E.turret_sprite_set]_off")
				add_overlay("turret_frame_5b_[case_sprite_set]")
				return TRUE

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(attacking_item, /obj/item/stack/material) && attacking_item.get_material_name() == DEFAULT_WALL_MATERIAL)
				var/obj/item/stack/M = attacking_item
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the exterior frame.</span>")
					cut_overlays()
					icon_state = "turret_frame_5a_[case_sprite_set]"
					add_overlay("turret_[E.turret_sprite_set]_off")
					add_overlay("turret_frame_5c_[case_sprite_set]")
					build_step = 7
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return TRUE

			else if(attacking_item.isscrewdriver())
				attacking_item.play_tool_sound(get_turf(src), 100)
				build_step = 5
				to_chat(user, "<span class='notice'>You open the access hatch.</span>")
				cut_overlays()
				icon_state = "turret_frame_4_[case_sprite_set]"
				add_overlay("turret_[E.turret_sprite_set]_off")
				return TRUE

		if(7)
			if(attacking_item.iswelder())
				var/obj/item/weldingtool/WT = attacking_item
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					to_chat(user, "<span class='notice'>You need more fuel to complete this task.</span>")

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/welder_pry.ogg'), 50, 1)
				if(attacking_item.use_tool(src, user, 30, volume = 50))
					if(!src || !WT.use(5, user))
						return
					build_step = 8
					to_chat(user, "<span class='notice'>You weld the turret's armor down.</span>")

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.name = finish_name
					Turret.installation = installation
					Turret.gun_charge = E.power_supply.charge
					Turret.enabled = 0

					Turret.projectile = initial(E.projectile_type)
					if(E.secondary_projectile_type)
						Turret.eprojectile = E.secondary_projectile_type
					else
						Turret.eprojectile = E.projectile_type

					Turret.shot_sound = initial(E.fire_sound)
					if(E.secondary_fire_sound)
						Turret.eshot_sound = E.secondary_fire_sound
					else
						Turret.eshot_sound = E.fire_sound
					Turret.egun = E.can_switch_modes
					Turret.sprite_set = E.turret_sprite_set
					Turret.lethal_icon = E.turret_is_lethal
					// Check if gun has wielded delay, turret will have same fire rate as the gun.
					if(E.fire_delay_wielded > 0)
						Turret.shot_delay = max(E.fire_delay_wielded, 4)
					else
						Turret.shot_delay = max(E.fire_delay, 4)

					Turret.cover_set = case_sprite_set
					Turret.icon_state = "cover_[case_sprite_set]"
					START_PROCESSING_MACHINE(Turret, MACHINERY_PROCESS_SELF)
					qdel(src) // qdel
				return TRUE

			else if(attacking_item.iscrowbar())
				attacking_item.play_tool_sound(get_turf(src), 75)
				to_chat(user, "<span class='notice'>You pry off the turret's exterior armor.</span>")
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				cut_overlays()
				icon_state = "turret_frame_5a_[case_sprite_set]"
				add_overlay("turret_[E.turret_sprite_set]_off")
				add_overlay("turret_frame_5c_[case_sprite_set]")
				return TRUE

	if(attacking_item.ispen())	//you can rename turrets like bots!
		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text, MAX_NAME_LEN)
		if(t && in_range(src, usr) && loc != usr)
			finish_name = t
			return TRUE
	return ..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3
			E.forceMove(src.loc)
			installation = null
			cut_overlays()
			icon_state = "turret_frame_3_[case_sprite_set]"
			to_chat(user, "<span class='notice'>You remove [E.name] from the turret frame.</span>")

		if(5)
			to_chat(user, "<span class='notice'>You remove the prox sensor from the turret frame.</span>")
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return

/atom/movable/porta_turret_cover
	icon = 'icons/obj/turrets.dmi'


//preset turrets

/obj/machinery/porta_turret/xray
	installation = /obj/item/gun/energy/xray
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "xray"

	eprojectile = /obj/item/projectile/beam/xray
	eshot_sound	= 'sound/weapons/laser3.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/ion
	installation = /obj/item/gun/energy/rifle/ionrifle
	lethal = 0
	lethal_icon = 0
	egun = 1
	sprite_set = "ion"

	projectile = /obj/item/projectile/ion/stun
	eprojectile = /obj/item/projectile/ion
	shot_sound = 'sound/weapons/laser1.ogg'
	eshot_sound	= 'sound/weapons/laser1.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/crossbow
	installation = /obj/item/gun/energy/crossbow
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "crossbow"

	eprojectile = /obj/item/projectile/energy/bolt/large
	eshot_sound	= 'sound/weapons/Genhit.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/cannon
	installation = /obj/item/gun/energy/rifle/laser/heavy
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "cannon"

	eprojectile = /obj/item/projectile/beam/heavylaser
	eshot_sound	= 'sound/weapons/lasercannonfire.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/pulse
	installation = /obj/item/gun/energy/pulse
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "pulse"
	no_salvage = TRUE

	eprojectile = /obj/item/projectile/beam/pulse
	eshot_sound	= 'sound/weapons/pulse.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/sniper
	installation = /obj/item/gun/energy/sniperrifle
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "sniper"
	no_salvage = TRUE

	eprojectile = /obj/item/projectile/beam/sniper
	eshot_sound	= 'sound/weapons/marauder.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/net
	installation = /obj/item/gun/energy/net
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "net"

	eprojectile = /obj/item/projectile/beam/energy_net
	eshot_sound	= 'sound/weapons/plasma_cutter.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/thermal
	installation = /obj/item/gun/energy/vaurca/thermaldrill
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "thermaldrill"

	eprojectile = /obj/item/projectile/beam/thermaldrill
	eshot_sound	= 'sound/magic/lightningbolt.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/meteor
	installation = /obj/item/gun/energy/meteorgun
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "meteor"
	no_salvage = TRUE

	eprojectile = /obj/item/projectile/meteor
	eshot_sound	= 'sound/weapons/lasercannonfire.ogg'
	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/ballistic
	installation = /obj/item/gun/energy/mountedsmg
	lethal = 1
	lethal_icon = 1
	egun = 0
	sprite_set = "ballistic"
	no_salvage = TRUE

	eprojectile = /obj/item/projectile/bullet/pistol/medium
	eshot_sound	= 'sound/weapons/gunshot/gunshot_saw.ogg'

	req_one_access = list(ACCESS_SYNDICATE)

/obj/machinery/porta_turret/legion
	enabled = 0
	use_power = POWER_USE_OFF
	icon_state = "cover_legion"
	lethal = 1
	lethal_icon = 1
	egun = 0
	installation = /obj/item/gun/energy/blaster/carbine
	sprite_set = "blaster"
	cover_set = "legion"
	eprojectile = /obj/item/projectile/energy/blaster/heavy

	check_arrest = 0
	check_records = 0
	check_access = 1
	ailock = 1
	req_one_access = list(ACCESS_LEGION)

#undef TURRET_PRIORITY_TARGET
#undef TURRET_SECONDARY_TARGET
#undef TURRET_NOT_TARGET
