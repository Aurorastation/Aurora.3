var/global/list/seen_citizenships = list()
var/global/list/seen_systems = list()
var/global/list/seen_factions = list()
var/global/list/seen_religions = list()

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/carbon/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

var/global/list/citizenship_choices = list(
	"Sol Alliance",
	"Republic of Biesel",
	"Republic of Elyra",
	"Eridani Federation",
	"Jargon Federation",
	"People's Republic of Adhomai",
	"Izweski Hegemony",
	"Zo'ra Hive",
	"K'lax Hive",
	"Empire of Dominia"
	"New Kingdom of Adhomai"
	)

var/global/list/home_system_choices = list(
	"Sol",
	"Tau Ceti",
	"New Ankara",
	"Epsilon Eridani",
	"Jargon",
	"S'rand'marr ",
	"Uueoa-Esa",
	"X'yr Vharn'p"
	)

var/global/list/faction_choices = list(
	"Sol Central",
	"Vey Med",
	"Einstein Engines",
	"Free Trade Union",
	"NanoTrasen",
	"Ward-Takahashi GMB",
	"Gilthari Exports",
	"Grayson Manufactories Ltd.",
	"Aether Atmospherics",
	"Zeng-Hu Pharmaceuticals",
	"Hephaestus Industries"
	)

var/global/list/religion_choices = list(
	"Unitarianism",
	"Hinduism",
	"Buddhist",
	"Islamic",
	"Christian",
	"Agnostic",
	"Deist",
	"Qeblak",
	"Weishii",
	"S'rendarr & Messa",
	"Ma'ta'ke",
	"Th'akh",
	"Sk'akh",
	"Moroz Holy Tribunal"
	)
