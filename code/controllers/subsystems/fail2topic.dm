SUBSYSTEM_DEF(fail2topic)
	name = "Fail2Topic"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_BACKGROUND
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY | RUNLEVEL_INIT

	var/list/rate_limiting = list()
	var/list/fail_counts = list()
	var/list/active_bans = list()

	var/rate_limit
	var/max_fails
	var/enabled = FALSE

/datum/controller/subsystem/fail2topic/Initialize(timeofday)
	rate_limit = GLOB.config.fail2topic_rate_limit
	max_fails = GLOB.config.fail2topic_max_fails
	enabled = GLOB.config.fail2topic_enabled

	DropFirewallRule() // Clear the old bans if any still remain


	if (world.system_type == UNIX && enabled)
		enabled = FALSE
		log_subsystem_fail2topic("Subsystem disabled due to it not supporting UNIX.")

	if (!enabled)
		can_fire = FALSE
		flags |= SS_NO_FIRE

	return SS_INIT_SUCCESS

/datum/controller/subsystem/fail2topic/fire()
	while (rate_limiting.len)
		var/ip = rate_limiting[1]
		var/last_attempt = rate_limiting[ip]

		if (world.time - last_attempt > rate_limit)
			rate_limiting -= ip
			fail_counts -= ip

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/fail2topic/Shutdown()
	DropFirewallRule()

/datum/controller/subsystem/fail2topic/proc/IsRateLimited(ip)
	var/last_attempt = rate_limiting[ip]

	if (GLOB.config?.api_rate_limit_whitelist[ip])
		return FALSE

	if (active_bans[ip])
		return TRUE

	rate_limiting[ip] = world.time

	if (isnull(last_attempt))
		return FALSE

	if (world.time - last_attempt > rate_limit)
		fail_counts -= ip
		return FALSE
	else
		var/failures = fail_counts[ip]

		if (isnull(failures))
			fail_counts[ip] = 1
			return TRUE
		else if (failures > max_fails)
			BanFromFirewall(ip)
			return TRUE
		else
			fail_counts[ip] = failures + 1
			return TRUE

/datum/controller/subsystem/fail2topic/proc/BanFromFirewall(ip)
	if (!enabled)
		return
	var/static/regex/R = regex(@"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$") // Anything that interacts with a shell should be parsed. Prevents subnet banning and possible injection vulnerabilities
	R.Find(ip)
	ip = R.match
	if(length(ip) > 15 || length(ip) < 8)
		WARNING("BanFromFirewall was called with an invalid or unsafe IP")
		return FALSE

	active_bans[ip] = world.time
	fail_counts -= ip
	rate_limiting -= ip

	. = shell("netsh advfirewall firewall add rule name=\"[GLOB.config.fail2topic_rule_name]\" dir=in interface=any action=block remoteip=[ip]")

	if (.)
		log_subsystem_fail2topic("Failed to ban [ip]. Exit code: [.].")
	else if (isnull(.))
		log_subsystem_fail2topic("Failed to invoke ban script.")
	else
		log_subsystem_fail2topic("Banned [ip].")

/datum/controller/subsystem/fail2topic/proc/DropFirewallRule()
	if (!enabled)
		return

	active_bans = list()

	. = shell("netsh advfirewall firewall delete rule name=\"[GLOB.config.fail2topic_rule_name]\"")

	if (.)
		log_subsystem_fail2topic("Failed to drop firewall rule. Exit code: [.].")
	else if (isnull(.))
		log_subsystem_fail2topic("Failed to invoke ban script.")
	else
		log_subsystem_fail2topic("Firewall rule dropped.")
