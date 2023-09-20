/obj/item/device/self_charge_module
	name = "weapon recharging module"
	desc = "A small device attached to the power cell of an energy weapon, designed to allow it to continue operation when away from a convenient recharger. This one seems outdated, with an abysmally slow recharge rate."
	icon = 'icons/obj/charge_modules.dmi'
	icon_state = "low-selfchargemodule"
	var/charge_rate = 10 //how long does it take for a shot to recharge (in ticks)
	origin_tech = list(TECH_POWER = 3, TECH_COMBAT = 3)
	flags = CONDUCT
	w_class = ITEMSIZE_TINY
	var/obj/item/gun/energy/gun
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound = 'sound/items/pickup/component.ogg'

/obj/item/device/self_charge_module/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/item/gun/energy))
		gun = loc

/obj/item/device/self_charge_module/afterattack(atom/target, mob/user, proximity_flag)
	if(proximity_flag)
		if(istype(target, /obj/item/gun/energy))
			var/obj/item/gun/energy/G = target
			if(!G.accepts_charge_module)
				to_chat(user, SPAN_NOTICE("\The [G] has nowhere to attach a recharging module!"))
				return
			if(!G.charge_module)
				gun_insert(user, G)
				to_chat(user, SPAN_NOTICE("You attach \the [src] to \the [G]."))
			else
				to_chat(user, SPAN_NOTICE("\The [G] already has a recharging module installed."))

/obj/item/device/self_charge_module/proc/gun_insert(mob/living/user, obj/item/gun/energy/G)
	gun = G
	user.drop_from_inventory(src,gun)
	gun.charge_module = src
	gun.self_recharge = TRUE
	gun.use_external_power = FALSE
	gun.recharge_time = src.charge_rate
	return

/obj/item/device/self_charge_module/standard
	name = "advanced weapon recharging module"
	desc = "A small device attached to the power cell of an energy weapon, designed to allow it to continue operation when away from a convenient recharger. This one is the current standard in the field, frequently used by the Orion Spur's military forces."
	icon_state = "medium-selfchargemodule"
	charge_rate = 4
	origin_tech = list(TECH_POWER = 6, TECH_COMBAT = 6)

/obj/item/device/self_charge_module/hyper
	name = "experimental weapon recharging module"
	desc = "A small device attached to the power cell of an energy weapon, designed to allow it to continue operation when away from a convenient recharger. This one seems to be a product of extremely advanced technology, with a truly outstanding recharge rate."
	icon_state = "fast-selfchargemodule"
	origin_tech = list(TECH_POWER = 7, TECH_COMBAT = 9)
	charge_rate = 2
