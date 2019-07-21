

//Laser Carbine
/obj/item/weapon/gun/energy/rifle/laser/military
	name = "laser carbine"
	desc = "A 'Mantis F2', a laser carbine designed with both lethal and riot modes."
	icon_state = "lasercarb"
	item_state = "lasercarb"
	modifystate = "lasercarb"
	accuracy = 1
	w_class = 3
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	can_turret = 1
	turret_is_lethal = 1
	turret_sprite_set = "laser"

/obj/item/weapon/gun/energy/rifle/laser/military/update_icon()
	..()
	if(charge_meter && power_supply && power_supply.maxcharge)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.20) * 100, 20)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

		if(wielded)
			item_state = "[initial(item_state)][ratio]-wielded"
		else
			item_state = "[initial(item_state)][ratio]"
	update_held_icon() //Try set it up so that it checks if it's wielded or not, before continueing to modifystate checks.
