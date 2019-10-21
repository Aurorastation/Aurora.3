/*
	Note: This file is meant for actual weapons (guns, swords, etc), and not the stupid 'every obj is a weapon, except when it's not' thing.
*/

//******
//*Guns*
//******

//This contains a lot of copypasta but I'm told it's better then a lot of New()s appending the var.
/obj/item/weapon/gun
	description_info = "This is a gun.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire."

/obj/item/weapon/gun/energy
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger."

/obj/item/weapon/gun/energy/crossbow
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire."
	description_antag = "This is a stealthy weapon which fires poisoned bolts at your target.  When it hits someone, they will suffer a stun effect, in \
	addition to toxins.  The energy crossbow recharges itself slowly, and can be concealed in your pocket or bag."

/obj/item/weapon/gun/energy/gun
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To switch between stun and lethal, click the weapon \
	in your hand.  To recharge this weapon, use a weapon recharger."

/obj/item/weapon/gun/energy/gun/nuclear
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To switch between stun and lethal, click the weapon \
	in your hand.  Unlike most weapons, this weapon recharges itself."

/obj/item/weapon/gun/energy/captain
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly. Unlike most weapons, this weapon recharges itself."

/obj/item/weapon/gun/energy/sniperrifle
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To recharge this weapon, use a weapon recharger. \
	To use the scope, use the appropriate verb in the object tab."

/obj/item/weapon/gun/projectile
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  To reload, click the weapon in your hand to unload (if needed), then add the appropiate ammo.  The description \
	will tell you what caliber you need."

/obj/item/weapon/gun/energy/chameleon
	description_info = null //The chameleon gun adopts the description_info of the weapon it is impersonating as, to make meta-ing harder.
	description_antag = "This gun is actually a hologram projector that can alter its appearance to mimick other weapons.  To change the appearance, use \
	the appropriate verb in the chameleon items tab. Any beams or projectiles fired from this gun are actually holograms and useless for actual combat. \
	Projecting these holograms over distance uses a little bit of charge."

/obj/item/weapon/gun/energy/chameleon/change(picked in gun_choices) //Making the gun change its help text to match the weapon's help text.
	..(picked)
	var/obj/O = gun_choices[picked]
	description_info = initial(O.description_info)

/obj/item/weapon/gun/projectile/shotgun/pump
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  After firing, you will need to pump the gun, by clicking on the gun in your hand.  To reload, load more shotgun \
	shells into the gun."

/obj/item/weapon/gun/projectile/heavysniper
	description_info = "This is a ballistic weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  The gun's chamber can be opened or closed by using it in your hand.  To reload, open the chamber, add a new bullet \
	then close it.  To use the scope, use the appropriate verb in the object tab."

//*******
//*Melee*
//*******

/obj/item/weapon/melee/baton
	description_info = "The baton needs to be turned on to apply the stunning effect.  Use it in your hand to toggle it on or off.  If your intent is \
	set to 'harm', you will inflict damage when using it, regardless if it is on or not.  Each stun reduces the baton's charge, which can be replenished by \
	putting it inside a weapon recharger or replacing its power cell outright."

/obj/item/weapon/melee/energy/sword
	description_antag = "The energy sword is a very strong melee weapon, capable of severing limbs easily, if they are targeted.  It can also has a chance \
	to block projectiles and melee attacks while it is on and being held.  The sword can be toggled on or off by using it in your hand.  While it is off, \
	it can be concealed in your pocket or bag."

/obj/item/weapon/melee/cultblade
	description_fluff = "While it is still recognisable as a large sword, it's almost as if the blade itself was made of some unrecognisable material."
	description_antag = "This sword is a powerful weapon, capable of severing limbs easily, if they are targeted.  Non-believers are unable to use this weapon."

//********
//*Staves*
//********

/obj/item/weapon/staff
	description_info =  "Apparently a staff used by the wizard."
	description_fluff = "The staff calls back on the outdated appearance of the devices used by wizards in media, such as those found in human board games and film."
	description_antag = "This pulses with magical energy.<br>\
	It isn't actually needed to cast spells, but DAMN does it have pizzazz."

/obj/item/weapon/staff/broom
	description_info = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	description_fluff = "This broom is based on a dated appearance used during the second millennium of the Common Era of humanity. This design in particular \
	was once better known as a besom, though is now called broom after the shrubs it acquired its twigs from (Genisteae).<br>\
	Associations with magic and witchcraft have first been referenced somewhere around 1453 CE by confessed male witch Guillaume Edelin."
	description_antag = "This pulses with magical energy.<br>\
	It isn't actually needed to cast spells, but DAMN does it have schmow-zow."

/obj/item/weapon/staff/gentcane
	description_info = "A cane used by a true gentlemen. Or a clown."
	description_fluff = "Walking canes have long been used throughout humanity's history for reasons including (but not limited to) posture support, walking assistance, \
	and fashion.<br>\
	Canes comes in an incredibly diverse range of styles, but most generally have a hooked end for gripping, which then straightens down to the user's feet.<br>\
	These items have also been used for defensive and offensive purposes. In the late 19th century, a martial art called Bartitsu was developed in England which utilises \
	a form of fighting with canes. Readers of the Sherlock Holmes novels may already be somewhat familiar with this form of self-defence."
	description_antag = "This pulses with magical energy.<br>\
	It isn't actually needed to cast spells, but DAMN does it have dazzling panache."

/obj/item/weapon/staff/stick
	description_info = "A great tool to drag someone else's drinks across the bar."
	description_antag = "This pulses with magical energy.<br>\
	It isn't actually needed to cast spells, but DAMN does it have razz-ma-tazz."

//************
//*Bioweapons*
//************

/obj/item/weapon/melee/arm_blade
	description_info = "It cleaves through people as a hot knife through butter.<br>\
	Dropping this will cause it to reform back into a normal arm."
	description_fluff = "Whatever machinations lay behind the instantaneous modification of one's arm can actually be achieved through a whole manner of methods. \
	One of the more common ways in which this is done is through a pathogen capable of assimilating and mimicking the cell structure of the host before undergoing, on \
	command, an extreme alteration of genetic structure following what would be perceived as self-inflicted physical trauma.<br>\
	However, other unknown possibilities include extreme specimens of fungi, parasites, viruses, bacteria, protozoa, cybernetics (which may or may not include \
	nanotechnology), and even alterations of brain signals over a transmitted medium. That is, of course, assuming this is anything non-surreal and comprehensible by \
	current knowledge of biology.<br>\
	Regardless of how this radically configured transformation can be explained, the product is that of one of the most grisly horrors never seen before by the eyes \
	of this galaxy."

/obj/item/weapon/shield/riot/changeling
	description_info = "Dropping this will cause it to reform back into a normal arm."
	description_fluff = "Whatever machinations lay behind the instantaneous modification of one's arm can actually be achieved through a whole manner of methods. \
	One of the more common ways in which this is done is through a pathogen capable of assimilating and mimicking the cell structure of the host before undergoing, on \
	command, an extreme alteration of genetic structure following what would be perceived as self-inflicted physical trauma.<br>\
	However, other unknown possibilities include extreme specimens of fungi, parasites, viruses, bacteria, protozoa, cybernetics (which may or may not include \
	nanotechnology), and even alterations of brain signals over a transmitted medium. That is, of course, assuming this is anything non-surreal and comprehensible by \
	current knowledge of biology.<br>\
	Regardless of how this radically configured transformation can be explained, the product is that of one of the most grisly horrors never seen before by the eyes \
	of this galaxy."

/obj/item/weapon/bone_dart
	description_fluff = "Most solid skeletons found in animals can be used as weapons if sharpened to a particular edge or point. In this case, a dart made of organic \
	materials such as this could easily be made from human, tajaran, skrellian, or unathi ribs, fingers, toes, ossicles, horns, clavicles, teeth, and even vertebrae. \
	Of course, fragments of bone may work just as well."