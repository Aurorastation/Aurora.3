#define SURGERY_FAILURE -1

// organ open flags
#define ORGAN_CLOSED            0
#define ORGAN_OPEN_INCISION     1 // skin incision OR hatch unscrewed
#define ORGAN_OPEN_RETRACTED    2 // skin retracted
#define ORGAN_ENCASED_OPEN      2.5 // bones e.g. ribcage sawed open
#define ORGAN_ENCASED_RETRACTED 3 // bones retracted OR hatch opened

// facial surgery
#define FACE_NORMAL             0
#define FACE_CUT_OPEN           1
#define FACE_RETRACTED          2
#define FACE_ALTERED            3

//macros
#define IS_ORGAN_FULLY_OPEN affected.open == ((affected.encased || affected.robotic) ? ORGAN_ENCASED_RETRACTED : ORGAN_OPEN_RETRACTED)