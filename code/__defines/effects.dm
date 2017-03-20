// tick/process() return vals.
#define EFFECT_CONTINUE 0 	// Keep processing.
#define EFFECT_HALT 1		// Stop processing, but don't qdel.
#define EFFECT_DESTROY 2	// qdel.

// Effect helpers.
#define QUEUE_EFFECT(effect) if (!effect.isprocessing) {effect.isprocessing = TRUE; SSeffects.effect_systems += effect;}
#define QUEUE_VISUAL(visual) if (!visual.isprocessing) {visual.isprocessing = TRUE; SSeffects.visuals += visual;}
#define STOP_EFFECT(effect) effect.isprocessing = FALSE; SSeffects.effect_systems -= effect;
#define STOP_VISUAL(visual)	visual.isprocessing = FALSE; SSeffects.visuals -= visual;
