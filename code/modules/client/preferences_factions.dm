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
	"Republic of Biesel",
	"Sol Alliance",
	"Frontier Alliance",
	"Republic of Elyra",
	"Eridani Federation",
	"Empire of Dominia",
	"Jargon Federation",
	"People's Republic of Adhomai",
	"Izweski Hegemony",
	"Zo'ra Hive",
	"K'lax Hive"
	)

var/global/list/home_system_choices = list(
	"Tau Ceti",
	"Sol",
	"Wintermute's Perches",
	"Alpha Centauri",
	"Trummer Flotilla",
	"Xanu",
	"Techno-Conglomerate Fleet",
	"Scarab Fleet",
	"New Ankara",
	"Epsilon Eridani",
	"X'yr Vharn'p",
	"Jargon",
	"S'rand'marr",
	"Uueoa-Esa"
	)

var/global/list/faction_choices = list(
	"NanoTrasen",
	"Hephaestus Industries",
	"Idris Incorporated",
	"Zeng-Hu Pharmaceuticals",
	"Einstein Engines",
	"Necropolis Industries"
	)

var/global/list/religion_choices = list(
	"Agnosticism",
	"Deism",
	"Christianity",
	"Islam",
	"Hinduism",
	"Buddhism",
	"Folk Religion",
	"Moroz Holy Tribunal",
	"Qeblak",
	"Weishii",
	"S'rendarr & Messa",
	"Ma'ta'ke",
	"Th'akh",
	"Sk'akh",
	"Aut'akh"
	)
