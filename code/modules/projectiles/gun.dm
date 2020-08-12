/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()
	var/list/original_settings

/datum/firemode/New(obj/item/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/gun/gun)
	LAZYINITLIST(original_settings)

	for(var/propname in settings)
		original_settings[propname] = gun.vars[propname]
		gun.vars[propname] = settings[propname]

/datum/firemode/proc/unapply_to(obj/item/gun/gun)
	if (LAZYLEN(original_settings))
		for (var/propname in original_settings)
			gun.vars[propname] = original_settings[propname]

		LAZYCLEARLIST(original_settings)
		original_settings = null

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	desc_info = "This is a gun.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire."
	icon = 'icons/obj/guns/pistol.dmi'
	var/gun_gui_icons = 'icons/obj/guns/gun_gui.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	contained_sprite = TRUE
	flags = CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	var/burst = 1
	var/can_autofire = FALSE
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 1	//delay between shots, if firing in bursts
	var/move_delay = 0
	var/fire_sound = 'sound/weapons/gunshot/gunshot1.ogg'
	var/fire_sound_text = "gunshot"
	var/recoil = 0		//screen shake
	var/silenced = 0
	var/muzzle_flash = 3
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/reliability = 100

	var/cyborg_maptext_override
	var/displays_maptext = FALSE
	var/can_ammo_display = TRUE
	var/obj/item/ammo_display
	maptext_x = 22
	maptext_y = 2

	var/obj/item/device/firing_pin/pin = /obj/item/device/firing_pin //standard firing pin for most guns.

	var/can_bayonet = FALSE
	var/obj/item/material/knife/bayonet/bayonet
	var/knife_x_offset = 0
	var/knife_y_offset = 0

	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()

	//wielding information
	var/fire_delay_wielded = 0
	var/recoil_wielded = 0
	var/accuracy_wielded = 0
	var/wielded = 0
	var/needspin = TRUE
	var/is_wieldable = FALSE
	var/wield_sound = "wield_generic"
	var/unwield_sound = null

	//aiming system stuff
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/lock_time = -100
	var/safety_state = TRUE
	var/has_safety = TRUE
	var/image/safety_overlay

	// sounds n shit
	var/safetyon_sound = 'sound/weapons/blade_open.ogg'
	var/safetyoff_sound = 'sound/weapons/blade_close.ogg'

	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'

/obj/item/gun/Initialize(mapload)
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if (!pin && needspin)
		pin = /obj/item/device/firing_pin

	if(pin && needspin)
		pin = new pin(src)

	if(istype(loc, /obj/item/robot_module))
		has_safety = FALSE
		if(!cyborg_maptext_override)
			displays_maptext = TRUE
		update_maptext()

	if(istype(loc, /obj/item/rig_module))
		has_safety = FALSE

	update_wield_verb()

	queue_icon_update()

/obj/item/gun/update_icon()
	..()
	underlays.Cut()
	if(bayonet)
		var/image/I
		I = image(icon = 'icons/obj/guns/bayonet.dmi', icon_state = "bayonet")
		I.pixel_x = knife_x_offset
		I.pixel_y = knife_y_offset
		underlays += I

	if(has_safety)
		cut_overlay(safety_overlay, TRUE)
		safety_overlay = null
		if(!isturf(loc)) // In a mob, holster or bag or something
			safety_overlay = image(gun_gui_icons,"[safety()]")
			add_overlay(safety_overlay, TRUE)

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)
	if(!isliving(user))
		return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE

	if(user.is_pacified())
		to_chat(user, SPAN_NOTICE("You don't want to risk harming anyone!"))
		return FALSE

	var/mob/living/M = user

	if(HULK in M.mutations)
		to_chat(M, SPAN_DANGER("Your fingers are much too large for the trigger guard!"))
		return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/A = M
		if(A.martial_art?.no_guns)
			to_chat(A, SPAN_WARNING("[A.martial_art.no_guns_message]"))
			return FALSE

	if((M.is_clumsy()) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick(BP_L_FOOT, BP_R_FOOT)))
				handle_post_fire(user, user)
				user.visible_message(
					SPAN_DANGER("\The [user] shoots \himself in the foot with \the [src]!"),
					SPAN_DANGER("You shoot yourself in the foot with \the [src]!")
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return FALSE

	if(pin && needspin)
		if(pin.pin_auth(user) || pin.emagged)
			return TRUE
		else
			pin.auth_fail(user)
			return FALSE
	else
		if(needspin)
			to_chat(user, SPAN_WARNING("\The [src]'s trigger is locked. This weapon doesn't have a firing pin installed!"))
			return FALSE
		else
			return TRUE

/obj/item/gun/verb/wield_gun()
	set name = "Wield Firearm"
	set category = "Object"
	set src in usr

	if(is_wieldable)
		toggle_wield(usr)
		update_held_icon()
	else
		to_chat(usr, SPAN_WARNING("You can't wield \the [src]!"))

/obj/item/gun/ui_action_click()
	if(src in usr)
		wield_gun()

/obj/item/gun/proc/update_wield_verb()
	if(is_wieldable) //If the gun is marked as wieldable, make the action button appear and add the verb.
		action_button_name = "Wield Firearm"
		verbs += /obj/item/gun/verb/wield_gun
	else
		action_button_name = ""
		verbs -= /obj/item/gun/verb/wield_gun


/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user?.client && user.aiming?.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return
	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == BP_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent != I_HURT && user.aiming && user.aiming.active) //if aim mode, don't pistol whip
		if (user.aiming.aiming_at != A)
			PreFire(A, user)
		else
			Fire(A, user, pointblank=1)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else if(bayonet)
		bayonet.attack(A, user, def_zone)
	else
		return ..() //Pistolwhippin'

/obj/item/gun/proc/fire_checks(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target)
		return FALSE

	add_fingerprint(user)

	if(safety())
		if(user.a_intent == I_HURT)
			toggle_safety(user)
		else
			handle_click_empty(user)
			return FALSE

	if(!special_check(user))
		return FALSE

	var/failure_chance = 100 - reliability
	if(prob(failure_chance))
		handle_reliability_fail(user)
		return FALSE

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, SPAN_WARNING("\The [src] is not ready to fire again!"))
		return FALSE

	var/shoot_time = (burst - 1) * burst_delay
	user.setClickCooldown(shoot_time)
	user.setMoveCooldown(shoot_time)
	next_fire_time = world.time + shoot_time

	return TRUE

/obj/item/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!fire_checks(target,user,clickparams,pointblank,reflex))
		return FALSE

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		var/acc = burst_accuracy[min(i, burst_accuracy.len)]
		var/disp = dispersion[min(i, dispersion.len)]
		process_accuracy(projectile, user, target, acc, disp)

		if(pointblank)
			process_point_blank(projectile, user, target)

		var/selected_zone = user.zone_sel ? user.zone_sel.selecting : BP_CHEST
		if(process_projectile(projectile, user, target, selected_zone, clickparams))
			var/show_emote = TRUE
			if(i > 1 && burst_delay < 3 && burst < 5)
				show_emote = FALSE
			handle_post_fire(user, target, pointblank, reflex, show_emote)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	update_held_icon()

	//update timing
	var/delay = max(burst_delay+1, fire_delay)
	user.setClickCooldown(min(delay, DEFAULT_QUICK_COOLDOWN))
	user.setMoveCooldown(move_delay)

// Similar to the above proc, but does not require a user, which is ideal for things like turrets.
/obj/item/gun/proc/Fire_userless(atom/target)
	if(!target)
		return FALSE

	if(world.time < next_fire_time)
		return FALSE

	var/shoot_time = (burst - 1)* burst_delay
	next_fire_time = world.time + shoot_time

	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile()
		if(!projectile)
			handle_click_empty()
			break

		if(isprojectile(projectile))
			var/obj/item/projectile/P = projectile

			var/acc = burst_accuracy[min(i, burst_accuracy.len)]
			var/disp = dispersion[min(i, dispersion.len)]

			P.accuracy = accuracy + acc
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced = silenced

			P.launch_projectile(target)

			handle_post_fire() // should be safe to not include arguments here, as there are failsafes in effect (?)

			if(silenced)
				playsound(src, fire_sound, 10, 1)
			else
				playsound(src, fire_sound, 75, 1, 3, 0.5, 1)

			if (muzzle_flash)
				set_light(muzzle_flash)
				addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 2, TIMER_UNIQUE | TIMER_OVERRIDE)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!target?.loc)
			target = targloc

	//update timing
	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracy

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target, var/mob/living/user)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return (target in check_trajectory(target, user))

//called if there was no projectile to shoot
/obj/item/gun/proc/handle_click_empty(mob/user)
	if(user)
		to_chat(user, SPAN_DANGER("*click*"))
	else
		src.visible_message("*click click*")
	playsound(loc, 'sound/weapons/empty.ogg', 100, 1)

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank = FALSE, var/reflex = FALSE, var/playemote = TRUE)
	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 75, 1, 3, 0.5, 1)

		if(playemote)
			if(reflex)
				user.visible_message(
					SPAN_DANGER("<b>\The [user] fires \the [src][pointblank ? " point blank at [target]" : ""] by reflex!</b>"),
					SPAN_DANGER("You fire \the [src][pointblank ? " point blank at [target]" : ""] by reflex!"),
					"You hear a [fire_sound_text]!"
				)
			else
				user.visible_message(
					SPAN_DANGER("\The [user] fires \the [src][pointblank ? " point blank at [target]" : ""]!"),
					SPAN_DANGER("You fire \the [src][pointblank ? " point blank at [target]" : ""]!"),
					"You hear a [fire_sound_text]!"
				)

		if(muzzle_flash)
			set_light(muzzle_flash)
			addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 2)

	if(recoil)
		shake_camera(user, recoil + 1, recoil)

	if(ishuman(user) && user.invisibility == INVISIBILITY_LEVEL_TWO) //shooting will disable a rig cloaking device
		var/mob/living/carbon/human/H = user
		if(istype(H.back, /obj/item/rig))
			var/obj/item/rig/R = H.back
			for(var/obj/item/rig_module/stealth_field/S in R.installed_modules)
				S.deactivate()
	update_icon()

/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/damage_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult
	//you can't miss at point blank..
	P.can_miss = 1

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/user, atom/target, acc_mod, dispersion)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod
	P.dispersion = dispersion

	//Increasing accuracy across the board, ever so slightly
	P.accuracy += 1

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 2

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, target_zone, params)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	//shooting while in shock
	var/added_spread = 0
	if(iscarbon(user))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			added_spread = 30
		else if(mob.shock_stage > 70)
			added_spread = 15

	return !P.launch_from_gun(target, target_zone, user, params, null, added_spread, src)

//Suicide handling.
/obj/item/gun/var/mouthshoot = FALSE //To stop people from suiciding twice... >.>
/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = TRUE
	M.visible_message(SPAN_WARNING("\The [user] sticks their gun in their mouth, ready to pull the trigger..."))
	if(!do_after(user, 40))
		M.visible_message(SPAN_NOTICE("\The [user] decided life was worth living"))
		mouthshoot = FALSE
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message(SPAN_WARNING("\The [user] pulls the trigger."))
		if (!pin && needspin)//Checks the pin of the gun.
			user.visible_message(SPAN_WARNING("*click click*"))
			mouthshoot = FALSE
			return
		if (!pin.pin_auth() && needspin)
			user.visible_message(SPAN_WARNING("*click click*"))
			mouthshoot = FALSE
			return
		if(safety() && user.a_intent != I_HURT)
			user.visible_message(SPAN_WARNING("The safety was on. How anticlimatic!"))
			handle_click_empty(user)
			mouthshoot = FALSE
			return
		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 75, 1, 3, 0.5, 1)

		in_chamber.on_hit(M)

		if (in_chamber.damage == 0)
			user.show_message(SPAN_WARNING("You feel rather silly, trying to commit suicide with a toy."))
			mouthshoot = FALSE
			return
		else if (in_chamber.damage_type == PAIN)
			to_chat(user, SPAN_NOTICE("Ow..."))
			user.apply_effect(110,PAIN,0)
		else
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, BP_HEAD, used_weapon = "Point blank shot in the mouth with \a [in_chamber]", damage_flags = DAM_SHARP)
			user.death()
		qdel(in_chamber)
		mouthshoot = FALSE
		return
	else
		handle_click_empty(user)
		mouthshoot = FALSE
		return

/obj/item/gun/proc/toggle_scope(var/zoom_amount=2.0, var/mob/user)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	zoom(user, zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(recoil)
			recoil = round(recoil*zoom_amount+1) //recoil is worse when looking through a scope

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/gun/zoom()
	..()
	if(!zoom)
		if(is_wieldable && wielded)
			if(accuracy_wielded)
				accuracy = accuracy_wielded
			else
				accuracy = initial(accuracy)
			if(recoil_wielded)
				recoil = recoil_wielded
			else
				recoil = initial(recoil)
		else
			accuracy = initial(accuracy)
			recoil = initial(recoil)

/obj/item/gun/examine(mob/user)
	..()
	if(get_dist(src, user) > 1)
		return
	if(needspin)
		if(pin)
			to_chat(user, "\The [pin] is installed in the trigger mechanism.")
		else
			to_chat(user, "It doesn't have a firing pin installed, and won't fire.")
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, "The fire selector is set to [current_mode.name].")
	if(has_safety)
		to_chat(user, "The safety is [safety() ? "on" : "off"].")

/obj/item/gun/proc/switch_firemodes()
	if(!firemodes.len)
		return null

	var/datum/firemode/old_mode = firemodes[sel_mode]
	old_mode.unapply_to(src)

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

	return new_mode

/obj/item/gun/attack_self(mob/user, var/list/message_mobs)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(new_mode)
		to_chat(user, SPAN_NOTICE("\The [src] is now set to [new_mode.name]."))
	for(var/M in message_mobs)
		to_chat(M, SPAN_NOTICE("[user] has set \the [src] to [new_mode.name]."))

// Safety Procs

/obj/item/gun/proc/toggle_safety(var/mob/user)
	safety_state = !safety_state
	update_icon()
	if(user)
		to_chat(user, SPAN_NOTICE("You switch the safety [safety_state ? "on" : "off"] on \the [src]."))
		if(!safety_state)
			playsound(src, safetyon_sound, 30, 1)
		else
			playsound(src, safetyoff_sound, 30, 1)

/obj/item/gun/verb/toggle_safety_verb()
	set src in usr
	set category = "Object"
	set name = "Toggle Gun Safety"
	if(usr == loc)
		toggle_safety(usr)

/obj/item/gun/CtrlClick(var/mob/user)
	if(user == loc)
		toggle_safety(user)
		return TRUE
	. = ..()

/obj/item/gun/proc/safety()
	return has_safety && safety_state

//Handling of rifles and two-handed weapons.
/obj/item/gun/proc/can_wield()
	return FALSE

/obj/item/gun/proc/toggle_wield(mob/user as mob)
	if(!is_wieldable)
		return
	if(!istype(user.get_active_hand(), /obj/item/gun))
		to_chat(user, SPAN_WARNING("You need to be holding \the [name] in your active hand."))
		return
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("It's too heavy for you to stabilize properly."))
		return

	var/mob/living/carbon/human/M = user
	if(M.isMonkey())
		to_chat(user, SPAN_WARNING("It's too heavy for you to stabilize properly."))
		return

	if(wielded)
		unwield()
		to_chat(user, SPAN_NOTICE("You are no-longer stabilizing \the [name] with both hands."))

		var/obj/item/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		else
			O = user.get_active_hand()
		return

	else
		if(user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You need your other hand to be empty."))
			return
		wield()
		to_chat(user, SPAN_NOTICE("You stabilize \the [initial(name)] with both hands."))

		var/obj/item/offhand/O = new(user)
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on \the [initial(name)]."
		user.put_in_inactive_hand(O)

	return

/obj/item/gun/proc/unwield()
	wielded = FALSE
	if(fire_delay_wielded)
		fire_delay = initial(fire_delay)
	if(recoil_wielded)
		recoil = initial(recoil)
	if(accuracy_wielded)
		accuracy = initial(accuracy)
	if(unwield_sound)
		playsound(src.loc, unwield_sound, 50, 1)

	update_icon()
	update_held_icon()

/obj/item/gun/proc/wield()
	wielded = TRUE
	if(fire_delay_wielded)
		fire_delay = fire_delay_wielded
	if(recoil_wielded)
		recoil = recoil_wielded
	if(accuracy_wielded)
		accuracy = accuracy_wielded
	if(wield_sound)
		playsound(src.loc, wield_sound, 50, 1)

	update_icon()
	update_held_icon()

/obj/item/gun/mob_can_equip(M as mob, slot, disable_warning, ignore_blocked)
	//Cannot equip wielded items.
	if(is_wieldable)
		if(wielded)
			if(!disable_warning) // unfortunately not sure there's a way to get this to only fire once when it's looped
				to_chat(M, SPAN_WARNING("Lower \the [initial(name)] first!"))
			return FALSE

	return ..()

/obj/item/gun/throw_at()
	..()
	update_maptext()

/obj/item/gun/on_give()
	update_maptext()

/obj/item/gun/dropped(mob/living/user)
	..()
	queue_icon_update()
	//Unwields the item when dropped, deletes the offhand
	update_maptext()
	if(is_wieldable)
		if(user)
			var/obj/item/offhand/O = user.get_inactive_hand()
			if(istype(O))
				O.unwield()
		return unwield()

/obj/item/gun/pickup(mob/user)
	..()
	queue_icon_update()
	addtimer(CALLBACK(src, .proc/update_maptext), 1)
	if(is_wieldable)
		unwield()

///////////OFFHAND///////////////
/obj/item/offhand
	w_class = 5.0
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	item_state = "nothing"
	name = "offhand"
	drop_sound = null
	pickup_sound = null
	equip_sound = null

/obj/item/offhand/proc/unwield()
	if(ismob(loc))
		var/mob/the_mob = loc
		the_mob.drop_from_inventory(src)
	else
		qdel(src)

/obj/item/offhand/proc/wield()
	if(ismob(loc))
		var/mob/the_mob = loc
		the_mob.drop_from_inventory(src)
	else
		qdel(src)

/obj/item/offhand/dropped(mob/living/user)
	if(user)
		var/obj/item/gun/O = user.get_inactive_hand()
		if(istype(O))
			to_chat(user, SPAN_NOTICE("You are no-longer stabilizing \the [name] with both hands."))
			O.unwield()
			unwield()

	if (!QDELETED(src))
		qdel(src)

/obj/item/offhand/mob_can_equip(var/mob/M, slot, disable_warning = FALSE)
	return FALSE

/obj/item/gun/Destroy()
	if (istype(pin))
		QDEL_NULL(pin)
	if(bayonet)
		QDEL_NULL(bayonet)
	return ..()


/obj/item/gun/proc/handle_reliability_fail(var/mob/user)
	var/severity = 1
	if(prob(100-reliability))
		severity = 2
		if(prob(100-reliability))
			severity = 3
	switch(severity)
		if(1)
			small_fail(user)
		if(2)
			medium_fail(user)
		else
			critical_fail(user)

/obj/item/gun/proc/small_fail(var/mob/user)
	return

/obj/item/gun/proc/medium_fail(var/mob/user)
	return

/obj/item/gun/proc/critical_fail(var/mob/user)
	return

/obj/item/gun/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/material/knife/bayonet))
		if(!can_bayonet)
			return ..()

		if(bayonet)
			to_chat(user, SPAN_DANGER("There is a bayonet attached to \the [src] already."))
			return

		user.drop_from_inventory(I,src)
		bayonet = I
		to_chat(user, SPAN_NOTICE("You attach \the [I] to the front of \the [src]."))
		update_icon()
		return

	if(istype(I, /obj/item/ammo_display))
		if(!can_ammo_display)
			to_chat(user, SPAN_WARNING("\The [I] cannot attach to \the [src]."))
			return
		if(ammo_display)
			to_chat(user, SPAN_WARNING("\The [src] already has a holographic ammo display."))
			return
		if(displays_maptext)
			to_chat(user, SPAN_WARNING("\The [src] is already displaying its ammo count."))
			return
		user.drop_from_inventory(I, src)
		ammo_display = I
		displays_maptext = TRUE
		to_chat(user, SPAN_NOTICE("You attach \the [I] to \the [src]."))
		return

	if(I.iscrowbar() && bayonet)
		to_chat(user, SPAN_NOTICE("You detach \the [bayonet] from \the [src]."))
		bayonet.forceMove(get_turf(src))
		user.put_in_hands(bayonet)
		bayonet = null
		update_icon()
		return

	if(I.iswrench() && ammo_display)
		to_chat(user, SPAN_NOTICE("You wrench the ammo display loose from \the [src]."))
		ammo_display.forceMove(get_turf(src))
		user.put_in_hands(ammo_display)
		ammo_display = null
		displays_maptext = FALSE
		maptext = ""
		return

	if(pin && I.isscrewdriver())
		visible_message(SPAN_WARNING("\The [user] begins to try and pry out \the [src]'s firing pin!"))
		if(do_after(user,45 SECONDS,act_target = src))
			if(pin.durable || prob(50))
				visible_message(SPAN_NOTICE("\The [user] pops \the [pin] out of \the [src]!"))
				pin.forceMove(get_turf(src))
				user.put_in_hands(pin)
				pin = null//clear it out.
			else
				user.visible_message(
				SPAN_WARNING("\The [user] breaks some electronics free from \the [src] with a crack."),
				SPAN_ALERT("You apply a bit too much force to \the [pin], and it breaks in two. Oops."),
				"You hear a metallic crack.")
				qdel(pin)
				pin = null
		return
	return ..()

/obj/item/gun/proc/get_ammo()
	return 0

//Autofire
/obj/item/gun/proc/can_autofire()
	return (can_autofire && world.time >= next_fire_time)

/obj/item/gun/proc/update_maptext()
	if(displays_maptext)
		if(!ismob(loc) && !ismob(loc.loc))
			maptext = ""
			return
		if(get_ammo() > 9)
			maptext_x = 18
		else
			maptext_x = 22
		maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">[get_ammo()]</span>"
