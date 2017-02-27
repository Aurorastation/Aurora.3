var/datum/subsystem/vote/SSvote

/datum/subsystem/vote
	name = "Voting"
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING | SS_FIRE_IN_LOBBY
	priority = SS_PRIORITY_VOTE

	var/next_transfer_time

/datum/subsystem/vote/Initialize(timeofday)
	next_transfer_time = config.vote_autotransfer_initial
	..(timeofday, silent = TRUE)

/datum/subsystem/vote/fire(resumed = FALSE)
	vote.process()

	if (world.time >= next_transfer_time - 600)
		vote.autotransfer()
		next_transfer_time += config.vote_autotransfer_interval
