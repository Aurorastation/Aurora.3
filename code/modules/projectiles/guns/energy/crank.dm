/obj/item/gun/energy/rifle/icelance
	name = "icelance rifle"
	desc = "A Tajaran made rifle, it houses a crank-chargable internal battery. It only holds three shots and each shot must be cranked manually."
	icon = 'icons/obj/guns/icelance.dmi'
	icon_state = "icelance"
	item_state = "icelance"
	fire_sound = 'sound/weapons/Laser.ogg'
	max_shots = 3
	accuracy = -1
	accuracy_wielded = 2
	fire_delay = 10
	fire_delay_wielded = 8
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	projectile_type = /obj/item/projectile/beam
	secondary_projectile_type = null
	secondary_fire_sound = null
	charge_failure_message = "'s charging socket was removed to make room for a crank."
	var/is_charging = FALSE

	firemodes = list()
	modifystate = null

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	description_fluff = "The Tui'ad \"Icelance\" laser rifle is an energy weapon of Tajaran design. Clumsy overheating handguns and rifles that slowly fire long bolts of \
	concentrated energy are used by high ranking soldiers or special operatives of the Republican army, but their durability is dubious in comparison to the mass-produced, \
	single shot or bolt action rifles that the majority of Tajaran soldiers use."

/obj/item/gun/energy/rifle/icelance/attack_self(mob/living/user as mob)
	if(is_charging)
		to_chat(user, "<span class='warning'>You are already charging \the [src].</span>")
		return
	if(power_supply.charge < power_supply.maxcharge)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.visible_message(
				"<span class='notice'>\The [user] begins to crank \the [src]!</span>",
				"<span class='notice'>You begin to rotate \the [src]'s crank!</span>"
				)
		playsound(user.loc, 'sound/items/crank.ogg', 60, 1)
		is_charging = TRUE
		flick("crank", src)
		if(do_after(user,20))
			to_chat(user, "<span class='notice'>You finish charging \the [src].</span>")
			power_supply.give(charge_cost)
			update_icon()
			is_charging = FALSE
		else
			is_charging = FALSE

/obj/item/gun/energy/rifle/icelance/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/rifle/icelance/update_icon()
	..()
	if(wielded)
		item_state = "icelance-wielded"
	else
		item_state = initial(item_state)
	update_held_icon()