var/list/floor_light_cache = list()

/obj/machinery/floor_light
	name = "floor light"
	icon = 'icons/obj/machinery/floor_light.dmi'
	icon_state = "base"
	desc = "A backlit floor panel."
	layer = ABOVE_TILE_LAYER
	anchored = 0
	use_power = POWER_USE_ACTIVE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = LIGHT
	matter = list(DEFAULT_WALL_MATERIAL = 2500, MATERIAL_GLASS = 2750)
	recyclable = TRUE

	var/on
	var/on_state = "on"
	var/damaged
	var/default_light_range = 4
	var/default_light_power = 2
	var/default_light_colour = "#FFFFFF"

/obj/machinery/floor_light/prebuilt
	anchored = 1

/obj/machinery/floor_light/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		anchored = !anchored
		visible_message("<span class='notice'>\The [user] has [anchored ? "attached" : "detached"] \the [src].</span>")
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		return TRUE
	else if(attacking_item.iswelder() && (damaged || (stat & BROKEN)))
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.use(0, user))
			to_chat(user, "<span class='warning'>\The [src] must be on to complete this task.</span>")
			return TRUE
		if(!attacking_item.use_tool(src, user, 20, volume = 50))
			return TRUE
		if(!src || !WT.isOn())
			return TRUE
		visible_message("<span class='notice'>\The [user] has repaired \the [src].</span>")
		update_icon()
		stat &= ~BROKEN
		damaged = null
		update_brightness()
		return TRUE
	else if(attacking_item.force && user.a_intent == "hurt")
		return attack_hand(user)
	else if(attacking_item.iscrowbar())
		if(anchored)
			to_chat(user, "<span class='warning'>\The [src] must be unfastened from the [loc] first!</span>")
			return TRUE
		else
			to_chat(user, "<span class='notice'>You lever off the [name].</span>")
			playsound(src.loc, 'sound/items/crowbar_tile.ogg', 100, TRUE)
			if(stat & BROKEN)
				qdel(src)
				return TRUE
			else
				new /obj/item/stack/tile/light(user.loc)
				qdel(src)
		return TRUE

/obj/machinery/floor_light/attack_hand(var/mob/user)

	if(user.a_intent == I_HURT && !issmall(user))
		if(!isnull(damaged) && !(stat & BROKEN))
			visible_message("<span class='danger'>\The [user] smashes \the [src]!</span>")
			playsound(src, /singleton/sound_category/glass_break_sound, 70, 1)
			update_icon()
			stat |= BROKEN
		else
			visible_message("<span class='danger'>\The [user] attacks \the [src]!</span>")
			playsound(src.loc, 'sound/effects/glass_hit.ogg', 75, 1)
			if(isnull(damaged)) damaged = 0
		update_brightness()
		return
	else

		if(!anchored)
			to_chat(user, "<span class='warning'>\The [src] must be screwed down first.</span>")
			return

		if(stat & BROKEN)
			to_chat(user, "<span class='warning'>\The [src] is too damaged to be functional.</span>")
			return

		if(stat & NOPOWER)
			to_chat(user, "<span class='warning'>\The [src] is unpowered.</span>")
			return

		on = !on
		if(on)
			update_use_power(POWER_USE_ACTIVE)
		visible_message("<span class='notice'>\The [user] turns \the [src] [on ? "on" : "off"].</span>")
		update_brightness()
		return

/obj/machinery/floor_light/process()
	..()
	var/need_update
	if((!anchored || broken()) && on)
		update_use_power(POWER_USE_OFF)
		on = 0
		need_update = 1
	else if(use_power && !on)
		update_use_power(POWER_USE_OFF)
		need_update = 1
	if(need_update)
		update_brightness()

/obj/machinery/floor_light/proc/update_brightness()
	if(on && use_power == POWER_USE_ACTIVE)
		if(light_range != default_light_range || light_power != default_light_power || light_color != default_light_colour)
			set_light(default_light_range, default_light_power, default_light_colour)
	else
		update_use_power(POWER_USE_OFF)
		if(light_range || light_power)
			set_light(0)

	change_power_consumption((light_range + light_power) * 10, POWER_USE_ACTIVE)
	update_icon()

/obj/machinery/floor_light/update_icon()
	cut_overlays()
	var/list/floor_light_cache = SSicon_cache.floor_light_cache
	if(use_power && !broken())
		if(damaged == null)
			var/cache_key = "floorlight-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("[on_state]")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			add_overlay(floor_light_cache[cache_key])
		else
			if(damaged == 0) //Needs init.
				damaged = rand(1,4)
			var/cache_key = "floorlight-broken[damaged]-[default_light_colour]"
			if(!floor_light_cache[cache_key])
				var/image/I = image("flicker[damaged]")
				I.color = default_light_colour
				I.layer = layer+0.001
				floor_light_cache[cache_key] = I
			add_overlay(floor_light_cache[cache_key])
	if(stat & BROKEN)
		icon_state = "broken"
	else
		icon_state = "base"

/obj/machinery/floor_light/proc/broken()
	return (stat & (BROKEN|NOPOWER))

/obj/machinery/floor_light/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if (prob(50))
				qdel(src)
			else if(prob(20))
				stat |= BROKEN
			else
				if(isnull(damaged))
					damaged = 0
		if(3)
			if (prob(5))
				qdel(src)
			else if(isnull(damaged))
				damaged = 0
	return

/obj/machinery/floor_light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
	return ..()

/obj/machinery/floor_light/cultify()
	default_light_colour = "#FF0000"
	update_brightness()

/obj/machinery/floor_light/dance
	name = "dance floor"
	on_state = "light_on-dancefloor_A"
	anchored = 1
	on = TRUE
	use_power = POWER_USE_ACTIVE

/obj/machinery/floor_light/dance/alternate
	name = "dance floor"
	on_state = "light_on-dancefloor_B"
	anchored = 1
