#define ALLOWED_MOVEMENT_RADIUS 25

/mob/abstract/eye/base_planner
	/// The location we're spawned at, and not allowed to leave too far from.
	var/turf/spawn_point

	/// A list of selectable ghost objects, an assoc list.
	var/list/object_selection_list = list(
		"Girder" = /obj/structure/blueprint/girder,
		"Window frame" = /obj/structure/blueprint/window_frame,
		"Airlock frame" = /obj/structure/blueprint/airlock_frame,
		"Turf plating" = /obj/structure/blueprint/turf_plating
	)

	/// Chosen ghost object to be placed at the target turf.
	var/selected_object

	/// List of room template datums.
	var/list/room_template_choices = list()

	/// Chosen room template.
	var/selected_room_template

	/// On what z-levels the blueprints can be used to modify or create areas.
	var/list/valid_z_levels = list()

	/// Used for notifying eye user about their movement is restricted.
	var/warning_time

/mob/abstract/eye/base_planner/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(get_spawn_point)), 0.1 SECONDS)

/mob/abstract/eye/base_planner/proc/get_spawn_point()
	spawn_point = get_turf(src)

/mob/abstract/eye/base_planner/check_allowed_movement(turf/step)
	if(get_dist(step, spawn_point) > ALLOWED_MOVEMENT_RADIUS)
		if(world.time > warning_time + 2 SECONDS)
			warning_time = world.time
			to_chat(owner, SPAN_WARNING("You can't see beyond this point from your current location!"))
		return FALSE

	return TRUE

/mob/abstract/eye/base_planner/Destroy()
	spawn_point = null
	return ..()

/mob/abstract/eye/base_planner/can_ztravel(var/direction)
	return FALSE // needed to avoid some exploits and efficiency in move restrictions

/mob/abstract/eye/base_planner/proc/choose_blueprint_object()
	var/choice = tgui_input_list(usr, "Choose an object to place.", "Object Selection", object_selection_list)

	if(!choice)
		return

	selected_object = object_selection_list[choice]

/mob/abstract/eye/base_planner/release(var/mob/user)
	if(owner && owner.client && user == owner)
		owner.client.images.Cut()
	. = ..()

/mob/abstract/eye/base_planner/ClickOn(atom/A, params)
	params = params2list(params)
	var/turf/T = get_turf(A)
	if(!canClick())
		return
	if(params["left"])
		put_selected_object(T)
	if(params["ctrl"])
		remove_object(T)
	if(params["middle"])
		copy_object(T)

/mob/abstract/eye/base_planner/proc/put_selected_object(var/turf/selected_turf)
	if(!selected_object)
		to_chat(owner, SPAN_WARNING("You need to select an object first!"))
		return

	if(selected_turf.density)
		to_chat(owner, SPAN_WARNING("This place isn't suitable for placing blueprints!"))
		return

	new selected_object(selected_turf)

/mob/abstract/eye/base_planner/proc/remove_object(var/turf/selected_turf)
	var/found_object = locate(/obj/structure/blueprint) in selected_turf
	if(!found_object)
		to_chat(owner, SPAN_WARNING("There is nothing to remove here."))
		return

	qdel(found_object)

/mob/abstract/eye/base_planner/proc/copy_object(var/turf/selected_turf)
	var/obj/structure/blueprint/found_object = locate(/obj/structure/blueprint) in selected_turf
	if(!found_object)
		to_chat(owner, SPAN_WARNING("There is nothing to copy here."))
		return

	selected_object = found_object.type
	to_chat(owner, SPAN_NOTICE("\The [found_object] has been copied."))

/mob/abstract/eye/base_planner/proc/place_template()
	var/datum/room_template/base_planner_template/ER = new()
	ER.template_selection(get_turf(src))

/mob/abstract/eye/base_planner/proc/erase_all()
	if(tgui_alert(owner, "This will erase EVERY blueprint objects in your near vicinity, do you wish to proceed?", "Erase All", list("Confirm", "Cancel")) != "Confirm")
		to_chat(owner, SPAN_NOTICE("You decided not to erase everything."))
		return

	for(var/obj/structure/blueprint/B in range(20, src))
		qdel(B)

	to_chat(owner, SPAN_NOTICE("You successfully erased nearby blueprint objects."))

/mob/abstract/eye/base_planner/additional_sight_flags()
	return SEE_TURFS|SEE_OBJS|BLIND

/mob/abstract/eye/base_planner/apply_visual(mob/living/M)
	M.overlay_fullscreen("blueprints", /atom/movable/screen/fullscreen/blueprints/less_alpha)
	M.add_client_color(/datum/client_color/monochrome)

/mob/abstract/eye/base_planner/remove_visual(mob/living/M)
	M.clear_fullscreen("blueprints", 0)
	M.remove_client_color(/datum/client_color/monochrome)

// ---- Blueprint Objects

ABSTRACT_TYPE(/obj/structure/blueprint)
	desc = "A construction plan component. Someone is going to finish this, eventually."
	icon = 'icons/obj/item/base_planning_blueprints.dmi'
	density = FALSE
	anchored = TRUE
	alpha = 200
	color = "#54809C"

	/// Object path that this ghost object represents.
	var/obj/target_object_path

	/// Turf path that this ghost object represents.
	var/turf/target_turf_path

	/// Target atom name, incase we can't get the name for some reason.
	var/target_atom_name = "blueprint"

	/// Path for required material to build `target_object_path`. /obj/item/stack/material/steel/
	var/obj/item/stack/required_material

	/// Required amount of required material.
	var/required_amount

	/// Required time to complete this blueprint.
	var/build_time = 3 SECONDS

	/// Whether someone is currently building blueprint this or not.
	var/currently_being_built = FALSE

	/// A list of type paths that this object will ignore when it's looking to delete incompatible blueprint objects in its turf.
	var/list/whitelisted_types = list()


/obj/structure/blueprint/Initialize()
	. = ..()
	if(!target_object_path && !target_turf_path)
		return INITIALIZE_HINT_QDEL

	name = target_object_path ? "[target_object_path.name] blueprint" : "[target_turf_path.name] blueprint"

	remove_incompatible_types()
	AddOverlays("in_progress")

/obj/structure/blueprint/mechanics_hints()
	. += ..()
	. += "You can click this with <b>[required_amount]</b> amounts of <b>[required_material.name]</b> to build <b>[target_object_path?.name || target_atom_name]</b>!"
	. += "You can click this with an <b>empty hand</b> on <b>harm intent</b> to remove it."

/obj/structure/blueprint/proc/remove_incompatible_types()
	var/turf/T = get_turf(src)
	for(var/obj/structure/blueprint/colliding_atom in T)
		if(colliding_atom == src || is_type_in_list(colliding_atom, whitelisted_types))
			continue
		qdel(colliding_atom)

/obj/structure/blueprint/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, required_material) && !currently_being_built)
		var/obj/item/stack/material/mat_stack = attacking_item
		var/current_amount = mat_stack.get_amount()
		if(current_amount < required_amount)
			to_chat(user, SPAN_WARNING("You need [required_amount - current_amount] more \the [mat_stack] to complete this!"))
			return ..()

		currently_being_built = TRUE
		if(!do_after(user, build_time) || !mat_stack.use(required_amount))
			currently_being_built = FALSE
			return ..()

		var/turf/T = get_turf(src)
		if(target_object_path)
			var/obj/solid_object = new target_object_path(get_turf(src))
			solid_object.dir = src.dir
		else
			T.ChangeTurf(target_turf_path)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)

		for(var/obj/structure/flora/F in T)
			qdel(F)

		qdel(src) // blueprint served its purpose, now it can embrace the oblivion

/obj/structure/blueprint/attack_hand(mob/user)
	. = ..()
	if(user.a_intent == I_HURT)
		user.visible_message(SPAN_NOTICE("[user] removes \the [src]."), SPAN_NOTICE("You remove \the [src]."))
		qdel(src)

/obj/structure/blueprint/girder
	icon_state = "girder"
	color = COLOR_BLUE_GRAY
	target_object_path = /obj/structure/girder
	required_material = /obj/item/stack/material/steel
	required_amount = 2

/obj/structure/blueprint/window_frame
	icon_state = "window_frame"
	target_object_path = /obj/structure/window_frame
	required_material = /obj/item/stack/material/steel
	required_amount = 4

/obj/structure/blueprint/airlock_frame
	icon_state = "airlock_frame"
	target_object_path = /obj/structure/door_assembly/door_assembly_generic
	required_material = /obj/item/stack/material/steel
	required_amount = 4
	whitelisted_types = list(
		/obj/structure/blueprint/turf_plating
	)

/obj/structure/blueprint/turf_plating
	icon_state = "plating"
	layer = BELOW_OBJ_LAYER
	target_turf_path = /turf/simulated/floor/plating
	target_atom_name = "plating"
	required_material = /obj/item/stack/tile/floor
	required_amount = 1
	build_time = 0.1 SECONDS
	whitelisted_types = list(
		/obj/structure/blueprint/airlock_frame
	)

#undef ALLOWED_MOVEMENT_RADIUS
