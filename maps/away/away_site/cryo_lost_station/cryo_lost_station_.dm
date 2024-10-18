/datum/map_template/ruin/away_site/cryo_lost_station_
	name = "Cryo-Lost Station"
	id = "cryo_lost"
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

	sectors = list(ALL_POSSIBLE_SECTORS) //The idea is for the station to be a little different each time, and for as many gimmicks as possible to be played from it

	unit_test_groups = list(1)

/singleton/submap_archetype/cryo_lost_station_
	map = "Cryo-Lost Station"
	descriptor = "An abandoned space station, lost to time."

/obj/effect/overmap/visitable/cryo_lost_station_
	name = "decaying space station"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "depot"
	class = "ISS" //Independent Space Station. The IFF transponder is on the fritz and has been factory reset. Ghost role crew should be able to rename it for a gimmick if they'd like.
	desc = "A large space station, one which appears derelict and dated by several decades. IFF data from the facility appears inconsistent and inaccurate due to near-total power failure, making it impossible to identify the owner accurately. Scans reveal compromised electical and atmospheric systems, with very few lifesigns detected - but not none. Beyond that, specifics are difficult to ascertain by sensor scan alone. Much of the facility appears to still be intact, but it's unlikely to be completely empty and "
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

//Instructional papers.

/obj/item/paper/cryo_lost_station_/nitrogen_SM //For the Nitrogen Supermatter submap
	name = "Supermatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Supermatter-Powered Thermoelectric Generator! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (Warranty voided in the event of Engine operation outside of these instructions. (IMPORTANT!): Make sure to don a radiation suit and safety goggles when operating a Supermatter engine! (1.) Wrench two Nitrogen canisters in the cyan Hot Loop Intake ports, and two Nitrogen canisters in the green Cold Loop Intake ports. (2.) Max out the Intake loop pumps and turn them on, fully emptying all four canisters into each loop. (3.)Max out and turn on the Cooling Array to Generators pump. (4.) Locate your engine omni gas filter. Note that some setups may come equipped with multiple. For the Compact-and-Easy! setup, there is only one. Enable South input, North output, and filter Nitrogen to West. This keeps coolant in the engine loop, while disposing of all other waste byproducts. (5.) Disable the Hot Loop and Cold Loop Intake pumps once the canisters are completely empty. (6.) Activate the Emitter. Count exactly twelve shots, and then make sure to turn it off afterwards! (7.) Install a Transmission and Capacitance coil in the leftmost SMES unit in your engine room. Make sure there is no stored charge, and Input and Output are both disabled. Your engine may require an additional four (4) emitter shots after extended operation, as it will eventually cool down once again. (IMPORTANT!): In the event of a delamination warning, do not panic! Simply open both Thermal Relief Valves located at the Fore and Aft of both turbines. If this is not successful, injecting an extra canister of room-temperature Nitrogen into the Hot Loop Intake is the next step. If your Supermatter shard integrity is not salvageable, ejection is recommended to avoid catastrophic damage. Locate and press the Supermatter Reactor Emergency Ventilatory Control switch, followed by the Supermatter Reactor Emergency Crystal Ejection switch. If you activate these switches out of the prescribed order, you will dislodge the crystal from the mass driver and will not be able to fire it again. Manual ejection through direct dragging by the shard safety pillar is the only option to avoid certain destruction in this scenario. Please note that the warranty on your Supermatter powered engine will be voided after the following: operation outside of the above instructions exact wording, loss of shard integrity potentially leading to delamination, delamination, core ejection, manual core ejection, destruction of property or life via contact with shard, and engine activation in any capacity. By using a Supermatter powered engine, you are accepting full responsibility for any harm up to and including loss of life, no liability is accepted by the sale provider."

/obj/item/paper/cryo_lost_station_/phoron_SM //For the Phoron Supermatter submap
	name = "Supermatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Supermatter-Powered Thermoelectric Generator! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (Warranty voided in the event of Engine operation outside of these instructions. (IMPORTANT!): Make sure to don a radiation suit and safety goggles when operating a Supermatter engine! (1.) Wrench two Phoron canisters in the cyan Hot Loop Intake ports, and two Phoron canisters in the green Cold Loop Intake ports. (2.) Max out the Intake loop pumps and turn them on, fully emptying all four canisters into each loop. (3.)Max out and turn on the Cooling Array to Generators pump. (4.) Locate your engine omni gas filter. Note that some setups may come equipped with multiple. For the Compact-and-Easy! setup, there is only one. Enable South input, North output, and filter Phoron to West. This keeps coolant in the engine loop, while disposing of all other waste byproducts. (5.) Disable the Hot Loop and Cold Loop Intake pumps once the canisters are completely empty. (6.) Activate the Emitter. Count up to fourty shots (up to one-hundred is safe, but not typically required short of extremely power-intensive machinery), and then make sure to turn it off afterwards! (7.) Install a Transmission and Capacitance coil in the leftmost SMES unit in your engine room. Make sure there is no stored charge, and Input and Output are both disabled. Your engine may require an additional four (4) emitter shots after extended operation, as it will eventually cool down once again. (IMPORTANT!): In the event of a delamination warning, do not panic! Simply open both Thermal Relief Valves located at the Fore and Aft of both turbines. If this is not successful, injecting an extra canister of room-temperature Phoron into the Hot Loop Intake is the next step. If your Supermatter shard integrity is not salvageable, ejection is recommended to avoid catastrophic damage. Locate and press the Supermatter Reactor Emergency Ventilatory Control switch, followed by the Supermatter Reactor Emergency Crystal Ejection switch. If you activate these switches out of the prescribed order, you will dislodge the crystal from the mass driver and will not be able to fire it again. Manual ejection through direct dragging by the shard safety pillar is the only option to avoid certain destruction in this scenario. Please note that the warranty on your Supermatter powered engine will be voided after the following: operation outside of the above instructions exact wording, loss of shard integrity potentially leading to delamination, delamination, core ejection, manual core ejection, destruction of property or life via contact with shard, and engine activation in any capacity. By using a Supermatter powered engine, you are accepting full responsibility for any harm up to and including loss of life, no liability is accepted by the sale provider."

/obj/item/paper/cryo_lost_station_/fusion //For the INDRA submap
	name = "Fusion Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Mk. I Tokamak Experimental Fusion Reactor! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (0.) OPTIONAL: If performing a cold start, locate a portable generator and load it with the requisite fuel. Power level should be set to level 2 or 3, as long as it remains within the safe green operation range. (1.) Locate a source of Deuterium and a source of Tritium. Metallic sheets may be processed into fuel rods with the Fuel Compressor, or gas canisters may be used if available. (2.) FUEL RODS: Create four Deuterium rods, and two Tritium rods. Load them into the Fuel Injectors in any order. On the Fuel Injection Control terminal, global injection rate can be adjusted to 25-50 for fuel longevity. GAS CANISTERS: Wrench one Deuterium canister and one Tritium canister into the two available gas injection connector ports. Set both pumps to 5-10 kPa. (3.) On the Gyrotron Control terminal, set Strength to 10, Delay to 2. (3.) On the Fusion Core Control terminal, set Field Strength to 60 Tesla. (4.) Enable Fuel Injection/Gas Pumps, enable the Gyrotron, and finally initiate the Fusion core. Power and temperature should rise on the Fusion Core Control terminal. Always ensure that the Instability is remaining below 1-2%. (5.) Once power output is 250kW or higher, disable the portable generator if one was in use to avoid potential damages. (6.) Gyrotron power Strength can now safely be lowered to 3, and Delay increased to 3, but make sure that instability is still being sufficiently managed if lowered. (7.) Install a Transmission and Capacitance coil in the north-facing SMES unit in your engine room in order to supply sufficient power to the rest of the facility. (8.) OPTIONAL: When the fusion reaction temperature reaches greater than 10,000 kelvin, Tritium sources may be swapped out in the following ways for greater power generation. FUEL RODS: A Hydrogen canister may be wrenched onto one of the gas ports, with a pump set to 5-10 kPa. Once Hydrogen is active, the Tritium fuel rods may be disabled and replaced with more Deuterium rods. GAS CANISTERS: The Tritium gas canister may be swapped out for a Hydrogen gas canister kept at the same pressure. (IMPORTANT!): In the event that instability begins to rise uncontrollably, raise the Gyrotron Strength as high as power supply allows for, and lower the Fire Delay as much as possible. If it still cannot be lowered, enable the portable generator to ensure a power supply to the Gyrotron, and completely cease the injection of all fuel rods and/or gas as soon as possible with the Fuel Injection Control and/or Fusion Chamber Monitor terminals. If safe levels are still not attainable, activate the Fusion Core Ventilatory Control switch to purge all reactants to space. Once there are no longer any reactions taking place, the Gyrotron may be disabled and the core allowed to cool down. Once the core temperature reaches below 1000 kelvin, it can be safely switched off on the Fusion Core Control terminal. Do not switch off the portable generator until the core has safely cooled off and been completely brought offline. If core safeties are overridden and the reactor is shutdown before it has safely cooled, this can potentially result in catastrophic damage to your facility, potentially up to and including loss of life."

/obj/item/paper/cryo_lost_station_/antimatter //For the Antimatter submap
	name = "Antimatter Reactor Startup Instructions"
	info = "Congratulations on the installation of your brand new Antimatter Reactor! You are just a few short steps away from a safe and reliable power source for your ship or facility. Follow the steps below to get started! (1.) Locate your nearest crate of blue Antimatter Containment Jars. Handle them with care, as they may rupture under high pressure. (2.) Insert an Antimatter Containment Jar into the Antimatter Control Unit. (3.) Set fuel injection to a maximum of 2 Units. The Antimatter shielding can only safely handle 2 Units per circular core. For higher power needs, more AM shielding segments may be purchased through your local Cargo supplier, or output may be supplemented by secondary power sources, such as solar panels. (NOTE:) If core shielding segments do not initialise properly, Force Shielding Update may update their software and allow for proper function."

/obj/item/paper/cryo_lost_station_/IFF_examples //Some reference material next to a sensor console so the ghost roles can rename the class/name of the station for a gimmick they might have
	name = "Notes on the IFF transponder"
	info = "The Bridge keep reporting issues with the IFF transponder. Apparently any time there is a power fluctuation during reactor cycling, the thing flickers on and off and resets to factory settings each time, so we have to keep manually resetting the station class and designation. I can never remember what all those IFF tags on stations mean. Pretty quiet today, so I am going to write this out to help me remember. Some of these might be wrong, I should check with someone on the Bridge that probably knows better later. (Corporate:) NSS: NanoTrasen. HSS: Hephaestus. ZSS: Zeng-Hu (might differ depending on the subsidiary maybe???). NISS: Necropolis Industries. IISS: Idris Incorporated. EESS: Einstein Engines (same with the subsidiaries??). These ones probably do all depend on the subsidiary actually but I'm just a wrencher so I don't need to know all that. (Government:) SASS: Sol Alliance govt. ? BSS: Biesel I guess. CSS: Coalition govt. (probably?). ESS: Elyra most likely (spacer suit...?). HIMSS: Dominia. His-Imperial-Majesty Space Station. I get it, but surely something rolls off the tongue better. NFSS: Nralakk or something. OCASS: Ouerean Colony Administration. Guess Sol and Nralakk couldn not decide what to call it. PRASS: The PRA. DPRASS: The DPRA. NKASS: The NKA. (Other:) (was not sure where to put these) ISS: Independent. The transponder keeps resetting to this when it reboots. IASS: Interstellar Aid Corps."

//Engineer Papers.

/obj/item/paper/cryo_lost_station_/engineer_suicide
	name = "Final Words"
	info = "I can't live with myself after locking all those people into the Service area. All the blood and screaming. I thought it was the only choice left since our security force was already dead, we had to contain it all somehow, but I left so many people to die. This is the least of what I deserve."

/obj/item/paper/cryo_lost_station_/engineer_despair
	name = "Paper Scrap"
	info = "I tried to save who I could after that fucker locked everyone in Service. I think I got four or five people out with the portable ladder before the Chapel was breached. I was not able to tear my eyes away as everyone got mowed down. There is a special place in hell for the Engineer that locked them all in there. I think I will just sit here and drink. Maybe pray. Never was the spiritual type, truth be told, but who else could I turn to after this?"

//Cryo Papers.

/obj/item/paper/cryo_lost_station_/bloody
	name = "Bloodied Paper"
	info = "I managed to lock down Engineering, but one of those fuckers got me in the hall just outside. I cannot get the bleeding to stop. If anyone wakes up from cryo and sees this, you would be better off just climbing back in and going to sleep forever. Stay away from Service. Stay away from Science. Tell my family th"

/obj/item/paper/cryo_lost_station_/cryo_report //A prompt for the ghost roles to follow or ignore as they wish
	name = "Cryogenics Emergency Stop Report"
	info = "Catastrophic electrical failure reported. Failing atmospheric systems. Beginning emergency stop of suspended animation. (ERROR!:) Cryogenic stasis pods locked. Searching for solution... (ERROR!:) Logs indicate crew in suspended animation far in excess of recommended safe duration. Tim#e elap&sed: $#@ y%ears, %1 mon^th$, 6+ d&ys.  (SOLUTION FOUND!:) Eme#rgency over%rid@e initiated. Disengaging locks. Discharging skeleton crew for vital diagnostics. Recommended actions for crew emerging from cryosleep are as follows. (1.) Locate and rectify the source of electrical failure. Initialize facility reactor and/or secondary solar arrays. (2.) Locate and repair fault in Atmospherics air supply system. (3.) Evaluate extent of damages to facility. (4.) Contact facility Administrator as soon as possible to inform Command."

//Bridge Papers.

/obj/item/paper/cryo_lost_station_/bridge_warning //A gentle discouragement from mindlessly triggering the distress beacon every round, unless the ghost roles are committing to taking their station back
	name = "Distress Beacon - A Warning"
	info = "The station is lost. Whatever electrical failure that allowed for the containment breach in Science has also left our communication systems down. I cannot get any faxes out, I cannot get the beacon to trigger, I cannot get anyone else into the cryo-stasis system because the pods have locked for some reason, and I cannot reset our IFF tags because the fucking thing has factory reset itself again. Half of the crew are dead or dying and I cannot even call for help. If anyone somehow finds their way here, do not bother with the distress beacon, unless you are somehow convinced you can fight for this place back. Just book it to Cargo and pray they have a shuttle left that can get you off this place."

//Cargo Papers. Vary depending on which shuttle spawns.

/obj/item/paper/cryo_lost_station_/cargo_diary_1
	name = "Personal Log #1"
	info = "Our active Security force are dead. So is everyone that was in Service after the containment breach. I turned my radio off for a while, I could not bear the screaming and crying any longer. Horrible to say, right? I don't know what to do though. Anyone that was by Cargo when shit hit the fan we let inside and locked the front down. Whatever is left of Engineering did the same I heard. Not like there were many left after one of them locked the Service doors though. Fuckers. Going to see if I can find anything that might work as bedding in a pinch, got a few scared people and it looks like we are in for a long night."

/obj/item/paper/cryo_lost_station_/cargo_diary_2_mining_shuttle //Mining shuttle only
	name = "Personal Log #2"
	info = "Power has started to go out across the station. Have not heard so much as a whisper from Engineering, not sure if they died or what, but no one is maintaining the electricals anymore. Luckily we had a portable generator in the warehouse, so we are just managing to keep the lights on in Cargo. The Miners are a blessing, still going out on digs to bring stuff back. Graphite is keeping the generator running, and the metals are keeping something going into the Cargo account when we export it on the automated shuttle. I wish we could all just get on that thing, but it refuses to depart with anyone on board. At least we can keep ordering food and water, but this surely is not sustainable."

/obj/item/paper/cryo_lost_station_/cargo_diary_3_mining_shuttle //Mining shuttle only
	name = "Personal Log #3"
	info = "Fuck. The mining crew thought they could find a work-around for the automated delivery shuttle safeties so they could manually fly us all out of here. The mining shuttle is only rated for subspace travel, so they were not accounting for the fucking warp drive in that thing. I told them it was a shit idea, but people were desperate and almost everyone piled on. Last thing I saw was the whole thing disappear in this horrible flash of light. I have tried calling the shuttle back about a hundred times over the last day and it wont return. Now we have no more way to get food or fuel for the generator."

/obj/item/paper/cryo_lost_station_/cargo_diary_2_delivery_shuttle //Delivery shuttle only
	name = "Personal Log #2"
	info = "Power has started to go out across the station. Have not heard so much as a whisper from Engineering, not sure if they died or what, but no one is maintaining the electricals anymore. Luckily we had a portable generator in the warehouse, so we are just managing to keep the lights on in Cargo. The miners had the idea to go out on a dig to get some more fuel for the generator. Some people wanted to take the mining shuttle and fly out of here since it's small and not a big clunky thing like the delivery shuttle, but there are some pretty big fucking issues with that. It is only rated for subspace fight so it lacks a warp drive, and its fuel input can only handle one canister at a time - so it cannot go very far from the station before it runs out of fuel. It placated most people, but I can see how desperate everyone is getting."

/obj/item/paper/cryo_lost_station_/cargo_diary_3_delivery_shuttle //Delivery shuttle only
	name = "Personal Log #3"
	info = "Fucking hell. The mining team came back with graphite for the generator, but once they put all their gear away a group of people made a mad dash for the shuttle because they wanted to get off this station. There was a fight, somebody has their blood decorating the inside of that airlock, but they managed to steal the fucking mining shuttle. The crew did not even have the time to refuel it once they returned, so the fuckers that took it are going to be drifting without fuel in no time. What a fucking waste. The rest of us are getting by on what food was still left on the delivery shuttle, but there is not much left. Only a matter of time now."

//Science papers. Vary depending on threat.

/obj/item/paper/cryo_lost_station_/science_geist_1 //Cave Geist
	name = "Xenobiology Report #1 - Cave Geist"
	info = "I can hardly believe it, such a rare specimen! And we have the unique chance to study it! It arrived JUST this morning, the team are practically salivating at the thought of getting to study its patterns. Some of the team are creeped out, insisting that the beast is plotting our demise, that there is intelligence behind those eyes, some even claiming that it may be possessed or an avatar of evil made manifest into the physical world, but I think that all sounds like superstitious rubbish. These things are creatures of legend, and our research into them will be INVALUABLE and RENOWN."

/obj/item/paper/cryo_lost_station_/science_geist_2 //Cave Geist
	name = "Xenobiology Report #2 - Cave Geist"
	info = "Once the creature was released from its stasis and placed into a proper monitoring cell, it almost immediately became aggressive. One of our scientists barely escaped alive! Such fascinating ferocity. It made short work of the reinforced borosilicate windows of the containment pen, but fortunate for us, we came ready with a shield generator. Some of our number are afraid the shield may not hold, or that the recent electrical problems troubling the facility may present a vulnerability in containment, but I think they are being worry-worts. What a formidable creature..."

/obj/item/paper/cryo_lost_station_/science_geist_3 //Cave Geist
	name = "Xenobiology Report #3 - Cave Geist"
	info = "We have exposed the creature to reconstituted monkey cubes to see how it responds, and the results were... well, messy does not even begin to cover it. The janitor will have quite the job ahead of them when it is time to clean the containment cage. All the rest of the science team have abandoned the lab, having much less faith in the shield generators than myself. I think they are spineless, but that is fine. More credit for me. The lights flickered earlier, but the shields still held then, so there is nothing to worry about. The beast seems to have calmed much more, and appears as though it is studying myself in turn, or is merely captivated by the simple glow of the shield generators. It often looks to me, then the lights above, and then to the generators. Perhaps it understands its new position, as my test subject."

/obj/item/paper/cryo_lost_station_/science_hivebot_1 //Hivebot Beacon
	name = "Xenobiology Report #1 - SDARs"
	info = "What a novel research specimen! Our security team were able to partially disable a SDAR beacon! For the purposes of brevity, SDARs (Self-Replicating Destructive Automated Robotics) from now on will be referred to as Hivebots throughout these logs. I have never had a chance to study one of these up close, particularly not when they are still partially functional! It no longer appears capable of processing teleportation signatures for Hivebot reinforcements, and its onboard weaponry appears disabled as well. I am looking forward to analysing this device up close. At best, who knows what we may discover about bluespace and teleportation? At worst, we may discover a way to better combat these vile nuisances. Perhaps I should call the Machinist for their mechanical expertise as well."

/obj/item/paper/cryo_lost_station_/science_hivebot_2 //Hivebot Beacon
	name = "Xenobiology Report #2 - SDARs"
	info = "The Machinist seemed a lot more skeptical about assisting me with this research than I had hoped, which was disappointing, but they still agreed to assist me with making sense of its components. One would not think such hacked-together, primitive looking technology would be capable of such sophistocated bluespace calculation and teleportation, and yet here we are."

/obj/item/paper/cryo_lost_station_/science_hivebot_3 //Hivebot Beacon
	name = "Xenobiology Report #3 - SDARs"
	info = "Progress has been unfortunately slow. The Machinist is thwarting progress at every turn, insisting on an over-abundance of caution, far too much caution in my opinion. We have made a small degree of insight into how the beacon processes teleportation, but it is not much. This whole time it has been attempting to call for reinforcements, but it has been unable to actually send these signals beyond a memory buffer which has almost entirely filled up with a massive queue of jump signatures that have not finalised. The Machinist INSISTS that we should not try and restore full functionality to its transmitters, but I feel as though the data we may glean from doing so will be invaluable. When their back is turned next, I think I know what I have to do. They make splicing wires look so easy - surely it cannot be that hard?"

/obj/item/paper/cryo_lost_station_/science_greimorians_1 //Greimorian Queen
	name = "Xenobiology Report #1 - Greimorian Eggs"
	info = "How fun. Usually when we see Greimorians, it happens because of an annoying infestation crawling forth from the vents. But not this time! A visiting shuttle found a patch of unhatched eggs in their back compartment before they departed, and our Science team were quick to request if they could take them. So we did! We have prepared the eggs in our containment cell, and we are all eagerly pressed up against the glass, waiting for the chance to observe the hatching process. Security seem worried about a containment breach, as these little creatures are so infamous for always pulling off, but we have assured them we will carry this out with the utmost vigilance."

/obj/item/paper/cryo_lost_station_/science_greimorians_2 //Greimorian Queen
	name = "Xenobiology Report #2 - Greimorian Eggs"
	info = "They hatched! Oh, it was positively slimy and revolting to watch, but what an educational experience it was. Now we have a containment cell full of little purple larvae. Everyone is still eager to study their maturation process into adult forms, as we seek an understanding as to what determines their ultimate evolution, though some researchers are more wary about allowing them to grow to that age at all, citing concerns for a potential breach. For now, many fears have been calmed by reminding the team of the shield generators, but not everyone is still convinced. Luckily, I am in charge of this operation, so I say that we continue."

/obj/item/paper/cryo_lost_station_/science_greimorians_3 //Greimorian Queen
	name = "Xenobiology Report #3 - Greimorian Eggs"
	info = "They have all grown up! It is horrible, greimorians are such vile, aggressive, unsettling creatures, but this is priceless research material. The shield generators are holding stong, even if the borosilicate windows did eventually cave in to a prolonged assault from the purple warrior forms. Some researchers insist we should incinerate them now, citing concerns over the recent power troubles potentially causing the shields to fail, but they remained strong when the lights flickered earlier, so I am satisfied with their reliability. Sadly we were not able to glean much insight into their maturation process, so I am directing the researchers to provide sustenance to the Worker forms for the production of more eggs."

/obj/item/paper/cryo_lost_station_/science_carp_1 //Carp Shoal
	name = "Geology Report #1 - Captured Asteroid"
	info = "Today we received an asteroid sample! We have never had a chance to have something so large brought straight to us, but it is so exciting. It has taken a monumental combined effort from Engineering, Mining, and Science, but we've constructed a temporary scaffolding tethered to the station to keep the asteroid from drifting away while our teams work on excavation. Usually our teams have to hitch a ride with Mining for something like this, so we are super excited to not have to share a workspace with those brutes anymore."

/obj/item/paper/cryo_lost_station_/science_carp_2 //Carp Shoal
	name = "Geology Report #2 - Captured Asteroid"
	info = "Astounding, this whole thing is like a gigantic geode, almost entirely sealed from the outside. Our preliminary scans have suggested that it's rich in mineral resources, but our research team is more interested in studying and excavating everything they can about it first. If there are precious metals to be found, I suppose Mining can have the husk once we finish with it. For now, we have begun excavation at a painstakingly slow pace as to not potentially break any samples."

/obj/item/paper/cryo_lost_station_/science_carp_3 //Carp Shoal
	name = "Geology Report #3 - Captured Asteroid"
	info = "Our drills are almost through the asteroid outer shell. Myself and some other researchers keep thinking that we can hear some kind of knocking from inside, but it is probably just equipment error. Samples from the rock that we have already taken indicate potentially anomalous objects on the inside which are of incredible interest to our archaeology crew. We are also picking up traces of Phoron in the rock, so we have the Mining team breathing down our neck, practically salivating with excitement. As a result, we have been encouraged to work a little faster. I would rather take this slow and steady, but Command are becomming insistent."
