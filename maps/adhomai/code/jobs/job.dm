
var/const/ENGSEC			=(1<<0)

var/const/COMMANDER			=(1<<0)
var/const/QUARTERMASTER		=(1<<1)
var/const/LEVY				=(1<<2)
var/const/GRENADIER			=(1<<3)
var/const/SHARPSHOOTER		=(1<<4)
var/const/ENGINEER			=(1<<5)

var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/VIROLOGIST		=(1<<5)
var/const/PSYCHIATRIST		=(1<<6)
var/const/ROBOTICIST		=(1<<7)
var/const/XENOBIOLOGIST		=(1<<8)
var/const/PARAMEDIC			=(1<<9)
var/const/INTERN_MED		=(1<<10)
var/const/INTERN_SCI		=(1<<11)

var/const/CIVILIAN			=(1<<2)

var/const/MAYOR				=(1<<0)
var/const/BARKEEPER			=(1<<1)
var/const/HUNTER			=(1<<2)
var/const/PRIEST			=(1<<3)
var/const/MEDIC				=(1<<4)
var/const/NURSE				=(1<<5)
var/const/MINER				=(1<<5)
var/const/BLACKSMITH		=(1<<6)
var/const/CHIEF				=(1<<7)
var/const/CONSTABLE			=(1<<8)
var/const/ASSISTANT			=(1<<9)


var/list/assistant_occupations = list() //Leaving this on one line stops Travis complaining ~Scopes


var/list/command_positions = list(
	"Mayor",
	"King's Hand"
)


var/list/engineering_positions = list(
)


var/list/medical_positions = list(
)


var/list/science_positions = list(
)

//BS12 EDIT
var/list/cargo_positions = list(
)

var/list/civilian_positions = list(
	"Civillian",
	"Mayor",
	"Barkeeper",
	"Hunter",
	"Priest",
	"Physician",
	"Nurse",
	"Miner",
	"Blacksmith",
	"Chief Constable",
	"Constable"
)


var/list/security_positions = list(
	"Commander",
	"Levy",
	"Quartermaster",
	"Royal Grenadier",
	"Sharpshooter",
	"Engineer"
)

var/list/nonhuman_positions = list()


/datum/outfit/job/adhomai
	allow_backbag_choice = FALSE
	uniform = /obj/item/clothing/under/tajaran
	id = null
	l_ear = null
	back = /obj/item/weapon/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/tajara
	pda = null
	box = null