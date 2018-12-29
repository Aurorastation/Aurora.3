// AI EYE
//
// A mob that the AI controls to look around the station with.
// It streams chunks as it moves around, which will show it what the AI can and cannot see.

/mob/abstract/eye/aiEye
	name = "Inactive AI Eye"
	icon_state = "AI-eye"

/mob/abstract/eye/aiEye/New()
	..()
	visualnet = cameranet

/mob/abstract/eye/aiEye/setLoc(var/T, var/cancel_tracking = 1)
	if(..())
		var/mob/living/silicon/ai/ai = owner
		if(cancel_tracking)
			ai.ai_cancel_tracking()

		//Holopad
		if(ai.holo && ai.hologram_follow)
			ai.holo.move_hologram(ai)
		return 1

// AI MOVEMENT

// The AI's "eye". Described on the top of the page.

/mob/living/silicon/ai
	holo = null

/mob/living/silicon/ai/proc/destroy_eyeobj(var/atom/new_eye)
	if(!eyeobj) return
	if(!new_eye)
		new_eye = src
	eyeobj.owner = null
	qdel(eyeobj) // No AI, no Eye
	eyeobj = null
	if(client)
		client.eye = new_eye

/mob/living/silicon/ai/proc/create_eyeobj(var/newloc)
	if(eyeobj) destroy_eyeobj()
	if(!newloc) newloc = src.loc
	eyeobj = new /mob/abstract/eye/aiEye(newloc)
	eyeobj.owner = src
	eyeobj.name = "[src.name] (AI Eye)" // Give it a name
	if(client) client.eye = eyeobj
	SetName(src.name)

// Intiliaze the eye by assigning it's "ai" variable to us. Then set it's loc to us.
/mob/living/silicon/ai/Initialize()
	. = ..()
	create_eyeobj()
	addtimer(CALLBACK(src, .proc/init_move_eyeobj), 5)

/mob/living/silicon/ai/proc/init_move_eyeobj()
	if (eyeobj)
		eyeobj.forceMove(loc)

/mob/living/silicon/ai/Destroy()
	destroy_eyeobj()
	return ..()

/atom/proc/move_camera_by_click()
	if(istype(usr, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/AI = usr
		if(AI.eyeobj && AI.client.eye == AI.eyeobj)
			AI.eyeobj.setLoc(src)

// Return to the Core.
/mob/living/silicon/ai/proc/core()
	set category = "AI Commands"
	set name = "AI Core"

	view_core()

/mob/living/silicon/ai/proc/view_core()
	camera = null
	unset_machine()

	if(!src.eyeobj)
		return

	if(client && client.eye)
		client.eye = src
	for(var/datum/chunk/c in eyeobj.visibleChunks)
		c.remove(eyeobj)
	src.eyeobj.setLoc(src)

/mob/living/silicon/ai/proc/toggle_acceleration()
	set category = "AI Commands"
	set name = "Toggle Camera Acceleration"

	if(!eyeobj)
		return

	eyeobj.acceleration = !eyeobj.acceleration
	to_chat(usr, "Camera acceleration has been toggled [eyeobj.acceleration ? "on" : "off"].")

/mob/living/silicon/ai/proc/play_sound()
	set category = "AI Commands"
	set name = "Play Music In The Area"

	var/delay = world.time - time_music
	if(delay < 3000)
		delay \= 10
		to_chat(src, "<span class='warning'>You have played music recently, you have to wait [(round(delay/60) > 0) ? ("[round(delay/60)] minutes") : ("[delay] seconds") ]</span>")
		return
	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "--CANCEL--"
	sounds += sounds_cache

	var/melody = input("Select a sound from the server to play", "Server sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")	return

	log_admin("[key_name(src)] played sound [melody]",admin_key=key_name(src))
	message_admins("[key_name_admin(src)] played sound [melody]", 1)
	var/area/A = get_area(eyeobj.loc)
	for(var/obj/item/device/radio/intercom/i in A)
		playsound(i.loc, melody, 40, 0)
	time_music = world.time

	feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
