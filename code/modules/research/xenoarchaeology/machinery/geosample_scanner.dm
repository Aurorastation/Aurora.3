// Continuous-stress radiation loop tuning. See `process()` block for the full rationale.
#define RC_RAD_MAX           50      // hard cap on emission power
#define RC_RAD_RAMP_NORMAL   1       // severity added per second while shield is down (no spike)
#define RC_RAD_RAMP_SPIKE    10      // severity added per second while shield is down during a radspike
#define RC_RAD_DECAY_RATE    25      // severity removed per second while shield is up (or after spike ends)
#define RC_SPIKE_INTERVAL_LO 15      // seconds between spike events (lower bound)
#define RC_SPIKE_INTERVAL_HI 25      // seconds between spike events (upper bound)
#define RC_SPIKE_DURATION_LO 5       // seconds a single spike lasts (lower bound)
#define RC_SPIKE_DURATION_HI 7       // seconds a single spike lasts (upper bound)

/obj/structure/machinery/radiocarbon_spectrometer
	name = "radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "spectrometer"

	idle_power_usage = 20
	active_power_usage = 300

	//var/obj/item/reagent_containers/glass/coolant_container
	var/scanning = FALSE
	var/report_num = 0
	//
	var/obj/item/scanned_item
	var/last_scan_data = "No scans on record."
	//
	var/last_process_worldtime = 0
	//
	var/scanner_progress = 0
	var/scanner_rate = 1.25			//80 seconds per scan
	var/scanner_rpm = 0
	var/scanner_rpm_dir = 1
	var/scanner_temperature = 0
	var/scanner_seal_integrity = 100
	//
	var/coolant_usage_rate = 0		//measured in u/microsec
	var/fresh_coolant = 0
	var/coolant_purity = 0
	var/datum/reagents/coolant_reagents
	var/used_coolant = 0
	var/list/coolant_reagents_purity = list()
	//
	var/maser_wavelength = 0
	var/optimal_wavelength = 0
	var/optimal_wavelength_target = 0
	var/tleft_retarget_optimal_wavelength = 0
	var/maser_efficiency = 0
	//
	/// Current emission power being pushed into SSradiation. Climbs while the shield is down,
	/// decays while it is up. Capped to RC_RAD_MAX so even RAD_SHIELDED suits keep meaningful
	/// mitigation at adjacency (over the cap, the armor_pen formula in /mob/living/rad_act
	/// starts overwhelming the suit's RAD value).
	var/radiation_emission = 0
	/// TRUE while a radspike event is currently active. Increases the shield-down ramp rate
	/// from RC_RAD_RAMP_NORMAL to RC_RAD_RAMP_SPIKE.
	var/spike_active = FALSE
	/// Seconds remaining in the current spike event. Used and decremented only while
	/// `spike_active` is TRUE.
	var/spike_remaining = 0
	/// Seconds until the next spike event begins. Counted down only while `spike_active`
	/// is FALSE; reaches 0 → flips spike_active TRUE.
	var/t_to_next_spike = 0
	var/rad_shield = FALSE

/obj/structure/machinery/radiocarbon_spectrometer/Initialize()
	. = ..()
	create_reagents(500)
	coolant_reagents_purity[/singleton/reagent/water] = 0.5
	coolant_reagents_purity[/singleton/reagent/drink/coffee/icecoffee] = 0.6
	coolant_reagents_purity[/singleton/reagent/drink/icetea] = 0.6
	coolant_reagents_purity[/singleton/reagent/drink/milkshake] = 0.6
	coolant_reagents_purity[/singleton/reagent/leporazine] = 0.7
	coolant_reagents_purity[/singleton/reagent/kelotane] = 0.7
	coolant_reagents_purity[/singleton/reagent/sterilizine] = 0.7
	coolant_reagents_purity[/singleton/reagent/dermaline] = 0.7
	coolant_reagents_purity[/singleton/reagent/hyperzine] = 0.8
	coolant_reagents_purity[/singleton/reagent/cryoxadone] = 0.9
	coolant_reagents_purity[/singleton/reagent/coolant] = 1
	coolant_reagents_purity[/singleton/reagent/adminordrazine] = 2

/obj/structure/machinery/radiocarbon_spectrometer/attack_hand(mob/user)
	ui_interact(user)

/obj/structure/machinery/radiocarbon_spectrometer/attackby(obj/item/attacking_item, mob/user)
	if(scanning)
		to_chat(user, SPAN_WARNING("You can't do that while [src] is scanning!"))
	else
		if(istype(attacking_item, /obj/item/stack/nanopaste))
			var/choice = alert("What do you want to do with the nanopaste?","Radiometric Scanner","Scan nanopaste","Fix seal integrity")
			if(choice == "Fix seal integrity")
				var/obj/item/stack/nanopaste/nanopaste_stack = attacking_item
				var/amount_used = min(nanopaste_stack.get_amount(), 10 - scanner_seal_integrity / 10)
				nanopaste_stack.use(amount_used)
				scanner_seal_integrity = round(scanner_seal_integrity + amount_used * 10)
				return
		if(istype(attacking_item, /obj/item/reagent_containers/glass))
			var/choice = alert("What do you want to do with the container?","Radiometric Scanner","Add coolant","Empty coolant","Scan container")
			if(choice == "Add coolant")
				var/obj/item/reagent_containers/glass/glass_container = attacking_item
				var/amount_transferred = min(src.reagents.maximum_volume - src.reagents.total_volume, glass_container.reagents.total_volume)
				glass_container.reagents.trans_to(src, amount_transferred)
				to_chat(user, "<span class='info'>You empty [amount_transferred]u of coolant into [src].</span>")
				update_coolant()
				return
			else if(choice == "Empty coolant")
				var/obj/item/reagent_containers/glass/glass_container = attacking_item
				var/amount_transferred = min(glass_container.reagents.maximum_volume - glass_container.reagents.total_volume, src.reagents.total_volume)
				src.reagents.trans_to(glass_container, amount_transferred)
				to_chat(user, "<span class='info'>You remove [amount_transferred]u of coolant from [src].</span>")
				update_coolant()
				return
		if(scanned_item)
			to_chat(user, "<span class=warning>\The [src] already has \a [scanned_item] inside!</span>")
			return
		user.drop_from_inventory(attacking_item, src)
		scanned_item = attacking_item
		to_chat(user, "<span class=notice>You put \the [attacking_item] into \the [src].</span>")

/obj/structure/machinery/radiocarbon_spectrometer/proc/update_coolant()
	var/total_purity = 0
	fresh_coolant = 0
	coolant_purity = 0
	for(var/reagent_type in reagents.reagent_volumes)
		var/singleton/reagent/reagent = GET_SINGLETON(reagent_type)
		if(!reagent)
			continue
		var/purity_value = coolant_reagents_purity[reagent_type]
		if(!purity_value)
			purity_value = 0.1
		else if(purity_value > 1)
			purity_value = 1
		total_purity += purity_value * REAGENT_VOLUME(reagents, reagent_type)
		fresh_coolant += REAGENT_VOLUME(reagents, reagent_type)
	if(total_purity && fresh_coolant)
		coolant_purity = total_purity / fresh_coolant

/obj/structure/machinery/radiocarbon_spectrometer/ui_interact(mob/user, datum/tgui/ui)
	if(user.stat)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeoScanner", "High Res Radiocarbon Spectrometer")
		ui.open()

/obj/structure/machinery/radiocarbon_spectrometer/ui_data(mob/user)
	return list(
		"scanned_item" = scanned_item ? scanned_item.name : "",
		"scanned_item_desc" = scanned_item ? (scanned_item.desc ? scanned_item.desc : "No information on record.") : "",
		"last_scan_data" = last_scan_data,
		"scan_progress" = round(scanner_progress),
		"scanning" = scanning,
		"scanner_seal_integrity" = round(scanner_seal_integrity),
		"scanner_rpm" = round(scanner_rpm),
		"scanner_temperature" = round(scanner_temperature),
		"coolant_usage_rate" = coolant_usage_rate,
		"unused_coolant_abs" = round(fresh_coolant),
		"unused_coolant_per" = round(fresh_coolant / reagents.maximum_volume * 100),
		"coolant_purity" = round(coolant_purity * 100),
		"optimal_wavelength" = round(optimal_wavelength),
		"maser_wavelength" = round(maser_wavelength),
		"maser_efficiency" = round(maser_efficiency * 100),
		"radiation_emission" = round(radiation_emission),
		"radiation_max" = RC_RAD_MAX,
		"spike_active" = spike_active,
		"t_to_next_spike" = round(t_to_next_spike),
		"rad_shield_on" = rad_shield
	)

/obj/structure/machinery/radiocarbon_spectrometer/process()
	if(scanning)
		if(!scanned_item || scanned_item.loc != src)
			scanned_item = null
			stop_scanning()
		else if(scanner_progress >= 100)
			complete_scan()
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1

			//modify the RPM over time
			//i want 1u to last for 10 sec at 500 RPM, scaling linearly
			scanner_rpm += scanner_rpm_dir * 50 * deltaT
			if(scanner_rpm > 1000)
				scanner_rpm = 1000
				scanner_rpm_dir = -1 * pick(0.5, 2.5, 5.5)
			else if(scanner_rpm < 1)
				scanner_rpm = 1
				scanner_rpm_dir = 1 * pick(0.5, 2.5, 5.5)

			//heat up according to RPM
			//each unit of coolant
			scanner_temperature += scanner_rpm * deltaT * 0.05

			// Continuous-stress radiation loop with random spike events. Emission climbs while the
			// shield is down and decays when it is raised. RC_RAD_RAMP_NORMAL is the baseline rate;
			// during a spike the rate switches to RC_RAD_RAMP_SPIKE, fast enough that letting it run
			// 5+ seconds will saturate to the cap. Spike events fire on a randomised interval so the
			// player has to actually watch the meter / geiger rather than memorise a tempo. The cap
			// (RC_RAD_MAX) is set just below where /mob/living/rad_act's armor_pen formula starts
			// overwhelming RAD_SHIELDED suits, so the anomaly suit (RAD=100) still grants meaningful
			// mitigation at adjacency even at the worst case.
			if(spike_active)
				spike_remaining -= deltaT
				if(spike_remaining <= 0)
					spike_active = FALSE
					t_to_next_spike = rand(RC_SPIKE_INTERVAL_LO, RC_SPIKE_INTERVAL_HI)
			else
				t_to_next_spike -= deltaT
				if(t_to_next_spike <= 0)
					spike_active = TRUE
					spike_remaining = rand(RC_SPIKE_DURATION_LO, RC_SPIKE_DURATION_HI)

			if(rad_shield)
				radiation_emission = max(radiation_emission - RC_RAD_DECAY_RATE * deltaT, 0)
			else
				var/ramp = spike_active ? RC_RAD_RAMP_SPIKE : RC_RAD_RAMP_NORMAL
				radiation_emission = min(radiation_emission + ramp * deltaT, RC_RAD_MAX)
				if(radiation_emission > 0)
					SSradiation.radiate(src, radiation_emission)

			//use some coolant to cool down
			if(coolant_usage_rate > 0)
				var/coolant_used = min(fresh_coolant, coolant_usage_rate * deltaT)
				if(coolant_used > 0)
					fresh_coolant -= coolant_used
					used_coolant += coolant_used
					scanner_temperature = max(scanner_temperature - coolant_used * coolant_purity * 20, 0)

			//modify the optimal wavelength
			tleft_retarget_optimal_wavelength -= deltaT
			if(tleft_retarget_optimal_wavelength <= 0)
				tleft_retarget_optimal_wavelength = pick(4,8,15)
				optimal_wavelength_target = rand() * 9900 + 100
			//
			if(optimal_wavelength < optimal_wavelength_target)
				optimal_wavelength = min(optimal_wavelength + 700 * deltaT, optimal_wavelength_target)
			else if(optimal_wavelength > optimal_wavelength_target)
				optimal_wavelength = max(optimal_wavelength - 700 * deltaT, optimal_wavelength_target)
			//
			maser_efficiency = 1 - max(min(10000, abs(optimal_wavelength - maser_wavelength) * 3), 1) / 10000

			//make some scan progress
			if(!rad_shield)
				scanner_progress = min(100, scanner_progress + scanner_rate * maser_efficiency * deltaT)

				//degrade the seal over time according to temperature
				//i want temperature of 50K to degrade at 1%/sec
				scanner_seal_integrity -= (max(scanner_temperature, 1) / 1000) * deltaT

			//emergency stop if seal integrity reaches 0
			if(scanner_seal_integrity <= 0 || (scanner_temperature >= 1273 && !rad_shield))
				stop_scanning()
				visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] buzzes unhappily. It has failed mid-scan!"), range = 2)

			if(prob(5))
				visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [pick("whirrs","chuffs","clicks")][pick(" excitedly"," energetically"," busily")]."), range = 2)
	else
		//gradually cool down over time
		if(scanner_temperature > 0)
			scanner_temperature = max(scanner_temperature - 5 - 10 * rand(), 0)
		if(prob(0.75))
			visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [pick("plinks","hisses")][pick(" quietly"," softly"," sadly"," plaintively")]."), range = 2)
	last_process_worldtime = world.time

/obj/structure/machinery/radiocarbon_spectrometer/proc/stop_scanning()
	scanning = FALSE
	scanner_rpm_dir = 1
	scanner_rpm = 0
	optimal_wavelength = 0
	maser_efficiency = 0
	maser_wavelength = 0
	coolant_usage_rate = 0
	radiation_emission = 0
	spike_active = FALSE
	spike_remaining = 0
	t_to_next_spike = 0
	if(used_coolant)
		src.reagents.remove_any(used_coolant)
		used_coolant = 0

/obj/structure/machinery/radiocarbon_spectrometer/proc/complete_scan()
	visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] makes an insistent chime."), range = 2)

	if(scanned_item)
		//create report
		var/obj/item/paper/report_paper = new(src)
		report_paper.name = "[src] report #[++report_num]: [scanned_item.name]"
		report_paper.stamped = list(/obj/item/stamp)
		report_paper.overlays = list("paper_stamped")

		//work out data
		var/data = " - Mundane object: [scanned_item.desc ? scanned_item.desc : "No information on record."]<br>"
		var/datum/geosample/geosample_data
		switch(scanned_item.type)
			if(/obj/item/ore)
				var/obj/item/ore/ore_item = scanned_item
				if(ore_item.geologic_data)
					geosample_data = ore_item.geologic_data

			if(/obj/item/rocksliver)
				var/obj/item/rocksliver/rock_sliver = scanned_item
				if(rock_sliver.geologic_data)
					geosample_data = rock_sliver.geologic_data

			if(/obj/item/archaeological_find)
				data = " - Mundane object (archaic xenos origins)<br>"

				var/obj/item/archaeological_find/arch_find = scanned_item
				if(arch_find.talking_atom)
					data = " - Exhibits properties consistent with sonic reproduction and audio capture technologies.<br>"

		var/anom_found = FALSE
		if(geosample_data)
			data = " - Spectometric analysis on mineral sample has determined type [GLOB.finds_as_strings[GLOB.responsive_carriers.Find(geosample_data.source_mineral)]]<br>"
			if(geosample_data.age_billion > 0)
				data += " - Radiometric dating shows age of [geosample_data.age_billion].[geosample_data.age_million] billion years<br>"
			else if(geosample_data.age_million > 0)
				data += " - Radiometric dating shows age of [geosample_data.age_million].[geosample_data.age_thousand] million years<br>"
			else
				data += " - Radiometric dating shows age of [geosample_data.age_thousand * 1000 + geosample_data.age] years<br>"
			data += " - Chromatographic analysis shows the following materials present:<br>"
			for(var/carrier in geosample_data.find_presence)
				if(geosample_data.find_presence[carrier])
					var/index = GLOB.responsive_carriers.Find(carrier)
					if(index > 0 && index <= GLOB.finds_as_strings.len)
						data += "	> [100 * geosample_data.find_presence[carrier]]% [GLOB.finds_as_strings[index]]<br>"

			if(geosample_data.artifact_id && geosample_data.artifact_distance >= 0)
				anom_found = TRUE
				data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [geosample_data.artifact_id]<br>"
				data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of [geosample_data.artifact_distance]m<br>"

		if(!anom_found)
			data += " - No anomalous data<br>"

		report_paper.info = "<b>[src] analysis report #[report_num]</b><br>"
		report_paper.info += "<b>Scanned item:</b> [scanned_item.name]<br><br>" + data
		last_scan_data = report_paper.info
		report_paper.forceMove(src.loc)

		scanned_item.forceMove(src.loc)
		scanned_item = null

/obj/structure/machinery/radiocarbon_spectrometer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(stat & (NOPOWER|BROKEN))
		return

	switch(action)
		if("scan_item")
			if(scanning)
				stop_scanning()
			else
				if(scanned_item)
					if(scanner_seal_integrity > 0)
						scanner_progress = 0
						scanning = TRUE
						t_to_next_spike = rand(RC_SPIKE_INTERVAL_LO, RC_SPIKE_INTERVAL_HI)
						to_chat(usr, SPAN_NOTICE("Scan initiated."))
					else
						to_chat(usr, SPAN_WARNING("Could not initiate scan, seal requires replacing."))
				else
					to_chat(usr, SPAN_WARNING("Insert an item to scan."))
			return TRUE

		if("maser_wavelength")
			maser_wavelength = clamp(maser_wavelength + 1000 * text2num(params["delta"]), 1, 10000)
			return TRUE

		if("coolant_rate")
			coolant_usage_rate = clamp(coolant_usage_rate + text2num(params["delta"]), 0, 10000)
			return TRUE

		if("toggle_rad_shield")
			rad_shield = !rad_shield
			return TRUE

		if("eject_item")
			if(scanned_item)
				scanned_item.forceMove(src.loc)
				scanned_item = null
			return TRUE

#undef RC_RAD_MAX
#undef RC_RAD_RAMP_NORMAL
#undef RC_RAD_RAMP_SPIKE
#undef RC_RAD_DECAY_RATE
#undef RC_SPIKE_INTERVAL_LO
#undef RC_SPIKE_INTERVAL_HI
#undef RC_SPIKE_DURATION_LO
#undef RC_SPIKE_DURATION_HI
