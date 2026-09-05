/obj/item/gun/energy/rifle/icelance
	name = "\improper Tui'ad icelance rifle"
	desc = "A Tajaran made rifle, it houses a crank-chargable internal battery. It only holds three shots and each shot must be cranked manually."
	icon = 'icons/obj/guns/faction/pra/icelance.dmi'
	icon_state = "icelance"
	item_state = "icelance"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	max_shots = 7
	accuracy = -1
	accuracy_wielded = 2
	fire_delay = 10
	fire_delay_wielded = 8
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 1)
	projectile_type = /obj/projectile/beam/midlaser/ice
	secondary_projectile_type = null
	secondary_fire_sound = null
	charge_failure_message = "'s charging socket was removed to make room for a crank."
	var/is_charging = FALSE

	firemodes = list()
	modifystate = null

	can_bayonet = TRUE
	knife_x_offset = 23
	knife_y_offset = 13

	desc_extended = "The Tui'ad \"Icelance\" laser rifle is an energy weapon of Tajaran design. Clumsy overheating handguns and rifles that slowly fire long bolts of \
	concentrated energy are used by high ranking soldiers or special operatives of the Republican army, but their durability is dubious in comparison to the mass-produced, \
	single shot or bolt action rifles that the majority of Tajaran soldiers use."

/obj/item/gun/energy/rifle/icelance/unique_action(mob/living/user)
	if(is_charging)
		to_chat(user, SPAN_WARNING("You are already charging \the [src]."))
		return
	if(power_supply.charge < power_supply.maxcharge)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.visible_message(
				SPAN_NOTICE("\The [user] begins to crank \the [src]!"),
				SPAN_NOTICE("You begin to rotate \the [src]'s crank!")
				)
		playsound(user.loc, 'sound/items/crank.ogg', 60, 1)
		is_charging = TRUE
		flick("crank", src)
		if(do_after(user,2 SECONDS))
			to_chat(user, SPAN_NOTICE("You finish charging \the [src]."))
			power_supply.give(charge_cost)
			update_maptext()
			update_icon()
			is_charging = FALSE
		else
			is_charging = FALSE

/obj/item/gun/energy/rifle/icelance/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/rifle/interloper
	name = "\improper H.I. Interloper lever-action laser rifle"
	desc = "An old rifle manufactured to this day by Hephaestus Industries. It has an internal battery chargeable by racking the lever."
	icon = 'icons/obj/guns/faction/hephaestus_industries/interloper.dmi'
	icon_state = "interloper"
	item_state = "interloper"
	has_item_ratio = FALSE
	fire_sound = 'sound/weapons/laser1.ogg'
	max_shots = 5
	force = 10
	accuracy = 0
	accuracy_wielded = 2
	fire_delay = 10
	fire_delay_wielded = 5
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	projectile_type = /obj/projectile/beam/midlaser/interloper
	secondary_projectile_type = null
	secondary_fire_sound = null
	charge_failure_message = "'s charging socket was removed to make room for a crank."
	var/is_charging = FALSE

	firemodes = list()
	modifystate = null

	desc_extended = "The Hephaestus Industries \"Interloper\" lever-action laser rifle is a long-time classic of the corporation's colony defense selection. It has been around nearly as long as lasers themselves have, and is cheap to make despite its rugged durability. This makes it a favorite of far flung colonists and militias spur-wide. A small side effect of its unique charging system is that the laser it produces is noticeably weaker than charger-dependent varieties. "

/obj/item/gun/energy/rifle/interloper/unique_action(mob/living/user)
	if(is_charging)
		to_chat(user, SPAN_WARNING("You are already charging \the [src]."))
		return
	if(power_supply.charge < power_supply.maxcharge)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.visible_message(
				SPAN_NOTICE("\The [user] begins to crank \the [src]!"),
				SPAN_NOTICE("You begin to rack \the [src]'s crank!")
				)
		playsound(user.loc, SFX_PUMP_SHOTGUN, 60, 1)
		is_charging = TRUE
		flick("crank", src)
		if(do_after(user,2 SECONDS,do_flags = (DO_USER_CAN_MOVE | DO_USER_CAN_TURN | DO_SHOW_PROGRESS)))
			to_chat(user, SPAN_NOTICE("You finish charging \the [src]."))
			power_supply.give(charge_cost)
			update_maptext()
			update_icon()
			is_charging = FALSE
		else
			is_charging = FALSE

/obj/item/gun/energy/rifle/interloper/get_cell()
	return DEVICE_NO_CELL

/obj/item/gun/energy/rifle/interloper/research
	name = "\improper H.I. Interloper lever-action laser rifle"
	desc = "An old rifle manufactured to this day by Hephaestus Industries. It has an internal battery chargeable by racking the lever. This one is marked for expeditionary use."
	pin = /obj/item/firing_pin/away_site
