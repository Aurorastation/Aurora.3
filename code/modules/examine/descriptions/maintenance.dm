//*************
//*Engineering*
//*************

/obj/machinery/power/supermatter
	description_info = "When energized by a laser (or something hitting it), it emits radiation and heat.  If the heat reaches above 7000 kelvin, it will send an alert and start taking damage. \
	After integrity falls to zero percent, it will delaminate, causing a massive explosion, station-wide radiation spikes, and hallucinations. \
	Supermatter reacts badly to oxygen in the atmosphere.  It'll also heat up really quick if it is in vacuum.<br>\
	<br>\
	Supermatter cores are extremely dangerous to be close to, and requires protection to handle properly.  The protection you will need is:<br>\
	Optical meson scanners on your eyes, to prevent hallucinations when looking at the supermatter.<br>\
	Radiation helmet and suit, as the supermatter is radioactive.<br>\
	<br>\
	Touching the supermatter will result in *instant death*, with no corpse left behind!  You can drag the supermatter, but anything else will kill you. \
	It is advised to obtain a genetic backup before trying to drag it."

	description_antag = "Exposing the supermatter to oxygen or vaccum will cause it to start rapidly heating up.  Sabotaging the supermatter and making it explode will \
	cause a period of lag as the explosion is processed by the server, as well as irradiating the entire station and causing hallucinations to happen.  \
	Wearing radiation equipment will protect you from most of the delamination effects sans explosion."

/obj/machinery/power/apc
	description_info = "An APC (Area Power Controller) regulates and supplies backup power for the area they are in. Their power channels are divided \
	out into 'environmental' (Items that manipulate airflow and temperature), 'lighting' (the lights), and 'equipment' (everything else that consumes power).  \
	Power consumption and backup power cell charge can be seen from the interface, further controls (turning a specific channel on, off or automatic, \
	toggling the APC's ability to charge the backup cell, or toggling power for the entire area via master breaker) first requires the interface to be unlocked \
	with an ID with Engineering access or by one of the station's robots or the artificial intelligence."

	description_antag = "This can be emagged to unlock it.  It will cause the APC to have a blue error screen. \
	Wires can be pulsed remotely with a signaler attached to it.  A powersink will also drain any APCs connected to the same wire the powersink is on."

/obj/item/inflatable
	description_info = "Inflate by using it in your hand.  The inflatable barrier will inflate on your tile.  To deflate it, use the 'deflate' verb."

/obj/structure/inflatable
	description_info = "To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."

/obj/structure/inflatable/door
	description_info = "Click the door to open or close it.  It only stops air while closed.<br>\
	To remove these safely, use the 'deflate' verb.  Hitting these with any objects will probably puncture and break it forever."

//************
//*Janitorial*
//************

/obj/item/weapon/caution
	description_info = "Caution! Wet Floor!"
	description_fluff = "A self-supporting portable sign which can be folded and unfolded accordingly. This particular design is commonly found in Republic of Biesel territories \
	and has two sets of bright red lights mounted at the corners of the sign. They are toggled on and off by a small switch located at the top of the sign, and runs on a \
	simple electronic power circuit with small embedded teranium-nickel batteries.<br>\
	Its A-frame design includes vacuum seals fitted at the bottom, allowing it to stand steadily on even the smoothest surfaces - in addition to the roughest - without \
	being knocked over."

/obj/item/weapon/caution/cone
	description_info = "This cone is trying to warn you of something!"
	description_fluff = "The self-supporting cone has become a staple for altering routes taken by traffic and non-traffic alike.<br>\
	It has fluorescent colouring to help make it stand out, and is typically used by being placed along a path to warn a traveller. The configuration of their placement \
	is such that it usually indicates an alternative route.<br>\
	<br>\
	Historically, the design of these cones were first invented by a Los Angeles painter named Charles D. Scanlon around the mid-1900s as a replacement for the then-used \
	wooden barriers and tripods. Since then, Scanlon's designs started to see use around Earth along with different designs being offered from different places."
