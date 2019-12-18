/obj/screen/psi/hub
	name = "Psi"
	icon_state = "psi_suppressed"
	screen_loc = "EAST-1:28,CENTER-3:11"
	hidden = FALSE
	maptext_x = 6
	maptext_y = -8
	var/image/on_cooldown

/obj/screen/psi/hub/New(var/mob/living/_owner)
	on_cooldown = image(icon, "cooldown")
	..()
	START_PROCESSING(SSprocessing, src)

/obj/screen/psi/hub/update_icon()

	if(!owner.psi)
		return

	icon_state = owner.psi.suppressed ? "psi_suppressed" : "psi_active"

/obj/screen/psi/hub/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner = null
	. = ..()

/obj/screen/psi/hub/process()
	if(!istype(owner))
		qdel(src)
		return
	if(!owner.psi)
		return
	maptext = "[round((owner.psi.stamina/owner.psi.max_stamina)*100)]%"
	update_icon()

/obj/screen/psi/hub/Click(var/location, var/control, var/params)
	var/list/click_params = params2list(params)
	if(click_params["shift"])
		owner.show_psi_assay(owner)
		return

	if(owner.psi.suppressed && owner.psi.stun)
		to_chat(owner, "<span class='warning'>You are dazed and reeling, and cannot muster enough focus to do that!</span>")
		return

	owner.psi.suppressed = !owner.psi.suppressed
	to_chat(owner, "<span class='notice'>You are <b>[owner.psi.suppressed ? "now suppressing" : "no longer suppressing"]</b> your psi-power.</span>")
	if(owner.psi.suppressed)
		owner.psi.cancel()
		owner.psi.hide_auras()
	else
		sound_to(owner, sound('sound/effects/psi/power_unlock.ogg'))
		owner.psi.show_auras()
	update_icon()