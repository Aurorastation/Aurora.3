/**************
* AI-specific *
**************/
/obj/item/camera/siliconcam
	parent_type = /obj/item/camera/digital
	desc = "An integrated digital camera. Stored photos can be printed using a photocopier."
	pictures_left = 0
	pictures_max = 0
	storage_capacity = INFINITY
	var/in_camera_mode = 0
	var/photos_taken = 0
	var/list/obj/item/photo/aipictures = list()

/obj/item/camera/siliconcam/Initialize()
	. = ..()
	// Keep the existing album API used by syncing, photocopiers and newscasters.
	stored_photos = aipictures

/obj/item/camera/siliconcam/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/camera/siliconcam/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SiliconCamera", name, 760, 600)
		ui.open()

/obj/item/camera/siliconcam/ui_data(mob/user)
	. = ..()
	.["capacity"] = null
	.["on"] = in_camera_mode
	var/list/photos = .["photos"]
	var/list/local_ids = list()
	for(var/list/photo in photos)
		photo["local"] = TRUE
		local_ids += photo["id"]
	var/obj/item/camera/siliconcam/master_camera = getsource(user)
	if(master_camera != src)
		var/list/master_data = master_camera.ui_data(user)
		for(var/list/photo in master_data["photos"])
			if(!(photo["id"] in local_ids))
				photo["local"] = FALSE
				photos += list(photo)
	return .

/obj/item/camera/siliconcam/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/camera_action = action
	// Run the parent's UI validation without invoking its printer or power toggle.
	if(action == "print" || action == "toggle_power")
		action = "silicon_camera"
	. = ..()
	if(.)
		return
	if(camera_action == "toggle_power")
		toggle_camera_mode()
		return TRUE

/obj/item/camera/siliconcam/mechanics_hints(mob/user, distance, is_adjacent)
	return list(
		"Use Take Image to photograph your next clicked subject. Use View Images to open the digital gallery and adjust focus or delete local photos.",
		"Connected cyborgs also see their AI's photos. Use a photocopier to print stored photos."
	)

/obj/item/camera/siliconcam/feedback_hints(mob/user, distance, is_adjacent)
	return list(SPAN_NOTICE("Its memory holds <b>[length(aipictures)] photos</b>. Use a photocopier to print them."))

/obj/item/camera/siliconcam/captureimage(atom/target, mob/living/user, flag)
	if(world.time < next_capture)
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return FALSE
	var/obj/item/photo/photo = createpicture(target_turf, user, flag)
	if(!photo)
		return FALSE
	next_capture = world.time + 2 SECONDS
	printpicture(user, photo)
	do_photo_sound()
	return TRUE

/obj/item/camera/siliconcam/printpicture(mob/user, obj/item/photo/photo)
	injectaialbum(photo)
	to_chat(user, SPAN_NOTICE("Image recorded."))

/obj/item/camera/siliconcam/ai_camera //camera AI can take pictures with
	name = "AI photo camera"

/obj/item/camera/siliconcam/robot_camera //camera cyborgs can take pictures with
	name = "Cyborg photo camera"

/obj/item/camera/siliconcam/drone_camera
	parent_type = /obj/item/camera/siliconcam/robot_camera
	name = "Drone photo camera"

/obj/item/camera/siliconcam/proc/injectaialbum(obj/item/photo/p, var/sufix = "") //stores image information to a list similar to that of the datacore
	p.forceMove(src)
	photos_taken++
	p.name = "Image [photos_taken][sufix]"
	aipictures += p
	SStgui.update_uis(src)

/obj/item/camera/siliconcam/proc/injectmasteralbum(obj/item/photo/p) //stores image information to a list similar to that of the datacore
	var/mob/living/silicon/robot/C = usr
	if(C.connected_ai)
		C.connected_ai.ai_camera.injectaialbum(p.copy(1), " (synced from [C.name])")
		to_chat(C.connected_ai, "<span class='unconscious'>Image uploaded by [C.name]</span>")
		to_chat(usr, "<span class='unconscious'>Image synced to remote database</span>")	//feedback to the Cyborg player that the picture was taken)
	else
		to_chat(usr, "<span class='unconscious'>Image recorded</span>")
	// Always save locally
	injectaialbum(p)

/obj/item/camera/siliconcam/proc/selectpicture(obj/item/camera/siliconcam/cam)
	if(!cam)
		cam = getsource()

	var/list/nametemp = list()
	var/find
	if(cam.aipictures.len == 0)
		to_chat(usr, SPAN_NOTICE("No images saved"))
		return
	for(var/obj/item/photo/t in cam.aipictures)
		nametemp += t.name
	find = input("Select image (numbered in order taken)") as null|anything in nametemp
	if(!find)
		return

	for(var/obj/item/photo/q in cam.aipictures)
		if(q.name == find)
			return q

/obj/item/camera/siliconcam/proc/viewpictures()
	ui_interact(usr)

/obj/item/camera/siliconcam/proc/deletepicture(obj/item/camera/siliconcam/cam)
	var/selection = selectpicture(cam)

	if(!selection)
		return

	aipictures -= selection
	qdel(selection)
	SStgui.update_uis(src)
	to_chat(usr, "<span class='unconscious'>Local image deleted</span>")

//Capture Proc for AI / Robot
/mob/living/silicon/ai/can_capture_turf(turf/T)
	var/mob/living/silicon/ai = src
	return ai.TurfAdjacent(T)

/obj/item/camera/siliconcam/proc/toggle_camera_mode()
	if(in_camera_mode)
		camera_mode_off()
	else
		camera_mode_on()

/obj/item/camera/siliconcam/proc/camera_mode_off()
	src.in_camera_mode = 0
	SStgui.update_uis(src)
	to_chat(usr, "<B>Camera Mode deactivated</B>")

/obj/item/camera/siliconcam/proc/camera_mode_on()
	src.in_camera_mode = 1
	SStgui.update_uis(src)
	to_chat(usr, "<B>Camera Mode activated</B>")

/obj/item/camera/siliconcam/ai_camera/printpicture(mob/user, obj/item/photo/p)
	injectaialbum(p)
	to_chat(usr, "<span class='unconscious'>Image recorded</span>")

/obj/item/camera/siliconcam/robot_camera/printpicture(mob/user, obj/item/photo/p)
	injectmasteralbum(p)

/obj/item/camera/siliconcam/ai_camera/verb/take_image()
	set category = "AI Commands"
	set name = "Take Image"
	set desc = "Takes an image"
	set src in usr

	toggle_camera_mode()

/obj/item/camera/siliconcam/ai_camera/verb/view_images()
	set category = "AI Commands"
	set name = "View Images"
	set desc = "View images"
	set src in usr

	viewpictures()

/obj/item/camera/siliconcam/ai_camera/verb/delete_images()
	set category = "AI Commands"
	set name = "Delete Image"
	set desc = "Delete image"
	set src in usr

	deletepicture()

/obj/item/camera/siliconcam/robot_camera/verb/take_image()
	set category ="Robot Commands"
	set name = "Take Image"
	set desc = "Takes an image"
	set src in usr

	toggle_camera_mode()

/obj/item/camera/siliconcam/robot_camera/verb/view_images()
	set category ="Robot Commands"
	set name = "View Images"
	set desc = "View images"
	set src in usr

	viewpictures()

/obj/item/camera/siliconcam/robot_camera/verb/delete_images()
	set category = "Robot Commands"
	set name = "Delete Image"
	set desc = "Delete a local image"
	set src in usr

	deletepicture(src)

/obj/item/camera/siliconcam/proc/getsource(mob/user = usr)
	if(isrobot(user) && user == loc)
		var/mob/living/silicon/robot/robot = user
		if(robot.connected_ai?.ai_camera)
			return robot.connected_ai.ai_camera
	return src

/mob/living/silicon/proc/GetPicture()
	if(!ai_camera)
		return
	return ai_camera.selectpicture()
