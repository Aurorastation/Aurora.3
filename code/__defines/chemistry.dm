#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3
#define CHEM_BREATHE 4

#define WET_TYPE_WATER 1
#define WET_TYPE_LUBE 2
#define WET_TYPE_ICE 3

#define MINIMUM_CHEMICAL_VOLUME 0.01

#define SOLID 1
#define LIQUID 2
#define GAS 3

#define REAGENTS_PER_SHEET 20
#define MAX_PILL_SPRITE 20 //max icon state of the pill sprites

#define REAGENTS_OVERDOSE 30

#define REAGENTS_BURNING_TEMP_HIGH T0C + 65 //Temperature at which high temperature burns occur
#define REAGENTS_BURNING_TEMP_HIGH_DAMAGE 0.0001 //Damage per celcius per unit above the REAGENTS_BURNING_TEMP_HIGH define per unit.
#define REAGENTS_BURNING_TEMP_HIGH_DAMAGE_CAP 20 //Maximum amount of burn damage to deal due to high temperature reagents.

#define REAGENTS_BURNING_TEMP_LOW T0C - 30 //Temperature at which low temperature burns occur
#define REAGENTS_BURNING_TEMP_LOW_DAMAGE 0.00005 //Damage per celcius per unit below the REAGENTS_BURNING_TEMP_LOW define per unit.
#define REAGENTS_BURNING_TEMP_LOW_DAMAGE_CAP 20 //Maximum amount of burn damage to deal due to low temperature reagents.

#define REAGENTS_BODYTEMP 0.002 //Increase in body temperature per unit per celcius above current body temperature.
#define REAGENTS_BODYTEMP_MIN 0.25 //Minimum amount of increase to actually increase body temperature. The increase is also rounded to this value.
#define REAGENTS_BODYTEMP_MAX 10 //Maximum allowed increase in body temperature (K) per unit.

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  4
#define IS_UNATHI  8
#define IS_TAJARA  16
#define IS_XENOS   32
#define IS_MACHINE 64
#define IS_VAURCA  128
#define IS_UNDEAD  256

#define CE_STABLE "stable" // Inaprovaline
#define CE_ANTIBIOTIC "antibiotic" // Spaceacilin
#define CE_BLOODRESTORE "bloodrestore" // Iron/nutriment
#define CE_PAINKILLER "painkiller"
#define CE_ALCOHOL "alcohol" // Liver filtering
#define CE_ALCOHOL_TOXIC "alcotoxic" // Liver damage
#define CE_SPEEDBOOST "gofast" // Hyperzine
#define CE_BERSERK "berserk"
#define CE_PACIFIED "pacified"

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_chlorophoride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

//Alcohol
#define INTOX_BUZZED     0.01
#define INTOX_JUDGEIMP   0.03
#define INTOX_MUSCLEIMP  0.08
#define INTOX_REACTION   0.10
#define INTOX_VOMIT		 0.12
#define INTOX_BALANCE    0.15
#define INTOX_BLACKOUT   0.20
#define INTOX_CONSCIOUS  0.30
#define INTOX_DEATH      0.45

//How many units of intoxication to remove per second
#define INTOX_FILTER_HEALTHY 0.035
#define INTOX_FILTER_BRUISED 0.02
#define INTOX_FILTER_DAMAGED 0.010

#define	BASE_DIZZY 50 //Base dizziness from getting drunk.
#define DIZZY_ADD_SCALE 15 //Amount added for every 0.01 percent over the JUDGEIMP limit

#define	BASE_VOMIT_CHANCE 10 //Base chance
#define	VOMIT_CHANCE_SCALE 2.5 //Percent change added for every 0.01 percent over the VOMIT limit
