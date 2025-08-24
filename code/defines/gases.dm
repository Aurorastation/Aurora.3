/singleton/xgm_gas/oxygen
	id = GAS_OXYGEN
	name = "Oxygen"
	desc = "The gas most life forms need to be able to survive. The most famous oxidizer."
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

	flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL

/singleton/xgm_gas/nitrogen
	id = GAS_NITROGEN
	name = "Nitrogen"
	desc = "A very common, largely inert gas commonly used as a buffer gas to pad artificial atmospheres to habitable pressures."
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol

/singleton/xgm_gas/carbon_dioxide
	id = GAS_CO2
	name = "Carbon Dioxide"
	desc = "What the fuck is carbon dioxide?"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/singleton/xgm_gas/phoron
	id = GAS_PHORON
	name = "Phoron"
	desc = "A highly toxic, highly flammable, and extremely rare substance with curious, nigh-miraculous properties. More precious and more deadly than even time."
	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_overlay = "phoron"
	tile_color = "#ff9940"
	overlay_limit = 0.7
	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT

/singleton/xgm_gas/hydrogen
	id = GAS_HYDROGEN
	name = "Hydrogen"
	desc = "A highly flammable gas. Starstuff. 75% of the universe is made of this."
	specific_heat = 100
	molar_mass = 0.002
	flags = XGM_GAS_FUEL|XGM_GAS_FUSION_FUEL

/singleton/xgm_gas/sleeping_agent
	id = GAS_N2O
	name = "Nitrous Oxide"
	desc = "Causes drowsiness, euphoria, and eventually unconsciousness."
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O
	tile_overlay = "sleeping_agent"
	overlay_limit = 1
	flags = XGM_GAS_OXIDIZER

/singleton/xgm_gas/hydrogen/deuterium
	id = GAS_DEUTERIUM
	name = "Deuterium"
	desc = "A stable isotope of hydrogen. That extra neutron is damned handy for low-temperature fusion reactions."
	specific_heat = 80
	molar_mass = 0.004

/singleton/xgm_gas/hydrogen/tritium
	id = GAS_TRITIUM
	name = "Tritium"
	desc = "An unstable (radioactive), short-lived isotope of hydrogen. Supremely useful as a fuel source for nuclear fusion. Don't breathe this."
	molar_mass = 0.006
	specific_heat = 60

/singleton/xgm_gas/helium
	id = GAS_HELIUM
	name = "Helium"
	desc = "An inert gas that makes your voice squeaky. This is Helium-4, the commonplace stuff. Its lightweight cousin, Helium-3, is ten-thousand times rarer."
	specific_heat = 80	// J/(mol*K)
	molar_mass = 0.004	// kg/mol
	flags = XGM_GAS_FUSION_FUEL

/singleton/xgm_gas/helium/fuel
	id = GAS_HELIUMFUEL
	name = "Helium-3"
	desc = "Helium-3 is a stable helium isotope valued for its use in fusion power; it fuses without dangerous neutron radiation and at much lower temperatures. Insanely valuable."
	specific_heat = 80	// J/(mol*K)
	molar_mass = 0.003	// kg/mol

/singleton/xgm_gas/vapor
	id = GAS_WATERVAPOR
	name = "Water Vapor"
	desc = "Water, in gas form. Slippery when it condenses on the floor. Hurts a LOT if its hot steam."
	tile_overlay = "generic"
	overlay_limit = 0.5
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.020	// kg/mol

/singleton/xgm_gas/sulfurdioxide
	id = GAS_SULFUR
	name = "Sulfur Dioxide"
	desc = "Volcano breath. Also the smell of burnt matches. Venus' atmosphere is full of this stuff."
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/singleton/xgm_gas/chlorine
	id = GAS_CHLORINE
	name = "Chlorine"
	desc = "Fucks up your lungs AND your eyes AND your skin. Maybe try to avoid it."
	tile_color = "#c5f72d"
	tile_overlay = "chlorine"
	overlay_limit = 0.5
	specific_heat = 5	// J/(mol*K)
	molar_mass = 0.017	// kg/mol
	flags = XGM_GAS_CONTAMINANT

/singleton/xgm_gas/nitrogendioxide
	id = GAS_NO2
	name = "Nitrogen Dioxide"
	desc = "A byproduct of a dozen and more critical chemical industrial processes. Pollution."
	specific_heat = 33	// J/(mol*K)
	molar_mass = 0.046	// kg/mol

/singleton/xgm_gas/alium
	id = GAS_ALIEN
	name = "Aliether"

/singleton/xgm_gas/alium/New()
	var/num = rand(100,999)
	name = "Compound #[num]"
	specific_heat = rand(1, 400)	// J/(mol*K)
	molar_mass = rand(20,800)/1000	// kg/mol
	if(prob(40))
		flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		flags |= XGM_GAS_CONTAMINANT

	if(prob(50))
		tile_color = RANDOM_RGB
		overlay_limit = 0.5
