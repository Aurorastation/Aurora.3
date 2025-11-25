/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	contained_sprite = TRUE
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/detonate_time = 0
	/// Default timer is 30 seconds, but can be configured for anything from 10s to 20m.
	var/timer = 300
	var/atom/target = null
	var/open_panel = 0
	var/obj/effect/plastic_explosive/effect_overlay

/obj/item/plastique/mechanics_hints()
	. += ..()
	. += "This can be planted on ANY type of target except for open turfs (floors), and items with built-in storage (boxes, jackets, webbings, etc.)."
	. += "This cannot be planted on playable characters (carbons), but any other mob type (department pets, maint drones, schlorrgos, borgs, rats, cleanbots, etc.) are fair game."
	. += "Use this on yourself to set the timer."
	. += "There is a wiring panel on it affixed by <b>screws</b>."

/obj/item/plastique/antagonist_hints()
	. += ..()
	. += "This can easily be converted into a remote-triggered bomb by attaching a signaller to all 5 wires on the same frequency. Pulse that frequency with another signaller to immediately detonate the bomb."
	. += "Everyone loves an exploding cake or pizza."
	. += "Everyone loves an exploding hat."
	. += "Everyone loves an exploding coffeemaker."
	. += "Everyone loves an exploding beer keg."
	. += "Everyone loves an exploding object you just dropped in the disposals."

/obj/item/plastique/Initialize()
	. = ..()
	wires = new(src)

/obj/item/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/plastique/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		open_panel = !open_panel
		to_chat(user, SPAN_NOTICE("You [open_panel ? "open" : "close"] the wire panel."))
		return TRUE
	else if(open_panel)
		wires.interact(user)
		return TRUE
	else
		return ..()

/obj/item/plastique/attack_self(mob/user as mob)
	if(user.get_active_hand() == src)
		timer = setTimer(user)
		if(timer)
			to_chat(user, SPAN_NOTICE("Timer set for [DisplayTimeText(timer)] seconds."))

/obj/item/plastique/proc/setTimer(mob/user as mob)
	var/newtime = tgui_input_number(
		user = user,
		message = "Please set the timer (in seconds).",
		title = "Timer",
		default = 30, // 30 second default
		max_value = 300, // 5 minute maximum
		min_value = 10, // 10 second minimum
		timeout = 30 SECONDS
	)
	if(!newtime)
		return FALSE

	// Convert player input to deciseconds.
	return newtime * 10

/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return FALSE
	if(iscarbon(target) || istype(target, /turf/unsimulated) || isopenturf(target) || istype(target, /obj/item/storage/) || istype(target, /obj/item/clothing/accessory/storage/) || istype(target, /obj/item/clothing/under))
		return FALSE
	if(!deploy_check(user))
		return FALSE
	to_chat(user, SPAN_NOTICE("Planting explosives..."))

	if(do_after(user, 5 SECONDS, target, DO_UNIQUE))
		user.do_attack_animation(target)
		deploy_c4(target, user)
		return TRUE
	return FALSE

/obj/item/plastique/proc/deploy_check(var/mob/user)
	return TRUE

/obj/item/plastique/proc/deploy_c4(var/atom/movable/explode_target, mob/user)
	user.drop_from_inventory(src, get_turf(user))
	src.target = explode_target
	var/timetext = DisplayTimeText(timer)

	log_and_message_admins("planted [src.name] on [target.name] with [timetext] fuse", user, get_turf(target))

	new /obj/effect/plastic_explosive(get_turf(user), target, src)
	to_chat(user, SPAN_WARNING("Bomb has been planted. Timer counting down from [timetext]."))

	detonate_time = world.time + (timer)
	addtimer(CALLBACK(src, PROC_REF(explode), get_turf(target)), timer)

/obj/item/plastique/proc/explode(turf/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	QDEL_NULL(effect_overlay)
	if(location)
		explosion(location, -1, -1, 2, 3, spreading = 0)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1, no_product = TRUE)
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)

	qdel(src)

/obj/item/plastique/attack(mob/living/target_mob, mob/living/user, target_zone)
	return

/obj/item/plastique/cyborg
	name = "plastic explosives dispenser"
	desc = "A stationbound-mounted C4 dispenser, how thrilling!"
	var/can_deploy = TRUE
	var/recharge_time = 5 MINUTES
	maptext_x = 3
	maptext_y = 2

/obj/item/plastique/cyborg/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "When used, this dispenser will deploy C4 on a target, upon which it will enter a charging state. After five minutes, it will restock a new C4 bundle."

/obj/item/plastique/cyborg/Initialize()
	. = ..()
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/plastique/cyborg/attackby()
	return

/obj/item/plastique/cyborg/deploy_check(mob/user)
	if(!can_deploy)
		to_chat(user, SPAN_WARNING("\The [src] hasn't recharged yet!"))
		return FALSE
	..()

/obj/item/plastique/cyborg/deploy_c4(atom/movable/target, mob/user)
	var/obj/item/plastique/C4 = new /obj/item/plastique(target)
	C4.timer = src.timer
	var/timetext = DisplayTimeText(timer)
	C4.target = target
	log_and_message_admins("planted [C4.name] on [target.name] with [timetext] fuse", user, get_turf(target))

	new /obj/effect/plastic_explosive(get_turf(user), target, C4)
	to_chat(user, SPAN_NOTICE("Bomb has been planted. Timer counting down from [timetext].."))

	C4.detonate_time = world.time + (timer)
	addtimer(CALLBACK(C4, PROC_REF(explode), get_turf(target)), timer)
	addtimer(CALLBACK(src, PROC_REF(recharge)), recharge_time)
	can_deploy = FALSE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 6px;\">Charging</span>"

/obj/item/plastique/cyborg/proc/recharge()
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R?.cell)
			R.cell.use(1000)
	can_deploy = TRUE
	maptext = "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;\">Ready</span>"

/obj/item/plastique/dirty
	name = "dirty bomb"
	desc = "A small explosive laced with radium. The explosion is small, but the radioactive material will remain for a fair while."
	timer = 30 SECONDS

/obj/item/plastique/dirty/explode(turf/location)
	if(location)
		SSradiation.radiate(src, 250)
		new /obj/effect/decal/cleanable/greenglow/radioactive(get_turf(src))
	..()
