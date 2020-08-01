#define SHEET_MATERIAL_AMOUNT 2000

#define TECH_MATERIAL "materials"
#define TECH_ENGINEERING "engineering"
#define TECH_PHORON "phorontech"
#define TECH_POWER "powerstorage"
#define TECH_BLUESPACE "bluespace"
#define TECH_BIO "biotech"
#define TECH_COMBAT "combat"
#define TECH_MAGNET "magnets"
#define TECH_DATA "programming"
#define TECH_ILLEGAL "syndicate"
#define TECH_ARCANE "arcane"

#define ALL_ORIGIN_TECHS list(TECH_MATERIAL, TECH_ENGINEERING, TECH_PHORON, TECH_POWER, TECH_BLUESPACE, TECH_BIO, TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ILLEGAL, TECH_ARCANE)

#define IMPRINTER	0x1	//For circuits. Uses glass/chemicals.
#define PROTOLATHE	0x2	//New stuff. Uses glass/metal/chemicals
#define MECHFAB		0x4	//Mechfab
#define CHASSIS		0x8	//For protolathe, but differently

#define MAX_TECH_LEVEL 15