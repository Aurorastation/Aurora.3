/mob/abstract/eye/base_planner
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

	/// Associative list of turfs -> boolean validity that the player has selected for new area creation.
	var/list/selected_turfs = list()
	///The overlayed images of the user's selection.
	var/list/selection_images = list()
	///The last turf selected.
	var/turf/last_selected_turf
	///The image overlayed on the last selected turf
	var/image/last_selected_image

	///On what z-levels the blueprints can be used to modify or create areas.
	var/list/valid_z_levels = list()

	///Displayed to the user to allow them to see what area they're hovering over
	var/obj/effect/overlay/area_name_effect
	///The prefix of the area name effect display
	var/area_prefix

	///Displayed to the user on failed area creation
	var/list/errors = list()

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
	if(!canClick())
		return
	if(params["left"])
		put_selected_object(get_turf(A))
	if(params["ctrl"])
		remove_object(get_turf(A))

/mob/abstract/eye/base_planner/proc/put_selected_object(var/turf/selected_turf)
	if(!selected_object)
		to_chat(owner, SPAN_WARNING("You need to select an object first!"))
		return

	var/colliding_object = locate(/obj/structure/blueprint) in selected_turf
	if(colliding_object)
		qdel(colliding_object)

	new selected_object(selected_turf)

/mob/abstract/eye/base_planner/proc/remove_object(var/turf/selected_turf)
	var/found_object = locate(/obj/structure/blueprint) in selected_turf
	if(found_object)
		qdel(found_object)
	else
		to_chat(owner, SPAN_WARNING("There is nothing to remove here."))

/mob/abstract/eye/base_planner/setLoc(T)
	. = ..()
	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(src)
	if(!A)
		return
	//area_name_effect.maptext = "<span style=\"[style]\">[area_prefix], [A.name]</span>"

/mob/abstract/eye/base_planner/additional_sight_flags()
	return SEE_TURFS|SEE_OBJS|BLIND

/mob/abstract/eye/base_planner/apply_visual(mob/living/M)
	M.overlay_fullscreen("blueprints", /atom/movable/screen/fullscreen/blueprints/less_alpha)
	//M.client.screen += area_name_effect
	M.add_client_color(/datum/client_color/monochrome)

/mob/abstract/eye/base_planner/remove_visual(mob/living/M)
	M.clear_fullscreen("blueprints", 0)
	//M.client.screen -= area_name_effect
	M.remove_client_color(/datum/client_color/monochrome)

// ---- Blueprint Objects

ABSTRACT_TYPE(/obj/structure/blueprint)
	desc = "A construction plan component. Someone is going to finish this, eventually."
	icon = 'icons/obj/item/blueprints.dmi'
	density = FALSE
	anchored = TRUE
	alpha = 200
	color = "#54809C"

	/// Object path that this ghost object represents.
	var/obj/target_object_path
	/// Turf path that this ghost object represents.
	var/turf/target_turf_path
	/// Path for required material to build `target_object_path`. /obj/item/stack/material/steel/
	var/obj/item/required_material
	/// Required amount of required material.
	var/required_amount


/obj/structure/blueprint/Initialize()
	. = ..()
	if(!target_object_path && !target_turf_path)
		return INITIALIZE_HINT_QDEL

	name = target_object_path ? "[target_object_path.name] blueprint" : "[target_turf_path.name] blueprint"

	AddOverlays("in_progress")

/obj/structure/blueprint/mechanics_hints()
	. += ..()
	. += "You can click this with <b>[required_amount]</b> amounts of <b>[required_material.name]</b> to build <b>[target_object_path.name]</b>!"
	. += "You can click this with an <b>empty hand</b> on <b>harm intent</b> to remove it."

/obj/structure/blueprint/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, required_material))
		var/obj/item/stack/material/mat_stack = attacking_item
		var/current_amount = mat_stack.get_amount()
		if(current_amount < required_amount)
			to_chat(user, SPAN_WARNING("You need [required_amount - current_amount] more \the [mat_stack] to complete this!"))
			return ..()

		if(!do_after(user, 3 SECONDS) || !mat_stack.use(required_amount))
			return ..()

		if(target_object_path)
			var/obj/solid_object = new target_object_path(get_turf(src))
			solid_object.dir = src.dir
		else
			var/turf/T = get_turf(src)
			T.ChangeTurf(target_turf_path)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)

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

/obj/structure/blueprint/turf_plating
	icon_state = "plating"
	target_turf_path = /turf/simulated/floor/plating
	required_material = /obj/item/stack/tile/floor
	required_amount = 1

// ---- Room Templates

/datum/room_tempate
	var/name = "base template"
	/// Width of the room template.
	var/width
	/// Height of the room template.
	var/height
	/// Top-down view of the room template, which can be edited like the example below:
	/**
	 * Define some vars that contains object/turf paths in New() like this:
	 * var/G = /obj/structure/blueprint/girder
	 * var/W = /obj/structure/blueprint/window
	 * var/F = /obj/structure/blueprint/floor
	 *
	 * then:
	 * layout = list(
	 *	list=(G, W, W, G)
	 *	list=(G, F, F, G)
	 *	list=(G, G, G, G)
	 *)
	 * This is a layout of a 4x3 (4 width, 3 height) room. vars can be changed
	 */
	var/list/layout

