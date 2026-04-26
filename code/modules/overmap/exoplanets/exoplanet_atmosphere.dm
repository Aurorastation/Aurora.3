/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	exterior_atmosphere = new
	if(habitability_weight == HABITABILITY_LOCKED)
		exterior_atmosphere.adjust_gas(GAS_OXYGEN, MOLES_O2STANDARD, 0)
		exterior_atmosphere.adjust_gas(GAS_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/habitability
		var/list/newgases = gas_data.gases.Copy()
		// AURORA SNOWFLAKE: Phoron is scarce. No random planets with phoron.
		newgases -= GAS_PHORON
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= GAS_ALIEN
		// No steam either
		newgases -= GAS_WATERVAPOR

		switch(habitability_weight)
			if (HABITABILITY_TYPICAL)
				habitability = NORMAL_RAND
			if (HABITABILITY_BAD)
				habitability = LINEAR_RAND
			if (HABITABILITY_EXTREME)
				habitability = SQUARE_RAND
			if (HABITABILITY_RANDOM)
				habitability = UNIFORM_RAND


		var/total_moles = MOLES_CELLSTANDARD * (rand(7, 40) / 10)
		var/generator/new_moles = generator("num", 0.15 * total_moles, 0.6 * total_moles, habitability)
		var/badflag = 0

		var/gasnum = rand(max(habitability_weight - 1, 1), 4)
		var/i = 0

		while (i <= gasnum && total_moles && length(newgases))
			if (badflag)
				for(var/g in newgases)
					if (gas_data.flags[g] & badflag)
						newgases -= g

			var/ng = pick_n_take(newgases)	//pick a gas

			if (gas_data.flags[ng] & XGM_GAS_OXIDIZER)
				badflag |= XGM_GAS_OXIDIZER
				if (prob(33))
					badflag |= (XGM_GAS_FUSION_FUEL | XGM_GAS_FUEL)

			if ((gas_data.flags[ng] & XGM_GAS_FUEL) || (gas_data.flags[ng] & XGM_GAS_FUSION_FUEL))
				badflag |= (XGM_GAS_FUSION_FUEL | XGM_GAS_FUEL)
				if (prob(33))
					badflag |= XGM_GAS_OXIDIZER

			var/part = new_moles.Rand() //allocate percentage to it
			if (i == gasnum || !length(newgases)) //if it's last gas, let it have all remaining moles
				part = total_moles

			exterior_atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++
	exterior_atmosphere.update_values()
	exterior_atmosphere.check_tile_graphic()

/obj/effect/overmap/visitable/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list()
	for(var/g as anything in exterior_atmosphere.gas)
		if(gas_data.tile_overlay_color[g])
			colors += gas_data.tile_overlay_color[g]
	if(length(colors))
		return MixColors(colors)
