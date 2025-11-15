/// You don't know anything about this subject.
#define SKILL_LEVEL_UNFAMILIAR	 	1
/// You're familiar with this subject, either by reading into it or by doing some courses.
#define SKILL_LEVEL_FAMILIAR		2
/// You've been formally trained in this subject. Typically, this is the minimum level for a job.
#define SKILL_LEVEL_TRAINED			3
/// You have some training and a good amount of experience in this subject.
#define SKILL_LEVEL_PROFESSIONAL	4

/// An everyday skill is a skill that can be picked up normally. Think like mixing a drink, growing a plant, cooking, and so on.
#define SKILL_CATEGORY_EVERYDAY			"Everyday"
	#define SKILL_SUBCATEGORY_SERVICE		"Service"
	#define SKILL_SUBCATEGORY_MUNDANE		"Mundane"

/// Occupational skills are the skills necessary for you to do your job to a minimum degree.
#define SKILL_CATEGORY_OCCUPATIONAL 	"Occupational"
	#define SKILL_SUBCATEGORY_MEDICAL		"Medical"
	#define SKILL_SUBCATEGORY_ENGINEERING	"Engineering"
	#define SKILL_SUBCATEGORY_SCIENCE		"Science"

///A combat skill is a skill that has a direct effect in combat. These have an increased cost.
#define SKILL_CATEGORY_COMBAT			"Combat"
	#define SKILL_SUBCATEGORY_RANGED		"Ranged"
	#define SKILL_SUBCATEGORY_MELEE			"Melee"

#define BASE_SKILL_POINTS_COMBAT					4
#define BASE_SKILL_POINTS_OCCUPATIONAL				8
#define BASE_SKILL_POINTS_EVERYDAY					8

#define SKILL_DIFFICULTY_MODIFIER_EASY				1
#define SKILL_DIFFICULTY_MODIFIER_MEDIUM			2
#define SKILL_DIFFICULTY_MODIFIER_HARD				4

/// Critical success on a difficulty class. Obtained by rolling a nat 20 or +10 over the DC. Used for skills at the moment, will be used for more later.
#define CRITICAL_SUCCESS 2
/// Normal success on a difficulty class. Obtained by rolling equal or higher than the DC. Used for skills at the moment, will be used for more later.
#define SUCCESS 1
/// Normal failure on a difficulty class. Obtained by rolling less than the DC. Used for skills at the moment, will be used for more later.
#define FAILURE 0
/// Critical failure on a difficulty class. Obtained by rolling a nat 1 or -10 under the DC. Used for skills at the moment, will be used for more later.
#define CRITICAL_FAILURE -1
