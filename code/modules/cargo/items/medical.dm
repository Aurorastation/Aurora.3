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
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/advancedfirstaidkit
	category = "medical"
	name = "advanced first-aid kit"
	supplier = "nanotrasen"
	description = "Contains advanced medical treatments."
	price = 605
	items = list(
		/obj/item/storage/firstaid/adv
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/firefirstaidkit
	category = "medical"
	name = "fire first-aid kit"
	supplier = "nanotrasen"
	description = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	price = 167
	items = list(
		/obj/item/storage/firstaid/fire
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/firstaidkit
	category = "medical"
	name = "first-aid kit"
	supplier = "nanotrasen"
	description = "It's an emergency medical kit for those serious boo-boos."
	price = 157
	items = list(
		/obj/item/storage/firstaid/regular
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/oxygendeprivationfirstaid
	category = "medical"
	name = "oxygen deprivation first aid"
	supplier = "nanotrasen"
	description = "A box full of oxygen goodies."
	price = 242
	items = list(
		/obj/item/storage/firstaid/o2
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1


/singleton/cargo_item/toxinfirstaid
	category = "medical"
	name = "toxin first aid"
	supplier = "nanotrasen"
	description = "Used to treat when you have a high amount of toxins in your body."
	price = 212
	items = list(
		/obj/item/storage/firstaid/toxin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/bloodpack_ominus
	category = "medical"
	name = "O- blood pack (x1)"
	supplier = "zeng_hu"
	description = "A blood pack filled with O- Blood."
	price = 300
	items = list(
		/obj/item/reagent_containers/blood/OMinus
	)
	access = ACCESS_MEDICAL
	container_type = "freezer"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/bloodpack_ominus
	category = "medical"
	name = "SBS blood pack (x1)"
	supplier = "zeng_hu"
	description = "A blood pack filled with Synthetic Blood Substitute. WARNING: Not compatible with organic blood!"
	price = 300
	items = list(
		/obj/item/reagent_containers/blood/OMinus
	)
	access = ACCESS_MEDICAL
	container_type = "freezer"
	groupable = TRUE
	spawn_multiplier = 1

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
	spawn_multiplier = 1

/singleton/cargo_item/anesthetictank
	category = "medical"
	name = "anesthetic tank"
	supplier = "nanotrasen"
	description = "A tank with an N2O/O2 gas mix."
	price = 200
	items = list(
		/obj/item/tank/anesthetic
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/butazoline_autoinjector
	category = "medical"
	name = "butazoline autoinjector"
	supplier = "nanotrasen"
	description = "An autoinjector designed to treat physical trauma."
	price = 200
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/butazoline
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/dermaline_autoinjector
	category = "medical"
	name = "dermaline autoinjector"
	supplier = "nanotrasen"
	description = "An autoinjector designed to treat burns."
	price = 200
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/dermaline
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/dexplus_autoinjector
	category = "medical"
	name = "dexalin plus autoinjector"
	supplier = "nanotrasen"
	description = "An autoinjector designed to treat oxygen deprivation."
	price = 450
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/oxygen
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/peridaxonautoinjector
	category = "medical"
	name = "peridaxon autoinjector"
	supplier = "nanotrasen"
	description = "An autoinjector designed to treat minor organ damage. NOTICE: Restricted substance."
	price = 800
	items = list(
		/obj/item/reagent_containers/hypospray/autoinjector/peridaxon
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/bodybags
	category = "medical"
	name = "body bags"
	supplier = "nanotrasen"
	description = "This box contains body bags."
	price = 255
	items = list(
		/obj/item/storage/box/bodybags
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/injectors_box
	category = "medical"
	name = "box of empty autoinjectors"
	supplier = "nanotrasen"
	description = "Contains empty autoinjectors."
	price = 500
	items = list(
		/obj/item/storage/box/autoinjectors
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/sterilegloves_box
	category = "medical"
	name = "box of sterile gloves"
	supplier = "zeng_hu"
	description = "Contains sterile gloves."
	price = 98
	items = list(
		/obj/item/storage/box/gloves
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/sterilemasks_box
	category = "medical"
	name = "box of sterile masks"
	supplier = "zeng_hu"
	description = "This box contains masks of sterility."
	price = 98
	items = list(
		/obj/item/storage/box/masks
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/syringes_box
	category = "medical"
	name = "box of syringes"
	supplier = "nanotrasen"
	description = "A box full of syringes."
	price = 200
	items = list(
		/obj/item/storage/box/syringes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/chemicalcartridge_dylovene
	category = "medical"
	name = "chemical cartridge-dylovene"
	supplier = "iac"
	description = "A metal canister containing 500 units of a substance. Mostly for use in liquid dispensers, though you can also pour it straight out of the can."
	price = 200
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/dylovene
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/chemicalcartridge_inaprovaline
	category = "medical"
	name = "chemical cartridge-inaprovaline"
	supplier = "iac"
	description = "A metal canister containing 500 units of a substance. Mostly for use in liquid dispensers, though you can also pour it straight out of the can."
	price = 200
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/inaprov
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/chemicalcartridge_thetamycin
	category = "medical"
	name = "chemical cartridge-thetamycin"
	supplier = "iac"
	description = "A metal canister containing 500 units of a substance. Mostly for use in liquid dispensers, though you can also pour it straight out of the can."
	price = 800
	items = list(
		/obj/item/reagent_containers/chem_disp_cartridge/thetamycin
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/dylovenebottle
	category = "medical"
	name = "dylovene bottle"
	supplier = "nanotrasen"
	description = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	price = 20
	items = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/hyronalinbottle
	category = "medical"
	name = "hyronalin bottle"
	supplier = "nanotrasen"
	description = "A small bottle. Contains hyronalin - used to treat radiation poisoning."
	price = 1000
	items = list(
		/obj/item/reagent_containers/glass/bottle/hyronalin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/inaprovalinebottle
	category = "medical"
	name = "inaprovaline bottle"
	supplier = "nanotrasen"
	description = "A small bottle. Contains inaprovaline - used to stabilize patients."
	price = 25
	items = list(
		/obj/item/reagent_containers/glass/bottle/inaprovaline
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/medicalbelt
	category = "medical"
	name = "medical belt"
	supplier = "nanotrasen"
	description = "Can hold various medical equipment."
	price = 75
	items = list(
		/obj/item/storage/belt/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/medicalmask
	category = "medical"
	name = "medical mask"
	supplier = "nanotrasen"
	description = "A close-fitting sterile mask that can be connected to an air supply."
	price = 105
	items = list(
		/obj/item/clothing/mask/breath/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/medicalscrubs
	category = "medical"
	name = "medical scrubs"
	supplier = "zeng_hu"
	description = "It's made of a special fiber that provides minor protection against biohazards. This one is in dark green."
	price = 75
	items = list(
		/obj/item/clothing/under/rank/medical/surgeon/zeng
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/medicalvoidsuit
	category = "medical"
	name = "medical voidsuit"
	supplier = "nanotrasen"
	description = "A special suit that protects against hazardous, low pressure environments. Has minor radiation shielding."
	price = 4200
	items = list(
		/obj/item/clothing/suit/space/void/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/medicalvoidsuithelmet
	category = "medical"
	name = "medical voidsuit helmet"
	supplier = "nanotrasen"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Has minor radiation shielding."
	price = 2850
	items = list(
		/obj/item/clothing/head/helmet/space/void/medical
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/nanopaste
	category = "medical"
	name = "nanopaste"
	supplier = "zeng_hu"
	description = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	price = 2000
	items = list(
		/obj/item/stack/nanopaste
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/pillbottles
	category = "medical"
	name = "pill bottles"
	supplier = "nanotrasen"
	description = "A storage box containing pill bottles."
	price = 155
	items = list(
		/obj/item/storage/pill_bottle
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/soporificbottle
	category = "medical"
	name = "soporific bottle"
	supplier = "nanotrasen"
	description = "A small bottle of soporific. Just the fumes make you sleepy."
	price = 55
	items = list(
		/obj/item/reagent_containers/glass/bottle/stoxin
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/stasisbag
	category = "medical"
	name = "stasis bag"
	supplier = "nanotrasen"
	description = "A folded, non-reusable bag designed to prevent additional damage to an occupant at the cost of genetic damage."
	price = 900
	items = list(
		/obj/item/bodybag/cryobag
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

//Surgery stuff

/singleton/cargo_item/surgeryresupplyset
	category = "medical"
	name = "surgery resupply set"
	supplier = "zeng_hu"
	description = "A set of surgical tools in case the original ones have been lost or misplaced."
	price = 2000
	items = list(
		/obj/item/surgery/scalpel,
		/obj/item/surgery/hemostat,
		/obj/item/surgery/retractor,
		/obj/item/surgery/circular_saw,
		/obj/item/surgery/cautery,
		/obj/item/surgery/surgicaldrill,
		/obj/item/surgery/bone_gel,
		/obj/item/surgery/bonesetter,
		/obj/item/surgery/fix_o_vein,
		/obj/item/stack/medical/advanced/bruise_pack
	)
	access = ACCESS_SURGERY
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/scalpel
	category = "medical"
	name = "scalpel"
	supplier = "zeng_hu"
	description = "Cut, cut, and once more cut."
	price = 100
	items = list(
		/obj/item/surgery/scalpel
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/retractor
	category = "medical"
	name = "retractor"
	supplier = "zeng_hu"
	description = "Retracts stuff."
	price = 115
	items = list(
		/obj/item/surgery/retractor
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/hemostat
	category = "medical"
	name = "hemostat"
	supplier = "zeng_hu"
	description = "You think you have seen this before."
	price = 135
	items = list(
		/obj/item/surgery/hemostat
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/circularsaw
	category = "medical"
	name = "circular saw"
	supplier = "zeng_hu"
	description = "For heavy duty cutting."
	price = 195
	items = list(
		/obj/item/surgery/circular_saw
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/fix_o_vein
	category = "medical"
	name = "vascular recoupler"
	supplier = "zeng_hu"
	description = "An advanced automatic surgical instrument that operates with extreme finesse."
	price = 495
	items = list(
		/obj/item/surgery/fix_o_vein
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/cautery
	category = "medical"
	name = "cautery"
	supplier = "zeng_hu"
	description = "This stops bleeding."
	price = 165
	items = list(
		/obj/item/surgery/cautery
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/surgicaldrill
	category = "medical"
	name = "surgical drill"
	supplier = "zeng_hu"
	description = "You can drill using this item. You dig?"
	price = 195
	items = list(
		/obj/item/surgery/surgicaldrill
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/surgicalcap
	category = "medical"
	name = "surgical cap"
	supplier = "nanotrasen"
	description = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	price = 75
	items = list(
		/obj/item/clothing/head/surgery
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/bonegel
	category = "medical"
	name = "bone gel"
	supplier = "zeng_hu"
	description = "A bottle-and-nozzle applicator containing a specialized gel. When applied to bone tissue, it can reinforce and repair breakages and act as a glue to keep bones in place while they heal."
	price = 495
	items = list(
		/obj/item/surgery/bone_gel
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

/singleton/cargo_item/bonesetter
	category = "medical"
	name = "bone setter"
	supplier = "zeng_hu"
	description = "Sets bones into place."
	price = 225
	items = list(
		/obj/item/surgery/bonesetter
	)
	access = ACCESS_MEDICAL
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

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
	spawn_multiplier = 1

/singleton/cargo_item/therapydoll
	category = "medical"
	name = "therapy doll"
	supplier = "virgo"
	description = "A toy for therapeutic and recreational purposes."
	price = 200
	items = list(
		/obj/item/toy/plushie/therapy
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_multiplier = 1

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
	spawn_multiplier = 1

