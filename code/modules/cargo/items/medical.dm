/singleton/cargo_item/medicalaidset
	category = "medical"
	name = "medical aid set"
	supplier = "iac"
	description = "A set of medical first aid kits."
	price = 2000
	items = list(
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/firstaid/fire,
		/obj/item/storage/firstaid/toxin,
		/obj/item/storage/firstaid/o2,
		/obj/item/storage/firstaid/adv
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/firstaidkit
	category = "medical"
	name = "first-aid kit"
	supplier = "nanotrasen"
	description = "A basic medical kit for those boo-boos."
	price = 60
	items = list(
		/obj/item/storage/firstaid/regular
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/advancedfirstaidkit
	category = "medical"
	name = "advanced first-aid kit"
	supplier = "nanotrasen"
	description = "An emergency medical kit for general severe injuries."
	price = 200
	items = list(
		/obj/item/storage/firstaid/adv
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/advancedfirstaidkit_large
	category = "medical"
	name = "large advanced first-aid kit"
	supplier = "nanotrasen"
	description = "A large emergency medical kit for many general severe injuries."
	price = 500
	items = list(
		/obj/item/storage/firstaid/large/adv
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/firefirstaidkit
	category = "medical"
	name = "fire first-aid kit"
	supplier = "nanotrasen"
	description = "An emergency medical kit for serious burns, either chemical or temperature."
	price = 150
	items = list(
		/obj/item/storage/firstaid/fire
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/oxygendeprivationfirstaid
	category = "medical"
	name = "oxygen deprivation first aid"
	supplier = "nanotrasen"
	description = "An emergency medical kit for oxygen deprivation, including cardiac arrest."
	price = 150
	items = list(
		/obj/item/storage/firstaid/o2
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toxinfirstaid
	category = "medical"
	name = "toxin first aid"
	supplier = "nanotrasen"
	description = "An emergency medical kit for toxin exposure."
	price = 150
	items = list(
		/obj/item/storage/firstaid/toxin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/radfirstaid
	category = "medical"
	name = "radiation first aid"
	supplier = "nanotrasen"
	description = "An emergency medical kit for severe radiation exposure."
	price = 150
	items = list(
		/obj/item/storage/firstaid/radiation
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bloodpack_ominus
	category = "medical"
	name = "O- blood pack (x2)"
	supplier = "zeng_hu"
	description = "A blood pack filled with universally-compatible O- Blood."
	price = 800
	items = list(
		/obj/item/reagent_containers/blood/OMinus
	)
	access = ACCESS_MEDICAL
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/bloodpack_sbs
	category = "medical"
	name = "SBS blood pack (x1)"
	supplier = "zeng_hu"
	description = "A blood pack filled with Synthetic Blood Substitute. WARNING: Not compatible with organic blood!"
	price = 675
	items = list(
		/obj/item/reagent_containers/blood/sbs
	)
	access = ACCESS_MEDICAL
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bloodpacksbags
	category = "medical"
	name = "empty IV bags"
	supplier = "nanotrasen"
	description = "This box contains empty IV bags."
	price = 85
	items = list(
		/obj/item/storage/box/bloodpacks
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dexplus_vial
	category = "medical"
	name = "dexalin plus vial"
	supplier = "nanotrasen"
	description = "A vial that comes with 15 units of Dexalin Plus, an advanced chemical used to rapidly oxygenate blood cells."
	price = 900
	items = list(
		/obj/item/reagent_containers/glass/beaker/vial/dexalin_plus
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/peridaxon_vial
	category = "medical"
	name = "peridaxon vial"
	supplier = "nanotrasen"
	description = "A vial that comes with 15 units of Peridaxon, an advanced organ regenerative compound."
	price = 1300
	items = list(
		/obj/item/reagent_containers/glass/beaker/vial/peridaxon
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pneumalin_inhalers
	category = "medical"
	name = "pneumalin autoinhaler kit (x3)"
	supplier = "nanotrasen"
	description = "A kit of autoinhalers used to treat lung damage."
	price = 750
	items = list(
		/obj/item/reagent_containers/inhaler/pneumalin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 3

/singleton/cargo_item/bodybags
	category = "medical"
	name = "body bag boxes (x3)"
	supplier = "nanotrasen"
	description = "A kit of three boxes of body bags."
	price = 35
	items = list(
		/obj/item/storage/box/bodybags
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 3

/singleton/cargo_item/injectors_box
	category = "medical"
	name = "box of empty autoinjectors"
	supplier = "nanotrasen"
	description = "Contains empty autoinjectors."
	price = 85
	items = list(
		/obj/item/storage/box/autoinjectors
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sterilegloves_box
	category = "medical"
	name = "box of sterile gloves"
	supplier = "zeng_hu"
	description = "Contains sterile gloves."
	price = 25
	items = list(
		/obj/item/storage/box/gloves
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/sterilemasks_box
	category = "medical"
	name = "box of sterile masks"
	supplier = "zeng_hu"
	description = "This box contains masks of sterility."
	price = 28
	items = list(
		/obj/item/storage/box/masks
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/syringes_box
	category = "medical"
	name = "box of syringes"
	supplier = "nanotrasen"
	description = "A box full of syringes."
	price = 27
	items = list(
		/obj/item/storage/box/syringes
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/butazoline_bottle
	category = "medical"
	name = "butazoline bottle"
	supplier = "nanotrasen"
	description = "A bottle of butazoline, a medicine used to treat severe trauma."
	price = 250
	items = list(
		/obj/item/reagent_containers/glass/bottle/butazoline
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/kelotane_bottle
	category = "medical"
	name = "kelotane bottle"
	supplier = "nanotrasen"
	description = "A bottle of kelotane, a medicine used to treat severe burns."
	price = 250
	items = list(
		/obj/item/reagent_containers/glass/bottle/kelotane
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dylovene_bottle
	category = "medical"
	name = "dylovene bottle"
	supplier = "nanotrasen"
	description = "A small bottle of dylovene, a broad-spectrum antitoxin and liver regenerative."
	price = 180
	items = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hyronalin_bottle
	category = "medical"
	name = "hyronalin bottle"
	supplier = "nanotrasen"
	description = "A bottle containing hyronalin, used to treat radiation poisoning."
	price = 375
	items = list(
		/obj/item/reagent_containers/glass/bottle/hyronalin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/arithrazine_vial
	category = "medical"
	name = "arithrazine vial"
	supplier = "nanotrasen"
	description = "A bottle containing Arithrazine, a potent anti-radiation medication."
	price = 750
	items = list(
		/obj/item/reagent_containers/glass/beaker/vial/arithrazine
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/inaprovaline_bottle
	category = "medical"
	name = "inaprovaline bottle"
	supplier = "nanotrasen"
	description = "A bottle of inaprovaline, a broad-spectrum stabilizer."
	price = 205
	items = list(
		/obj/item/reagent_containers/glass/bottle/inaprovaline
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/soporific_bottle
	category = "medical"
	name = "soporific bottle"
	supplier = "nanotrasen"
	description = "A bottle of soporific. Just the fumes make you sleepy."
	price = 245
	items = list(
		/obj/item/reagent_containers/glass/bottle/stoxin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mortaphenyl_bottle
	category = "medical"
	name = "mortaphenyl bottle"
	supplier = "nanotrasen"
	description = "A bottle of mortaphenyl, a strong non-opioid painkiller."
	price = 455
	items = list(
		/obj/item/reagent_containers/glass/bottle/mortaphenyl
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/thetamycin_bottle
	category = "medical"
	name = "thetamycin bottle"
	supplier = "nanotrasen"
	description = "A bottle of thetamycin, a broad-spectrum antibiotic."
	price = 350
	items = list(
		/obj/item/reagent_containers/glass/bottle/thetamycin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalbelt
	category = "medical"
	name = "medical belt"
	supplier = "nanotrasen"
	description = "Can hold various medical equipment."
	price = 35
	items = list(
		/obj/item/storage/belt/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalmask
	category = "medical"
	name = "medical mask"
	supplier = "nanotrasen"
	description = "A close-fitting sterile mask that can be connected to an air supply."
	price = 25
	items = list(
		/obj/item/clothing/mask/breath/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/surgicalcap
	category = "medical"
	name = "surgical cap"
	supplier = "nanotrasen"
	description = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	price = 22
	items = list(
		/obj/item/clothing/head/surgery
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalscrubs
	category = "medical"
	name = "medical scrubs"
	supplier = "nanotrasen"
	description = "It's made of a special fiber that provides minor protection against biohazards."
	price = 45
	items = list(
		/obj/item/clothing/under/rank/medical/surgeon
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalgown
	category = "medical"
	name = "medical gown"
	supplier = "nanotrasen"
	description = "A loose-fitting gown for medical patients."
	price = 23
	items = list(
		/obj/item/clothing/under/medical_gown
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalvoidsuit
	category = "medical"
	name = "medical voidsuit"
	supplier = "nanotrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	price = 780
	items = list(
		/obj/item/clothing/suit/space/void/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medicalvoidsuithelmet
	category = "medical"
	name = "medical voidsuit helmet"
	supplier = "nanotrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	price = 480
	items = list(
		/obj/item/clothing/head/helmet/space/void/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/nanopaste
	category = "medical"
	name = "nanopaste"
	supplier = "zeng_hu"
	description = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	price = 750
	items = list(
		/obj/item/stack/nanopaste
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pillbottles
	category = "medical"
	name = "pill bottles"
	supplier = "nanotrasen"
	description = "A storage box containing pill bottles."
	price = 55
	items = list(
		/obj/item/storage/pill_bottle
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/stasisbag
	category = "medical"
	name = "stasis bag"
	supplier = "zeng_hu"
	description = "A folded, non-reusable bag designed to keep patients in stasis for transport."
	price = 2450
	items = list(
		/obj/item/bodybag/cryobag
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/stabilizer_harness
	category = "medical"
	name = "stabilizer harness"
	supplier = "nanotrasen"
	description = "A specialized medical harness that gives regular compressions to the patient's ribcage for cases of urgent heart issues, and functions as an emergency artificial respirator for cases of urgent lung issues."
	price = 2110
	items = list(
		/obj/item/auto_cpr
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hypospray
	category = "medical"
	name = "hypospray"
	supplier = "zeng_hu"
	description = "A sterile, air-needle autoinjector for administration of drugs to patients."
	price = 800
	items = list(
		/obj/item/reagent_containers/hypospray
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

//Surgery stuff

/singleton/cargo_item/surgerykit
	category = "medical"
	name = "surgery kit"
	supplier = "zeng_hu"
	description = "A kit containing surgical tools, either for resupply or for use on-the-go."
	price = 3200
	items = list(
		/obj/item/storage/firstaid/surgery
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/anesthetictank
	category = "medical"
	name = "anesthetic tank"
	supplier = "nanotrasen"
	description = "A tank with an N2O/O2 gas mix."
	price = 250
	items = list(
		/obj/item/tank/anesthetic
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/scalpel
	category = "medical"
	name = "scalpel"
	supplier = "zeng_hu"
	description = "Cut, cut, and once more cut."
	price = 255
	items = list(
		/obj/item/surgery/scalpel
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/retractor
	category = "medical"
	name = "retractor"
	supplier = "zeng_hu"
	description = "Retracts stuff."
	price = 275
	items = list(
		/obj/item/surgery/retractor
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hemostat
	category = "medical"
	name = "hemostat"
	supplier = "zeng_hu"
	description = "You think you have seen this before."
	price = 275
	items = list(
		/obj/item/surgery/hemostat
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/circularsaw
	category = "medical"
	name = "circular saw"
	supplier = "zeng_hu"
	description = "For heavy duty cutting."
	price = 510
	items = list(
		/obj/item/surgery/circular_saw
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/fix_o_vein
	category = "medical"
	name = "vascular recoupler"
	supplier = "zeng_hu"
	description = "An advanced automatic surgical instrument that operates with extreme finesse."
	price = 850
	items = list(
		/obj/item/surgery/fix_o_vein
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cautery
	category = "medical"
	name = "cautery"
	supplier = "zeng_hu"
	description = "This stops bleeding."
	price = 550
	items = list(
		/obj/item/surgery/cautery
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/surgicaldrill
	category = "medical"
	name = "surgical drill"
	supplier = "zeng_hu"
	description = "You can drill using this item. You dig?"
	price = 470
	items = list(
		/obj/item/surgery/surgicaldrill
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bonegel
	category = "medical"
	name = "bone gel"
	supplier = "zeng_hu"
	description = "A bottle-and-nozzle applicator containing a specialized gel. When applied to bone tissue, it can reinforce and repair breakages and act as a glue to keep bones in place while they heal."
	price = 485
	items = list(
		/obj/item/surgery/bone_gel
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bonesetter
	category = "medical"
	name = "bone setter"
	supplier = "zeng_hu"
	description = "Sets bones into place."
	price = 255
	items = list(
		/obj/item/surgery/bonesetter
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tajaranlatexgloves
	category = "medical"
	name = "tajaran latex gloves"
	supplier = "zharkov"
	description = "Sterile latex gloves. Designed for Tajara use."
	price = 8
	items = list(
		/obj/item/clothing/gloves/latex/tajara
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/unathilatexgloves
	category = "medical"
	name = "unathi latex gloves"
	supplier = "arizi"
	description = "Sterile latex gloves. Designed for Unathi use."
	price = 8
	items = list(
		/obj/item/clothing/gloves/latex/unathi
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/organcooler
	category = "medical"
	name = "organ cooler"
	supplier = "zeng_hu"
	description = "A sealed, cooled container to keep organs from decaying."
	price = 300
	items = list(
		/obj/item/storage/box/freezer/organcooler
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
