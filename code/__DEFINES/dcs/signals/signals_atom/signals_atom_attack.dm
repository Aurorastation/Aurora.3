// Atom attack signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

///from base of atom/attackby(): (/obj/item, /mob/living, params)
#define COMSIG_ATOM_ATTACKBY "atom_attackby"

/// From [/item/attack()], sent by an atom which was just attacked by an item: (/obj/item/weapon, /mob/user, proximity_flag, click_parameters)
#define COMSIG_ATOM_AFTER_ATTACKEDBY "atom_after_attackby"

///Return this in response if you don't want afterattack to be called
	#define COMPONENT_NO_AFTERATTACK (1<<0)

	///Ends the attack chain. If sent early might cause posterior attacks not to happen.
	#define COMPONENT_CANCEL_ATTACK_CHAIN (1<<0)
	///Skips the specific attack step, continuing for the next one to happen.
	#define COMPONENT_SKIP_ATTACK (1<<1)
