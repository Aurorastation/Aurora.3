//False Alarm Event
//This picks a random moderate or severe event and fakes its announcement
//without actually running the event
//After roughly 3 minutes, CC sends another announcement apologising for the false alarm

/datum/event/false_alarm
	announceWhen	= 0
	endWhen	=	90
	var/datum/event_meta/EM
	var/eventname
	var/datum/event/E = null


/datum/event/false_alarm/end()
	command_announcement.Announce("Error, It appears our previous announcement about [eventname] was a sensor glitch. There is no cause for alarm, please return to your stations.", "False Alarm", new_sound = 'sound/AI/falsealarm.ogg')
	if(two_part)
		E.end()
	if (EM)
		qdel(EM)
		EM = null

/datum/event/false_alarm/announce()
	var/datum/event_container/EC
	if (prob(60))
		EC = SSevents.event_containers[EVENT_LEVEL_MODERATE]
	else
		EC = SSevents.event_containers[EVENT_LEVEL_MAJOR]

	//Don't pick events that are excluded from faking.
	EM = pick(EC.available_events)
	var/fake_allowed = 0
	while (!fake_allowed)
		if (E)
			E.end()
			E.kill()
			qdel(E)
			E = null
		EM = pick(EC.available_events)
		E = new EM.event_type(EM,1)
		fake_allowed = !E.no_fake

	if (E.ic_name)
		eventname = E.ic_name
	else
		eventname = EM.name
	if(E.two_part)
		two_part = 1
		E.start()

	E.end()
	E.kill()
	E.announce()