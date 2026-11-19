/singleton/skill/medicine
	name = "Medicine"
	description = "Governs the user's ability to perform basic first-aid, as well as operate medical equipment."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	required = TRUE
	component_type = MEDICINE_SKILL_COMPONENT

/singleton/skill/surgery
	name = "Surgery"
	description = "Governs the user's ability to perform surgical procedures on organic humanoids, as well as what complexity of procedures can be performed. " \
		+ "A low rank in this skill causes surgery procedures to have a significantly higher chance to fail, while high ranks improve surgical chances. " \
		+ "The more advanced a surgery is, the greater the penalties will be from attempting it unskilled. " \
		+ "Having high ranks in this skill can also help offset the penalties from using non-ideal tools in surgery. " \
		+ "This does not affect \"surgeries\" performed on mechanical prosthetics, robots, or synthetics in general."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_FAMILIAR // Only the most basic of all surgeries could be bought into, you'll need a real doctor education to do anything more.
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = SURGERY_SKILL_COMPONENT
	required = TRUE
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or experience with surgery.<br>" \
			+ " - You suffer a large penalty to the chances of successfully performing any surgery on organic humanoids.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of surgery. This is equivalent to a fresh med school graduate, or a military corpsman.<br>" \
			+ "You can perform surgeries slightly faster.<br>" \
			+ "You can perform the following procedures without any penalties: <br>" \
			+ " - Opening or Closing incisions.<br>" \
			+ " - Clamp bleeders.<br>" \
			+ " - Fixing Arterial Bleeding<br>" \
			+ " - Amputating a limb.",
		SKILL_LEVEL_TRAINED = "You have years of formal training and experience with surgery. This is equivalent to a fully licensed surgeon.<br>" \
			+ "You can perform surgeries somewhat faster.<br>" \
			+ "You can perform the following procedures without any penalties:<br>" \
			+ " - Opening or Closing incisions.<br>" \
			+ " - Clamp bleeders.<br>" \
			+ " - Fixing Arterial Bleeding<br>" \
			+ " - Amputating a limb." \
			+ " - Repairing broken bones or muscle tendons.<br>" \
			+ " - Sawing and retracting a ribcage.<br>" \
			+ " - Facial Reconstructions only on organic humanoids, not synthetics.<br>" \
			+ " - Remove or Insert implants.<br>" \
			+ " - Re-attach (organic) limbs. Robotic limbs require the Robotics skill instead.<br>" \
			+ " - Repair non-necrotic organs other than the brain, or mechanical prosthetics.<br>",
		SKILL_LEVEL_PROFESSIONAL = "You are a world class surgeon with decades worth of training and experience.<br>" \
			+ "You can perform surgeries moderately faster.<br>" \
			+ "You can perform the following procedures without any penalties:<br>" \
			+ " - Opening or Closing incisions.<br>" \
			+ " - Clamp bleeders.<br>" \
			+ " - Fixing Arterial Bleeding<br>" \
			+ " - Amputating a limb." \
			+ " - Repairing broken bones or muscle tendons.<br>" \
			+ " - Sawing and retracting a ribcage.<br>" \
			+ " - Facial Reconstructions only on organic humanoids, not synthetics.<br>" \
			+ " - Remove or Insert implants.<br>" \
			+ " - Re-attach (organic) limbs. Robotic limbs require the Robotics skill instead.<br>" \
			+ " - Repair non-necrotic organs other than the brain, or mechanical prosthetics.<br>" \
			+ " - Repair and debride necrotic organs.<br>" \
			+ " - Repair damaged brains."
	)

/singleton/skill/pharmacology
	name = "Pharmacology"
	description = "Governs the user's knowledge of chemicals, pharmaceuticals, and toxicology, as well as their proficiency with pharmacy machinery, chemical analysis devices, and medication administration."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = PHARMACOLOGY_SKILL_COMPONENT
	required = TRUE
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have no formal training in chemistry or pharmacology.<br>" \
			+ " - You cannot visually identify chemicals in beakers or pills, and can only roughly estimate liquid volumes.<br>" \
			+ " - Industrial and medical chemical dispensers and ChemMasters display unfamiliar reagents in containers or buffers as unknown compounds, and your dispensing/transferring is slightly imprecise.<br>" \
			+ " - Health Analyzers and Breath Analyzers only display a general abnormal reagent concentration warning rather than pinpointing which medication is overdosing.<br>" \
			+ " - Unless trained in Medicine, administering injections with syringes, hyposprays, or droppers is slower and clumsier.",
		SKILL_LEVEL_FAMILIAR = "You have basic familiarity with everyday chemicals and common over-the-counter or first-aid medications.<br>" \
			+ " - You can visually recognize common food/drink reagents and basic first-aid medicines in open or transparent containers when adjacent.<br>" \
			+ " - You can read all reagent names and dispense exact amounts in Chemical Dispensers and ChemMasters.<br>" \
			+ " - Health Analyzers and Breath Analyzers still only display a general abnormal reagent concentration warning rather than pinpointing which specific medication is overdosing.<br>" \
			+ " - You can administer injections and eye drops at standard speed without clumsiness.",
		SKILL_LEVEL_TRAINED = "You have formal training in pharmacology and clinical chemistry.<br>" \
			+ " - You can visually identify standard medical reagents, psychiatric medications, and chemical precursors with approximate volumes, and notice when open dispenser cartridges do not match their labels.<br>" \
			+ " - Health Analyzers and Breath Analyzers you use pinpoint active overdoses on specific scannable medications, and Mass Spectrometers and Reagent Scanners provide approximate reagent quantities.<br>" \
			+ " - You can produce larger pill batches in the ChemMaster 3000, grind reagents faster with 10% higher yield, and assemble Chemical Heaters from flatpaks.<br>" \
			+ " - Pills you compound have a sugar coating that masks bitter chemical tastes and provides a small morale boost.<br>" \
			+ " - You administer injections and IV drips faster and with a 50% chance to avoid contaminating syringes.",
		SKILL_LEVEL_PROFESSIONAL = "You are a licensed Doctor of Pharmacy or master toxicologist.<br>" \
			+ " - You can visually identify almost any non-concealed reagent, toxin, or compound with exact volumes, and notice when open dispenser cartridges do not match their labels.<br>" \
			+ " - Health Analyzers and Breath Analyzers you use pinpoint active overdoses on specific scannable medications, and Mass Spectrometers and Reagent Scanners reveal full quantitative reagent breakdowns, including concealed/spectro-hidden compounds.<br>" \
			+ " - You can produce up to 40 pills at once in the ChemMaster 3000, and grind reagents significantly faster with 20% higher yield.<br>" \
			+ " - Pills you compound have a flawless pharmaceutical glaze that masks bitter chemical tastes and provides a moderate morale boost.<br>" \
			+ " - You administer injections and IV drips at maximum speed with a 75% chance to avoid contaminating syringes."
	)

/singleton/skill/anatomy
	name = "Anatomy"
	description = "Governs the speed at which you can check yourself for injuries, as well as the quality of the information obtained when doing so."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_PROFESSIONAL
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = ANATOMY_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or knowledge of anatomy.<br>" \
			+ " - You can only distinguish visible damage like cuts and burns.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of anatomy.<br>" \
			+ " - You are 2.5% more likely to succeed when performing surgeries on a patient whose species matches your own.<br>" \
			+ " - You can perform surgeries 5% faster on a patient whose species matches your own.<br>"\
			+ "You can diagnose the following conditions: <br>" \
			+ " - External injuries.<br>" \
			+ " - Limb dislocation.<br>" \
			+ " - Simple bleeds.",
		SKILL_LEVEL_TRAINED = "You have years of formal training and experience with anatomy.<br>" \
			+ " - You are 5% more likely to succeed when performing surgeries on a patient whose species matches your own.<br>" \
			+ " - You can perform surgeries 10% faster on a patient whose species matches your own.<br>"\
			+ "You can diagnose the following conditions: <br>" \
			+ " - External injuries at a high level of detail.<br>" \
			+ " - Limb dislocation.<br>" \
			+ " - Broken bones.<br>" \
			+ " - Distinguish between simple bleeds and severed arteries.<br>" \
			+ " - Limb necrosis.<br>" \
			+ " - Tag injuries by triage priority.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive training and experience with anatomy.<br>" \
			+ " - You are 7.5% more likely to succeed when performing surgeries on a patient whose species matches your own.<br>" \
			+ " - You can perform surgeries 15% faster on a patient whose species matches your own.<br>"\
			+ "You can diagnose the following conditions at the highest level of detail: <br>" \
			+ " - External injuries at a high level of detail.<br>" \
			+ " - Limb dislocation.<br>" \
			+ " - Broken bones.<br>" \
			+ " - Distinguish between simple bleeds and severed arteries.<br>" \
			+ " - Limb necrosis.<br>" \
			+ " - Tag injuries by triage priority."
	)
	required = TRUE

/singleton/skill/forensics
	name = "Forensics"
	description = "Governs your knowledge of evidence gathering and analyzing."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = FORENSICS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or knowledge of forensic principles.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of forensics and evidence preservation.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place and gathering person on evidence bags and photos.",
		SKILL_LEVEL_TRAINED = "You have years of formal training and experience with forensic principles.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place and gathering person on evidence bags and photos.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive training and experience with forensics.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place and gathering person on evidence bags and photos.",
	)
	required = TRUE
