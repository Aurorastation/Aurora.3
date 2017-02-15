 /**
  * Failsafe
  *
  * Pretty much pokes the MC to make sure it's still alive.
 **/

// The users to poke when the shit starts hitting the fan.
#define FAILSAFE_NOTIFY (R_DEBUG|R_ADMIN|R_DEV)
#define FAILSAFE_PREFIX "<font color='#4863A0'>Failsafe</font> - "

var/datum/controller/failsafe/Failsafe

/datum/controller/failsafe // This thing pretty much just keeps poking the master controller
	name = "Failsafe"

	// The length of time to check on the MC (in deciseconds).
	// Set to 0 to disable.
	var/processing_interval = 20
	// The alert level. For every failed poke, we drop a DEFCON level. Once we hit DEFCON 1, restart the MC.
	var/defcon = 5
	//the world.time of the last check, so the mc can restart US if we hang.
	//	(Real friends look out for *eachother*)
	var/lasttick = 0

	// Track the MC iteration to make sure its still on track.
	var/master_iteration = 0

/datum/controller/failsafe/New()
	// Highlander-style: there can only be one! Kill off the old and replace it with the new.
	if(Failsafe != src)
		if(istype(Failsafe))
			qdel(Failsafe)
	Failsafe = src
	spawn()
		Failsafe.Loop()
		qdel(Failsafe) //when Loop() returns, we delete ourselves and let the mc recreate us


/datum/controller/failsafe/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW


/datum/controller/failsafe/proc/Loop()
	while(1)
		lasttick = world.time
		if(!Master)
			// Replace the missing Master! This should never, ever happen.
			new /datum/controller/master()
		// Only poke it if overrides are not in effect.
		if(processing_interval > 0)
			if(Master.processing && Master.iteration)
				// Check if processing is done yet.
				if(Master.iteration == master_iteration)
					switch(defcon)
						if(4,5)
							--defcon
						if(3)
							admin_notice("[FAILSAFE_PREFIX]<font color='black'>Notice: DEFCON [defcon_pretty()]. The Master Controller has not fired in the last [(5-defcon) * processing_interval] ticks.</font>", FAILSAFE_NOTIFY)
							--defcon
						if(2)
							admin_notice(span("danger", "[FAILSAFE_PREFIX]Warning: DEFCON [defcon_pretty()]. The Master Controller has not fired in the last [(5-defcon) * processing_interval] ticks. Automatic restart in [processing_interval] ticks."), FAILSAFE_NOTIFY)
							--defcon
						if(1)

							admin_notice(span("danger", "[FAILSAFE_PREFIX]Warning: DEFCON [defcon_pretty()]. The Master Controller has still not fired within the last [(5-defcon) * processing_interval] ticks. Killing and restarting..."), FAILSAFE_NOTIFY)
							--defcon
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								admin_notice("<font color='black'>[FAILSAFE_PREFIX] Master Controller restarted successfully!</font>", FAILSAFE_NOTIFY)
							else if(rtn < 0)
								log_game("FailSafe: Could not restart MC, runtime encountered. Entering defcon 0")
								admin_notice(span("danger", "[FAILSAFE_PREFIX]ERROR: DEFCON [defcon_pretty()]. Unable to restart Master Controller, runtime encountered. Silently retrying."), FAILSAFE_NOTIFY)
							//if the return number was 0, it just means the mc was restarted too recently, and it just needs some time before we try again
							//no need to handle that specially when defcon 0 can handle it
						if(0) //DEFCON 0! (mc failed to restart)
							var/rtn = Recreate_MC()
							if(rtn > 0)
								defcon = 4
								master_iteration = 0
								admin_notice("[FAILSAFE_PREFIX]<font color='black'>Failsafe: Master Controller restarted successfully!</font>", FAILSAFE_NOTIFY)
				else
					defcon = min(defcon + 1,5)
					master_iteration = Master.iteration
			if (defcon <= 1)
				sleep(processing_interval*2)
			else
				sleep(processing_interval)
		else
			defcon = 5
			sleep(initial(processing_interval))

/datum/controller/failsafe/proc/defcon_pretty()
	return defcon

/datum/controller/failsafe/proc/stat_entry()
	if(!statclick)
		statclick = new/obj/effect/statclick/debug("Initializing...", src)

	stat("Failsafe Controller:", statclick.update("Defcon: [defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])"))

#undef FAILSAFE_NOTIFY
#undef FAILSAFE_PREFIX
