/obj/item/mecha_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mecha_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/carrying
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_equipment/clamp/resolve_attackby(atom/A, mob/user, click_params)
	if(istype(A, /obj/structure/closet) && owner)
		return 0
	return ..()

/obj/item/mecha_equipment/clamp/attack_hand(mob/user)
	if(owner && LAZYISIN(owner.pilots, user))
		if(!owner.hatch_closed && carrying)
			if(user.put_in_active_hand(carrying))
				owner.visible_message("<span class='notice'>\The [user] carefully grabs \the [carrying] from \the [src].</span>")
				carrying = null
	. = ..()
/obj/item/mecha_equipment/clamp/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()

	if(. && !carrying)
		if(istype(target, /obj))


			var/obj/O = target
			if(O.buckled_mob)
				return
			if(locate(/mob/living) in O)
				to_chat(user,"<span class='warning'>You can't load living things into the cargo compartment.</span>")
				return

			if(O.anchored)
				to_chat(user, "<span class='warning'>[target] is firmly secured.</span>")
				return


			owner.visible_message("<span class='notice'>\The [owner] begins loading \the [O].</span>")
			if(do_after(owner, 20, O, 0, 1))
				O.forceMove(src)
				carrying = O
				owner.visible_message("<span class='notice'>\The [owner] loads \the [O] into its cargo compartment.</span>")

				//attacking - Cannot be carrying something, cause then your clamp would be full
		else if(istype(target,/mob/living))
			var/mob/living/M = target
			if(user.a_intent == I_HURT)
				admin_attack_log(user, M, "attempted to clamp [M] with [src] ", "Was subject to a clamping attempt.", ", using \a [src], attempted to clamp")
				owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
				if(prob(33))
					owner.visible_message("<span class='danger'>[owner] swings its [src] in a wide arc at [target] but misses completely!</span>")
					return
				M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
				M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
				to_chat(user, "<span class='warning'>You slam [target] with [src.name].</span>")
				owner.visible_message("<span class='danger'>[owner] slams [target] with the hydraulic clamp.</span>")
			else
				step_away(M, owner)
				to_chat(user, "You push [target] out of the way.")
				owner.visible_message("[owner] pushes [target] out of the way.")

/obj/item/mecha_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, "<span class='warning'>You are not carrying anything in \the [src].</span>")
		else
			owner.visible_message("<span class='notice'>\The [owner] unloads \the [carrying].</span>")
			carrying.forceMove(get_turf(src))
			carrying = null

/obj/item/mecha_equipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

/obj/item/mecha_equipment/clamp/uninstalled()
	if(carrying)
		carrying.dropInto(loc)
		carrying = null
	. = ..()

/obj/item/weldingtool/get_hardpoint_status_value()
	return (get_fuel()/max_fuel)

/obj/item/weldingtool/get_hardpoint_maptext()
	return "[get_fuel()]/[max_fuel]"

/obj/item/mecha_equipment/mounted_system/plasmacutter
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "mecha_plasmacutter"
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)

/obj/item/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE

// A lot of this is copied from flashlights.
/obj/item/mecha_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	item_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)
	mech_layer = MECH_INTERMEDIATE_LAYER

	var/on = 0
	var/brightness_on = 12		//can't remember what the maxed out value is
	light_color = LIGHT_COLOR_TUNGSTEN
	light_wedge = LIGHT_WIDE
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)

/obj/item/mecha_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()
		owner.update_icon()

/obj/item/mecha_equipment/light/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on, 1)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/mecha_equipment/light/uninstalled()
	on = FALSE
	update_icon()
	. = ..()
#define CATAPULT_SINGLE 1
#define CATAPULT_AREA   2

/obj/item/mecha_equipment/catapult
	name = "gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mecha_teleport"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = CATAPULT_SINGLE
	var/atom/movable/locked
	equipment_delay = 30 //Stunlocks are not ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	require_adjacent = FALSE

/obj/item/mecha_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == CATAPULT_SINGLE ? CATAPULT_AREA : CATAPULT_SINGLE
		to_chat(user, "<span class='notice'>You set \the [src] to [mode == CATAPULT_SINGLE ? "single" : "multi"]-target mode.</span>")
		update_icon()

/obj/item/mecha_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)

		switch(mode)
			if(CATAPULT_SINGLE)
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored || !AM.simulated)
						to_chat(user, "<span class='notice'>Unable to lock on [target].</span>")
						return
					locked = AM
					to_chat(user, "<span class='notice'>Locked on [AM].</span>")
					return
				else if(target != locked)
					if(locked in view(owner))
						locked.throw_at(target, 14, 1.5, owner)
						log_and_message_admins("used [src] to throw [locked] at [target].", user, owner.loc)
						locked = null

						var/obj/item/cell/C = owner.get_cell()
						if(istype(C))
							C.use(active_power_use * CELLRATE)

					else
						locked = null
						to_chat(user, "<span class='notice'>Lock on [locked] disengaged.</span>")
			if(CATAPULT_AREA)

				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored || !A.simulated) continue
					var/dist = 5-get_dist(A,target)
					A.throw_at(get_edge_target_turf(A,get_dir(target, A)),dist,0.7)


				log_and_message_admins("used [src]'s area throw on [target].", user, owner.loc)
				var/obj/item/cell/C = owner.get_cell()
				if(istype(C))
					C.use(active_power_use * CELLRATE * 2) //bit more expensive to throw all

/obj/item/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon_state = "drill_head"

/obj/item/material/drill_head/New(var/newloc)
	. = ..()
	durability = 2 * material.integrity

/obj/item/material/drill_head/proc/get_durability_percentage()
	return (durability * 100) / (2 * material.integrity)

/obj/item/material/drill_head/examine(mob/user, distance)
	. = ..()
	var/percentage = get_durability_percentage()
	var/descriptor = "looks close to breaking"
	if(percentage > 10)
		descriptor = "is very worn"
	if(percentage > 50)
		descriptor = "is fairly worn"
	if(percentage > 75)
		descriptor = "shows some signs of wear"
	if(percentage > 95)
		descriptor = "shows no wear"

	to_chat(user, span("notice", "It [descriptor]."))

/obj/item/mecha_equipment/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mecha_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	//Drill can have a head
	var/obj/item/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_equipment/drill/Initialize()
	. = ..()
	drill_head = new /obj/item/material/drill_head(src, DEFAULT_WALL_MATERIAL)//You start with a basic steel head

/obj/item/mecha_equipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message("<span class='warning'>[owner] revs the [drill_head], menancingly.</span>")
			playsound(src, 'sound/mecha/mechdrill.ogg', 50, 1)

/obj/item/mecha_equipment/drill/get_hardpoint_maptext()
	if(drill_head)
		return "Integrity: [round(drill_head.get_durability_percentage())]%"
	return

/obj/item/mecha_equipment/drill/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(isobj(target))
			var/obj/target_obj = target
			if(target_obj.unacidable)
				return
		if(istype(target,/obj/item/material/drill_head))
			var/obj/item/material/drill_head/DH = target
			if(drill_head)
				owner.visible_message("<span class='notice'>\The [owner] detaches the [drill_head] mounted on the [src].</span>")
				drill_head.forceMove(owner.loc)
			DH.forceMove(src)
			drill_head = DH
			owner.visible_message("<span class='notice'>\The [owner] mounts the [drill_head] on the [src].</span>")
			return

		if(drill_head == null)
			to_chat(user, "<span class='warning'>Your drill doesn't have a head!</span>")
			return

		var/obj/item/cell/C = owner.get_cell()
		if(istype(C))
			C.use(active_power_use * CELLRATE)
		owner.visible_message("<span class='danger'>\The [owner] starts to drill \the [target]</span>", "<span class='warning'>You hear a large drill.</span>")

		var/T = target.loc

		//Better materials = faster drill!
		var/delay = max(5, 20 - drill_head.material.protectiveness)
		owner.setClickCooldown(delay) //Don't spamclick!
		if(do_after(owner, delay, target) && drill_head)
			if(src == owner.selected_system)
				if(drill_head.durability <= 0)
					drill_head.shatter()
					drill_head = null
					return
				if(istype(target, /turf/simulated/wall))
					var/turf/simulated/wall/W = target
					if(max(W.material.hardness, W.reinf_material ? W.reinf_material.hardness : 0) > drill_head.material.hardness)
						to_chat(user, "<span class='warning'>\The [target] is too hard to drill through with this drill head.</span>")
					target.ex_act(2)
					drill_head.durability -= 1
					log_and_message_admins("used [src] on the wall [W].", user, owner.loc)
				else if(istype(target, /turf/simulated/mineral))
					for(var/turf/simulated/mineral/M in range(owner,1))
						if(get_dir(owner,M)&owner.dir)
							M.GetDrilled()
							drill_head.durability -= 1
					if(owner.hardpoints.len)
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/mecha_equipment/clamp/I = owner.hardpoints[hardpoint]
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in I
							if(ore_box)
								for(var/obj/item/ore/ore in range(owner,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)
				else if(istype(target, /turf/unsimulated/floor/asteroid))
					for(var/turf/unsimulated/floor/asteroid/M in range(owner,1))
						if(get_dir(owner,M)&owner.dir)
							M.gets_dug()
							drill_head.durability -= 1
					if(owner.hardpoints.len)
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/mecha_equipment/clamp/I = owner.hardpoints[hardpoint]
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in I
							if(ore_box)
								for(var/obj/item/ore/ore in range(owner,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)
				else if(target.loc == T)
					target.ex_act(2)
					drill_head.durability -= 1
					log_and_message_admins("[src] used to drill [target].", user, owner.loc)

				playsound(src, 'sound/mecha/mechdrill.ogg', 50, 1)

		else
			to_chat(user, "You must stay still while the drill is engaged!")


		return 1

/obj/item/mecha_equipment/mounted_system/flarelauncher
	name = "flare launcher"
	desc = "The SGL-6 Special grenade launcher has been retooled to fire lit flares for emergency illumination."
	icon_state = "mech_flaregun"
	holding_type = /obj/item/gun/launcher/mech/flarelauncher
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/gun/launcher/mech/flarelauncher
	name = "mounted flare launcher"
	desc = "The SGL-6 Special grenade launcher has been retooled to fire lit flares for emergency illumination."
	icon = 'icons/obj/robot_items.dmi'
	icon_state = "smg"
	item_state = "smg"
	fire_sound = 'sound/items/flare.ogg'

	release_force = 5
	throw_distance = 7
	proj = 3
	max_proj = 3
	proj_gen_time = 400


/obj/item/gun/launcher/mech/flarelauncher/consume_next_projectile()
	if(proj < 1) return null
	var/obj/item/device/flashlight/flare/mech/g = new (src)
	proj--
	addtimer(CALLBACK(src, .proc/regen_proj), proj_gen_time, TIMER_UNIQUE)
	return g

/obj/item/device/flashlight/flare/mech/Initialize()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	on = 1
	src.force = on_damage
	src.damtype = "fire"
	update_icon()
	START_PROCESSING(SSprocessing, src)
	..()