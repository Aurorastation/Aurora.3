#define AIRLOCK_CRUSH_DIVISOR 8 // Damage caused by airlock crushing a mob is split into multiple smaller hits. Prevents things like cut off limbs, etc, while still having quite dangerous injury.
#define CYBORG_AIRLOCKCRUSH_RESISTANCE 4 // Damage caused to silicon mobs (usually cyborgs) from being crushed by airlocks is divided by this number. Unlike organics cyborgs don't have passive regeneration, so even one hit can be devastating for them.

#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

/obj/machinery/door/airlock
	name = "Airlock"
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door_closed"
	power_channel = ENVIRON
	hatch_colour = "#7d7d7d"

	explosion_resistance = 10
	var/aiControlDisabled = 0 //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/electrified_until = 0			//World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until = 0	 	//World time when main power is restored.
	var/backup_power_lost_until = -1	//World time when backup power is restored.
	var/next_beep_at = 0				//World time when we may next beep due to doors being blocked by mobs
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = 0
	var/bolt_cut_state = BOLTS_FINE
	var/lights = 1 // bolt lights show by default
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0
	var/datum/wires/airlock/wires = null
	var/obj/item/device/magnetic_lock/bracer = null
	var/panel_visible_while_open = FALSE

	var/open_sound_powered = 'sound/machines/airlock.ogg'
	var/close_sound_powered = 'sound/machines/airlockclose.ogg'
	var/open_sound_unpowered = 'sound/machines/airlock_open_force.ogg'
	var/close_sound_unpowered = 'sound/machines/airlock_close_force.ogg'

	var/bolts_dropping = 'sound/machines/boltsdown.ogg'
	var/bolts_rising = 'sound/machines/boltsup.ogg'

	hashatch = 1

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/has_set_boltlight = FALSE

	var/insecure = 1 //if the door is insecure it will open when power runs out
	var/securitylock = 0

/obj/machinery/door/airlock/attack_generic(var/mob/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= 10)
			if(src.density)
				visible_message(span("danger", "\The [user] forces \the [src] open!"))
				open(1)
			else
				visible_message(span("danger", "\The [user] forces \the [src] closed!"))
				close(1)
		else
			visible_message(span("notice", "\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return
	..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return SSmaterials.get_material_by_name(mineral)
	return SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)

/obj/machinery/door/airlock/command
	name = "Airlock"
	icon = 'icons/obj/doors/Doorcom.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	hatch_colour = "#446892"

/obj/machinery/door/airlock/sac
	name = "Airlock"
	icon = 'icons/obj/doors/DoorSAC.dmi'
	assembly_type = null
	aiControlDisabled = 1
	hackProof = 1
	electrified_until = -1
	open_sound_powered = 'sound/machines/airlock_open_force.ogg'

/obj/machinery/door/airlock/security
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsec.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	hatch_colour = "#677c97"

/obj/machinery/door/airlock/engineering
	name = "Airlock"
	icon = 'icons/obj/doors/Dooreng.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	hatch_colour = "#caa638"

/obj/machinery/door/airlock/medical
	name = "Airlock"
	icon = 'icons/obj/doors/Doormed.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/Doormaint.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	hatch_colour = "#7d7d7d"

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorext.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	hashatch = 0
	insecure = 0

/obj/machinery/door/airlock/science
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsci.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	icon = 'icons/obj/doors/Doorsciglass.dmi'
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	open_sound_powered = 'sound/machines/windowdoor.ogg'
	close_sound_powered = 'sound/machines/windowdoor.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1
	panel_visible_while_open = TRUE
	hatch_colour = "#eaeaea"

/obj/machinery/door/airlock/centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	opacity = 0
	hatch_colour = "#606061"
	hashatch = FALSE

/obj/machinery/door/airlock/vaurca
	name = "Alien Biomass Airlock"
	icon = 'icons/obj/doors/Doorvaurca.dmi'
	opacity = 0
	hatch_colour = "#606061"
	hashatch = FALSE

/obj/machinery/door/airlock/centcom/attackby(obj/item/I, mob/user)
	if (operating)
		return

	if (allowed(user) && operable())
		if (density)
			open()
		else
			close()
	else
		do_animate("deny")

/obj/machinery/door/airlock/centcom/attack_ai(mob/user)
	return attackby(null, user)

/obj/machinery/door/airlock/centcom/take_damage()
	return	// No.

/obj/machinery/door/airlock/centcom/emag_act()
	return NO_EMAG_ACT

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_vault
	hashatch = 0
	maxhealth = 800
	panel_visible_while_open = TRUE
	insecure = 0

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	desc = "An extra thick, double-insulated door to preserve the cold atmosphere. Keep closed at all times."
	maxhealth = 800
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre
	hatch_colour = "#ffffff"
	open_duration = 20

/obj/machinery/door/airlock/freezer_maint
	name = "Freezer Maintenance Access"
	icon = 'icons/obj/doors/Doormaintfreezer.dmi'
	desc = "An extra thick, double-insulated door to preserve the cold atmosphere. Keep closed at all times."
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fma
	hatch_colour = "#ffffff"
	open_duration = 20

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	hatch_colour = "#5b5b5b"
	var/hatch_colour_bolted = "#695a5a"
	insecure = 0

/obj/machinery/door/airlock/hatch/update_icon()//Special hatch colour setting for this one snowflakey door that changes color when bolted
	if (hashatch)
		if(density && locked && lights && src.arePowerSystemsOn())
			hatch_image.color = hatch_colour_bolted
		else
			hatch_image.color = hatch_colour
	..()

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch
	hatch_colour = "#7d7d7d"

/obj/machinery/door/airlock/glass_command
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorcomglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1
	hatch_colour = "#3e638c"

/obj/machinery/door/airlock/glass_engineering
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorengglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1
	hatch_colour = "#caa638"

/obj/machinery/door/airlock/glass_security
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorsecglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1
	hatch_colour = "#677c97"

/obj/machinery/door/airlock/glass_medical
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doormedglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doormining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	hatch_colour = "#c29142"

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	hatch_colour = "#caa638"

/obj/machinery/door/airlock/research
	name = "Airlock"
	icon = 'icons/obj/doors/Doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/glass_research
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorresearchglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	heat_proof = 1
	hatch_colour = "#d2d2d2"

/obj/machinery/door/airlock/glass_mining
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorminingglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1
	hatch_colour = "#c29142"

/obj/machinery/door/airlock/glass_atmos
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Dooratmoglass.dmi'
	hitsound = 'sound/effects/glass_hit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1
	hatch_colour = "#caa638"

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = "gold"
	hatch_colour = "#dbbb2b"

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral = "silver"
	hatch_colour = "#ffffff"

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral = "diamond"
	hatch_colour = "#66eeee"
	maxhealth = 2000

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/Doorsand.dmi'
	mineral = "sandstone"
	hatch_colour = "#efc8a8"

/obj/machinery/door/airlock/palepurple
	name = "airlock"
	icon = 'icons/obj/doors/Doorpalepurple.dmi'
	hashatch = FALSE

/obj/machinery/door/airlock/highsecurity
	name = "Secure Airlock"
	icon = 'icons/obj/doors/hightechsecurity.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	hatch_colour = "#5a5a66"
	maxhealth = 600
	insecure = 0

/obj/machinery/door/airlock/skrell
	name = "airlock"
	icon = 'icons/obj/doors/purple_skrell_door.dmi'
	explosion_resistance = 20
	secured_wires = 1
	maxhealth = 600
	insecure = 0
	hashatch = FALSE

/obj/machinery/door/airlock/skrell/grey
	icon = 'icons/obj/doors/grey_skrell_door.dmi'

//---Uranium doors
/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0
	hatch_colour = "#004400"

/obj/machinery/door/airlock/uranium/machinery_process()
	if(world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/living/L in range (3,src))
		L.apply_effect(15,IRRADIATE, blocked = L.getarmor(null, "rad"))
	return

//---Phoron door
/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorphoron.dmi'
	mineral = "phoron"
	hatch_colour = "#891199"

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas("phoron", 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

//-------------------------

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/



/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(user))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(var/wireIndex)
	// You can find the wires in the datum folder.
	return QDELETED(wires) ? FALSE : wires.IsIndexCut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(src.isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return 1
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return 1
	return 0

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_MAIN_POWER1) || src.isWireCut(AIRLOCK_WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) || src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)
	if (main_power_lost_until > 0)
		addtimer(CALLBACK(src, .proc/regainMainPower), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)
		addtimer(CALLBACK(src, .proc/regainBackupPower), 10 SECONDS, TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)
	if (backup_power_lost_until > 0)
		addtimer(CALLBACK(src, .proc/regainBackupPower), 60 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		src.electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		src.electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		src.electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			LAZYADD(shockedby, "\[[time_stamp()]\] - [usr](ckey:[usr.ckey])")
			usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>")
		else
			LAZYADD(shockedby, "\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		src.electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)
		if (electrified_until > 0)
			addtimer(CALLBACK(src, .proc/electrify, 0), duration SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_NO_HASH_WAIT)

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (src.isWireCut(AIRLOCK_WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = 0
	else if (activate && !src.safe)
		safe = 1

	if(feedback && message)
		to_chat(usr, message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0

// Only set_light() if there's a change, no need to waste processor cycles with lighting updates.
/obj/machinery/door/airlock/update_icon()
	if (QDELING(src))
		return
	cut_overlays()
	var/list/new_overlays = list()
	if(density)
		if(locked && lights && src.arePowerSystemsOn())
			icon_state = "door_locked"
			if (!has_set_boltlight)
				set_light(2, 0.75, COLOR_RED_LIGHT)
				has_set_boltlight = TRUE
		else
			icon_state = "door_closed"
			if (has_set_boltlight)
				set_light(0)
				has_set_boltlight = FALSE
		if(p_open || welded)
			if(p_open)
				new_overlays += "panel_open"
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					new_overlays += "sparks_broken"
				else if (health < maxhealth * 3/4)
					new_overlays += "sparks_damaged"
			if(welded)
				new_overlays += "welded"
		else if (health < maxhealth * 3/4 && !(stat & NOPOWER))
			new_overlays += "sparks_damaged"

		if (hatch_image)
			if (hatchstate)
				hatch_image.icon_state = "[hatchstyle]_open"
			else
				hatch_image.icon_state = hatchstyle
			new_overlays += hatch_image
	else
		if(p_open && panel_visible_while_open)
			icon_state = "o_door_open"
		else
			icon_state = "door_open"

		if((stat & BROKEN) && !(stat & NOPOWER))
			add_overlay("sparks_open")
		if (has_set_boltlight)
			set_light(0)
			has_set_boltlight = FALSE

	add_overlay(new_overlays)

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			cut_overlays()
			compile_overlays()	// Flick will prevent SSoverlays from changing the overlay list mid-flick, so we force it.
			if(p_open)
				flick("o_door_opening", src)
				update_icon()
			else
				flick(stat ? "door_opening_stat" : "door_opening", src)
				update_icon()
		if("closing")
			if(overlays)
				cut_overlays()
				compile_overlays()
			if(p_open)
				flick("o_door_closing", src)
				update_icon()
			else
				flick(stat ? "door_closing_stat" : "door_closing", src)
				update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && src.arePowerSystemsOn())
				flick("door_deny", src)
				if(secured_wires)
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
		if ("braced")
			if (src.arePowerSystemsOn())
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/hydraulic_short.ogg', 50, 0)

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]

	data["main_power_loss"]		= round(main_power_lost_until 	> 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until,	1)
	data["backup_power_loss"]	= round(backup_power_lost_until	> 0 ? max(backup_power_lost_until - world.time,	0) / 10 : backup_power_lost_until,	1)
	data["electrified"] 		= round(electrified_until		> 0 ? max(electrified_until - world.time, 	0) / 10 	: electrified_until,		1)
	data["open"] = !density

	var/commands[0]
	commands[++commands.len] = list("name" = "IdScan",					"command"= "idscan",				"active" = !aiDisabledIdScanner,	"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Bolts",					"command"= "bolts",					"active" = !locked,					"enabled" = "Raised ",	"disabled" = "Dropped",		"danger" = 0, "act" = 0)
	commands[++commands.len] = list("name" = "Bolt Lights",				"command"= "lights",				"active" = lights,					"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Safeties",				"command"= "safeties",				"active" = safe,					"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Timing",					"command"= "timing",				"active" = normalspeed,				"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Door State",				"command"= "open",					"active" = density,					"enabled" = "Closed",	"disabled" = "Opened", 		"danger" = 0, "act" = 0)

	data["commands"] = commands

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_control.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.aiHacking==0)
		src.aiHacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.aiControlDisabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.aiHacking = 0
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (DEFAULT_WALL_MATERIAL in i.matter) && i.matter[DEFAULT_WALL_MATERIAL] > 0)
				spark(src, 5, alldirs)
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.getBrainLoss() >= 50)
			if(prob(40) && src.density)
				playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
				if(!istype(H.head, /obj/item/clothing/head/helmet))
					user.visible_message(span("warning", "[user] headbutts the airlock."))
					var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
					H.Stun(8)
					H.Weaken(5)
					if(affecting.take_damage(10, 0))
						H.UpdateDamageIcon()
				else
					user.visible_message(span("warning", "[user] headbutts the airlock. Good thing they're wearing a helmet."))
				return

		if(H.species.can_shred(H))

			if(!src.density)
				return

			H.visible_message("\The [H] begins to pry open \the [src]!", "You begin to pry open \the [src]!", "You hear the sound of an airlock being forced open.")

			if(!do_after(H, 120, 1, act_target = src))
				return

			src.do_animate("spark")
			src.stat |= BROKEN
			var/check = src.open(1)
			H.visible_message("\The [H] slices \the [src]'s controls[check ? ", ripping it open!" : ", breaking it!"]", "You slice \the [src]'s controls[check ? ", ripping it open!" : ", breaking it!"]", "You hear something sparking.")
			return
	if(src.p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(var/obj/item/tool, var/mob/user)
	var/cut_delay = 200
	var/cut_verb
	var/cut_sound
	var/cutting = FALSE

	if(istype(tool,/obj/item/weldingtool))
		var/obj/item/weldingtool/WT = tool
		if(!WT.isOn())
			return
		if(!WT.remove_fuel(0,user))
			to_chat(user, span("notice", "You need more welding fuel to complete this task."))
			return
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 1.5/WT.toolspeed
		cutting = TRUE
	else if(istype(tool,/obj/item/gun/energy/plasmacutter))
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 1
		cutting = TRUE
	else if(istype(tool,/obj/item/melee/energy/blade) || istype(tool,/obj/item/melee/energy/sword))
		cut_verb = "slicing"
		cut_sound = "sparks"
		cut_delay *= 1
		cutting = TRUE
	else if(istype(tool,/obj/item/surgery/circular_saw))
		cut_verb = "sawing"
		cut_sound = 'sound/weapons/saw/circsawhit.ogg'
		cut_delay *= 2
		cutting = TRUE
	else if(istype(tool,/obj/item/material/twohanded/fireaxe))
		//fireaxe can smash open the bolt cover instantly
		var/obj/item/material/twohanded/fireaxe/F = tool
		if (!F.wielded)
			return FALSE
		if(src.bolt_cut_state == BOLTS_FINE)
			to_chat(user, span("warning", "You smash the bolt cover open!"))
			playsound(src, 'sound/weapons/smash.ogg', 100, 1)
			src.bolt_cut_state = BOLTS_EXPOSED
		else if(src.bolt_cut_state != BOLTS_FINE)
			cut_verb = "smashing"
			cut_sound = 'sound/weapons/smash.ogg'
			cut_delay *= 1
			cutting = TRUE
	if(cutting)
		cut_procedure(user, cut_delay, cut_verb, cut_sound)
	else
		return FALSE

/obj/machinery/door/airlock/proc/cut_procedure(var/mob/user, var/cut_delay, var/cut_verb, var/cut_sound)
	if(src.bolt_cut_state == BOLTS_FINE)
		to_chat(user, "You begin [cut_verb] through the bolt panel.")
	else if(src.bolt_cut_state == BOLTS_EXPOSED)
		to_chat(user, "You begin [cut_verb] through the door bolts.")

	cut_delay *= 0.25

	var/i
	for(i = 0; i < 4; i += 1)
		if(i == 0)
			if(do_after(user, cut_delay, src))
				to_chat(user, span("notice", "You're a quarter way through."))
				playsound(src, cut_sound, 100, 1)
		else if(i == 1)
			if(do_after(user, cut_delay, src))
				to_chat(user, span("notice", "You're halfway through."))
				playsound(src, cut_sound, 100, 1)
		else if(i == 2)
			if(do_after(user, cut_delay, src))
				to_chat(user, span("notice", "You're three quarters through."))
				playsound(src, cut_sound, 100, 1)
		else if(i == 3)
			if(do_after(user, cut_delay, src))
				playsound(src, cut_sound, 100, 1)
				if(src.bolt_cut_state == BOLTS_FINE)
					to_chat(user, span("notice", "You remove the cover and expose the door bolts."))
					src.bolt_cut_state = BOLTS_EXPOSED
				else if(src.bolt_cut_state == BOLTS_EXPOSED)
					to_chat(user, span("notice", "You sever the door bolts, unlocking the door."))
					src.bolt_cut_state = BOLTS_CUT
					src.unlock(TRUE) //force it

/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(operating < 0) //emagged
		to_chat(user, span("warning", "Unable to interface: Internal error."))
		return STATUS_CLOSE
	if(issilicon(user) && !src.canAIControl())
		if(src.canAIHack(user))
			src.hack(user)
		else
			if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
				to_chat(user, span("warning", "Unable to interface: Connection timed out."))
			else
				to_chat(user, span("warning", "Unable to interface: Connection refused."))
		return STATUS_CLOSE

	return ..()

/obj/machinery/door/airlock/Topic(href, href_list)
	if(..())
		return 1

	var/activate = text2num(href_list["activate"])
	switch (href_list["command"])
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts")
			if(src.isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
				to_chat(usr, "The door bolt control wire is cut - Door bolts permanently dropped.")
			else if(activate && src.lock())
				to_chat(usr, "The door bolts have been dropped.")
			else if(!activate && src.unlock())
				to_chat(usr, "The door bolts have been raised.")
		if("electrify_temporary")
			electrify(30 * activate, 1)
		if("electrify_permanently")
			electrify(-1 * activate, 1)
		if("open")
			if(src.welded)
				to_chat(usr, text("The airlock has been welded shut!"))
			else if(src.locked)
				to_chat(usr, text("The door bolts are down!"))
			else if(activate && density)
				open()
				if (isAI(usr))
					SSfeedback.IncrementSimpleStat("AI_DOOR")
			else if(!activate && !density)
				close()
		if("safeties")
			set_safeties(!activate, 1)
		if("timing")
			// Door speed control
			if(src.isWireCut(AIRLOCK_WIRE_SPEED))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (activate && src.normalspeed)
				normalspeed = 0
			else if (!activate && !src.normalspeed)
				normalspeed = 1
		if("lights")
			// Bolt lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = 0
				to_chat(usr, "The door bolt lights have been disabled.")
			else if (activate && !src.lights)
				lights = 1
				to_chat(usr, "The door bolt lights have been enabled.")
	update_icon()
	return 1



/obj/machinery/door/airlock/proc/CreateAssembly()
	var/obj/structure/door_assembly/da = new assembly_type(src.loc)
	if (istype(da, /obj/structure/door_assembly/multi_tile))
		da.set_dir(src.dir)

	da.anchored = 1
	if(mineral)
		da.glass = mineral
	else if(glass && !da.glass)
		da.glass = 1
	da.state = 1
	da.created_name = src.name
	da.update_state()
	if(operating == -1 || (stat & BROKEN))
		new /obj/item/circuitboard/broken(src.loc)
		operating = 0
	else
		if (!electronics) create_electronics()
		electronics.forceMove(src.loc)
		electronics = null
	qdel(src)


/obj/machinery/door/airlock/proc/CanChainsaw(var/obj/item/material/twohanded/chainsaw/ChainSawVar)
	return (ChainSawVar.powered && density && hashatch)

/obj/machinery/door/airlock/attackby(var/obj/item/C, mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/taperoll))
		return
	if(!istype(C, /obj/item/forensics))
		src.add_fingerprint(user)
	if (!repairing && (stat & BROKEN) && src.locked) //bolted and broken
		if (!cut_bolts(C,user))
			..()
		return
	if (istype(C, /obj/item/device/magnetic_lock))
		if (bracer)
			to_chat(user, span("notice", "There is already a [bracer] on [src]!"))
			return
		var/obj/item/device/magnetic_lock/newbracer = C
		newbracer.attachto(src, user)
		return
	if(!repairing && (C.iswelder() && !( src.operating > 0 ) && src.density))
		var/obj/item/weldingtool/WT = C
		if(WT.isOn())
			user.visible_message(
				span("warning", "[user] begins welding [src] [welded ? "open" : "shut"]."),
				span("notice", "You begin welding [src] [welded ? "open" : "shut"]."),
				"You hear a welding torch on metal."
			)
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if (!do_after(user, 2/C.toolspeed SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_open, src.density)))
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, span("notice", "You need more welding fuel to complete this task."))
				return
			playsound(src, 'sound/items/Welder2.ogg', 50, 1)
			welded = !welded
			update_icon()
			return
		else
			return
	else if(C.isscrewdriver())
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(usr, span("warning", "The panel is broken and cannot be closed."))
			else
				src.p_open = 0
		else
			src.p_open = 1
		src.update_icon()
	else if(C.iswirecutter())
		return src.attack_hand(user)
	else if(C.ismultitool())
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(!repairing && C.iscrowbar())
		if(istype(C, /obj/item/melee/arm_blade))
			if(!arePowerSystemsOn()) //if this check isn't done and empty, the armblade will never be used to hit the airlock
			else if(!(stat & BROKEN))
				..()
				return
		if(src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && !src.locked)))
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40/C.toolspeed))
				to_chat(user, span("notice", "You removed the airlock electronics!"))
				CreateAssembly()
				return
		else if(arePowerSystemsOn())
			to_chat(user, span("notice", "The airlock's motors resist your efforts to force it."))
		else if(locked)
			to_chat(user, span("notice", "The airlock's bolts prevent it from being forced."))
		else
			if(density)
				open(1)
			else
				close(1)
	else if(istype(C, /obj/item/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked && user.a_intent != I_HURT)
			to_chat(user, span("notice", "The airlock's bolts prevent it from being forced."))
		else if(locked && user.a_intent == I_HURT)
			..()
		else if(!welded && !operating)
			if(density)
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					open(1)
				else
					to_chat(user, span("warning", "You need to be wielding \the [C] to do that."))
			else
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					close(1)
				else
					to_chat(user, span("warning", "You need to be wielding \the [C] to do that."))
	else if(istype(C, /obj/item/melee/hammer) && !arePowerSystemsOn())
		if(locked && user.a_intent != I_HURT)
			to_chat(user, span("notice", "The airlock's bolts prevent it from being forced."))
		else if(locked && user.a_intent == I_HURT)
			..()
		else if(!welded && !operating)
			if(density)
				open(1)
			else
				close(1)
	else if(density && istype(C, /obj/item/material/twohanded/chainsaw))
		var/obj/item/material/twohanded/chainsaw/ChainSawVar = C
		if(!ChainSawVar.wielded)
			to_chat(user, span("notice", "Cutting the airlock requires the strength of two hands."))
		else if(ChainSawVar.cutting)
			to_chat(user, span("notice", "You are already cutting an airlock open."))
		else if(!ChainSawVar.powered)
			to_chat(user, span("notice", "The [C] needs to be on in order to open this door."))
		else if(bracer) //Has a magnetic lock
			to_chat(user, span("notice", "The bracer needs to be removed in order to cut through this door."))
		else if(!arePowerSystemsOn())
			ChainSawVar.cutting = 1
			user.visible_message(\
				span("danger", "[user.name] starts cutting the control pannel of the airlock with the [C]!"),\
				span("warning", "You start cutting the airlock control panel..."),\
				span("notice", "You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, .proc/CanChainsaw, C)))
				user.visible_message(\
					span("warning", "[user.name] finishes cutting the control pannel of the airlock with the [C]."),\
					span("warning", "You finish cutting the airlock control panel."),\
					span("notice", "You hear a metal clank and some sparks.")\
				)
				set_broken()
				sleep(1 SECONDS)
				CreateAssembly()
			ChainSawVar.cutting = 0
			take_damage(50)
		else if(locked)
			ChainSawVar.cutting = 1
			user.visible_message(\
				span("danger", "[user.name] starts cutting below the airlock with the [C]!"),\
				span("warning", "You start cutting below the airlock..."),\
				span("notice", "You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, .proc/CanChainsaw, C)))
				user.visible_message(\
					span("warning", "[user.name] finishes cutting below the airlock with the [C]."),\
					span("notice", "You finish cutting below the airlock."),\
					span("notice", "You hear a metal clank and some sparks.")\
				)
				unlock(1)
			ChainSawVar.cutting = 0
			take_damage(50)
		else
			ChainSawVar.cutting = 1
			user.visible_message(\
				span("danger", "[user.name] starts cutting between the airlock with the [C]!"),\
				span("warning", "You start cutting between the airlock..."),\
				span("notice", "You hear a loud buzzing sound and metal grinding on metal...")\
			)
			if(do_after(user, ChainSawVar.opendelay SECONDS, act_target = user, extra_checks  = CALLBACK(src, .proc/CanChainsaw, C)))
				user.visible_message(\
					span("warning", "[user.name] finishes cutting between the airlock."),\
					span("warning", "You finish cutting between the airlock."),\
					span("notice", "You hear a metal clank and some sparks.")\
				)
				open(1)
				take_damage(50)
			ChainSawVar.cutting = 0
	else
		..()
	return

/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken()
	src.p_open = 1
	stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name]'s control panel bursts open, sparks spewing out!")

	spark(src, 5, alldirs)

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))

		return 0
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 60, 1)
	else
		playsound(src.loc, open_sound_unpowered, 60, 1)

	if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
		src.closeOther.close()
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(!forced)
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return 0
	if (bracer)
		do_animate("braced")
		visible_message(span("warning", "[src]'s actuators whirr, but the door does not open."))
		return 0
	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0
	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return	0
	return ..()

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return 0

/obj/structure/window/blocks_airlock()
	return 0

/obj/machinery/mech_sensor/blocks_airlock()
	return 0

/mob/living/blocks_airlock()
	return mob_size > MOB_SMALL

/atom/movable/proc/airlock_crush(var/crush_damage)
	return 0

/obj/structure/window/airlock_crush(var/crush_damage)
	return 0

/obj/machinery/portable_atmospherics/canister/airlock_crush(var/crush_damage)
	. = ..()
	health -= crush_damage
	healthcheck()

/obj/effect/energy_field/airlock_crush(var/crush_damage)
	Stress(crush_damage)

/obj/structure/closet/airlock_crush(var/crush_damage)
	..()
	damage(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return 1

/mob/living/airlock_crush(var/crush_damage)
	. = ..()
	for(var/i = 1, i <= AIRLOCK_CRUSH_DIVISOR, i++)
		adjustBruteLoss(round(crush_damage / AIRLOCK_CRUSH_DIVISOR))
	SetStunned(5)
	SetWeakened(5)

	var/turf/T = get_turf(src)

	var/list/valid_turfs = list()
	for(var/dir_to_test in cardinal)
		var/turf/new_turf = get_step(T, dir_to_test)
		if(!new_turf.contains_dense_objects())
			valid_turfs |= new_turf

	while(valid_turfs.len)
		T = pick(valid_turfs)
		valid_turfs -= T

		if(src.forceMove(T))
			return


/mob/living/carbon/airlock_crush(var/crush_damage)
	. = ..()
	if (can_feel_pain())
		emote("scream")

/mob/living/silicon/robot/airlock_crush(var/crush_damage)
	return ..(round(crush_damage / CYBORG_AIRLOCKCRUSH_RESISTANCE))

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0
	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					close_door_in(6)
					return
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(DOOR_CRUSH_DAMAGE))
				take_damage(DOOR_CRUSH_DAMAGE)
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 100, 1)
	else
		playsound(src.loc, close_sound_unpowered, 100, 1)

	..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0
	if (operating && !forced) return 0
	if (bolt_cut_state == BOLTS_CUT) return 0 //what bolts?
	src.locked = 1
	playsound(src, bolts_dropping, 30, 0, -6)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return
	if (!forced)
		if(operating || !src.arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS)) return
	src.locked = 0
	playsound(src, bolts_rising, 30, 0, -6)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

/obj/machinery/door/airlock/Initialize(mapload, obj/structure/door_assembly/assembly = null)
	var/on_admin_z = FALSE
	//wires & hatch - this needs to be done up here so the hatch isn't generated by the parent Initialize().
	if(loc && isAdminLevel(z))
		on_admin_z = TRUE
		hashatch = FALSE

	. = ..()

	//if assembly is given, create the new door from the assembly
	if (istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.forceMove(src)

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		if(electronics.one_access)
			req_access = null
			req_one_access = electronics.conf_access
		else
			req_one_access = null
			req_access = electronics.conf_access

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

	if (on_admin_z)
		secured_wires = TRUE

	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

	if(mapload && src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in SSmachinery.processing_machines)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/airlock_electronics/secure( src.loc )
	else
		src.electronics = new/obj/item/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(!src.req_access)
		src.check_access()
	if(LAZYLEN(req_access))
		electronics.conf_access = src.req_access
	else if (LAZYLEN(req_one_access))
		electronics.conf_access = src.req_one_access
		electronics.one_access = 1

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(40/severity))
		var/duration = SecondsToTicks(30 / severity)
		if(electrified_until > -1 && (duration + world.time) > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		// Keeping door lights on, runs on internal battery or something.
		electrified_until = 0
		//if we lost power open 'er up
		if(insecure)
			INVOKE_ASYNC(src, /obj/machinery/door/.proc/open, 1)
			securitylock = 1
	else if(securitylock)
		INVOKE_ASYNC(src, /obj/machinery/door/.proc/close, 1)
		securitylock = 0
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(bracer)
		return

	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return

/obj/machinery/door/airlock/examine()
	..()
	if (bolt_cut_state == BOLTS_EXPOSED)
		to_chat(usr, "The bolt cover has been cut open.")
	if (bolt_cut_state == BOLTS_CUT)
		to_chat(usr, "The door bolts have been cut.")
	if(bracer)
		to_chat(usr, "\The [bracer] is installed on \the [src], preventing it from opening.")
		to_chat(usr, bracer.health)

#undef AIRLOCK_CRUSH_DIVISOR
#undef CYBORG_AIRLOCKCRUSH_RESISTANCE
#undef BOLTS_FINE
#undef BOLTS_EXPOSED
#undef BOLTS_CUT