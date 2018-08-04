/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/weapon/gun/gun, list/properties = null)
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

/datum/firemode/proc/apply_to(obj/item/weapon/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(//DEPRECATED. USE CONTAINED SPRITES IN FUTURE
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi'
		)
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
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
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/fire_sound_text = "gunshot"
	var/recoil = 0		//screen shake
	var/silenced = 0
	var/muzzle_flash = 3
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/reliability = 100

	var/obj/item/device/firing_pin/pin = /obj/item/device/firing_pin//standard firing pin for most guns.

	var/can_bayonet = FALSE
	var/obj/item/weapon/material/knife/bayonet/bayonet
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


	//aiming system stuff
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/lock_time = -100

/obj/item/weapon/gun/Initialize(mapload)
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if (!pin && needspin)
		pin = /obj/item/device/firing_pin

	if(pin && needspin)
		pin = new pin(src)

	queue_icon_update()

/obj/item/weapon/gun/update_icon()
	underlays.Cut()
	if(bayonet)
		var/image/I
		I = image('icons/obj/gun.dmi', "bayonet")
		I.pixel_x = knife_x_offset
		I.pixel_y = knife_y_offset
		underlays += I
	return ..()

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/weapon/gun/proc/special_check(var/mob/user)
	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0

	if(user.disabilities & PACIFIST)
		to_chat(user, "<span class='notice'>You don't want to risk harming anyone!</span>")
		return 0

	var/mob/living/M = user

	if(HULK in M.mutations)
		M << "<span class='danger'>Your fingers are much too large for the trigger guard!</span>"
		return 0

	if(ishuman(M))
		var/mob/living/carbon/human/A = M
		if(A.martial_art && A.martial_art.no_guns)
			to_chat(A, "<span class='warning'>[A.martial_art.no_guns_message]</span>")
			return 0

	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				user.visible_message(
					"<span class='danger'>\The [user] shoots \himself in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0

	if(pin && needspin)
		if(pin.pin_auth(user) || pin.emagged)
			return 1
		else
			pin.auth_fail(user)
			return 0
	else
		if(needspin)
			to_chat(user, "<span class='warning'>[src]'s trigger is locked. This weapon doesn't have a firing pin installed!</span>")
			return 0
		else
			return 1

	return 1

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	else
		Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_sel.selecting == "mouth" && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		Fire(A, user, pointblank=1)
	else if(bayonet)
		bayonet.attack(A, user, def_zone)
	else
		return ..() //Pistolwhippin'

/obj/item/weapon/gun/proc/fire_checks(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target)
		return 0

	add_fingerprint(user)
	if(user.client && (user.client.prefs.toggles_secondary & SAFETY_CHECK) && user.a_intent != I_HURT) //Check this first to save time.
		user << "You refrain from firing, as you aren't on harm intent."
		return 0

	if(!special_check(user))
		return 0

	var/failure_chance = 100 - reliability
	if(failure_chance && prob(failure_chance))
		handle_reliability_fail(user)
		return 0

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			user << "<span class='warning'>[src] is not ready to fire again!</span>"
		return 0

	var/shoot_time = (burst - 1)* burst_delay
	user.setClickCooldown(shoot_time)
	user.setMoveCooldown(shoot_time)
	next_fire_time = world.time + shoot_time

	return 1

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!fire_checks(target,user,clickparams,pointblank,reflex))
		return

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

		if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex, i == burst)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

	update_held_icon()

	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.setMoveCooldown(move_delay)
	next_fire_time = world.time + fire_delay

// Similar to the above proc, but does not require a user, which is ideal for things like turrets.
/obj/item/weapon/gun/proc/Fire_userless(atom/target)
	if(!target)
		return

	if(world.time < next_fire_time)
		return

	var/shoot_time = (burst - 1)* burst_delay
	next_fire_time = world.time + shoot_time

	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile()
		if(!projectile)
			handle_click_empty()
			break

		if(istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile

			var/acc = burst_accuracy[min(i, burst_accuracy.len)]
			var/disp = dispersion[min(i, dispersion.len)]

			P.accuracy = accuracy + acc
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced = silenced

			P.launch_projectile(target)

			if(silenced)
				playsound(src, fire_sound, 10, 1)
			else
				playsound(src, fire_sound, 50, 1)

			if (muzzle_flash)
				set_light(muzzle_flash)
				addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 2, TIMER_UNIQUE | TIMER_OVERRIDE)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc

	//update timing
	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracy

//obtains the next projectile to fire
/obj/item/weapon/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/weapon/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return (target in check_trajectory(target, user))

//called if there was no projectile to shoot
/obj/item/weapon/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
	else
		src.visible_message("*click click*")
	playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

//called after successfully firing
/obj/item/weapon/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0, var/playemote = 1)
	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 1)

		if (playemote)
			if(reflex)
				user.visible_message(
					"<span class='reflex_shoot'><b>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""] by reflex!</b></span>",
					"<span class='reflex_shoot'>You fire \the [src] by reflex!</span>",
					"You hear a [fire_sound_text]!"
					)
			else
				user.visible_message(
					"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""]!</span>",
					"<span class='warning'>You fire \the [src]!</span>",
					"You hear a [fire_sound_text]!"
					)

		if(muzzle_flash)
			set_light(muzzle_flash)
			addtimer(CALLBACK(src, /atom/.proc/set_light, 0), 2)

	if(recoil)
		spawn()
			shake_camera(user, recoil+1, recoil)
	update_icon()


/obj/item/weapon/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
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
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult
	//you can't miss at point blank..
	P.can_miss = 1

/obj/item/weapon/gun/proc/process_accuracy(obj/projectile, mob/user, atom/target, acc_mod, dispersion)
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
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, target_zone, params)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return 0 //default behaviour only applies to true projectiles

	//shooting while in shock
	var/added_spread = 0
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			added_spread = 30
		else if(mob.shock_stage > 70)
			added_spread = 15

	return !P.launch_from_gun(target, target_zone, user, params, null, added_spread, src)

//Suicide handling.
/obj/item/weapon/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>
/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<span class='warning'>[user] sticks their gun in their mouth, ready to pull the trigger...</span>")
	if(!do_after(user, 40))
		M.visible_message("<span class='notice'>[user] decided life was worth living</span>")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		if (!pin && needspin)//Checks the pin of the gun.
			user.visible_message("<span class = 'warning'>*click click*</span>")
			mouthshoot = 0
			return
		if (!pin.pin_auth() && needspin)
			user.visible_message("<span class = 'warning'>*click click*</span>")
			mouthshoot = 0
			return
		if(silenced)
			playsound(user, fire_sound, 10, 1)
		else
			playsound(user, fire_sound, 50, 1)

		in_chamber.on_hit(M)

		if (in_chamber.damage == 0)
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return
		else if (in_chamber.damage_type == HALLOSS)
			user << "<span class = 'notice'>Ow...</span>"
			user.apply_effect(110,AGONY,0)
		else
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
			user.death()
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

/obj/item/weapon/gun/proc/toggle_scope(var/zoom_amount=2.0, var/mob/user)
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
/obj/item/weapon/gun/zoom()
	..()
	if(!zoom)
		if(can_wield() && wielded)
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

/obj/item/weapon/gun/examine(mob/user)
	..()
	if(needspin)
		if(pin)
			to_chat(user, "\The [pin] is installed in the trigger mechanism.")
		else
			to_chat(user, "It doesn't have a firing pin installed, and won't fire.")
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		to_chat(user, "The fire selector is set to [current_mode.name].")

/obj/item/weapon/gun/proc/switch_firemodes()
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)

	return new_mode

/obj/item/weapon/gun/attack_self(mob/user)
	var/datum/firemode/new_mode = switch_firemodes(user)
	if(new_mode)
		user << "<span class='notice'>\The [src] is now set to [new_mode.name].</span>"

//Handling of rifles and two-handed weapons.
/obj/item/weapon/gun/proc/can_wield()
	return 0

/obj/item/weapon/gun/proc/toggle_wield(mob/user as mob)
	if(!can_wield())
		return
	if(!istype(user.get_active_hand(), /obj/item/weapon/gun))
		user << "<span class='warning'>You need to be holding the [name] in your active hand</span>"
		return
	if(!istype(user, /mob/living/carbon/human))
		user << "<span class='warning'>It's too heavy for you to stabilize properly.</span>"
		return

	var/mob/living/carbon/human/M = user
	if(istype(M.species, /datum/species/monkey))
		user << "<span class='warning'>It's too heavy for you to stabilize properly.</span>"
		return

	if(wielded)
		unwield()
		user << "<span class='notice'>You are no-longer stabilizing the [name] with both hands.</span>"

		var/obj/item/weapon/gun/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		else
			O = user.get_active_hand()
			if(O && istype(O))
				O.unwield()

		return

	else
		if(user.get_inactive_hand())
			user << "<span class='warning'>You need your other hand to be empty.</span>"
			return
		wield()
		user << "<span class='notice'>You stabilize the [initial(name)] with both hands.</span>"

		var/obj/item/weapon/gun/offhand/O = new(user)
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]."
		user.put_in_inactive_hand(O)

	return

/obj/item/weapon/gun/proc/unwield()
	wielded = 0
	if(fire_delay_wielded)
		fire_delay = initial(fire_delay)
	if(recoil_wielded)
		recoil = initial(recoil)
	if(accuracy_wielded)
		accuracy = initial(accuracy)

	update_icon()
	update_held_icon()

/obj/item/weapon/gun/proc/wield()
	wielded = 1
	if(fire_delay_wielded)
		fire_delay = fire_delay_wielded
	if(recoil_wielded)
		recoil = recoil_wielded
	if(accuracy_wielded)
		accuracy = accuracy_wielded

	update_icon()
	update_held_icon()

/obj/item/weapon/gun/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(can_wield())
		if(wielded)
			M << "<span class='warning'>Lower the [initial(name)] first!</span>"
			return 0

	return ..()

/obj/item/weapon/gun/dropped(mob/living/user as mob)
	..()

	//Unwields the item when dropped, deletes the offhand
	if(can_wield())
		if(user)
			var/obj/item/weapon/gun/O = user.get_inactive_hand()
			if(istype(O))
				O.unwield()
		return unwield()

/obj/item/weapon/gun/pickup(mob/user)
	if(can_wield())
		unwield()

///////////OFFHAND///////////////
/obj/item/weapon/gun/offhand
	w_class = 5.0
	icon = 'icons/obj/weapons.dmi'
	icon_state = "offhand"
	item_state = "nothing"
	name = "offhand"
	needspin = FALSE

	unwield()
		if (ismob(loc))
			var/mob/the_mob = loc
			the_mob.drop_from_inventory(src)
		else
			qdel(src)

	wield()
		if (ismob(loc))
			var/mob/the_mob = loc
			the_mob.drop_from_inventory(src)
		else
			qdel(src)

	dropped(mob/living/user as mob)
		if(user)
			var/obj/item/weapon/gun/O = user.get_inactive_hand()
			if(istype(O))
				user << "<span class='notice'>You are no-longer stabilizing the [name] with both hands.</span>"
				O.unwield()
				unwield()

		if (!QDELETED(src))
			qdel(src)

	mob_can_equip(M as mob, slot)
		return 0

obj/item/weapon/gun/Destroy()
	if (istype(pin))
		QDEL_NULL(pin)
	if(bayonet)
		QDEL_NULL(bayonet)
	return ..()


/obj/item/weapon/gun/proc/handle_reliability_fail(var/mob/user)
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

/obj/item/weapon/gun/proc/small_fail(var/mob/user)
	return

/obj/item/weapon/gun/proc/medium_fail(var/mob/user)
	return

/obj/item/weapon/gun/proc/critical_fail(var/mob/user)
	return

/obj/item/weapon/gun/attackby(var/obj/item/I as obj, var/mob/user as mob)

	if(istype(I, /obj/item/weapon/material/knife/bayonet))
		if(!can_bayonet)
			return ..()

		if(bayonet)
			to_chat(user, "<span class='danger'>There is a bayonet attached to \the [src] already.</span>")
			return

		user.drop_from_inventory(I,src)
		bayonet = I
		to_chat(user, "<span class='notice'>You attach \the [I] to the front of \the [src].</span>")
		update_icon()

	if(!pin)
		return ..()

	if(isscrewdriver(I))
		visible_message("<span class = 'warning'>[user] begins to try and pry out [src]'s firing pin!</span>")
		if(do_after(user,45 SECONDS,act_target = src))
			if(pin.durable)
				visible_message("<span class = 'notice'>[user] pops the [pin] out of [src]!</span>")
				pin.forceMove(get_turf(src))
				pin = null//clear it out.
			else
				user.visible_message(
				"<span class='warning'>[user] breaks some electronics free from [src] with a crack.</span>",
				"<span class='alert'>You apply a bit too much force to [pin], and it breaks in two. Oops.</span>",
				"You hear a metallic crack.")
				qdel(pin)
				pin = null
	.=..()