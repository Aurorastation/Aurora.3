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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/oxygendeprivationfirstaid
	category = "medical"
	name = "oxygen deprivation first aid kit"
	supplier = "nanotrasen"
	description = "An emergency medical kit for oxygen deprivation, including cardiac arrest."
	price = 150
	items = list(
		/obj/item/storage/firstaid/o2
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toxinfirstaid
	category = "medical"
	name = "toxin first aid kit"
	supplier = "nanotrasen"
	description = "An emergency medical kit for toxin exposure."
	price = 150
	items = list(
		/obj/item/storage/firstaid/toxin
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/radfirstaid
	category = "medical"
	name = "radiation first aid kit"
	supplier = "nanotrasen"
	description = "An emergency medical kit for severe radiation exposure."
	price = 150
	items = list(
		/obj/item/storage/firstaid/radiation
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bloodpack_ominus
	category = "medical"
	name = "O- blood pack (x2)"
	supplier = "zeng_hu"
	description = "A blood pack filled with universally-compatible O- Blood."
	price = 600
	items = list(
		/obj/item/reagent_containers/blood/OMinus
	)
	access = list(/datum/access/medical::id)
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/bloodpack_sbs
	category = "medical"
	name = "SBS blood pack (x2)"
	supplier = "zeng_hu"
	description = "A blood pack filled with Synthetic Blood Substitute. WARNING: Not compatible with organic blood!"
	price = 475
	items = list(
		/obj/item/reagent_containers/blood/sbs
	)
	access = list(/datum/access/medical::id)
	container_type = "freezer"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/bloodpacksbags
	category = "medical"
	name = "empty IV bags"
	supplier = "nanotrasen"
	description = "This box contains empty IV bags."
	price = 85
	items = list(
		/obj/item/storage/box/bloodpacks
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 3

/singleton/cargo_item/pneumalin_inhalers
	category = "medical"
	name = "pneumalin autoinhaler kit (x3)"
	supplier = "nanotrasen"
	description = "A kit of autoinhalers used to treat lung damage."
	price = 750
	items = list(
		/obj/item/reagent_containers/inhaler/pneumalin
	)
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tricordrazine
	category = "medical"
	name = "tricordrazine bottle"
	supplier = "nanotrasen"
	description = "A bottle of tricordrazine, a medicine used to treat various wounds."
	price = 175
	items = list(
		/obj/item/reagent_containers/glass/bottle/tricordrazine
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bicaridine_bottle
	category = "medical"
	name = "bicaridine bottle"
	supplier = "nanotrasen"
	description = "A bottle of bicaridine, a medicine used to treat trauma."
	price = 250
	items = list(
		/obj/item/reagent_containers/glass/bottle/bicaridine
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/butazoline_bottle
	category = "medical"
	name = "butazoline bottle"
	supplier = "zeng_hu"
	description = "A bottle of butazoline, a medicine used to treat severe trauma."
	price = 525
	items = list(
		/obj/item/reagent_containers/glass/bottle/butazoline
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/kelotane_bottle
	category = "medical"
	name = "kelotane bottle"
	supplier = "nanotrasen"
	description = "A bottle of kelotane, a medicine used to treat burns."
	price = 250
	items = list(
		/obj/item/reagent_containers/glass/bottle/kelotane
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dermaline_bottle
	category = "medical"
	name = "dermaline bottle"
	supplier = "zeng_hu"
	description = "A bottle of dermaline, a medicine used to treat severe burns."
	price = 525
	items = list(
		/obj/item/reagent_containers/glass/bottle/dermaline
	)
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mortaphenyl_bottle
	category = "medical"
	name = "mortaphenyl bottle"
	supplier = "nanotrasen"
	description = "A bottle of mortaphenyl, a weak, synthetic, opioid painkiller."
	price = 455
	items = list(
		/obj/item/reagent_containers/glass/bottle/mortaphenyl
	)
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/surgery::id)
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
	access = list(/datum/access/medical::id)
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
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/organcooler
	category = "medical"
	name = "organ cooler"
	supplier = "zeng_hu"
	description = "A sealed, cooled container to keep organs from decaying."
	price = 80
	items = list(
		/obj/item/storage/box/unique/freezer/organcooler
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/iv_stand
	category = "medical"
	name = "IV stand"
	supplier = "zeng_hu"
	description = "An intravenous drip stand used for hooking up IV bags. It also features an emergency positive pressure system for breathing-compromised patients. Comes with a breath mask. Tank or IV bags not included."
	price = 150
	items = list(
		/obj/structure/machinery/iv_drip,
		/obj/item/clothing/mask/breath/medical
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/stethoscope
	category = "medical"
	name = "stethoscope"
	supplier = "zeng_hu"
	description = "A medical instrument used to listen to a patient's heartbeat and breathing."
	price = 25
	items = list(
		/obj/item/clothing/accessory/stethoscope
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/organcooler/mind_blanker
	name = "mind blanker cooler"
	description = "An organ cooler containing a single Zeng-Hu Mind Blanker. Their cost has been subsidized by ZH for Operation Deep Dive."
	price = 500
	items = list(
		/obj/item/storage/box/unique/freezer/organcooler/mind_blanker
	)

/singleton/cargo_item/hover_rollerbed
	category = "medical"
	name = "hover rollerbed (x2)"
	supplier = "zeng_hu"
	description = "A common sight in Nralakk space, the Ziip'Ta Medicinal hover stretcher can sometimes also be found in select Zeng-Hu facilities."
	price = 130
	items = list(
		/obj/item/roller/hover
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/gauze
	category = "medical"
	name = "gauze roll"
	supplier = "nanotrasen"
	description = "A roll of gauze for treating bruises and minor wounds. Holds five uses."
	price = 12
	items = list(
		/obj/item/stack/medical/bruise_pack/full
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ointment
	category = "medical"
	name = "ointment tube"
	supplier = "nanotrasen"
	description = "A tube of ointment for treating burns. Holds five uses."
	price = 12
	items = list(
		/obj/item/stack/medical/ointment/full
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/advancedgauze
	category = "medical"
	name = "advanced trauma kit"
	supplier = "nanotrasen"
	description = "An advanced dressing for treating severe bruises and wounds. Holds five uses."
	price = 35
	items = list(
		/obj/item/stack/medical/advanced/bruise_pack/full
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/advancedointment
	category = "medical"
	name = "advanced burn kit"
	supplier = "nanotrasen"
	description = "An advanced dressing for treating severe burns. Holds five uses."
	price = 35
	items = list(
		/obj/item/stack/medical/advanced/ointment/full
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/splints
	category = "medical"
	name = "splints"
	supplier = "nanotrasen"
	description = "A pack of five splints, for immobilizing broken limbs."
	price = 15
	items = list(
		/obj/item/stack/medical/splint/full
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/healthanalyzer
	category = "medical"
	name = "health analyzer"
	supplier = "zeng_hu"
	description = "A handheld scanner that reads a patient's vital signs."
	price = 40
	items = list(
		/obj/item/healthanalyzer
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/defibrillator
	category = "medical"
	name = "defibrillator"
	supplier = "zeng_hu"
	description = "A portable defibrillator for restarting stopped hearts. Comes with a power cell."
	price = 1250
	items = list(
		/obj/item/defibrillator/loaded
	)
	access = list(/datum/access/medical::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dental_hygiene
	category = "medical"
	name = "Dental Hygiene Kit"
	supplier = "getmore"
	description = "A box containing a toothbrush, a tube of toothpaste, and a bottle of mouthwash."
	price = 25
	items = list(
		/obj/item/storage/box/toothpaste
	)
	container_type = "crate"
	groupable = TRUE

/singleton/cargo_item/autopsy_scanner
	category = "medical"
	name = "autopsy scanner"
	supplier = "nanotrasen"
	description = "A handheld autopsy scanner that extracts information on wounds."
	price = 250
	items = list(
		/obj/item/autopsy_scanner
	)
	access = list(/datum/access/security::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
