/datum/controller/subsystem/job
	name = "Job"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/job/Initialize(timeofday)
	job_master = new /datum/controller/occupations()
	job_master.SetupOccupations()
	job_master.LoadJobs("config/jobs.txt")
