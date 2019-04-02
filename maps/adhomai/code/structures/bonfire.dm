/obj/structure/bonfire
	name = "bonfire"
	desc = "A large pile of wood, ready to be burned."
	icon = 'icons/adhomai/structures.dmi'
	icon_state = "bonfire"
	anchored = TRUE
	density = FALSE
	light_color = LIGHT_COLOR_FIRE
	var/fuel = 2000
	var/max_fuel = 2000
	var/on_fire = FALSE
	var/safe = FALSE

/obj/structure/bonfire/Initialize()
	. = ..()
	fuel = rand(1000, 2000)

/obj/structure/bonfire/update_icon()
	if(on_fire)
		icon_state = "[initial(icon_state)]_fire"
	else
		icon_state = initial(icon_state)

/obj/structure/bonfire/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(W.iswelder())
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			light(user)
	else if(isflamesource(W))
		light(user)
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light(user)

	if(istype(W, /obj/item/device/flashlight/flare/torch))
		var/obj/item/device/flashlight/flare/torch/T = W
		if(T.on)
			T.light(user)

	if(istype(W,/obj/item/stack/material/wood) && (fuel < max_fuel))
		var/obj/item/stack/material/wood/I = W
		I.use(1)
		fuel = min(fuel + 200, max_fuel)
		to_chat(user, "<span class='notice'>You add some of \the [I] to \the [src].</span>")

/obj/structure/bonfire/proc/light(mob/user)
	if(!fuel)
		to_chat(user, "<span class='warning'>There is not enough fuel to start a fire.</span>")
		return
	if(!on_fire)
		on_fire = TRUE
		check_light()
		update_icon()
		START_PROCESSING(SSprocessing, src)

/obj/structure/bonfire/proc/check_light()
	if(on_fire)
		switch(fuel)
			if(0 to 200)
				set_light(2)
			if(200 to 600)
				set_light(3)
			if(600 to 900)
				set_light(4)
			if(900 to 1300)
				set_light(5)
			if(1300 to 2000)
				set_light(6)
	else
		set_light(0)

/obj/structure/bonfire/process()
	if(!on_fire)
		return

	fuel--

	if(!fuel)
		extinguish()

	if(istype(loc, /turf))
		var/turf/T = loc
		T.hotspot_expose(700, 5)

	if(locate(/mob/living, src.loc))
		var/mob/living/M = locate(/mob/living, src.loc)
		burn(M)

	check_light()
	heat()

/obj/structure/bonfire/proc/extinguish()
	on_fire = FALSE
	START_PROCESSING(SSprocessing, src)
	check_light()
	update_icon()

/obj/structure/bonfire/proc/heat()
	var/turf/simulated/L = loc
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		if(env.temperature >= T0C+10)
			return
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles)

		if(removed)
			removed.add_thermal_energy(4000)

			env.merge(removed)

/obj/structure/bonfire/Crossed(AM as mob|obj)
	if(on_fire)
		if(istype(AM, /mob/living))
			burn(AM, TRUE)
	..()

/obj/structure/bonfire/proc/burn(var/mob/living/M, var/entered = FALSE)
	if(safe)
		return
	if(M)
		if(entered)
			to_chat(M, "<span class='warning'>You are covered by fire and heat from entering \the [src]!</span>")
		if(isanimal(M))
			var/mob/living/simple_animal/H = M
			if(H.flying) //flying mobs will ignore the lava
				return
			else
				M.bodytemperature = min(M.bodytemperature + 150, 1000)
		else
			if(prob(50))
				M.adjust_fire_stacks(5)
				M.IgniteMob()
				return

/obj/structure/bonfire/fireplace
	name = "fireplace"
	desc = "A large stone brick fireplace."
	icon = 'icons/adhomai/fireplace.dmi'
	icon_state = "fireplace"
	pixel_x = -16
	safe = TRUE

/obj/structure/bonfire/fireplace/update_icon()
	cut_overlays()
	if(on_fire)
		switch(fuel)
			if(0 to 500)
				add_overlay("fireplace_fire0")
			if(500 to 1000)
				add_overlay("fireplace_fire1")
			if(1000 to 1500)
				add_overlay("fireplace_fire2")
			if(1500 to 1700)
				add_overlay("fireplace_fire3")
			if(1700 to 2000)
				add_overlay("fireplace_fire4")
		add_overlay("fireplace_glow")