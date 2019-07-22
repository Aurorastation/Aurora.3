
var/const/ENGSEC			=(1<<0)
var/const/MEDSCI			=(1<<1)
var/const/CIVILIAN			=(1<<2)

var/list/assistant_occupations = list() //Leaving this on one line stops Travis complaining ~Scopes

// TODO: refactor to type paths OR move to map datum.
var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"
)


var/list/engineering_positions = list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
	"Engineering Apprentice"
)


var/list/medical_positions = list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Psychiatrist",
	"Pharmacist",
	"Paramedic",
	"Medical Resident"
)


var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Roboticist",
	"Xenobiologist",
	"Lab Assistant"
)

//BS12 EDIT
var/list/cargo_positions = list(
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner"
)

var/list/civilian_positions = list(
	"Head of Personnel",
	"Internal Affairs Agent",
	"Bartender",
	"Gardener",
	"Chef",
	"Janitor",
	"Librarian",
	"Corporate Reporter",
	"Chaplain",
	"Assistant"
)


var/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Forensic Technician",
	"Security Officer",
	"Security Cadet"
)

var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI",
	"Merchant"
)

/proc/guest_jobbans(var/job)
	return ((job in command_positions) || job == "Internal Affairs Agent")

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles

//Mahzel : Job preview not added because code don't exist in BS12
