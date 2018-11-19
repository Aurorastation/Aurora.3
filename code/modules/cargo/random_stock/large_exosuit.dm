// This one is long, so it gets its own file.

STOCK_ITEM_LARGE(exosuit, 1.2)//A randomly generated exosuit in a very variable condition.

	//First up, weighted list of suits to spawn.
	//Some of these come preloaded with modules
	//Those which have dangerous modules have lower weights

	//We may farther remove modules to mitigate it
	var/list/randsuits = list(
		/obj/mecha/working/hoverpod = 5,
		/obj/mecha/working/hoverpod/combatpod = 0.5,//Comes with weapons
		/obj/mecha/working/hoverpod/shuttlepod = 6,
		/obj/mecha/working/ripley = 5,
		/obj/mecha/working/ripley/firefighter = 6,
		/obj/mecha/working/ripley/deathripley = 0.5,//has a dangerous melee weapon
		/obj/mecha/working/ripley/mining = 4,
		/obj/mecha/medical/odysseus = 6,
		/obj/mecha/medical/odysseus/loaded = 5,
		/obj/mecha/combat/durand = 1,//comes unarmed
		/obj/mecha/combat/gygax = 1.5,//comes unarmed
		/obj/mecha/combat/gygax/dark = 0.5,//has weapons
		/obj/mecha/combat/marauder = 0.6,
		/obj/mecha/combat/marauder/seraph = 0.3,
		/obj/mecha/combat/marauder/mauler = 0.4,
		/obj/mecha/combat/phazon = 0.1,
		/obj/mecha/combat/honker = 0.01,
		/obj/mecha/combat/tank = 0.01
	)
	var/type = pickweight(randsuits)
	var/obj/mecha/exosuit = new type(get_turf(L))
	//Now we determine the exosuit's condition
	switch (rand(0,100))
		if (0 to 3)
		//Perfect condition, it was well cared for and put into storage in a pristine state
		//Nothing is done to it.
		if (4 to 10)
		//Poorly maintained.
		//The internal airtank and power cell will be somewhat depleted, otherwise intact
			var/P = rand(0,50)
			P /= 100
			if (exosuit.cell)//Set the cell to a random charge below 50%
				exosuit.cell.charge =  exosuit.cell.maxcharge * P

			P = rand(50,100)
			P /= 100
			if(exosuit.internal_tank)//remove 50-100% of airtank contents
				exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)


		if (11 to 20)
		//Wear and tear
		//Hull has light to moderate damage, tank and cell are depleted
		//Any equipment will have a 25% chance to be lost
			var/P = rand(0,30)
			P /= 100
			if (exosuit.cell)//Set the cell to a random charge below 50%
				exosuit.cell.charge =  exosuit.cell.maxcharge * P

			P = rand(70,100)
			P /= 100
			if(exosuit.internal_tank)//remove 50-100% of airtank contents
				exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)

			exosuit.lose_equipment(25)//Lose modules

			P = rand(10,100)//Set hull integrity
			P /= 100
			exosuit.health = initial(exosuit.health)*P


		if (21 to 40)
		//Severe damage
		//Power cell has 50% chance to be missing or is otherwise low
		//Significant chance for internal damage
		//Hull integrity less than half
		//Each module has a 50% loss chance
		//Systems may be misconfigured
			var/P

			if (prob(50))//Remove cell
				exosuit.cell = null
			else
				P = rand(0,20)//or deplete it
				P /= 100
				if (exosuit.cell)//Set the cell to a random charge below 50%
					exosuit.cell.charge = exosuit.cell.maxcharge * P

			P = rand(80,100)
			P /= 100//Deplete tank
			if(exosuit.internal_tank)//remove 50-100% of airtank contents
				exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles * P)

			exosuit.lose_equipment(50)//Lose modules
			exosuit.random_internal_damage(15)//Internal damage

			P = rand(5,50)//Set hull integrity
			P /= 100
			exosuit.health = initial(exosuit.health)*P
			exosuit.misconfigure_systems(15)


		if (41 to 80)
		//Decomissioned
		//The exosuit is a writeoff, it was tossed into storage for later scrapping.
		//Wasnt considered worth repairing, but you still can
		//Power cell missing, internal tank completely drained or ruptured/
		//65% chance for each type of internal damage
		//90% chance to lose each equipment
		//System settings will be randomly configured
			var/P
			if (prob(15))
				exosuit.cell.rigged = 1//Powercell will explode if you use it
			else if (prob(50))//Remove cell
				exosuit.cell = null

			if (exosuit.cell)
				P = rand(0,20)//or deplete it
				P /= 100
				if (exosuit.cell)//Set the cell to a random charge below 50%
					exosuit.cell.charge =  exosuit.cell.maxcharge * P

			exosuit.lose_equipment(90)//Lose modules
			exosuit.random_internal_damage(50)//Internal damage

			if (!exosuit.hasInternalDamage(MECHA_INT_TANK_BREACH))//If the tank isn't breaches
				qdel(exosuit.internal_tank)//Then delete it
				exosuit.internal_tank = null

			P = rand(5,50)//Set hull integrity
			P /= 100
			exosuit.health = initial(exosuit.health)*P
			exosuit.misconfigure_systems(45)


		if (81 to 100)
		//Salvage
		//The exosuit is wrecked. Spawns a wreckage object instead of a suit
			//Set the noexplode var so it doesn't explode, then just qdel it
			//The destroy proc handles wreckage generation
			exosuit.noexplode = 1
			qdel(exosuit)
			exosuit = null


	//Finally, so that the exosuit seems like it's been in storage for a while
	//We will take any malfunctions to their logical conclusion, and set the error states high
	if (exosuit)
		//If the tank has a breach, then there will be no air left
		if (exosuit.hasInternalDamage(MECHA_INT_TANK_BREACH) && exosuit.internal_tank)
			exosuit.internal_tank.air_contents.remove(exosuit.internal_tank.air_contents.total_moles)

		//If there's an electrical fault, the cell will be complerely drained
		if (exosuit.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT) && exosuit.cell)
			exosuit.cell.charge = 0


		exosuit.process_warnings()//Trigger them first, if they'll happen

		if (exosuit.power_alert_status)
			exosuit.last_power_warning = -99999999
			//Make it go into infrequent warning state instantly
			exosuit.power_warning_delay = 99999999
			//and set the delay between warnings to a functionally infinite value
			//so that it will shut up

		if (exosuit.damage_alert_status)
			exosuit.last_damage_warning = -99999999
			exosuit.damage_warning_delay = 99999999

		exosuit.process_warnings()
