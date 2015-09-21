
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)
var/const/INTERN_SEC		=(1<<10)
var/const/INTERN_ENG		=(1<<11)
var/const/FORENSICS			=(1<<12)


var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/PARAMEDIC			=(1<<5)
var/const/GENETICIST		=(1<<6)
var/const/VIROLOGIST		=(1<<7)
var/const/PSYCHIATRIST		=(1<<8)
var/const/ROBOTICIST		=(1<<9)
var/const/XENOBIOLOGIST		=(1<<10)
var/const/INTERN_MED		=(1<<11)
var/const/INTERN_SCI		=(1<<12)



var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/ASSISTANT			=(1<<13)


var/list/assistant_occupations = list(
)


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
	"Geneticist",
	"Psychiatrist",
	"Chemist",
	"Emergency Medical Tech",
	"Nursing Intern"
)


var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Geneticist",	//Part of both medical and science
	"Roboticist",
	"Xenobiologist",
	"Lab Assistant"
)

//BS12 EDIT
var/list/civilian_positions = list(
	"Head of Personnel",
	"Bartender",
	"Gardener",
	"Chef",
	"Janitor",
	"Librarian",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner",
	"Lawyer",
	"Chaplain",
	"Intern",
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
	"pAI"
)


/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))

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
		if(!J)	continue
		if(J.title == job)
			titles = J.alt_titles

	return titles



// All this datum/preview/job stuff is for the preview icon when you're building your character.
// See code\modules\mob\new_player\preferences_setup.dm for where it's used

datum/preview/job
	var/job_type=null
	var/job_index=null
	var/uniform_icon='icons/mob/uniform.dmi'
	var/uniform_state="grey_s"
	var/mask_icon='icons/mob/mask.dmi'
	var/mask_state=null
	var/hat_state=null
	var/hat_icon='icons/mob/head.dmi'
	var/gloves_icon='icons/mob/hands.dmi'
	var/gloves_state=null
	var/shoes_icon='icons/mob/feet.dmi'
	var/shoes_state="black"
	var/jacket_icon='icons/mob/suit.dmi'
	var/jacket_state=null
	var/belt_icon='icons/mob/belt.dmi'
	var/belt_state=null
	var/backpack_01_icon='icons/mob/back.dmi'
	var/backpack_01_state="backpack"
	var/backpack_02_icon='icons/mob/back.dmi'
	var/backpack_02_state="satchel-norm"
	var/backpack_03_icon='icons/mob/back.dmi'
	var/backpack_03_state="satchel"

datum/preview/job/proc/blend_icon(var/icon/result_icon, var/current_icon, var/current_state, var/blend_type)
	if (current_state)
		result_icon.Blend(new /icon(current_icon,current_state),blend_type)

datum/preview/job/proc/create_clothes_icon(var/backpack_selection)
	var/icon/result=new /icon(uniform_icon, uniform_state)
	blend_icon(result,shoes_icon,shoes_state,ICON_UNDERLAY)
	blend_icon(result,gloves_icon,gloves_state,ICON_UNDERLAY)
	blend_icon(result,belt_icon,belt_state,ICON_OVERLAY)
	blend_icon(result,jacket_icon,jacket_state,ICON_OVERLAY)
	blend_icon(result,mask_icon,mask_state,ICON_OVERLAY)
	blend_icon(result,hat_icon,hat_state,ICON_OVERLAY)
	switch(backpack_selection)
		if(2)
			blend_icon(result,backpack_01_icon,backpack_01_state,ICON_OVERLAY)
		if(3)
			blend_icon(result,backpack_02_icon,backpack_02_state,ICON_OVERLAY)
		if(4)
			blend_icon(result,backpack_03_icon,backpack_03_state,ICON_OVERLAY)
	return result


datum/preview/job/engsec
	job_type=ENGSEC

datum/preview/job/engsec/captain
	job_index=CAPTAIN
	uniform_state="captain_s"
	shoes_state="brown"
	hat_state="captain"
	backpack_02_state="satchel-cap"

datum/preview/job/engsec/security
	shoes_state="jackboots"
	gloves_state="bgloves"
	backpack_01_state="securitypack"
	backpack_02_state="satchel-sec"

datum/preview/job/engsec/security/head_of_security
	job_index=HOS
	uniform_state="hosred_s"
	hat_state="hosberet"

datum/preview/job/engsec/security/warden
	job_index=WARDEN
	uniform_state="warden_s"

datum/preview/job/engsec/security/officer
	job_index=OFFICER
	uniform_state="secred_s"

datum/preview/job/engsec/detective
	job_index=DETECTIVE
	uniform_state="wardentanclothes_s"
	gloves_state="bgloves"

datum/preview/job/engsec/forensics
	job_index=FORENSICS
	uniform_state="polsuit_s"
	jacket_state="labcoat_open"

datum/preview/job/engsec/chief_of_engineering
	job_index=CHIEF
	uniform_state="chief_s"
	shoes_state="brown"
	belt_state="utility"
	hat_state="hardhat0_white"
	backpack_01_state="engiepack"
	backpack_02_state="satchel-eng"

datum/preview/job/engsec/engineer
	job_index=ENGINEER
	uniform_state="engine_s"
	shoes_state="orange"
	belt_state="utility"
	hat_state="hardhat0_yellow"
	backpack_01_state="engiepack"
	backpack_02_state="satchel-eng"

datum/preview/job/engsec/atmospherics_tech
	job_index=ATMOSTECH
	uniform_state="atmos_s"
	shoes_state="black"
	gloves_state="bgloves"
	belt_state="utility"

datum/preview/job/engsec/security/security_cadet
	job_index=INTERN_SEC
	uniform_state="redshirt2_s"
	hat_state="officerberet"

datum/preview/job/engsec/security/engineering_assistant
	job_index=INTERN_ENG
	uniform_state="engine_s"
	shoes_state="orange"
	hat_state="e_beret_badge"
	backpack_01_state="engiepack"
	backpack_02_state="satchel-eng"

datum/preview/job/engsec/ai
	job_index=AI

datum/preview/job/engsec/cyborg
	job_index=CYBORG

datum/preview/job/medsci
	job_type=MEDSCI
	shoes_state="white"
	jacket_state="labcoat_open"

datum/preview/job/medsci/science
	backpack_02_state="satchel-tox"
	uniform_state="sciencewhite_s"
	jacket_state="labcoat_tox_open"

datum/preview/job/medsci/science/research_director
	job_index=RD
	uniform_state="director_s"
	shoes_state="brown"

datum/preview/job/medsci/science/scientist
	job_index=SCIENTIST

datum/preview/job/medsci/science/xenobiologist
	job_index=XENOBIOLOGIST

datum/preview/job/medsci/science/intern
	job_index=INTERN_SCI
	jacket_state=null

datum/preview/job/medsci/chemist
	job_index=CHEMIST
	uniform_state="chemistrywhite_s"
	jacket_state="labcoat_chem_open"
	backpack_02_state="satchel-chem"

datum/preview/job/medsci/medical
	backpack_01_state="medicalpack"
	backpack_02_state="satchel-med"

datum/preview/job/medsci/medical/chief_medical_officer
	job_index=CMO
	uniform_state="cmo_s"
	shoes_state="brown"
	jacket_state="labcoat_cmo_open"

datum/preview/job/medsci/medical/emt
	job_index=PARAMEDIC
	uniform_state="emt_s"
	jacket_state="fr_jacket_open"
	backpack_01_state="emtpack"
	backpack_02_state="satchel-emt"

datum/preview/job/medsci/medical/geneticist
	job_index=GENETICIST
	uniform_state="geneticswhite_s"
	jacket_state="labcoat_gen_open"
	backpack_01_state="backpack"
	backpack_02_state="satchel-gen"

datum/preview/job/medsci/medical/virologist
	job_index=VIROLOGIST
	uniform_state="virologywhite_s"
	mask_state="sterile"
	jacket_state="labcoat_vir_open"
	backpack_02_state="satchel-vir"

datum/preview/job/medsci/medical/intern
	job_index=INTERN_MED
	uniform_state="medical_s"
	jacket_state=null

datum/preview/job/medsci/roboticist
	job_index=ROBOTICIST
	uniform_state="robotics_s"
	shoes_state="black"
	gloves_state="bgloves"

datum/preview/job/civilian
	job_type=CIVILIAN
	shoes_state="black"

datum/preview/job/civilian/head_of_personnel
	job_index=HOP
	uniform_state="hop_s"
	shoes_state="brown"

datum/preview/job/civilian/bartender
	job_index=BARTENDER
	uniform_state="ba_suit_s"

datum/preview/job/civilian/botanist
	job_index=BOTANIST
	uniform_state="hydroponics_s"
	gloves_state="ggloves"
	jacket_state="apron"
	backpack_02_state="satchel-hyd"

datum/preview/job/civilian/chef
	job_index=CHEF
	uniform_state="chef_s"
	hat_state="chef"

datum/preview/job/civilian/janitor
	job_index=JANITOR
	uniform_state="janitor_s"

datum/preview/job/civilian/librarian
	job_index=LIBRARIAN
	uniform_state="red_suit_s"

datum/preview/job/civilian/quartermaster
	job_index=QUARTERMASTER
	uniform_state="qm_s"
	shoes_state="brown"
	gloves_state="bgloves"

datum/preview/job/civilian/cargo_tech
	job_index=CARGOTECH
	uniform_state="cargotech_s"
	gloves_state="bgloves"
	hat_state="flat_cap"

datum/preview/job/civilian/miner
	job_index=MINER
	uniform_state="miner_s"
	gloves_state="bgloves"
	backpack_02_state="satchel-eng"

datum/preview/job/civilian/internal_affairs
	job_index=LAWYER
	uniform_state="internalaffairs_s"
	shoes_state="brown"

datum/preview/job/civilian/chaplain
	job_index=CHAPLAIN
	uniform_state="chapblack_s"

var/list/job_preview_data=null
proc/job_preview_list()
	if (!job_preview_data)
		job_preview_data=list()
		for(var/job_preview_type in typesof(/datum/preview/job)-/datum/preview/job)
			var/datum/preview/job/new_job = new job_preview_type()
			var/type_string="[new_job.job_type]"
			var/index_string="[new_job.job_index]"
			if(!(type_string in job_preview_data))
				job_preview_data[type_string]=list()
			if(new_job.job_index)
				job_preview_data[type_string][index_string]=new_job
		job_preview_data["DEFAULT"] = list(new/datum/preview/job())
	return job_preview_data

proc/get_job_preview_for_index(job_type,job_index)
	var/list/preview_list=job_preview_list()
	return preview_list[job_type][job_index]