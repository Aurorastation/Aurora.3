#define ORGAN_CAN_FEEL_PAIN(organ) !BP_IS_ROBOTIC(organ) && (!organ.species || !(organ.species.flags & NO_PAIN))
#define ORGAN_IS_DISLOCATED(organ) (organ.dislocated > 0)
