var/datum/subsystem/vote/SSvote

/datum/subsystem/vote
	name = "Voting"
	wait = 1 SECONDS
	flags = SS_NO_INIT | SS_KEEP_TIMING | SS_FIRE_IN_LOBBY
	priority = SS_PRIORITY_VOTE

/datum/subsystem/vote/fire(resumed = FALSE)
	vote.process()
