/*
	Sampling
*/
/obj/item/sampler
	name = "science sampler"
	desc = "A multi-purpose sampling device designed by Zeng-Hu Pharmaceuticals for gathering samples during their research expeditions."
	desc_extended = "The \"Chimera\" model field sampling device was developed by Zeng-Hu Pharmaceuticals in the 2450s to make allow their \
					researchers to take a variety of samples, ranging from plant and animal tissue to soil or water samples, compacted into \
					a single handheld device. It became widely popular even among rival corporations and independant research groups, with \
					its versatility and compact nature making it the tool-of-choice for almost every modern scientific expedition."
	icon = 'icons/obj/item/sampling.dmi'
	icon_state = "sampler"
	item_state = "sampler"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_SMALL
	/**
	 * Which attachment we are using
	 */
	var/attachment = SAMPLE_BIO
	/**
	 * The vial we load our sample into
	 */
	var/obj/item/reagent_containers/glass/beaker/vial/vial

/obj/item/sampler/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It has attachments allowing for sampling of biological tissue, surface soil and water sources. Must be loaded with a vial. Alt-click to cycle between attachments."

/obj/item/sampler/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/item/sampler/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/reagent_containers/glass/beaker/vial))
		if(!vial)
			to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]."))
			vial = attacking_item
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(vial)
			vial.forceMove(src)
			update_icon()
			return TRUE
		to_chat(user, SPAN_NOTICE("\The [src] already has a vial inserted."))
	return ..()

/obj/item/sampler/attack_hand(mob/user)
	if(vial)
		to_chat(user, SPAN_NOTICE("You remove \the [vial] from \the [src]."))
		user.put_in_active_hand(vial)
		vial = null
		update_icon()
		return TRUE
	return ..()

/obj/item/sampler/AltClick(mob/user)
	attachment = next_in_list(attachment, ALL_SAMPLE_ATTACHMENTS)
	to_chat(user, SPAN_NOTICE("You switch \the [src] to its [attachment] attachment."))
	update_icon()

/obj/item/sampler/update_icon()
	. = ..()
	ClearOverlays()
	if(vial)
		icon_state = "[initial(icon_state)]_loaded"
		if(vial.reagents.total_volume)
			AddOverlays(overlay_image(icon, "sampler_full"))
	else
		icon_state = initial(icon_state)
	var/image/I
	switch(attachment)
		if(SAMPLE_BIO)
			I = overlay_image(icon, "bio_attachment")
		if(SAMPLE_SOIL)
			I = overlay_image(icon, "soil_attachment")
		if(SAMPLE_WATER)
			I = overlay_image(icon, "water_attachment")
	if(I)
		AddOverlays(I)

/obj/item/sampler/attack(mob/living/target_mob, mob/living/user, target_zone)
	if(!vial || vial.reagents.total_volume)
		return ..()
	else
		return FALSE

/obj/item/sampler/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!vial || vial.reagents.total_volume)
		return ..()
	if(try_sample(target, user))
		to_chat(user, SPAN_NOTICE("\The [src]'s attachment whirrs as it samples \the [target]."))
	else
		to_chat(user, SPAN_NOTICE("\The [src]'s attachment buzzes as it fails to sample \the [target]. Maybe try another attachment?"))

/**
 * Tries to sample the target using our current attachment, loading a sample into our vial if successful.
 */
/obj/item/sampler/proc/try_sample(atom/target, mob/user)
	switch(attachment)
		if(SAMPLE_BIO)
			if(istype(target, /mob/living/simple_animal))
				var/mob/living/simple_animal/fauna = target
				if(!fauna.sample_data)
					return FALSE
				vial.reagents.add_reagent(/singleton/reagent/biological_tissue, 10, fauna.sample_data)
				return TRUE
			if(istype(target, /obj/structure/flora))
				var/obj/structure/flora/flora = target
				if(flora.is_rock)
					return FALSE
				vial.reagents.add_reagent(/singleton/reagent/biological_tissue, 10, flora.sample_data)
				return TRUE
		if(SAMPLE_SOIL)
			if(istype(target, /obj/structure/flora))
				var/obj/structure/flora/rock = target
				if(!rock.is_rock)
					return FALSE
				vial.reagents.add_reagent(/singleton/reagent/soil, 10, rock.sample_data)
				return TRUE
			if(istype(target, /turf/simulated/floor/exoplanet))
				var/turf/simulated/floor/exoplanet/ground = target
				var/obj/effect/overmap/visitable/sector/planet = GLOB.map_sectors["[target.z]"]
				if(istype(ground, /turf/simulated/floor/exoplanet/water) || !ground.has_resources || !istype(planet))
					return FALSE
				var/list/possible_data = planet.soil_data.Copy()
				var/list/data = list()
				for(var/_ in 1 to rand(2,4))
					var/d = pick(possible_data)
					possible_data -= d
					data += d
				vial.reagents.add_reagent(/singleton/reagent/soil, 10, data)
				return TRUE
		if(SAMPLE_WATER)
			if(istype(target, /turf/simulated/floor/exoplanet/water))
				var/obj/effect/overmap/visitable/sector/planet = GLOB.map_sectors["[target.z]"]
				if(!istype(planet))
					return FALSE
				var/list/possible_data = planet.water_data.Copy()
				var/list/data = list()
				for(var/_ in 1 to rand(2,4))
					var/d = pick(possible_data)
					possible_data -= d
					data += d
				vial.reagents.add_reagent(/singleton/reagent/water, 10, data)
				return TRUE

/obj/machinery/microscope/science
	name = "compound microscope"
	desc = "A less-than-state-of-the-art means of examining tiny samples. At least it has a printer for recording its results."
	icon = 'icons/obj/item/sampling.dmi'
	density = FALSE
	allowed_analysis = MICROSCOPE_CELLS

/obj/machinery/centrifuge
	name = "centrifuge"
	desc = "A device capable of spinning samples at 1000 RPM, to separate their components for analysis. It has a printer attached to record its results."
	icon = 'icons/obj/item/sampling.dmi'
	icon_state = "centrifuge_0"
	anchored = TRUE
	density = FALSE

	/**
	 * The sample vials loaded in this centrifuge
	 */
	var/list/obj/item/reagent_containers/glass/beaker/vial/samples = list()
	/**
	 * The report number of our last report
	 */
	var/report_num = 0

/obj/machinery/centrifuge/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	update_icon()

/obj/machinery/centrifuge/attackby(obj/item/attacking_item, mob/user)

	if(LAZYLEN(samples) >= 4)
		to_chat(user, SPAN_WARNING("\The [src] is already full with samples."))
		return

	if(istype(attacking_item, /obj/item/reagent_containers/glass/beaker/vial))
		to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]."))
		user.unEquip(attacking_item)
		attacking_item.forceMove(src)
		samples += attacking_item
		update_icon()
		return

/obj/machinery/centrifuge/attack_hand(mob/user)

	if(!LAZYLEN(samples))
		to_chat(user, SPAN_WARNING("\The [src] has no samples to examine."))
		return

	if(LAZYLEN(samples) == 1 || LAZYLEN(samples) == 3) //Odd number, unbalanced
		to_chat(user, SPAN_WARNING("\The [src] is unbalanced. Try adding blank samples as counter-weights."))
		return

	to_chat(user, SPAN_NOTICE("\The [src] begins to spin, separating the contents of the samples."))

	icon_state = "centrifuge_working"
	addtimer(CALLBACK(src, PROC_REF(process_samples)), 30 SECONDS)

/obj/machinery/centrifuge/proc/process_samples()
	update_icon()
	visible_message(SPAN_NOTICE("\The [src] prints out a report of its findings."))
	var/obj/item/paper/report = new()

	report_num++
	var/pname = "Centrifuge report #[report_num]"
	var/info = "<b><font size=\"4\">Centrifugal analysis report #[report_num]</font></b><HR>"
	var/sample = 1
	for(var/obj/item/reagent_containers/glass/beaker/vial/V in samples)
		var/list/soil = REAGENT_DATA(V.reagents, /singleton/reagent/soil)
		if(soil)
			info += "Separation of sample [sample] has revealed the following characteristics<ul>"
			for(var/characteristic in soil)
				info += "<li>[characteristic]</li>"
			info += "</ul>"
		else
			info += "<li>No soil or dust found in sample [sample].</li>"
		sample++

	report.set_content_unsafe(pname, info)

	if(report)
		report.update_icon()
	print(report)

/**
 * Removes the last sample from the centrifuge
 */
/obj/machinery/centrifuge/proc/remove_sample(mob/living/remover)
	if(!istype(remover) || remover.incapacitated() || !Adjacent(remover))
		return
	if(!LAZYLEN(samples))
		to_chat(remover, SPAN_WARNING("\The [src] does not have a sample in it."))
		return
	var/obj/item/reagent_containers/glass/beaker/vial/sample = samples[LAZYLEN(samples)]
	to_chat(remover, SPAN_NOTICE("You remove \the [sample] from \the [src]."))
	sample.forceMove(get_turf(src))
	remover.put_in_hands(sample)
	samples -= sample
	update_icon()

/obj/machinery/centrifuge/AltClick()
	remove_sample(usr)

/obj/machinery/centrifuge/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(user == over)
		remove_sample(user)
	else
		return ..()

/obj/machinery/centrifuge/update_icon()
	. = ..()
	icon_state = "centrifuge_[LAZYLEN(samples)]"

/obj/machinery/spectrophotometer
	name = "spectrophotometer"
	desc = "A device to analyse liquid samples by shining various frequencies of light through and measuring absorption. It has a printer attached to record its results."
	icon = 'icons/obj/item/sampling.dmi'
	icon_state = "spectrophotometer_closed_empty"
	anchored = TRUE
	density = TRUE

	/**
	 * The sample vial to analyse
	 */
	var/obj/item/reagent_containers/glass/beaker/vial/sample
	/**
	 * The report number of our last report
	 */
	var/report_num = 0
	/**
	 * Whether this spectrophotometer has been calibrated already.
	 * Must be done with pure water
	 */
	var/zeroed = FALSE
	/**
	 * Whether the hatch is open, allowing samples to be added/removed
	 */
	var/open = FALSE

/obj/machinery/spectrophotometer/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	update_icon()

/obj/machinery/spectrophotometer/attackby(obj/item/attacking_item, mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("\The [src] is closed."))
		return

	if(sample)
		to_chat(user, SPAN_WARNING("\The [src] already has a sample."))
		return

	if(istype(attacking_item, /obj/item/reagent_containers/glass/beaker/vial))
		to_chat(user, SPAN_NOTICE("You insert \the [attacking_item] into \the [src]."))
		user.unEquip(attacking_item)
		attacking_item.forceMove(src)
		sample = attacking_item
		update_icon()
		return

/obj/machinery/spectrophotometer/attack_hand(mob/user)
	if(open)
		if(!sample)
			to_chat(user, SPAN_WARNING("\The [src] has no samples to remove."))
			return
		to_chat(user, SPAN_NOTICE("You remove \the [sample] from \the [src]."))
		sample.forceMove(get_turf(src))
		user.put_in_hands(sample)
		sample = null
		update_icon()
		return

	if(!sample)
		to_chat(user, SPAN_WARNING("\The [src] has no sample to examine."))
		return

	if(!REAGENT_VOLUME(sample.reagents, /singleton/reagent/water))
		to_chat(user, SPAN_WARNING("\The [src] can only examine water samples."))
		return

	if(!zeroed && REAGENT_DATA(sample.reagents, /singleton/reagent/water))
		to_chat(user, SPAN_WARNING("\The [src] has not yet been calibrated. Try zeroing it with a blank sample."))
		return

	to_chat(user, SPAN_NOTICE("\The [src] begins to glow, shining light through its sample."))

	icon_state = "spectrophotometer_working"
	addtimer(CALLBACK(src, PROC_REF(process_sample)), 15 SECONDS)

/**
 * Prints a report of the analysis after finishing, or zeroes successfully
 */
/obj/machinery/spectrophotometer/proc/process_sample()
	update_icon()
	if(!zeroed)
		zeroed = TRUE
		visible_message(SPAN_NOTICE("\The [src] beeps, \"Calibration complete!\""))
		return

	visible_message(SPAN_NOTICE("\The [src] prints out a report of its findings."))
	var/obj/item/paper/report = new()

	report_num++
	var/pname = "Spectrophotometer report #[report_num]"
	var/info = "<b><font size=\"4\">Spectrophotometry anaylsis report #[report_num]</font></b><HR>"
	var/list/water = REAGENT_DATA(sample.reagents, /singleton/reagent/water)
	if(water)
		info += "Absorption spectra of [src] have revealed the following electrolytes present<ul>"
		for(var/characteristic in water)
			info += "<li>[characteristic]</li>"
		info += "</ul>"
	else
		info += "Absorption spectra of [src] match those of pure water."

	report.set_content_unsafe(pname, info)

	if(report)
		report.update_icon()
	print(report)

/obj/machinery/spectrophotometer/AltClick()
	open = !open
	update_icon()

/obj/machinery/spectrophotometer/update_icon()
	. = ..()
	icon_state = "spectrophotometer_[open ? "open" : "closed"]_[sample ? "full" : "empty"]"
