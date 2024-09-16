/datum/map_template/ruin/away_site/cryo_lost_station_
	name = "Cryo-Lost Station"
	id = "cryolost"
	spawn_cost = 1
	spawn_weight = 1
	description = "An abandoned space station, lost to time."

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		//Z3
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "away_site/cryo_lost_station/"
	suffix = "cryo_lost_station_.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS) //the idea is for the station to be a little different each time, and for as many gimmicks as possible to be played from it

	unit_test_groups = list(1)

/singleton/submap_archetype/cryo_lost_station_
	map = "Cryo-Lost Station"
	descriptor = "An abandoned space station, lost to time."

/obj/effect/overmap/visitable/cryo_lost_station_
	name = "decaying space station"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "depot"
	class = "ISS" //Independent Space Station. The IFF transponder is on the fritz and has been factory reset. Ghost role crew should be able to rename it for a gimmick if they'd like.
	desc = "A large space station, one which appears derelict and dated by several decades. IFF data from the facility appears inconsistent and inaccurate due to near-total power failure, making it impossible to identify the owner accurately. Scans reveal compromised electical and atmospheric systems, with very few lifesigns detected - but not none. Beyond that, specifics are difficult to ascertain by sensor scan alone. Much of the facility appears to still be intact, but it's unlikely to be completely empty."
	initial_generic_waypoints = list(
		"cryo_lost_waypoint_dock_port",
		"cryo_lost_waypoint_dock_port_fore",
		"cryo_lost_waypoint_dock_port_aft",
		"cryo_lost_waypoint_dock_starboard",
		"cryo_lost_waypoint_dock_starboard_fore"
		"cryo_lost_waypoint_dock_starboard_aft"
		"cryo_lost_waypoint_dock_cargo"
		"cryo_lost_waypoint_dock_mining"
		"cryo_lost_waypoint_n_space",
		"cryo_lost_waypoint_e_space",
		"cryo_lost_waypoint_w_space",
		"cryo_lost_waypoint_s_space"
	)

/obj/effect/overmap/visitable/cryo_lost_station_/New()
	designation = "[pick("Void Star", "Radiance", "Daybreak", "Nightfall", "Stardust")]"
	..()


/obj/item/paper/cryo_lost_station_/nitrogenSM
	name = "Supermatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Supermatter-Powered Thermoelectric Generator! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (Warranty voided in the event of Engine operation outside of these instructions. (IMPORTANT!): Make sure to don a radiation suit and safety goggles when operating a Supermatter engine! (1.) Wrench two Nitrogen canisters in the cyan Hot Loop Intake ports, and two Nitrogen canisters in the green Cold Loop Intake ports. (2.) Max out the Intake loop pumps and turn them on, fully emptying all four canisters into each loop. (3.)Max out and turn on the Cooling Array to Generators pump. (4.) Locate your engine omni gas filter. Note that some setups may come equipped with multiple. For the Compact-and-Easy! setup, there is only one. Enable South input, North output, and filter Nitrogen to West. This keeps coolant in the engine loop, while disposing of all other waste byproducts. (5.) Disable the Hot Loop and Cold Loop Intake pumps once the canisters are completely empty. (6.) Activate the Emitter. Count exactly twelve shots, and then make sure to turn it off afterwards! (7.) Install a Transmission and Capacitance coil in the leftmost SMES unit in your engine room. Make sure there is no stored charge, and Input and Output are both disabled. Your engine may require an additional four (4) emitter shots after extended operation, as it will eventually cool down once again. (IMPORTANT!): In the event of a delamination warning, do not panic! Simply open both Thermal Relief Valves located at the Fore and Aft of both turbines. If this is not successful, injecting an extra canister of room-temperature Nitrogen into the Hot Loop Intake is the next step. If your Supermatter shard integrity is not salvageable, ejection is recommended to avoid catastrophic damage. Locate and press the Supermatter Reactor Emergency Ventilatory Control switch, followed by the Supermatter Reactor Emergency Crystal Ejection switch. If you activate these switches out of the prescribed order, you will dislodge the crystal from the mass driver and will not be able to fire it again. Manual ejection through direct dragging by the shard safety pillar is the only option to avoid certain destruction in this scenario. Please note that the warranty on your Supermatter powered engine will be voided after the following: operation outside of the above instructions exact wording, loss of shard integrity potentially leading to delamination, delamination, core ejection, manual core ejection, destruction of property or life via contact with shard, and engine activation in any capacity. By using a Supermatter powered engine, you are accepting full responsibility for any harm up to and including loss of life, no liability is accepted by the sale provider."

/obj/item/paper/cryo_lost_station_/phoronSM
	name = "Supermatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Supermatter-Powered Thermoelectric Generator! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (Warranty voided in the event of Engine operation outside of these instructions. (IMPORTANT!): Make sure to don a radiation suit and safety goggles when operating a Supermatter engine! (1.) Wrench two Phoron canisters in the cyan Hot Loop Intake ports, and two Phoron canisters in the green Cold Loop Intake ports. (2.) Max out the Intake loop pumps and turn them on, fully emptying all four canisters into each loop. (3.)Max out and turn on the Cooling Array to Generators pump. (4.) Locate your engine omni gas filter. Note that some setups may come equipped with multiple. For the Compact-and-Easy! setup, there is only one. Enable South input, North output, and filter Phoron to West. This keeps coolant in the engine loop, while disposing of all other waste byproducts. (5.) Disable the Hot Loop and Cold Loop Intake pumps once the canisters are completely empty. (6.) Activate the Emitter. Count up to fourty shots (up to one-hundred is safe, but not typically required short of extremely power-intensive machinery), and then make sure to turn it off afterwards! (7.) Install a Transmission and Capacitance coil in the leftmost SMES unit in your engine room. Make sure there is no stored charge, and Input and Output are both disabled. Your engine may require an additional four (4) emitter shots after extended operation, as it will eventually cool down once again. (IMPORTANT!): In the event of a delamination warning, do not panic! Simply open both Thermal Relief Valves located at the Fore and Aft of both turbines. If this is not successful, injecting an extra canister of room-temperature Phoron into the Hot Loop Intake is the next step. If your Supermatter shard integrity is not salvageable, ejection is recommended to avoid catastrophic damage. Locate and press the Supermatter Reactor Emergency Ventilatory Control switch, followed by the Supermatter Reactor Emergency Crystal Ejection switch. If you activate these switches out of the prescribed order, you will dislodge the crystal from the mass driver and will not be able to fire it again. Manual ejection through direct dragging by the shard safety pillar is the only option to avoid certain destruction in this scenario. Please note that the warranty on your Supermatter powered engine will be voided after the following: operation outside of the above instructions exact wording, loss of shard integrity potentially leading to delamination, delamination, core ejection, manual core ejection, destruction of property or life via contact with shard, and engine activation in any capacity. By using a Supermatter powered engine, you are accepting full responsibility for any harm up to and including loss of life, no liability is accepted by the sale provider."

/obj/item/paper/cryo_lost_station_/fusion
	name = "Fusion Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Mk. I Tokamak Experimental Fusion Reactor! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (0.) OPTIONAL: If performing a cold start, locate a portable generator and load it with the requisite fuel. Power level should be set to level 2 or 3, as long as it remains within the safe green operation range. (1.) Locate a source of Deuterium and a source of Tritium. Metallic sheets may be processed into fuel rods with the Fuel Compressor, or gas canisters may be used if available. (2.) FUEL RODS: Create four Deuterium rods, and two Tritium rods. Load them into the Fuel Injectors in any order. On the Fuel Injection Control terminal, global injection rate can be adjusted to 25-50 for fuel longevity. GAS CANISTERS: Wrench one Deuterium canister and one Tritium canister into the two available gas injection connector ports. Set both pumps to 5-10 kPa. (3.) On the Gyrotron Control terminal, set Strength to 10, Delay to 2. (3.) On the Fusion Core Control terminal, set Field Strength to 60 Tesla. (4.) Enable Fuel Injection/Gas Pumps, enable the Gyrotron, and finally initiate the Fusion core. Power and temperature should rise on the Fusion Core Control terminal. Always ensure that the Instability is remaining below 1-2%. (5.) Once power output is 250kW or higher, disable the portable generator if one was in use to avoid potential damages. (6.) Gyrotron power Strength can now safely be lowered to 3, and Delay increased to 3, but make sure that instability is still being sufficiently managed if lowered. (7.) Install a Transmission and Capacitance coil in the north-facing SMES unit in your engine room in order to supply sufficient power to the rest of the facility. (8.) OPTIONAL: When the fusion reaction temperature reaches greater than 10,000 kelvin, Tritium sources may be swapped out in the following ways for greater power generation. FUEL RODS: A Hydrogen canister may be wrenched onto one of the gas ports, with a pump set to 5-10 kPa. Once Hydrogen is active, the Tritium fuel rods may be disabled and replaced with more Deuterium rods. GAS CANISTERS: The Tritium gas canister may be swapped out for a Hydrogen gas canister kept at the same pressure. (IMPORTANT!): In the event that instability begins to rise uncontrollably, raise the Gyrotron Strength as high as power supply allows for, and lower the Fire Delay as much as possible. If it still cannot be lowered, enable the portable generator to ensure a power supply to the Gyrotron, and completely cease the injection of all fuel rods and/or gas as soon as possible with the Fuel Injection Control and/or Fusion Chamber Monitor terminals. If safe levels are still not attainable, activate the Fusion Core Ventilatory Control switch to purge all reactants to space. Once there are no longer any reactions taking place, the Gyrotron may be disabled and the core allowed to cool down. Once the core temperature reaches below 1000 kelvin, it can be safely switched off on the Fusion Core Control terminal. Do not switch off the portable generator until the core has safely cooled off and been completely brought offline. If core safeties are overridden and the reactor is shutdown before it has safely cooled, this can potentially result in catastrophic damage to your facility, potentially up to and including loss of life."

/obj/item/paper/cryo_lost_station_/antimatter
	name = "Antimatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Antimatter Reactor! You’re just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (1.) Locate your nearest crate of blue Antimatter Containment Jars. Handle them with care, as they may rupture under high pressure. (2.) Insert an Antimatter Containment Jar into the Antimatter Control Unit. (3.) Set fuel injection to a maximum of 2 Units. The Antimatter shielding can only safely handle 2 Units per circular core. For higher power needs, more AM shielding segments may be purchased through your local Cargo supplier, or output may be supplemented by secondary power sources, such as solar panels. (NOTE:) If core shielding segments do not initialise properly, Force Shielding Update may update their software and allow for proper function."

/obj/item/paper/cryo_lost_station_/IFFexamples
	name = "Notes on the IFF transponder"
	info = "The Bridge keep reporting issues with the IFF transponder. Apparently any time there is a power fluctuation during reactor cycling, the thing flickers on and off and resets to factory settings each time, so we have to keep manually resetting the station class and designation. I can never remember what all those IFF tags on stations mean. Pretty quiet today, so I am going to write this out to help me remember. Some of these might be wrong, I should check with someone on the Bridge that probably knows better later. (Corporate:) NSS: NanoTrasen. HSS: Hephaestus. ZSS: Zeng-Hu (might differ depending on the subsidiary maybe???). NISS: Necropolis Industries. IISS: Idris Incorporated. EESS: Einstein Engines (same with the subsidiaries??). These ones probably do all depend on the subsidiary actually but I'm just a wrencher so I don't need to know all that. (Government:) SASS: Sol Alliance govt. ? BSS: Biesel I guess. CSS: Coalition govt. (probably?). ESS: Elyra most likely (spacer suit...?). HIMSS: Dominia. His-Imperial-Majesty Space Station. I get it, but surely something rolls off the tongue better. NFSS: Nralakk or something. OCASS: Ouerean Colony Administration. Guess Sol and Nralakk couldn not decide what to call it. PRASS: The PRA. DPRASS: The DPRA. NKASS: The NKA. (Other:) (was not sure where to put these) ISS: Independent. The transponder keeps resetting to this when it reboots. IASS: Interstellar Aid Corps."

/obj/item/paper/cryo_lost_station_/suicide
	name = "Final Words"
	info = "I can't live with myself after locking all those people into the Civilian area. All the blood and screaming. I thought it was the only choice left since our security force was already dead, we had to contain it all somehow, but I left so many people to die. This is the least of what I deserve."
