/obj/item/custom_ka_upgrade/cells/attack_self(mob/user)
	if(is_pumping)
		return

	if(pump_restore)
		is_pumping = TRUE
		if(stored_charge >= cell_increase)
			to_chat(user, SPAN_WARNING("The pump on \the [src] refuses to move."))
		else
			if(!pump_delay || do_after(user, pump_delay, use_user_turf = -1))
				if(last_pump < world.time)
					if(isturf(src.loc))
						to_chat(user, SPAN_NOTICE("You pump \the [src]."))
					else
						to_chat(user, SPAN_NOTICE("You pump \the [src.loc]."))
					last_pump = world.time + 100 // every ten seconds
				stored_charge = min(stored_charge + pump_restore, cell_increase)
				playsound(src, 'sound/weapons/kinetic_reload.ogg', 50, FALSE)

		is_pumping = FALSE
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/item/custom_ka_upgrade/cells/cell01
	//Pump Action
	name = "pump recharging KA cell"
	build_name = "pump-recharging"
	desc = "A very basic power cell and pump action combo that stores 4 charges. Low capacity however it has slightly increased range."
	icon_state = "cell01"
	firedelay_increase = 0.25 SECONDS
	range_increase = 2
	recoil_increase = -3
	cell_increase = 4
	capacity_increase = -1
	mod_limit_increase = 0

	pump_restore = 1
	pump_delay = 0.4 SECONDS

	origin_tech = list(TECH_MATERIAL = 1,TECH_ENGINEERING = 1,TECH_MAGNET = 1,TECH_POWER = 1)

/obj/item/custom_ka_upgrade/cells/cell02
	//Pump Action
	name = "advanced pump recharging KA cell"
	build_name = "pump-recharging"
	desc = "A somewhat more advanced, standard issue pump and cell assembly that stores charges up to a capacity of 12. Can fire and pump quite quickly."
	icon_state = "cell02"
	firedelay_increase = 0.1 SECONDS
	recoil_increase = 1
	cell_increase = 12
	capacity_increase = -2
	mod_limit_increase = 0

	pump_restore = 1
	pump_delay = 0.3 SECONDS

	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 1,TECH_MAGNET = 1,TECH_POWER = 3)

/obj/item/custom_ka_upgrade/cells/cell03
	name = "kinetic charging KA cell"
	build_name = "kinetic"
	desc = "A complex pump and cell assembly that uses the kinetic energy of an initial pump to significantly charge the cell. Deals increased damage at the cost of reduced firerate."
	icon_state = "cell03"
	damage_increase = 10
	firedelay_increase = 0.5 SECONDS
	cost_increase = -1
	cell_increase = 40
	capacity_increase = -3
	mod_limit_increase = 0

	pump_restore = 40
	pump_delay = 1 SECONDS

	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 3,TECH_MAGNET = 2,TECH_POWER = 3)

/obj/item/custom_ka_upgrade/cells/cell04
	name = "uranium charging KA cell"
	build_name = "recharging"
	desc = "A pumpless cell assembly that containes a miniaturized nuclear reactor housed safely inside the assembly. Recharges the cell shortly over time, however deals slightly reduced damage."
	icon_state = "cell04"
	firedelay_increase = 0.1 SECONDS
	damage_increase = -5
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 60
	capacity_increase = -4
	mod_limit_increase = 0

	pump_restore = 0
	pump_delay = 0

	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 4,TECH_MAGNET = 3,TECH_POWER = 5)

/obj/item/custom_ka_upgrade/cells/cell04/on_update(var/obj/item/gun/custom_ka/the_gun)
	stored_charge = min(stored_charge + 3,cell_increase)

/obj/item/custom_ka_upgrade/cells/cell05
	name = "recoil reloader KA cell"
	build_name = "recoil-reloading"
	desc = "A very experimental and well designed cell and pump assembly that converts some of the kinetic energy from the weapon's recoil into usable energy. Only works if the recoil is high enough. Contains a basic top-mounted pump just in case, however it blocks the chip slot."
	icon_state = "cell05"
	firedelay_increase = 0.4 SECONDS
	damage_increase = 0
	recoil_increase = -5
	cost_increase = -3
	cell_increase = 80
	capacity_increase = -5
	mod_limit_increase = 0

	pump_restore = 5
	pump_delay = 0.5 SECONDS

	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 6,TECH_MAGNET = 5,TECH_POWER = 5, TECH_PHORON = 5)

	disallow_chip = TRUE

/obj/item/custom_ka_upgrade/cells/cell05/on_fire(var/obj/item/gun/custom_ka/the_gun)
	if(the_gun.recoil_increase > 0)
		stored_charge = min(stored_charge + min(the_gun.recoil_increase*2,the_gun.cost_increase*0.5),cell_increase)

/obj/item/custom_ka_upgrade/cells/cyborg
	name = "cyborg KA cell"
	build_name = "battery powered"
	desc = "A pumpless cell assembly that leaches power from the cyborg's internal battery."
	icon_state = "cell_cyborg"
	damage_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 20
	capacity_increase = 0
	mod_limit_increase = 0
	firedelay_increase = 0.25 SECONDS

	pump_restore = 0
	pump_delay = 0

	origin_tech = list()

/obj/item/custom_ka_upgrade/cells/cyborg/on_update(var/obj/item/gun/custom_ka/the_gun)
	var/mob/living/silicon/robot/owner_robot = the_gun.loc
	if(!istype(owner_robot))
		return

	var/obj/item/cell/external = owner_robot.cell
	var/charge_to_give = cell_increase - stored_charge
	if(istype(external) && external.use(charge_to_give*5))
		stored_charge += charge_to_give

/obj/item/custom_ka_upgrade/cells/illegal
	//Pump Action
	name = "pump action KA cell"
	build_name = "pump-action"
	desc = "A clusterfuck of circuitry and battery parts all snuggly fit inside a solid, static plastisteel frame. A single pump is enough to fully charge any set-up."
	icon_state = "cell_illegal"
	firedelay_increase = 0
	recoil_increase = 0
	cost_increase = -100
	stored_charge = 5
	cell_increase = 5
	capacity_increase = 0
	mod_limit_increase = 0

	pump_restore = 30
	pump_delay = 0.3 SECONDS

	origin_tech = list(TECH_MATERIAL = 3,TECH_ENGINEERING = 3,TECH_MAGNET = 3,TECH_POWER = 3, TECH_ILLEGAL = 4)

/obj/item/custom_ka_upgrade/cells/kinetic_charging
	name = "kinetic charging KA cell"
	build_name = "kinetic recharging"
	desc = "A curious cell and pump combo that automatically charges based on how much charge is already present in the cell."
	icon_state = "cell_burst"
	firedelay_increase = 0.1 SECONDS
	damage_increase = 0
	recoil_increase = 0
	cost_increase = 0
	cell_increase = 30
	capacity_increase = -4
	mod_limit_increase = 0

	pump_restore = 3
	pump_delay = 0.3 SECONDS

	origin_tech = list(TECH_MATERIAL = 6,TECH_ENGINEERING = 5,TECH_MAGNET = 4,TECH_POWER = 6)

/obj/item/custom_ka_upgrade/cells/kinetic_charging/on_update(var/obj/item/gun/custom_ka/the_gun)
	stored_charge = min(stored_charge + round(stored_charge*0.2),cell_increase)


/obj/item/custom_ka_upgrade/cells/loader
	name = "phoron loading KA cell"
	build_name = "phoron loading"
	desc = "A bottom feeding mount that accepts sheets of phoron, and processes them into useable energy. Wildy ineffecient and expensive to maintain, however the charge lasts a while and the damage boost makes it worth it."
	icon_state = "cell_phoronloader"
	damage_increase = 10
	recoil_increase = 2
	cell_increase = 250
	capacity_increase = -5

	pump_restore = 0
	pump_delay = 0

	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 6,TECH_MAGNET = 5,TECH_POWER = 6, TECH_PHORON = 5)

	var/type_to_take = "phoron"
	var/charge_per_sheet = 100

/obj/item/custom_ka_upgrade/cells/loader/attackby(var/obj/item/I as obj, var/mob/user as mob)

	var/obj/item/stack/material/the_sheet = I

	if(istype(the_sheet) && the_sheet.default_type == type_to_take)

		var/amount_to_take = 1
		if(stored_charge + charge_per_sheet > cell_increase)
			to_chat(user,"<span class='notice'>You can't put any more [I] into \the [src].</span>")
			return

		amount_to_take = min(amount_to_take,the_sheet.amount)
		the_sheet.amount -= amount_to_take
		stored_charge += amount_to_take*charge_per_sheet

		user.visible_message("<span class='notice'>\The [user] inserts a sheet [I] into \the [src].</span>", \
			"<span class='notice'>You insert a sheet of [I]s into \the [src].</span>", \
			"<span class='notice'>You hear mechanical whirring.</span>")


		if(the_sheet.amount <= 0)
			qdel(I)

/obj/item/custom_ka_upgrade/cells/loader/uranium
	name = "uranium loading KA cell"
	build_name = "uranium loading"
	desc = "A bottom feeding mount that accepts sheets of uranium, and processes them into useable energy. Wildy ineffecient and expensive to maintain, however the charge lasts a while."
	icon_state = "cell_uraniumloader"
	cell_increase = 300
	capacity_increase = -5

	pump_restore = 0
	pump_delay = 0

	origin_tech = list(TECH_MATERIAL = 5,TECH_ENGINEERING = 6,TECH_MAGNET = 5,TECH_POWER = 6)

	type_to_take = "uranium"
	charge_per_sheet = 75

/obj/item/custom_ka_upgrade/cells/loader/hydrogen
	name = "hydrogen loading KA cell"
	build_name = "hydrogen loading"
	desc = "A bottom feeding mount that accepts sheets of hydrogen, and processes them into useable energy. Wildy ineffecient and expensive to maintain."
	icon_state = "cell_hydrogenloader"

	cell_increase = 100
	capacity_increase = -4

	pump_restore = 0
	pump_delay = 0

	origin_tech = list(TECH_MATERIAL = 4,TECH_ENGINEERING = 5,TECH_MAGNET = 4,TECH_POWER = 4)

	type_to_take = "mhydrogen"
	charge_per_sheet = 90