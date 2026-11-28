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
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = PHARMACOLOGY_SKILL_COMPONENT

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
	description = "Governs your knowledge of crime scene evidence preservation, sample collection, forensic laboratory equipment, and post-mortem examination."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = FORENSICS_SKILL_COMPONENT
	skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You have zero training or knowledge of forensic principles.<br>" \
			+ " - You have a 25% chance to contaminate items with your fingerprints when placing them into evidence bags.<br>" \
			+ " - Taking forensic samples (prints, fibers, swabs) takes 4 seconds and has a 30% chance to smudge, scatter, or contaminate the sample.<br>" \
			+ " - You cannot operate the electron microscope or autopsy scanner, and DNA analyzer scans run at 0.5x speed.",
		SKILL_LEVEL_FAMILIAR = "You have minimal training on the basics of forensics and evidence preservation.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place, and gathering person on evidence bags and photos.<br>" \
			+ " - Safely collect prints, fibers, and swabs in 2.5 seconds without risking contamination.<br>" \
			+ " - Operate the electron microscope (3.5 seconds), DNA analyzer (1x speed), and autopsy scanner.<br>" \
			+ " - Estimate approximate time since death when examining a corpse up close.",
		SKILL_LEVEL_TRAINED = "You have years of formal training and experience with forensic principles.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place, and gathering person on evidence bags and photos.<br>" \
			+ " - Collect prints, fibers, and swabs in 1.5 seconds while preserving the original evidence on the scene.<br>" \
			+ " - Operate the electron microscope faster (2.5 seconds) and run DNA analyzer scans at 1.5x speed.<br>" \
			+ " - Spot faint fingerprints, cloth fibers, and gunshot residue when examining objects up close.<br>" \
			+ " - Estimate approximate time since death when examining a corpse up close.",
		SKILL_LEVEL_PROFESSIONAL = "You have extensive training and experience with forensics.<br>" \
			+ "You can do the following: <br>" \
			+ " - Automatically record time, place, and gathering person on evidence bags and photos.<br>" \
			+ " - Rapidly collect prints, fibers, and swabs in 0.75 seconds while preserving scene evidence and partially reconstructing smudged fingerprints.<br>" \
			+ " - Operate the electron microscope rapidly (1 second) and run DNA analyzer scans at 2x speed.<br>" \
			+ " - Identify hidden trace chemicals and exact reagent volumes even with a standard mass spectrometer.<br>" \
			+ " - Determine exact time of death and apparent cause indicators when examining a corpse up close, and scan surface weapon wounds with an autopsy scanner without requiring a surgical incision.<br>" \
			+ " - Identify the exact number of distinct fingerprint sets, fiber samples, and residue traces when examining objects up close.<br>" \
			+ " - Toggle <b>Noir Vision</b>, desaturating your vision while highlighting blood, severed limbs and organs, spent bullet casings, bullet piles, bullet holes, discarded weapons, and examined clues in view. Alt-click anything in view while Noir Vision is active to place mental evidence markers.",
	)
	required = TRUE
