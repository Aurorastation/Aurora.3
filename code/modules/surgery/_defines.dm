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

//bone repair
#define BONE_PRE_OP             0
#define BONE_GLUED              1
#define BONE_SET                2

//cavity
#define CAVITY_CLOSED           0
#define CAVITY_OPEN             1

//macros
#define IS_ORGAN_FULLY_OPEN affected.open == ((affected.encased || affected.robotic) ? ORGAN_ENCASED_RETRACTED : ORGAN_OPEN_RETRACTED)

//skill difficulty ratings
#define SURGERY_DIFFICULTY_TRIVIAL 10
#define SURGERY_DIFFICULTY_EASY 15
#define SURGERY_DIFFICULTY_MEDIUM 20
#define SURGERY_DIFFICULTY_HARD 25
#define SURGERY_DIFFICULTY_EXTREME 33

// self-surgery and pain modifiers
#define SELF_SURGERY_SUCCESS_PENALTY 50
#define SELF_SURGERY_TIME_MULTIPLIER 1.5
#define SURGERY_PAIN_TIME_MODIFIER 0.01

// surgery complication thresholds
#define SURGERY_COMPLICATION_BASE_CHANCE 30
#define SURGERY_COMPLICATION_MARGIN_BONUS 2
#define SURGERY_COMPLICATION_CRITICAL_MARGIN 30
#define SURGERY_COMPLICATION_CATASTROPHIC_MARGIN 60

// surgery complication IDs - organic standard
#define COMPLICATION_HEAVY_BLEEDING    "heavy_bleeding"
#define COMPLICATION_CONTAMINATION     "contamination"
#define COMPLICATION_NERVE_SHOCK       "nerve_shock"
#define COMPLICATION_TENDON_TEAR       "tendon_tear"
#define COMPLICATION_DISLOCATION       "dislocation"
#define COMPLICATION_HAIRLINE_FRACTURE "hairline_fracture"
#define COMPLICATION_ORGAN_BRUISE      "organ_bruise"
#define COMPLICATION_FACIAL_SCARRING   "facial_scarring"
#define COMPLICATION_OCULAR_TRAUMA     "ocular_trauma"
#define COMPLICATION_SURGEON_FUMBLE    "surgeon_fumble"

// surgery complication IDs - organic critical
#define COMPLICATION_SEVERED_ARTERY         "severed_artery"
#define COMPLICATION_SEVERED_TENDON         "severed_tendon"
#define COMPLICATION_SHATTERED_BONE         "shattered_bone"
#define COMPLICATION_RUPTURED_ORGAN         "ruptured_organ"
#define COMPLICATION_SEPTIC_SHOCK           "septic_shock"
#define COMPLICATION_CEREBRAL_TRAUMA        "cerebral_trauma"
#define COMPLICATION_CARDIORESPIRATORY_SHOCK "cardiorespiratory_shock"
#define COMPLICATION_INCISION_RUPTURE       "incision_rupture"
#define COMPLICATION_ACCIDENTAL_AMPUTATION  "accidental_amputation"

// surgery complication IDs - robotic standard
#define COMPLICATION_ROBOTIC_POWER_SHORT      "power_short"
#define COMPLICATION_ROBOTIC_ACTUATOR_JAM     "actuator_jam"
#define COMPLICATION_ROBOTIC_SURGEON_SHOCK    "surgeon_shock"
#define COMPLICATION_ROBOTIC_COMPONENT_DAMAGE "component_damage"

// surgery complication IDs - robotic critical
#define COMPLICATION_ROBOTIC_CATASTROPHIC_SHORT "catastrophic_short"
#define COMPLICATION_ROBOTIC_CHASSIS_COLLAPSE   "chassis_collapse"
#define COMPLICATION_ROBOTIC_NEURAL_FEEDBACK    "neural_feedback"
