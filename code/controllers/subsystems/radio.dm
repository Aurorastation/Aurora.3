/*
  HOW IT WORKS

	SSradio is a subsystem responsible for maintaining all radio transmissions, think about it as about "ether".
  Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
  procs:

    add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
      Adds listening object.
      parameters:
        device - device receiving signals, must have proc receive_signal (see description below).
          one device may listen several frequencies, but not same frequency twice.
        new_frequency - see possibly frequencies below;
        filter - thing for optimization. Optional, but recommended.
                 All filters should be consolidated in this file, see defines later.
                 Device without listening filter will receive all signals (on specified frequency).
                 Device with filter will receive any signals sent without filter.
                 Device with filter will not receive any signals sent with different filter.
      returns:
       Reference to frequency object.

    remove_object (obj/device, old_frequency)
      Obliviously, after calling this proc, device will not receive any signals on old_frequency.
      Other frequencies will left unaffected.

   return_frequency(var/frequency as num)
      returns:
       Reference to frequency object. Use it if you need to send and do not need to listen.

  radio_frequency is a global object maintaining list of devices that listening specific frequency.
  procs:

    post_signal(obj/source as obj|null, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
      Sends signal to all devices that wants such signal.
      parameters:
        source - object, emitted signal. Usually, devices will not receive their own signals.
        signal - see description below.
        filter - described above.
        range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

  obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param)
    Handler from received signals. By default does nothing. Define your own for your object.
    Avoid of sending signals directly from this proc, use spawn(-1). DO NOT use sleep() here or call procs that sleep please. If you must, use spawn()
      parameters:
        signal - see description below. Extract all needed data from the signal before doing sleep(), spawn() or return!
        receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
          TRANSMISSION_WIRE is currently unused.
        receive_param - for TRANSMISSION_RADIO here comes frequency.

  datum/signal
    vars:
    source
      an object that emitted signal. Used for debug and bearing.
    data
      list with transmitting data. Usual use pattern:
        data["msg"] = "hello world"
    encryption
      Some number symbolizing "encryption key".
      Note that game actually do not use any cryptography here.
      If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.

*/

/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)

Radio:
1459 - standard radio chat
1351 - Science
1353 - Command
1355 - Medical
1357 - Engineering
1359 - Security
1341 - deathsquad
1443 - Confession Intercom
1347 - Cargo techs
1349 - Service people

Devices:
1451 - tracking implant
1457 - RSD default

On the map:
1311 for prison shuttle console (in fact, it is not used)
1435 for status displays
1437 for atmospherics/fire alerts
1438 for engine components
1439 for air pumps, air scrubbers, atmo control
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot, secbot and ed209 control
1449 for airlock controls, electropack, magnets
1451 for toxin lab access
1453 for engineering access
1455 for AI access
*/

var/datum/controller/subsystem/radio/SSradio

/datum/controller/subsystem/radio
	name = "Radio"
	flags = SS_NO_FIRE | SS_NO_INIT

	var/list/datum/radio_frequency/frequencies = list()

/datum/controller/subsystem/radio/New()
	NEW_SS_GLOBAL(SSradio)

/datum/controller/subsystem/radio/stat_entry()
	..("F:[frequencies.len]")

/datum/controller/subsystem/radio/proc/add_object(obj/device, new_frequency, filter = null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/subsystem/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(frequency)
		frequency.remove_listener(device)

		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text

	return 1

/datum/controller/subsystem/radio/proc/remove_object_all(obj/device)
	for(var/freq in frequencies)
		SSradio.remove_object(device, text2num(freq))

/datum/controller/subsystem/radio/proc/get_devices(freq, filter = RADIO_DEFAULT)
	var/datum/radio_frequency/frequency = frequencies[num2text(freq)]
	if(!frequency)
		return

	return frequency.devices["[filter]"]

/datum/controller/subsystem/radio/proc/return_frequency(new_frequency)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency


// Some misc procs not technically part of the subsystem, but are related.

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return null

/proc/frequency_span_class(var/frequency)
	. = "radio"
	var/fstr = "[frequency]"
	// Antags!
	if (ANTAG_FREQS_ASSOC[fstr])
		return "syndradio"

	// centcomm channels (deathsquid and ert)
	if(CENT_FREQS_ASSOC[fstr])
		return "centradio"

	// department radio formatting
	switch (frequency)
		if (COMM_FREQ)	// command
			. = "comradio"
		if (AI_FREQ)	// AI Private
			. = "airadio"
		if (SEC_FREQ,SEC_I_FREQ)
			. = "secradio"
		if (PEN_FREQ)
			. = "penradio"
		if (ENG_FREQ)
			. = "engradio"
		if (SCI_FREQ)
			. = "sciradio"
		if (MED_FREQ,MED_I_FREQ)
			. = "medradio"
		if (SUP_FREQ)	// cargo
			. = "supradio"
		if (SRV_FREQ)	// service
			. = "srvradio"
		if (ENT_FREQ) //entertainment
			. = "entradio"
		if (BLSP_FREQ)
			. = "bluespaceradio"
		if (SHIP_FREQ)
			. = "shipradio"
		else
			if(DEPT_FREQS_ASSOC[fstr])
				. = "deptradio"
