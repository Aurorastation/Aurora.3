/datum/wires/shield_generator
	holder_type = /obj/machinery/power/shield_generator
	wire_count = 5

var/const/SHIELDGEN_WIRE_POWER =     (1<<0)		// Cut to disable power input into the generator. Pulse does nothing. Mend to restore.
var/const/SHIELDGEN_WIRE_HACK =      (1<<1)		// Pulse to hack the generator, enabling hacked modes. Cut to unhack. Mend does nothing.
var/const/SHIELDGEN_WIRE_CONTROL =   (1<<2)		// Cut to lock most shield controls. Mend to unlock them. Pulse does nothing.
var/const/SHIELDGEN_WIRE_AICONTROL = (1<<3)		// Cut to disable AI control. Mend to restore.
var/const/SHIELDGEN_WIRE_NOTHING =   (1<<4)		// A blank wire that doesn't have any specific function

/datum/wires/shield_generator/CanUse()
	var/obj/machinery/power/shield_generator/S = holder
	return S.panel_open

/datum/wires/shield_generator/UpdateCut(index, mended)
	var/obj/machinery/power/shield_generator/S = holder
	switch(index)
		if(SHIELDGEN_WIRE_POWER)
			S.input_cut = !mended
		if(SHIELDGEN_WIRE_HACK)
			if(!mended)
				S.hacked = FALSE
				if(S.check_flag(MODEFLAG_BYPASS))
					S.toggle_flag(MODEFLAG_BYPASS)
				if(S.check_flag(MODEFLAG_OVERCHARGE))
					S.toggle_flag(MODEFLAG_OVERCHARGE)
		if(SHIELDGEN_WIRE_CONTROL)
			S.mode_changes_locked = !mended
		if(SHIELDGEN_WIRE_AICONTROL)
			S.ai_control_disabled = !mended

/datum/wires/shield_generator/UpdatePulsed(var/index)
	var/obj/machinery/power/shield_generator/S = holder
	switch(index)
		if(SHIELDGEN_WIRE_HACK)
			S.hacked = TRUE