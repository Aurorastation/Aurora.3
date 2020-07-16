//update_state
#define UPDATE_CELL_IN 			 (1<<0)
#define UPDATE_OPENED1 			 (1<<1)
#define UPDATE_OPENED2 			 (1<<2)
#define UPDATE_MAINT 			 (1<<3)
#define UPDATE_BROKE 			 (1<<4)
#define UPDATE_BLUESCREEN 		 (1<<5)
#define UPDATE_WIREEXP 			 (1<<6)
#define UPDATE_ALLGOOD 			 (1<<7)

//update_overlay
#define APC_UPOVERLAY_CHARGING0  (1<<0)
#define APC_UPOVERLAY_CHARGING1  (1<<1)
#define APC_UPOVERLAY_CHARGING2  (1<<2)
#define APC_UPOVERLAY_EQUIPMENT0 (1<<3)
#define APC_UPOVERLAY_EQUIPMENT1 (1<<4)
#define APC_UPOVERLAY_EQUIPMENT2 (1<<5)
#define APC_UPOVERLAY_LIGHTING0  (1<<6)
#define APC_UPOVERLAY_LIGHTING1  (1<<7)
#define APC_UPOVERLAY_LIGHTING2  (1<<8)
#define APC_UPOVERLAY_ENVIRON0   (1<<9)
#define APC_UPOVERLAY_ENVIRON1   (1<<10)
#define APC_UPOVERLAY_ENVIRON2   (1<<11)
#define APC_UPOVERLAY_LOCKED     (1<<12)
#define APC_UPOVERLAY_OPERATING  (1<<13)

//has_electronics
#define HAS_ELECTRONICS_NONE	 0
#define HAS_ELECTRONICS_CONNECT  1
#define HAS_ELECTRONICS_SECURED	 2

//opened
#define COVER_CLOSED			 0
#define COVER_OPENED			 1
#define COVER_REMOVED			 2

//charging
#define CHARGING_OFF			 0
#define CHARGING_ON			     1
#define CHARGING_FULL			 2

//channel settings
#define CHANNEL_OFF         0
#define CHANNEL_OFF_AUTO    1
#define CHANNEL_ON          2
#define CHANNEL_ON_AUTO     3

//channel types
#define CHANNEL_EQUIPMENT   0
#define CHANNEL_LIGHTING    1
#define CHANNEL_ENVIRONMENT 2

//charge_mode states
#define CHARGE_MODE_CHARGE    0
#define CHARGE_MODE_DISCHARGE 1
#define CHARGE_MODE_STABLE    2

//autoflag states
#define AUTOFLAG_OFF                0
#define AUTOFLAG_ENVIRON_ON         1
#define AUTOFLAG_ENVIRON_LIGHTS_ON  2
#define AUTOFLAG_ALL_ON             3