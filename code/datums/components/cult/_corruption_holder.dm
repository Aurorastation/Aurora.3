#define CORRUPTION_SPEED_MOD     0.085
#define CORRUPTION_MESSAGE_TIME  50
#define CORRUPTION_LOW           10
#define CORRUPTION_MEDIUM        25
#define CORRUPTION_HIGH          50
#define CORRUPTION_VERY_HIGH     75
#define CORRUPTION_ENLIGHTENMENT 90

/datum/component/corruption_holder
	var/mob/living/carbon/human/owner
	var/current_corruption   = 0 //Amount of ACTUAL current corruption.
	var/overflow_corruption  = 0 //Amount of corruption to add. We have a better overall effect if we add it overtime instead of IMMEDIATELY.
	var/last_corrupt_message = 0

/datum/component/corruption_holder/Initialize()
	if(!ishuman(parent))
		crash_with("Corruption holder initialized on a non-human parent!")
		qdel(src)
		return
	owner = parent

/datum/component/corruption_holder/proc/add_corruption(var/amount = 0, var/ignore_overflow = FALSE)
	if(iscultist(owner))
		return
	if(!ignore_overflow)
		overflow_corruption = Clamp(overflow_corruption + amount, 0, 100)
	else
		corruption = Clamp(corruption + amount, 0, 100)

	if((corruption > 0 || overflow_corruption > 0))
		START_PROCESSING(SSprocessing, src)

/datum/component/corruption_holder/process()
	if(!corruption && !overflow_corruption)
		STOP_PROCESSING(SSprocessing, src)
		return //Nothing to process here.

	if(iscultist(owner))
		return

	if(overflow_corruption) //Time to figure out how much we add at once.
		var/to_add = corruption * CORRUPTION_SPEED_MOD
		corruption = Clamp(corruption + to_add, 0, 100)

	corruption_effects()

/datum/component/corruption_holder/proc/corruption_effects()
	//The species itself handles messages and such.
	owner.species?.corruption_effects(current_corruption)

