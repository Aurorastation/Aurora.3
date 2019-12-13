/datum/expansion/multitool/mineral/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	. += buffer(M)
	. += "<HR><b>Connected Machine:</b> "
	var/obj/machinery/mineralconsole/MC = holder
	if(MC.machine)
		. += "[MC.machine.name]<br>"

/datum/expansion/multitool/mineral/receive_buffer(var/obj/item/device/multitool/M, var/atom/buffer, var/mob/user)
	var/obj/machinery/mineral/MM = buffer
	var/obj/machinery/mineralconsole/C = holder

	if(!istype(M))
		to_chat(user, span("warning", "No valid connection data in \the [M] buffer."))
		return MT_NOACTION

	if(C.machine)
		to_chat(user, span("notice", "You [C.Unlink() ? "" : "failed to "] disconnect [C.machine] from [C]."))
		C.Unlink()
		return MT_REFRESH
	if(MM.console)
		to_chat(user, span("notice", "There is already a console connected to that machine!"))
		return MT_NOACTION

	to_chat(user, span("notice", "You [C.LinkTo(MM) ? "" : "failed to " ]connect \the [MM] to \the [C]."))
	return MT_REFRESH
