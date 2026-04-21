//Condition flags.
/// This condition processes regardless of stage.
#define CONDITION_FLAG_PROCESS 1
/// Hidden from standard scanners.
#define CONDITION_FLAG_HIDDEN 2

// Condition severity.
/// Low-severity condition.
#define CONDITION_SEVERITY_LOW 1
/// Medium-severity condition.
#define CONDITION_SEVERITY_MEDIUM 2
/// High-severity condition.
#define CONDITION_SEVERITY_HIGH 3

/// This condition doesn't use stages.
#define CONDITION_STAGE_NONE -1
/// This condition uses stages.
#define CONDITION_STAGE_INITIAL 0

// Human condition traits.
#define TRAIT_BROKEN_SPINE "broken_spine"
