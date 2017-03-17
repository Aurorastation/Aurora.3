/var/datum/controller/subsystem/airflow/SSairflow

/datum/controller/subsystem/airflow
	name = "Airflow"
	wait = 2
	flags = SS_TICKER | SS_NO_INIT

	var/list/pushing
	var/list/pulling

	var/tmp/list/current_pushing
	var/tmp/list/current_pulling

/datum/controller/subsystem/airflow/New()
	NEW_SS_GLOBAL(SSairflow)

/datum/controller/subsystem/airflow/fire(resumed = FALSE)
	if (!resumed)
		current_pushing = pushing.Copy()
		current_pulling = pulling.Copy()

	var/list/curr_pull = current_pulling
	var/list/curr_push = current_pushing

	while (current_pulling.len)
		var/atom/movable/target = current_pulling[current_pulling.len]
		current_pulling.len--

		if (target.airflow_speed <= 0)
			pulling -= target
			continue

		if (target.airflow_process_delay)
			target.airflow_process_delay -= 2
			continue
		
		target.airflow_speed = min(target.airflow_speed, 15)
		target.airflow_speed -= vsc.airflow_speed_decay
		if (target.airflow_speed > 7)
			if (target.airflow_time++ >= target.airflow_speed - 7)
				if (target.airflow_od)
					target.density = 0
				continue
		else
			if (target.airflow_od)
				target.density = 0
			target.airflow_process_delay = max(1, 10 - (target.airflow_speed + 3))
			continue

/atom/movable
	var/tmp/airflow_xo
	var/tmp/airflow_yo
	var/tmp/airflow_od
	var/tmp/airflow_process_delay
