#define INDEP	1
#define SLF	2
#define BIS	3
#define ASI	4
#define PSIS	5
#define HSH	6
#define TCD	7

#define PRO_SYNTH 1
#define ANTI_SYNTH 2

var/global/list/contest_factions = list("Independant" = INDEP,
									   "Synthetic Liberation Front" = SLF,
									   "Biesel Intelligence Service" = BIS,
									   "Alliance Strategic Intelligence" = ASI,
									   "People's Strategic Information Service" = PSIS,
									   "Hegemon Shadow Service" = HSH,
									   "Tup Commandos Division" = TCD)

var/global/list/contest_factions_prosynth = list(SLF)
var/global/list/contest_factions_antisynth = list(HSH, TCD)
