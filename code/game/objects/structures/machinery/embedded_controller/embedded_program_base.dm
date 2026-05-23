
/datum/computer/file/embedded_program
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master

	var/id_tag

/datum/computer/file/embedded_program/New(var/obj/machinery/embedded_controller/M)
	set_master(M)

/datum/computer/file/embedded_program/proc/set_master(obj/machinery/embedded_controller/new_master)
	if(new_master && master != new_master)
		master = new_master
		id_tag = astype(new_master, /obj/machinery/embedded_controller/radio)?.id_tag
		RegisterSignal(master, COMSIG_QDELETING, PROC_REF(unset_master))

/datum/computer/file/embedded_program/proc/unset_master()
	if(master)
		UnregisterSignal(master, COMSIG_QDELETING)
	master = null
	id_tag = null

/datum/computer/file/embedded_program/Destroy(force)
	master = null
	. = ..()

/datum/computer/file/embedded_program/proc/receive_user_command(command)
	return

/datum/computer/file/embedded_program/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return

/datum/computer/file/embedded_program/process()
	return

/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	if(master)
		master.post_signal(signal, comm_line)
	else
		qdel(signal)
