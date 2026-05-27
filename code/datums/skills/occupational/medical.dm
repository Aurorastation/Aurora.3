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
			+ "You can perform the following procedures without any penalties: <br>" \
			+ " - Opening or Closing incisions.<br>" \
			+ " - Clamp bleeders.<br>" \
			+ " - Fixing Arterial Bleeding<br>" \
			+ " - Amputating a limb.",
		SKILL_LEVEL_TRAINED = "You have years of formal training and experience with surgery. This is equivalent to a fully licensed surgeon.<br>" \
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
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = ANATOMY_SKILL_COMPONENT

/singleton/skill/forensics
	name = "Forensics"
	description = "Not currently implemented."
	maximum_level = SKILL_LEVEL_PROFESSIONAL
	uneducated_skill_cap = SKILL_LEVEL_TRAINED
	category =  /singleton/skill_category/occupational
	subcategory = SKILL_SUBCATEGORY_MEDICAL
	component_type = FORENSICS_SKILL_COMPONENT
