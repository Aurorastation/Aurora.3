#define NO_EMPTY_ICON 1				//does NOT have an iconstate_empty icon. If adding empty icons for a drink, make sure it does not have this flag
#define UNIQUE_EMPTY_ICON 2			//Uses the empty_icon_state listed. Should really only be used when one trash state applies to multiple drinks. Remove if one is added
#define UNIQUE_EMPTY_ICON_FILE 4	//Uses the empty_icon_state listed. also doesn't change its icon file, giving it a pseudo contained sprite status
#define IS_GLASS 8					//Container is glass. Affects shattering, unacidable, etc.