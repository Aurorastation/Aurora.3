/obj/item/device/assembly/igniter
	name = "igniter"
	desc = "A small electronic device able to ignite combustable substances."
	icon_state = "igniter"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 50)

	secured = TRUE
	wires = WIRE_RECEIVE

/obj/item/device/assembly/igniter/activate()
	. = ..()
	if(!.)
		return FALSE //Cooldown check

	if(holder && istype(holder.loc, /obj/item/grenade/chem_grenade))
		var/obj/item/grenade/chem_grenade/grenade = holder.loc
		grenade.prime()
	else
		var/turf/location = get_turf(loc)
		if(location)
			location.hotspot_expose(1000, 1000)
		if(istype(src.loc, /obj/item/device/assembly_holder))
			if(istype(src.loc.loc, /obj/structure/reagent_dispensers/fueltank))
				var/obj/structure/reagent_dispensers/fueltank/tank = src.loc.loc
				if(tank?.is_leaking)
					tank.ex_act(3)
		spark(src, 4, cardinal)
	return TRUE

/obj/item/device/assembly/igniter/attack_self(mob/user)
	activate()
	add_fingerprint(user)

/obj/item/device/assembly/igniter/isFlameSource()
	return TRUE