/*
 * # Large Structure
 *
 * This datum controls a large, multi-tile structure, capable of being assembled or disassembled as a unit (i.e. tents).
 */
/datum/large_structure
	/**
	 * Name of this structure
	 */
	var/name = "structure"
	/**
	 * Turfs this structure exists on
	 */
	var/list/turf/target_turfs = list()
	/**
	 * Structures that are part of this structure
	 */
	var/list/obj/structure/component/grouped_structures = list()
	/**
	 * Mobs assembling or disassembling this structure
	 */
	var/list/mob/interacting = list()
	/**
	 * A list of the stages required to assemble or disassemble the large structure. Format: "string" = STAGE
	 */
	var/list/stages = list()
	/**
	 * The smaller structure which makes up this large one
	 */
	var/component_structure
	/**
	 * The type item used to set up this structure in the first place, made on disassembly
	 */
	var/source_item_type
	/**
	 * The item used to set up this structure, deleted after assembly
	 */
	var/obj/item/source_item
	/**
	 * The turf this structure started from. Used to check if the source_item building this has moved.
	 */
	var/turf/origin
	var/color
	var/dir
	var/x1
	var/x2
	var/y1
	var/y2
	var/z1
	var/z2

/**
 * Returns the first stage with value `type`
 */
/datum/large_structure/proc/get_next_stage(var/type)
	for(var/stage in stages)
		if(stages[stage] == type)
			return stage

/datum/large_structure/proc/assemble(var/time_per_structure, var/mob/user)
	if(user in interacting)
		to_chat(user, SPAN_INFO("You are already working on assembling \the [src]."))
		return FALSE

	var/stage_to_do = get_next_stage(STAGE_DISASSEMBLED)

	if(!stage_to_do)
		to_chat(user, SPAN_INFO("There is no more work to be done assembling \the [src]."))
		return FALSE


	if(!LAZYLEN(target_turfs))
		get_target_turfs(user)

	interacting += user

	user.visible_message(SPAN_NOTICE("\The [user] begins assembling \the [src]'s [stage_to_do]."))
	stages[stage_to_do] = STAGE_PROGRESS
	if(!do_after(user, time_per_structure * LAZYLEN(target_turfs)))
		stages[stage_to_do] = STAGE_DISASSEMBLED
		interacting -= user
		return
	user.visible_message(SPAN_NOTICE("\The [user] finishes assembling the [stage_to_do]."))
	stages[stage_to_do] = STAGE_ASSEMBLED

	interacting -= user

	if(get_next_stage(STAGE_DISASSEMBLED)) //Still work to do
		assemble(time_per_structure, user)
		return FALSE

	if(get_next_stage(STAGE_PROGRESS)) //Still work being done
		return FALSE

	build_structures()
	QDEL_NULL(source_item)
	return TRUE

/datum/large_structure/proc/get_target_turfs(var/mob/user, var/force = FALSE)
	target_turfs = block(x1,y1,z1,x2,y2,z2)
	for(var/turf/T in target_turfs)
		if(!(istype(T) || force))
			to_chat(user, SPAN_ALERT("You cannot set up \the [src] here. Try and find a big enough solid surface."))
			return FALSE

/datum/large_structure/proc/build_structures()
	for(var/turf/T in target_turfs)
		var/obj/structure/component/C = new component_structure(T)
		C.part_of = src
		C.color = color
		grouped_structures += C
		RegisterSignal(T, COMSIG_ATOM_ENTERED, PROC_REF(structure_entered), override = TRUE)

/datum/large_structure/proc/disassemble(var/time_per_structure, var/mob/user)
	if(user in interacting)
		to_chat(user, SPAN_INFO("You are already working on disassembling \the [src]."))
		return FALSE

	var/stage_to_do = get_next_stage(STAGE_ASSEMBLED)

	if(!stage_to_do)
		to_chat(user, SPAN_INFO("There is no more work to be done disassembling \the [src]."))
		return FALSE

	interacting += user

	user.visible_message(SPAN_NOTICE("\The [user] begins disassembling \the [src]'s [stage_to_do]."))
	stages[stage_to_do] = STAGE_PROGRESS
	if(!do_after(user, time_per_structure * LAZYLEN(grouped_structures)))
		stages[stage_to_do] = STAGE_ASSEMBLED
		interacting -= user
		return FALSE
	user.visible_message(SPAN_NOTICE("\The [user] finishes disassembling the [stage_to_do]."))
	stages[stage_to_do] = STAGE_DISASSEMBLED

	interacting -= user

	if(get_next_stage(STAGE_ASSEMBLED)) //Still work to do
		return disassemble(time_per_structure, user)

	if(get_next_stage(STAGE_PROGRESS)) //Still work being done
		return

	QDEL_LIST(grouped_structures)

	var/obj/item/I = new source_item_type(get_turf(user))
	I.color = color
	qdel(src)
	return TRUE

/datum/large_structure/proc/structure_entered(var/turf/entry_point, var/atom/movable/entering)
	if(!(isliving(entering) || isobserver(entering)))
		return FALSE
	RegisterSignal(entering, COMSIG_MOVABLE_MOVED, PROC_REF(mob_moved), override = TRUE)
	return TRUE

/datum/large_structure/proc/mob_moved(var/mob/mover)
	if(!(get_turf(mover) in target_turfs))
		UnregisterSignal(mover, COMSIG_MOVABLE_MOVED)
		return FALSE
	return TRUE

/obj/structure/component
	var/datum/large_structure/part_of

/obj/structure/component/Destroy()
	if(part_of)
		part_of.grouped_structures -= src
	return ..()
