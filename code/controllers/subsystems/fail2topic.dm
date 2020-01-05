var/datum/controller/subsystem/fail2topic/SSfail2topic

/datum/controller/subsystem/fail2topic
	name = "Fail2Topic"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_FIRE_IN_LOBBY | SS_BACKGROUND

	var/list/rate_limiting = list()
	var/list/fail_counts = list()
	var/list/active_bans = list()

	var/rate_limit
	var/ban_time
	var/max_fails
	var/rule_name
	var/enabled = FALSE

/datum/controller/subsystem/fail2topic/New()
	NEW_SS_GLOBAL(SSfail2topic)

/datum/controller/subsystem/fail2topic/Initialize(timeofday)
	rate_limit = config.fail2topic_rate_limit
	ban_time = config.fail2topic_ban_time
	max_fails = config.fail2topic_max_fails
	rule_name = config.fail2topic_rule_name
	enabled = config.fail2topic_enabled

	DropFirewallRule() // Clear the old bans if any still remain

	if (!enabled)
		suspended = TRUE

	. = ..()

/datum/controller/subsystem/fail2topic/fire()
	while (rate_limiting.len)
		var/ip = rate_limiting[0]
		var/last_attempt = rate_limiting[ip]

		if (world.time - last_attempt > rate_limit)
			rate_limiting -= ip

		if (MC_TICK_CHECK)
			return

	while (active_bans.len)
		var/ip = active_bans[0]
		var/time_banned = active_bans[ip]

		if (world.time - time_banned > ban_time)
			UnbanFromFirewall(ip)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/fail2topic/Shutdown()
	DropFirewallRule()

/datum/controller/subsystem/fail2topic/proc/IsRateLimited(ip)
	var/last_attempt = rate_limiting[ip]

	if (config?.api_rate_limit_whitelist[ip])
		return FALSE

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
		else if (failures > max_fails)
			BanFromFirewall(ip)
		else
			fail_counts[ip] = failures + 1

/datum/controller/subsystem/fail2topic/proc/BanFromFirewall(ip)
	active_bans[ip] = world.time
	fail_counts -= ip
	rate_limiting -= ip

	to_world("BANNING IP: [ip]")
	. = shell("./scripts/fail2topic/ban_ip.ps1 -RuleName \"[rule_name]\" -Address \"[ip]\"")

	if (.)
		log_ss("fail2topic", "Failed to ban [ip]. Exit code: [.].", log_world = TRUE, severity = SEVERITY_ERROR)
	else
		log_ss("fail2topic", "Banned [ip] for [ban_time SECONDS] seconds.", log_world = TRUE, severity = SEVERITY_NOTICE)

/datum/controller/subsystem/fail2topic/proc/UnbanFromFirewall(ip)
	active_bans -= ip

	to_world("UNBANNING IP: [ip]")
	. = shell("./scripts/fail2topic/unban_ip.ps1 -RuleName \"[rule_name]\" -Address \"[ip]\"")

	if (.)
		log_ss("fail2topic", "Failed to unban [ip]. Exit code: [.].", log_world = TRUE, severity = SEVERITY_ERROR)
	else
		log_ss("fail2topic", "Unbanned [ip].", log_world = TRUE, severity = SEVERITY_INFO)

/datum/controller/subsystem/fail2topic/proc/DropFirewallRule()
	active_bans = list()

	to_world("DROPPING RULE")
	. = shell("./scripts/fail2topic/drop_rule.ps1 -RuleName \"[rule_name]\"")

	if (.)
		crash_with("fail2topic/droprule failed.")
		log_ss("fail2topic", "Failed to drop firewall rule. Exit code: [.].", log_world = TRUE, severity = SEVERITY_ERROR)
	else
		log_ss("fail2topic", "Firewall rule dropped.", log_world = TRUE, severity = SEVERITY_INFO)
