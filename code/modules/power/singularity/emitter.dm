#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators
#define EMITTER_LOOSE 0
#define EMITTER_BOLTED 1

#define BARREL_UNMODIFIED 0
#define BARREL_STOCKED 1
#define BARREL_WIRED 2

#define STOCK_UNMODIFIED 0
#define STOCK_BOTTOMED 1

/obj/machinery/power/emitter
	name = "emitter"
	desc = "It is a heavy duty industrial laser, capable of carbonizing anything that stands in its path. It has securing struts that prevent it from being moved when anchored."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = FALSE
	density = TRUE
	req_access = list(access_engine_equip)
	obj_flags = OBJ_FLAG_ROTATABLE
	var/id

	use_power = 0	//uses powernet power, not APC power
	active_power_usage = 30000	//30 kW laser. I guess that means 30 kJ per shot.

	var/active = FALSE
	var/powered = FALSE
	var/fire_delay = 100
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = EMITTER_LOOSE
	var/locked = FALSE

	var/obj/item/emitter_barrel/barrel
	var/barrel_secured = TRUE

	var/special_emitter = FALSE // special emitters notify admins if something happens to them, to prevent grief

	var/_wifi_id
	var/datum/wifi/receiver/button/emitter/wifi_receiver

	var/datum/effect_system/sparks/spark_system

/obj/machinery/power/emitter/examine(mob/user)
	..()
	switch(state)
		if(EMITTER_LOOSE)
			to_chat(user, SPAN_WARNING("\The [src] isn't attached to anything and is not ready to fire."))
		if(EMITTER_BOLTED)
			to_chat(user, SPAN_NOTICE("\The [src] is secured to the floor and ready to fire."))
	if(signaler && user.Adjacent(src))
		to_chat(user, FONT_SMALL(SPAN_WARNING("\The [src] has a hidden signaler attached to it.")))

/obj/machinery/power/emitter/Destroy()
	if(special_emitter)
		message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Emitter deleted at ([x],[y],[z])")
		investigate_log("<font color='red'>deleted</font> at ([x],[y],[z])","singulo")
	QDEL_NULL(wifi_receiver)
	QDEL_NULL(spark_system)
	QDEL_NULL(signaler)
	return ..()

/obj/machinery/power/emitter/Initialize()
	. = ..()
	barrel = new /obj/item/emitter_barrel(src)
	spark_system = bind_spark(src, 5, alldirs)
	if(state == EMITTER_BOLTED && anchored)
		connect_to_network()
		if(_wifi_id)
			wifi_receiver = new(_wifi_id, src)

/obj/machinery/power/emitter/update_icon()
	cut_overlays()
	var/dismantled = ""
	if(!barrel)
		dismantled = "_dismantled"
	if(state != EMITTER_BOLTED)
		icon_state = "emitter[dismantled]"
	else
		if(active && powernet && avail(active_power_usage))
			icon_state = "emitter[dismantled]_secure_on"
			var/mutable_appearance/glow_overlay = make_screen_overlay(icon, "emitter_glow")
			add_overlay(glow_overlay)
			set_light(1.5, 1, COLOR_BRIGHT_GREEN)
		else
			icon_state = "emitter[dismantled]_secure"

/obj/machinery/power/emitter/attack_hand(mob/user)
	add_fingerprint(user)
	activate(user)

/obj/machinery/power/emitter/proc/activate(mob/user)
	if(state == EMITTER_BOLTED)
		if(!barrel)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src] doesn't have a barrel!"))
			return TRUE
		if(!powernet)
			if(user)
				to_chat(user, SPAN_WARNING("\The [src] isn't connected to a powered wire."))
				update_icon()
			return TRUE
		if(!locked)
			if(active)
				active = FALSE
				if(user)
					to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
					if(special_emitter)
						message_admins("Emitter turned off by [key_name_admin(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
						log_game("Emitter turned off by [user.ckey]([user]) in ([x],[y],[z])",ckey=key_name(user))
						investigate_log("turned <font color='red'>off</font> by [user.key]","singulo")
			else
				active = TRUE
				shot_number = 0
				fire_delay = 100
				if(user)
					to_chat(user, SPAN_NOTICE("You activate \the [src]."))
					if(special_emitter)
						message_admins("Emitter turned on by [key_name_admin(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
						log_game("Emitter turned on by [user.ckey]([user]) in ([x],[y],[z])",ckey=key_name(user))
						investigate_log("turned <font color='green'>on</font> by [user.key]","singulo")
			update_icon()
		else
			if(user)
				to_chat(user, SPAN_WARNING("The controls are locked!"))
	else
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return TRUE


/obj/machinery/power/emitter/emp_act()
	activate(null)
	return TRUE

/obj/machinery/power/emitter/machinery_process()
	if(stat & (BROKEN))
		return
	if(state != EMITTER_BOLTED || (!powernet && active_power_usage) || !barrel)
		active = FALSE
		update_icon()
		return
	if(((last_shot + fire_delay) <= world.time) && active)
		var/actual_load = draw_power(active_power_usage)
		if(actual_load >= active_power_usage) //does the laser have enough power to shoot?
			if(!powered)
				powered = TRUE
				update_icon()
				if(special_emitter)
					investigate_log("regained power and turned <font color='green'>on</font>","singulo")
		else
			if(powered)
				powered = FALSE
				update_icon()
				if(special_emitter)
					investigate_log("lost power and turned <font color='red'>off</font>","singulo")
			return

		last_shot = world.time
		if(shot_number < burst_shots)
			fire_delay = 2
			shot_number++
		else
			fire_delay = rand(min_burst_delay, max_burst_delay)
			shot_number = 0

		//need to calculate the power per shot as the emitter doesn't fire continuously.
		var/burst_time = (min_burst_delay + max_burst_delay) / 2 + 2 * (burst_shots - 1)
		var/power_per_shot = active_power_usage * (burst_time / 10) / burst_shots

		playsound(get_turf(src), 'sound/weapons/emitter.ogg', 25, TRUE, 3, 0.5, TRUE)
		if(prob(35))
			spark_system.queue()

		var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/emitter(get_turf(src))
		A.damage = round(power_per_shot / EMITTER_DAMAGE_POWER_TRANSFER)
		A.launch_projectile(get_step(src, dir))

/obj/machinery/power/emitter/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/S = W
		user.drop_from_inventory(W, src)
		signaler = S
		S.machine = src
		user.visible_message("<b>\The [user]</b> attaches \the [S] to \the [src].",
							SPAN_NOTICE("You attach \the [S] to \the [src]."))
		return
	if(W.iswirecutter() && signaler)
		signaler.forceMove(get_turf(user))
		signaler.machine = null
		user.visible_message("<b>\The [user]</b> removes \the [signaler] from \the [src].",
							SPAN_NOTICE("You remove \the [signaler] to \the [src]."))
		signaler = null
		return
	if(W.iswrench())
		if(active)
			to_chat(user, SPAN_WARNING("You cannot unsecure \the [src] while it's active."))
			return
		if(locked)
			to_chat(user, SPAN_WARNING("The struts cannot be adjusted whilst \the [src] is locked."))
			return
		switch(state)
			if(EMITTER_LOOSE)
				state = EMITTER_BOLTED
				playsound(get_turf(src), W.usesound, 75, TRUE)
				user.visible_message("<b>\The [user]</b> secures \the [src] to the floor.", \
					SPAN_NOTICE("You secure \the [src]'s external struts to the floor."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = TRUE
				connect_to_network()
				update_icon()
			if(EMITTER_BOLTED)
				state = EMITTER_LOOSE
				playsound(get_turf(src), W.usesound, 75, TRUE)
				user.visible_message("<b>\The [user]</b> unsecures \the [src]'s struts from the floor.", \
					SPAN_NOTICE("You unsecure \the [src]'s external struts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				anchored = FALSE
				update_icon()
		return

	if(istype(W, /obj/item/emitter_barrel))
		if(barrel)
			to_chat(user, SPAN_WARNING("\The [src] already has a barrel!"))
			return
		var/obj/item/emitter_barrel/EB = W
		if(EB.build_state != BARREL_UNMODIFIED)
			to_chat(user, SPAN_WARNING("\The [EB] has auxiliary attachments and can't fit into the [src]!"))
			return
		user.visible_message("<b>\The [user]</b> installs \the [EB] into \the [src].", SPAN_NOTICE("You install \the [EB] into \the [src]."), range = 3)
		user.drop_from_inventory(EB, src)
		barrel = EB
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/device/pda))
		if(emagged)
			to_chat(user, SPAN_WARNING("The lock seems to be broken."))
			return
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("The controls are now [locked ? "locked." : "unlocked."]"))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(W.isscrewdriver())
		if(!barrel)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a barrel!"))
			return
		barrel_secured = !barrel_secured
		var/others_msg = "<b>\The [user]</b> [barrel_secured ? "" : "un"]secures \the [src]'s barrel."
		var/self_msg = "You [barrel_secured ? "" : "un"]secure \the [src]'s barrel."
		user.visible_message(others_msg, SPAN_WARNING(self_msg), range = 3)
		playsound(get_turf(src), W.usesound, 75, TRUE)
		return

	if(W.iscrowbar())
		if(!barrel)
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a barrel!"))
			return
		if(barrel_secured)
			to_chat(user, SPAN_WARNING("\The [src] barrel is still secured within its housing!"))
			return
		if(active)
			to_chat(user, SPAN_WARNING("You jam \the [W] into \the [src] while it's active, shocking yourself!"))
			electrocute_mob(user, powernet, src)
			return
		user.visible_message("<b>\The [user]</b> starts prying out \the [src]'s barrel...", SPAN_NOTICE("You start prying out \the [src]'s barrel..."), range = 3)
		if(do_after(user, 50, TRUE, src))
			if(!barrel)
				to_chat(user, SPAN_WARNING("\The [src] doesn't have a barrel!"))
				return
			if(barrel_secured)
				to_chat(user, SPAN_WARNING("\The [src] barrel is still secured within its housing!"))
				return
			if(active)
				to_chat(user, SPAN_WARNING("You jam \the [W] into \the [src] while it's active, shocking yourself!"))
				electrocute_mob(user, powernet, src)
				return
			playsound(get_turf(src), W.usesound, 75, TRUE)
			user.visible_message("<b>\The [user]</b> pries out \the [src]'s barrel.", SPAN_NOTICE("You pry out \the [src]'s barrel."), range = 3)
			barrel.forceMove(get_turf(src))
			user.put_in_hands(barrel)
			barrel = null
			update_icon()
			return

	..()

/obj/machinery/power/emitter/emag_act(remaining_charges, mob/user)
	if(!emagged)
		locked = FALSE
		emagged = TRUE
		// Give this boy the buff it deserves. - Geeves
		burst_shots *= 2
		min_burst_delay *= 0.5
		max_burst_delay *= 0.5
		to_chat(user, SPAN_NOTICE("You short out the emitter's locking system, and put its capacitor into overdrive."))
		return TRUE
	else
		to_chat(user, SPAN_WARNING("\The [src] seems to already have been modified."))
		return FALSE

/obj/machinery/power/emitter/do_signaler()
	if(!locked)
		activate(null)
	else
		visible_message("\icon[src] [src] whines, \"Access denied!\"")


/obj/item/emitter_barrel
	name = "emitter barrel"
	desc = "A long, heavy barrel, which contains the lenses and capacitor needed to fire a high-power laser blast. It just needs a mount and a power source..."
	icon = 'icons/obj/improvised.dmi'
	icon_state = "emitter_barrel"
	var/build_state = BARREL_UNMODIFIED

/obj/item/emitter_barrel/attackby(obj/item/W, mob/user)
	switch(build_state)
		if(BARREL_UNMODIFIED)
			if(istype(W, /obj/item/emitter_stock))
				var/obj/item/emitter_stock/ES = W
				if(ES.build_state != STOCK_BOTTOMED)
					to_chat(user, SPAN_WARNING("\The [ES] isn't finished and cannot be attached!"))
					return
				user.visible_message("<b>\The [user]</b> starts adding \the [ES] to \the [src]...", SPAN_NOTICE("You start adding \the [ES] to \the [src]..."), range = 3)
				if(do_after(user, 50, TRUE, src))
					if(build_state != BARREL_UNMODIFIED)
						return
					user.visible_message("<b>\The [user]</b> adds \the [ES] to \the [src].", SPAN_NOTICE("You add \the [ES] to \the [src]."), range = 3)
					icon_state = "emitter_barrel-1"
					build_state = BARREL_STOCKED
					qdel(ES)
		if(BARREL_STOCKED)
			if(W.iscoil())
				var/obj/item/stack/cable_coil/CC = W
				if(CC.amount < 5)
					to_chat(user, SPAN_WARNING("You need at least 5 lengths of coil in \the [CC]!"))
					return
				user.visible_message("<b>\The [user]</b> starts wiring up \the [src]...", SPAN_NOTICE("You start wiring up \the [src]..."), range = 3)
				if(do_after(user, 50, TRUE, src))
					if(build_state != BARREL_STOCKED)
						return
					if(CC.amount < 5)
						to_chat(user, SPAN_WARNING("You need at least 5 lengths of coil in \the [CC]!"))
						return
					CC.use(5)
					user.visible_message("<b>\The [user]</b> wires up \the [src].", SPAN_NOTICE("You wire up \the [src]."), range = 3)
					icon_state = "emitter_barrel-2"
					build_state = BARREL_WIRED
			else if(W.iswelder())
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(3, user))
					user.visible_message("<b>\The [user]</b> starts removing the stock from \the [src]...", SPAN_NOTICE("You start removing the stock from \the [src]..."), range = 3)
					playsound(get_turf(src), W.usesound, 75, TRUE)
					if(do_after(user, 50, TRUE, src))
						if(build_state != BARREL_STOCKED)
							return
						user.visible_message("<b>\The [user]</b> removes the stock from \the [src].", SPAN_NOTICE("You remove the stock from \the [src]."), range = 3)
						var/obj/item/emitter_stock/ES = new /obj/item/emitter_stock(get_turf(src))
						ES.build_state = STOCK_BOTTOMED
						ES.icon_state = "emitter_stock-1"
						user.put_in_hands(ES)
						build_state = BARREL_UNMODIFIED
						icon_state = "emitter_barrel"
		if(BARREL_WIRED)
			if(W.isscrewdriver())
				user.visible_message("<b>\The [user]</b> starts fastening and securing all of \the [src]'s attachments...", SPAN_NOTICE("You start fastening and securing all of \the [src]'s attachments..."), range = 3)
				playsound(get_turf(src), W.usesound, 75, TRUE)
				if(do_after(user, 50, TRUE, src))
					if(build_state != BARREL_WIRED)
						return
					user.visible_message("<b>\The [user]</b> fastens and secures all of \the [src]'s attachments.", SPAN_NOTICE("You fasten and secure all of \the [src]'s attachments."), range = 3)
					var/obj/item/gun/energy/emitter_rifle/ER = new /obj/item/gun/energy/emitter_rifle(get_turf(src))
					user.put_in_hands(ER)
					transfer_fingerprints_to(ER)
					qdel(src)
			else if(W.iswirecutter())
				user.visible_message("<b>\The [user]</b> starts snipping off \the [src]'s wiring...", SPAN_NOTICE("You start snipping off \the [src]'s wiring..."), range = 3)
				playsound(get_turf(src), W.usesound, 75, TRUE)
				if(do_after(user, 50, TRUE, src))
					if(build_state != BARREL_WIRED)
						return
					user.visible_message("<b>\The [user]</b> snips off \the [src]'s wiring.", SPAN_NOTICE("You snips off \the [src]'s wiring."), range = 3)
					var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(get_turf(src), 5)
					user.put_in_hands(CC)
					build_state = BARREL_STOCKED
					icon_state = "emitter_barrel-1"


/obj/item/emitter_stock
	name = "plasteel stock"
	desc = "A huge stock, capable of mounting something large. Who the hell thought this was a good idea?"
	icon = 'icons/obj/improvised.dmi'
	icon_state = "emitter_stock"
	var/build_state = STOCK_UNMODIFIED

/obj/item/emitter_stock/attackby(obj/item/W, mob/user)
	switch(build_state)
		if(STOCK_UNMODIFIED)
			if(istype(W, /obj/item/stack/rods))
				var/obj/item/stack/rods/R = W
				if(R.amount < 5)
					to_chat(user, SPAN_WARNING("You need atleast 5 rods in the stack of rods!"))
					return
				user.visible_message("<b>\The [user]</b> starts creating a trigger and grip for \the [src]...", SPAN_NOTICE("You start creating a trigger and grip for \the [src]..."), range = 3)
				if(do_after(user, 50, TRUE, src))
					if(build_state != STOCK_UNMODIFIED)
						return
					if(R.amount < 5)
						to_chat(user, SPAN_WARNING("You need atleast 5 rods in the stack of rods!"))
						return
					R.use(5)
					user.visible_message("<b>\The [user]</b> creates a trigger and grip for \the [src].", SPAN_NOTICE("You create a trigger and grip for \the [src]."), range = 3)
					build_state = STOCK_BOTTOMED
					icon_state = "emitter_stock-1"
			else if(W.iswelder())
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(3, user))
					user.visible_message("<b>\The [user]</b> starts cutting \the [src] apart...", SPAN_NOTICE("You start cutting \the [src] apart..."), range = 3)
					playsound(get_turf(src), W.usesound, 75, TRUE)
					if(do_after(user, 50, TRUE, src))
						if(build_state != STOCK_UNMODIFIED)
							return
						user.visible_message("<b>\The [user]</b> cuts \the [src] apart.", SPAN_NOTICE("You cut \the [src] apart."), range = 3)
						var/obj/item/stack/material/plasteel/P = new /obj/item/stack/material/plasteel(get_turf(src), 10) // a bit of a lossy conversion
						user.put_in_hands(P)
						qdel(src)
			else if(istype(W, /obj/item/emitter_barrel))
				W.attackby(src, user)
		if(STOCK_BOTTOMED)
			if(W.iswelder())
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(3, user))
					user.visible_message("<b>\The [user]</b> starts slicing \the [src]'s trigger and grips off...", SPAN_NOTICE("You start cutting \the [src]'s trigger and grips off..."), range = 3)
					playsound(get_turf(src), W.usesound, 75, TRUE)
					if(do_after(user, 50, TRUE, src))
						if(build_state != STOCK_BOTTOMED)
							return
						user.visible_message("<b>\The [user]</b> cuts \the [src]'s trigger and grips off.", SPAN_NOTICE("You cut \the [src]'s trigger and grips off."), range = 3)
						var/obj/item/stack/rods/R = new /obj/item/stack/rods(get_turf(src), 5)
						user.put_in_hands(R)
						build_state = STOCK_UNMODIFIED
						icon_state = "emitter_stock"
			else if(istype(W, /obj/item/emitter_barrel))
				W.attackby(src, user)

#undef BARREL_UNMODIFIED
#undef BARREL_STOCKED
#undef BARREL_WIRED
#undef STOCK_UNMODIFIED
#undef STOCK_BOTTOMED