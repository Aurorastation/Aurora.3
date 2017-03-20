/var/datum/controller/subsystem/airflow/SSairflow

#define CLEAR_OBJECT(LIST, TARGET) \
	LIST -= TARGET;                \
	TARGET.airflow_dest = null;    \
	TARGET.airflow_speed = 0;      \
	TARGET.airflow_time = 0;       \
	if (TARGET.airflow_od) {;      \
		TARGET.density = 0;        \
	}

/datum/controller/subsystem/airflow
	name = "Airflow"
	wait = 2
	flags = SS_TICKER | SS_NO_INIT

	var/list/pushing
	var/list/pulling

	var/tmp/list/current_pushing
	var/tmp/list/current_pulling

/datum/controller/subsystem/airflow/stat_entry()
	..("Push:[pushing.len] Pull:[pulling.len]")

/datum/controller/subsystem/airflow/New()
	NEW_SS_GLOBAL(SSairflow)
	pushing = list()
	pulling = list()

/datum/controller/subsystem/airflow/fire(resumed = FALSE)
	if (!resumed)
		current_pushing = pushing.Copy()
		current_pulling = pulling.Copy()

	var/list/curr_pull = current_pulling
	var/list/curr_push = current_pushing

	while (curr_pull.len)
		var/atom/movable/target = curr_pull[curr_pull.len]
		curr_pull.len--

		if (target.airflow_speed <= 0)
			CLEAR_OBJECT(pulling, target)
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
		if (target.airflow_od)
			target.density = 1

		if (!target.airflow_dest || target.loc == target.airflow_dest)
			target.airflow_dest = locate(min(max(target.x + target.airflow_xo, 1), world.maxx), min(max(target.y + target.airflow_yo, 1), world.maxy), target.z)

		if ((target.x == 1) || (target.x == world.maxx) || (target.y == 1) || (target.y == world.maxy))
			CLEAR_OBJECT(pulling, target)
			continue

		if (!isturf(loc))
			CLEAR_OBJECT(pulling, target)
			continue
		
		step_towards(target, target.airflow_dest)
		if (ismob(target) && target:client)
			target:setMoveCooldown(vsc.airflow_mob_slowdown)

		if (MC_TICK_CHECK)
			return

	while (curr_push.len)
		var/atom/movable/target = curr_push[curr_push.len]
		curr_push.len--

		if (target.airflow_speed <= 0)
			CLEAR_OBJECT(pushing, target)
			continue

		if (target.airflow_process_delay)
			target.airflow_process_delay -= 2
			continue

		

#undef CLEAR_OBJECT		

/atom/movable
	var/tmp/airflow_xo
	var/tmp/airflow_yo
	var/tmp/airflow_od
	var/tmp/airflow_process_delay
