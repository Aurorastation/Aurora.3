//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into this type for easy identification and shared procs.

/obj/structure/machinery/r_n_d
	name = "R&D device"
	icon = 'icons/obj/machinery/research.dmi'
	density = TRUE
	anchored = TRUE
	var/busy = 0
	var/obj/structure/machinery/computer/rdconsole/linked_console

/obj/structure/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/structure/machinery/r_n_d/proc/getMaterialType(var/name)
	return SSmaterials.material_stack_type(name)

/obj/structure/machinery/r_n_d/fabricator
	/// The design build flag accepted by this machine.
	var/build_type

	/// Whether this machine checks and consumes design chemicals.
	var/uses_reagents = FALSE

	/// Whether completed products are placed one tile in front of the machine.
	var/product_offset = FALSE

	/// Material cost multiplier.
	var/mat_efficiency = 1

	/// Fabrication speed multiplier.
	var/production_speed = 1

	/// Job currently assigned by the research console.
	var/datum/research_fabrication_job/assigned_job

	/// Design currently being fabricated.
	var/datum/design/current_design

	/// Timer ID for the active fabrication.
	var/build_callback_timer

	/// Looping-sound datum selected by this machine type.
	var/fabrication_loop_type

	/// Active looping-sound controller for this machine.
	var/datum/looping_sound/fabrication_loop

	/// Whether this fabricator's construction loop is currently playing.
	var/fabrication_audio_playing = FALSE

/obj/structure/machinery/r_n_d/fabricator/Initialize(mapload, d, populate_components, is_internal)
	. = ..()

	if(fabrication_loop_type)
		fabrication_loop = new fabrication_loop_type(src)

/obj/structure/machinery/r_n_d/fabricator/proc/start_fabrication_audio()
	if(!fabrication_loop || fabrication_audio_playing)
		return

	fabrication_loop.start()
	fabrication_audio_playing = TRUE

/obj/structure/machinery/r_n_d/fabricator/proc/stop_fabrication_audio()
	if(!fabrication_loop || !fabrication_audio_playing)
		return

	fabrication_loop.stop()
	fabrication_audio_playing = FALSE

/obj/structure/machinery/r_n_d/fabricator/power_change()
	. = ..()
	if((stat & NOPOWER) && build_callback_timer)
		if(build_callback_timer)
			deltimer(build_callback_timer)
		pause_console_job()

/obj/structure/machinery/r_n_d/fabricator/proc/is_available()
	return !assigned_job && !build_callback_timer && !(stat & (NOPOWER | BROKEN)) && !panel_open

/obj/structure/machinery/r_n_d/fabricator/proc/get_material_silo()
	return linked_console?.linked_silo

/obj/structure/machinery/r_n_d/fabricator/proc/get_required_material_amount(datum/design/design_to_check, material_id)
	return round(design_to_check.materials[material_id] * mat_efficiency)

/obj/structure/machinery/r_n_d/fabricator/proc/get_required_reagent_amount(datum/design/design_to_check, reagent_id)
	return round(design_to_check.chemicals[reagent_id] * mat_efficiency)

/obj/structure/machinery/r_n_d/fabricator/proc/has_required_materials(datum/design/design_to_check)
	if(!design_to_check)
		return FALSE

	var/obj/structure/machinery/r_n_d/material_silo/silo = get_material_silo()
	if(!silo)
		return FALSE

	for(var/material_id in design_to_check.materials)
		if(!silo.has_material(material_id, get_required_material_amount(design_to_check, material_id)))
			return FALSE

	return TRUE

/obj/structure/machinery/r_n_d/fabricator/proc/has_required_reagents(datum/design/design_to_check)
	if(!design_to_check)
		return FALSE
	if(!uses_reagents)
		return TRUE

	for(var/reagent_id in design_to_check.chemicals)
		if(!reagents?.has_reagent(reagent_id, get_required_reagent_amount(design_to_check, reagent_id)))
			return FALSE

	return TRUE

/obj/structure/machinery/r_n_d/fabricator/proc/can_build(datum/design/design_to_check)
	return has_required_materials(design_to_check) && has_required_reagents(design_to_check)

/obj/structure/machinery/r_n_d/fabricator/proc/canBuild(datum/design/design_to_check)
	return can_build(design_to_check)

/obj/structure/machinery/r_n_d/fabricator/proc/getLackingMaterials(datum/design/design_to_check)
	var/obj/structure/machinery/r_n_d/material_silo/silo = get_material_silo()
	var/list/missing = list()

	for(var/material_id in design_to_check.materials)
		var/required_amount = get_required_material_amount(design_to_check, material_id)
		var/stored_amount = silo?.get_material_amount(material_id) || 0
		if(stored_amount < required_amount)
			missing += "[required_amount - stored_amount] [SSmaterials.material_display_name(material_id)]"

	if(uses_reagents)
		for(var/reagent_id in design_to_check.chemicals)
			var/required_amount = get_required_reagent_amount(design_to_check, reagent_id)
			if(!reagents?.has_reagent(reagent_id, required_amount))
				var/singleton/reagent/reagent = GET_SINGLETON(reagent_id)
				missing += reagent?.name || "unknown reagent"

	return english_list(missing)

/obj/structure/machinery/r_n_d/fabricator/proc/can_produce_job(datum/research_fabrication_job/job)
	if(!job?.design)
		return FALSE
	if(!(job.design.build_type & build_type))
		return FALSE
	if(!has_required_reagents(job.design))
		return FALSE
	if(length(job.reserved_materials))
		return TRUE
	return has_required_materials(job.design)

/obj/structure/machinery/r_n_d/fabricator/proc/reserve_job_materials(datum/research_fabrication_job/job)
	if(!job?.design)
		return FALSE
	if(length(job.reserved_materials))
		return TRUE

	var/obj/structure/machinery/r_n_d/material_silo/silo = get_material_silo()
	if(!silo)
		return FALSE

	for(var/material_id in job.design.materials)
		var/required_amount = get_required_material_amount(job.design, material_id)
		if(!silo.has_material(material_id, required_amount))
			return FALSE

	for(var/material_id in job.design.materials)
		var/required_amount = get_required_material_amount(job.design, material_id)
		var/material = SSmaterials.material_to_path(material_id, FALSE)
		if(!material)
			material = material_id
		SSmaterials.remove_material_amount(silo.materials, material, required_amount)
		job.reserved_materials[material] = required_amount

	silo.update_linked_uis()
	return TRUE

/obj/structure/machinery/r_n_d/fabricator/proc/begin_console_job(datum/research_fabrication_job/job)
	if(!job || !is_available() || !can_produce_job(job))
		return FALSE
	if(!reserve_job_materials(job))
		return FALSE

	assigned_job = job
	current_design = job.design
	job.assigned_machine = src
	on_job_started(job)
	update_use_power(POWER_USE_ACTIVE)
	build_callback_timer = addtimer(CALLBACK(src, PROC_REF(complete_console_job)), current_design.time / production_speed, TIMER_UNIQUE | TIMER_STOPPABLE)
	start_fabrication_audio()
	update_icon()
	SStgui.update_uis(linked_console)
	return TRUE

/obj/structure/machinery/r_n_d/fabricator/proc/on_job_started(datum/research_fabrication_job/job)
	return

/obj/structure/machinery/r_n_d/fabricator/proc/complete_console_job()
	build_callback_timer = null

	var/datum/research_fabrication_job/job = assigned_job
	var/datum/design/design_to_build = job?.design
	if(!job || !design_to_build)
		clear_console_job()
		return

	if(!has_required_reagents(design_to_build))
		visible_message(SPAN_WARNING("\The [src] stops because the required reagents are no longer available."))
		pause_console_job()
		return

	consume_reagents(design_to_build)
	use_fabrication_power(design_to_build)
	fabricate_design(design_to_build, job)
	job.reserved_materials.Cut()

	var/obj/structure/machinery/computer/rdconsole/console = linked_console
	console?.finish_fabrication_job(job)

	/*
	 * Keep construction audio running while the console attempts to assign
	 * another job. This prevents the end and startup sounds from playing
	 * between consecutive items.
	 */
	clear_console_job(FALSE, FALSE)
	console?.dispatch_fabrication_jobs()

	/*
	 * If dispatch did not assign another job to this machine, construction
	 * has actually ended and the loop can now stop.
	 */
	if(!assigned_job)
		stop_fabrication_audio()

/obj/structure/machinery/r_n_d/fabricator/proc/pause_console_job()
	var/datum/research_fabrication_job/job = assigned_job
	if(job)
		job.assigned_machine = null

	assigned_job = null
	current_design = null
	build_callback_timer = null
	stop_fabrication_audio()
	update_use_power(POWER_USE_IDLE)
	update_icon()
	on_job_cleared()

	if(linked_console)
		SStgui.update_uis(linked_console)
		linked_console.dispatch_fabrication_jobs()

/obj/structure/machinery/r_n_d/fabricator/proc/clear_console_job(clear_assignment = TRUE, stop_audio = TRUE)
	if(clear_assignment && assigned_job)
		assigned_job.assigned_machine = null

	assigned_job = null
	current_design = null
	build_callback_timer = null

	if(stop_audio)
		stop_fabrication_audio()

	update_use_power(POWER_USE_IDLE)
	update_icon()
	on_job_cleared()

/obj/structure/machinery/r_n_d/fabricator/proc/consume_reagents(datum/design/design_to_build)
	if(!uses_reagents)
		return

	for(var/reagent_id in design_to_build.chemicals)
		reagents.remove_reagent(reagent_id, get_required_reagent_amount(design_to_build, reagent_id))

/obj/structure/machinery/r_n_d/fabricator/proc/use_fabrication_power(datum/design/design_to_build)
	var/power_cost = active_power_usage
	for(var/material_id in design_to_build.materials)
		power_cost += round(design_to_build.materials[material_id] / 2)
	use_power_oneoff(max(active_power_usage, power_cost))

/obj/structure/machinery/r_n_d/fabricator/proc/fabricate_design(datum/design/design_to_build, datum/research_fabrication_job/job)
	intent_message(MACHINE_SOUND)
	if(!design_to_build.build_path)
		return

	var/atom/product_location = product_offset ? get_step(src, dir) : src
	var/obj/new_item = design_to_build.Fabricate(product_location, src)
	if(!new_item)
		return

	if(!product_offset)
		new_item.forceMove(loc)

	if(mat_efficiency != 1 && new_item.matter?.len)
		for(var/material_id in new_item.matter)
			new_item.matter[material_id] *= mat_efficiency

	apply_product_data(new_item, design_to_build, job)
	on_product_completed(new_item, design_to_build, job)

/obj/structure/machinery/r_n_d/fabricator/proc/apply_product_data(obj/new_item, datum/design/design_to_build, datum/research_fabrication_job/job)
	return

/obj/structure/machinery/r_n_d/fabricator/proc/on_product_completed(obj/new_item, datum/design/design_to_build, datum/research_fabrication_job/job)
	return


/obj/structure/machinery/r_n_d/fabricator/proc/wake_console_dispatch()
	linked_console?.dispatch_fabrication_jobs()

/obj/structure/machinery/r_n_d/fabricator/proc/disconnect_console()
	if(!linked_console)
		return
	var/obj/structure/machinery/computer/rdconsole/console = linked_console
	if(build_callback_timer)
		deltimer(build_callback_timer)
	if(assigned_job)
		assigned_job.assigned_machine = null
	assigned_job = null
	current_design = null
	build_callback_timer = null
	stop_fabrication_audio()
	update_use_power(POWER_USE_IDLE)
	update_icon()
	linked_console = null
	console.remove_fabricator(src)

/obj/structure/machinery/r_n_d/fabricator/attackby(obj/item/attacking_item, mob/user)
	if(user.a_intent == I_HURT)
		return ..()
	if(build_callback_timer)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for the current operation to finish."))
		return TRUE
	if(default_deconstruction_screwdriver(user, attacking_item))
		disconnect_console()
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
	if(istype(attacking_item, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("Materials must be inserted into the linked research material silo."))
		return TRUE
	return ..()

/obj/structure/machinery/r_n_d/fabricator/Destroy()
	if(build_callback_timer)
		deltimer(build_callback_timer)

	stop_fabrication_audio()
	QDEL_NULL(fabrication_loop)

	if(assigned_job)
		assigned_job.assigned_machine = null

	if(linked_console)
		linked_console.remove_fabricator(src)

	assigned_job = null
	current_design = null
	return ..()

/obj/structure/machinery/r_n_d/fabricator/proc/on_job_cleared()
	return
