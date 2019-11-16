/*********************MANUALS (BOOKS)***********************/

/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	due_date = 0 // Game time in 1/10th seconds
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified

/obj/item/book/manual/wiki
	var/sub_page = ""

/obj/item/book/manual/wiki/Initialize()
	. = ..()

	dat = {"
		<html>
		<head></head>

		<body>
		<iframe width='100%' height='97%' src="[config.wikiurl][sub_page]&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>
	"}

/obj/item/book/manual/wiki/engineering_construction
	name = "Station Repairs and Construction"
	icon_state ="bookEngineering"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Station Repairs and Construction"
	sub_page = "Guide_to_construction"

/obj/item/book/manual/engineering_particle_accelerator
	name = "Particle Accelerator User's Guide"
	icon_state ="bookParticleAccelerator"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Particle Accelerator User's Guide"

/obj/item/book/manual/engineering_particle_accelerator/Initialize()
	. = ..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Experienced User's Guide</h1>

				<h2>Setting up the accelerator</h2>

				<ol>
					<li><b>Wrench</b> all pieces to the floor</li>
					<li>Add <b>wires</b> to all the pieces</li>
					<li>Close all the panels with your <b>screwdriver</b></li>
				</ol>

				<h2>Using the accelerator</h2>

				<ol>
					<li>Open the control panel</li>
					<li>Set the speed to 2</li>
					<li>Start firing at the singularity generator</li>
					<li><font color='red'><b>When the singularity reaches a large enough size so it starts moving on it's own set the speed down to 0, but don't shut it off</b></font></li>
					<li>Remember to wear a radiation suit when working with this machine... we did tell you that at the start, right?</li>
				</ol>

				</body>
			</html>
			"}


/obj/item/book/manual/supermatter_engine
	name = "Supermatter Engine Operating Manual"
	icon_state = "bookSupermatter"
	author = "Engineering Encyclopedia"
	title = "Supermatter Engine Operating Manual"

/obj/item/book/manual/supermatter_engine/Initialize()
	. = ..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>OPERATING MANUAL FOR MK 1 PROTOTYPE THERMOELECTRIC SUPERMATTER ENGINE 'TOMBOLA'</h1>
				<br>
				<h2>OPERATING PRINCIPLES</h2>
				<br>
				<li>The supermatter crystal serves as the fundamental power source of the engine. Upon being charged, it begins to emit large amounts of heat and radiation, as well and oxygen and phoron gas. As oxygen accelerates the reaction, and phoron carries the risk of fire, these must be filtered out. NOTE: Supermatter radiation will not charge radiation collectors.</li>
				<br>
				<li>Air in the reactor chamber housing the supermatter is circulated through the reactor loop, which passes through the filters and thermoelectric generators. The thermoelectric generators transfer heat from the reactor loop to the colder radiator loop, thereby generating power. Additional power is generated from internal turbines in the circulators.</li>
				<br>
				<li>Air in the radiator loop is circulated through the radiator bank, located in space. This rapidly cools the air, preserving the temperature differential needed for power generation.</li>
				<br>
				<li>The MK 1 Prototype Thermoelectric Supermatter Engine is designed to operate at reactor temperatures of 3000K to 4000K and generate up to 1MW of power. Beyond 1MW, the thermoelectric generators will begin to lose power through electrical discharge, reducing efficiency, but additional power generation remains feasible.</li>
				<br>
				<li>The crystal structure of the supermatter will begin to liquefy if its temperature exceeds 5000K. This eventually results in a massive release of light, heat and radiation, disintegration of both the supermatter crystal and most of the surrounding area, and as as-of-yet poorly documented psychological effects on all animals within a 2km radius. Appropriate action should be taken to stabilize or eject the supermatter before such occurs.</li>
				<br>
				<h2>SUPERMATTER HANDLING</h2>
				<li>Do not expose supermatter to oxygen.</li>
				<li><b>NEVER</b> allow the supermatter to come into contact any solid object apart from the specially-designed supporting pallet.</li>
				<li>Never directly look at the supermatter, it has a poorly documented psychological effect on those that do.</li>
				<li>While handles on pallet allow moving the supermatter via pulling, pushing should <b>NEVER</b> be attempted.</li>
				<br>
				<h2>STARTUP PROCEDURE</h2>
				<ol>
				<li>Don radiation hood, radiation suit and meson goggles, without these PPE, you <b>will</b> become irradiated.</li>
				<li>Fill the hot loop's (northernmost) port with <b>ONE</b> canister of phoron.</li>
				<li>Fill the cold loop's (southernmost) port with <b>TWO</b> canisters of phoron.</li>
				<li>Ensure that <b>ALL</b> pumps and filters in the engine and waste room are on and operating at maximum power.</li>
				<li>Ensure the both the emergency coolant valves (located to the west and east of the TEGs) are <b>NOT</b> active.</li>
				<li>Set the two waste loop filters to filter <b>PHORON</b>.</li>
				<li>Set all three of the northernmost coolers to <b>ON</b> keep their temperature setting at its default of <b>293k</b>.</li>
				<li>Fire <b>twenty-one to twenty-five</b> pulses from the emitter at supermatter crystal. Reactor blast doors <b>MUST</b> be open for this procedure.</li>
				<li>Set the SMES in the adjacent room (not the one in the engine bay) to <b>NO</b> input and <b>MAXIMUM</b> output until the power is drained completely.</li>
				<li>Go to hard storage and retrieve two coils, Transmission and Capacitance.</li>
				<li>Open the SMES unit's maintenance panel with your screwdriver and insert both coils, close panel once finished.</li>
				<li>Set input to maximum, and output to 1400000 (1.4 MW).</li>
				</ol>
				<br>
				<h2>OPERATION AND MAINTENANCE</h2>
				<ol>
				<li>Ensure that radiation protection and meson goggles are worn at <b>ALL</b> times while working in the engine room.</li>
				<li>Ensure that reactor and radiator loops are undamaged and unobstructed.</li>
				<li>Ensure that phoron and oxygen gas exhaust from filters is properly contained or disposed. Do not allow exhaust pressure to exceed 4500 kPa.</li>
				<li>Ensure that engine room Area Power Controller (APC) and engine Superconducting Magnetic Energy Storage unit (SMES) are properly charged.</li>
				<li>Ensure that reactor temperature does not exceed 5000K. In event of reactor temperature exceeding 5000K, see EMERGENCY COOLING PROCEDURE.</li>
				<li>In event of imminent and/or unavoidable delamination, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EMERGENCY COOLING PROCEDURE</h2>
				<ol>
				<li>Open Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>When reactor temperature returns to safe operating levels, close Emergency Cooling Valve 1 and Emergency Cooling Valve 2.</li>
				<li>Add additional phoron canister to the COLD LOOP.</li>
				<li>If reactor temperature does not return to safe operating levels, see EJECTION PROCEDURE.</li>
				</ol>
				<br>
				<h2>EJECTION PROCEDURE</h2>
				<ol>
				<li>Press Engine Ventilatory Control button to open engine core vent to space.</li>
				<li>Press Emergency Core Eject button to eject supermatter crystal. NOTE: Attempting crystal ejection while engine core vent is closed will result in ejection failure.</li>
				<li>In event of ejection failure, evacuate the area immediately, inform medical and prepare anti-radiation medicine.</li>
				<li>Start work on repairing telecommunications and setting up an alternate method of power generation (Solars, Tesla).</li>
				</ol>
				<h2>Frequently Asked Questions</h2>
				<br>
				<li><b>Q:</b> Why do some Chief Engineers ask me to use a set-up that isn't in this book?</li>
				<br>
				<li><b>A:</b> There are a few different ways of setting up things in engineering, some Chief Engineers may want more power to be generated, some may want it to be run safely. Trust them.</li>
				<br>
				<li><b>Q:</b> Why is the Chief telling me to run the SMES at X MegaWatt output?</li>
				<br>
				<li><b>A:</b> Sometimes the station needs more power, sometimes it needs less. On a lazy day with no shields, 1.2 MW output is enough to keep the station running, and prevent people getting shocked from the main loop from getting injured.</li>
				<br>
				<li><b>Q:</b> What is that port south east of the waste loop blast doors?</li>
				<br>
				<li><b>A:</b> That's the emergency gas flushing port. Notice how it bypasses the filter. You use that to pull all the gas out of the pipes and into that port.</li>
				<br>
				<li><b>Q:</b> Why do my co-workers sometimes wrench a canister into the port inside the waste room?</li>
				<br>
				<li><b>A:</b> That's the canister you use an analyzer on to check the contents of the waste loop. It contains a miniscule amount of gas, but it's in the correct ratio to let you know. It's also a nice back-up in the event of backed up pipes.</li>
				<br>
				<li><b>Q:</b> I accidentally put way too many emitter shots into the crystal! What do I do!?</li>
				<br>
				<li><b>A:</b> The supermatter will heat up more, so all you do is place more coolant (likely phoron) into the cold loop. Once the situation settles, check if you're producing too little power, and emitter it some more.</li>
				<br>
				<li><b>Q:</b> Are other gasses safe to use in the loops?</li>
				<br>
				<li><b>A:</b> Mostly, yes. More skilled engineers will likely teach you new methods of using other gasses. Our recommendation is to use phoron if you're unsure. The best idea is to ask your co-workers for help, especially if they set up the engine.</li>
				<br>
				<li><b>Q:</b> What do the emergency valves actually do?</li>
				<br>
				<li><b>A:</b> They combine the loops, which will lead to to the rapid cooling of the hot loop and the minor heating of the cold. Eventually they will normalize again. Pressure will be equalized in both.</li>
				<br>
				<li><b>Q:</b> An engineer walked into the room with no PPE, why did they do that?</li>
				<br>
				<li><b>A:</b> If the supermatter engine hasn't been started yet, it will not output radiation. Our recommendation is to be safe instead of sorry, however. If the engine has started, call medical and security, they may be attempting to do an emergency fix, or they are mentally unwell. Remember that non-organics do not suffer from radiation poisoning.</li>
				<br>
				</body>
			</html>"}

/obj/item/book/manual/wiki/engineering_hacking
	name = "Hacking"
	icon_state ="bookHacking"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Hacking"
	sub_page = "Hacking"

/obj/item/book/manual/engineering_singularity_safety
	name = "Singularity Safety in Special Circumstances"
	icon_state ="bookEngineeringSingularitySafety"
	author = "Engineering Encyclopedia"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Singularity Safety in Special Circumstances"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Singularity Safety in Special Circumstances</h1>

				<h2>Power outage</h2>

				A power problem has made the entire station lose power? Could be station-wide wiring problems or syndicate power sinks. In any case follow these steps:

				<ol>
					<li><b><font color='red'>PANIC!</font></b></li>
					<li>Get your ass over to engineering! <b>QUICKLY!!!</b></li>
					<li>Get to the <b>Area Power Controller</b> which controls the power to the emitters.</li>
					<li>Swipe it with your <b>ID card</b> - if it doesn't unlock, continue with step 15.</li>
					<li>Open the console and disengage the cover lock.</li>
					<li>Pry open the APC with a <b>Crowbar.</b></li>
					<li>Take out the empty <b>power cell.</b></li>
					<li>Put in the new, <b>full power cell</b> - if you don't have one, continue with step 15.</li>
					<li>Quickly put on a <b>Radiation suit.</b></li>
					<li>Check if the <b>singularity field generators</b> withstood the down-time - if they didn't, continue with step 15.</li>
					<li>Since disaster was averted you now have to ensure it doesn't repeat. If it was a powersink which caused it and if the engineering APC is wired to the same powernet, which the powersink is on, you have to remove the piece of wire which links the APC to the powernet. If it wasn't a powersink which caused it, then skip to step 14.</li>
					<li>Grab your crowbar and pry away the tile closest to the APC.</li>
					<li>Use the wirecutters to cut the wire which is connecting the grid to the terminal. </li>
					<li>Go to the bar and tell the guys how you saved them all. Stop reading this guide here.</li>
					<li><b>GET THE FUCK OUT OF THERE!!!</b></li>
				</ol>

				<h2>Shields get damaged</h2>

				<ol>
					<li><b>GET THE FUCK OUT OF THERE!!! FORGET THE WOMEN AND CHILDREN, SAVE YOURSELF!!!</b></li>
				</ol>
				</body>
			</html>
			"}

/obj/item/book/manual/medical_cloning
	name = "Cloning Techniques of the 26th Century"
	icon_state ="bookCloning"
	author = "Medical Journal, volume 3"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Cloning Techniques of the 26th Century"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<H1>How to Clone People</H1>
				So there are 50 dead people lying on the floor, chairs are spinning like no tomorrow and you haven't the foggiest idea of what to do? Not to worry!
				This guide is intended to teach you how to clone people and how to do it right, in a simple, step-by-step process! If at any point of the guide you have a mental meltdown,
				genetics probably isn't for you and you should get a job-change as soon as possible before you're sued for malpractice.

				<ol>
					<li><a href='#1'>Acquire body</a></li>
					<li><a href='#2'>Strip body</a></li>
					<li><a href='#3'>Put body in cloning machine</a></li>
					<li><a href='#4'>Scan body</a></li>
					<li><a href='#5'>Clone body</a></li>
					<li><a href='#6'>Get clean Structural Enzymes for the body</a></li>
					<li><a href='#7'>Put body in morgue</a></li>
					<li><a href='#8'>Await cloned body</a></li>
					<li><a href='#9'>Cryo and use the clean SE injector</a></li>
					<li><a href='#10'>Give person clothes back</a></li>
					<li><a href='#11'>Send person on their way</a></li>
				</ol>

				<a name='1'><H3>Step 1: Acquire body</H3>
				This is pretty much vital for the process because without a body, you cannot clone it. Usually, bodies will be brought to you, so you do not need to worry so much about this step. If you already have a body, great! Move on to the next step.

				<a name='2'><H3>Step 2: Strip body</H3>
				The cloning machine does not like abiotic items. What this means is you can't clone anyone if they're wearing clothes or holding things, so take all of it off. If it's just one person, it's courteous to put their possessions in the closet.
				If you have about seven people awaiting cloning, just leave the piles where they are, but don't mix them around and for God's sake don't let people in to steal them.

				<a name='3'><h3>Step 3: Put body in cloning machine</h3>
				Grab the body and then put it inside the DNA modifier. If you cannot do this, then you messed up at Step 2. Go back and check you took EVERYTHING off - a commonly missed item is their headset.

				<a name='4'><h3>Step 4: Scan body</h3>
				Go onto the computer and scan the body by pressing 'Scan - &lt;Subject Name Here&gt;.' If you're successful, they will be added to the records (note that this can be done at any time, even with living people,
				so that they can be cloned without a body in the event that they are lying dead on port solars and didn't turn on their suit sensors)!
				If not, and it says "Error: Mental interface failure.", then they have left their bodily confines and are one with the spirits. If this happens, just shout at them to get back in their body,
				click 'Refresh' and try scanning them again. If there's no success, threaten them with gibbing.
				Still no success? Skip over to Step 7 and don't continue after it, as you have an unresponsive body and it cannot be cloned.
				If you got "Error: Unable to locate valid genetic data.", you are trying to clone a monkey - start over.

				<a name='5'><h3>Step 5: Clone body</h3>
				Now that the body has a record, click 'View Records,' click the subject's name, and then click 'Clone' to start the cloning process. Congratulations! You're halfway there.
				Remember not to 'Eject' the cloning pod as this will kill the developing clone and you'll have to start the process again.

				<a name='6'><h3>Step 6: Get clean SEs for body</h3>
				Cloning is a finicky and unreliable process. Whilst it will most certainly bring someone back from the dead, they can have any number of nasty disabilities given to them during the cloning process!
				For this reason, you need to prepare a clean, defect-free Structural Enzyme (SE) injection for when they're done. If you're a competent Geneticist, you will already have one ready on your working computer.
				If, for any reason, you do not, then eject the body from the DNA modifier (NOT THE CLONING POD) and take it next door to the Genetics research room. Put the body in one of those DNA modifiers and then go onto the console.
				Go into View/Edit/Transfer Buffer, find an open slot and click "SE" to save it. Then click 'Injector' to get the SEs in syringe form. Put this in your pocket or something for when the body is done.

				<a name='7'><h3>Step 7: Put body in morgue</h3>
				Now that the cloning process has been initiated and you have some clean Structural Enzymes, you no longer need the body! Drag it to the morgue and tell the Chef over the radio that they have some fresh meat waiting for them in there.
				To put a body in a morgue bed, simply open the tray, grab the body, put it on the open tray, then close the tray again. Use one of the nearby pens to label the bed "CHEF MEAT" in order to avoid confusion.

				<a name='8'><h3>Step 8: Await cloned body</h3>
				Now go back to the lab and wait for your patient to be cloned. It won't be long now, I promise.

				<a name='9'><h3>Step 9: Cryo and clean SE injector on person</h3>
				Has your body been cloned yet? Great! As soon as the guy pops out, grab them and stick them in cryo. Clonexadone and Cryoxadone help rebuild their genetic material. Then grab your clean SE injector and jab it in them. Once you've injected them,
				they now have clean Structural Enzymes and their defects, if any, will disappear in a short while.

				<a name='10'><h3>Step 10: Give person clothes back</h3>
				Obviously the person will be naked after they have been cloned. Provided you weren't an irresponsible little shit, you should have protected their possessions from thieves and should be able to give them back to the patient.
				No matter how cruel you are, it's simply against protocol to force your patients to walk outside naked.

				<a name='11'><h3>Step 11: Send person on their way</h3>
				Give the patient one last check-over - make sure they don't still have any defects and that they have all their possessions. Ask them how they died, if they know, so that you can report any foul play over the radio.
				Once you're done, your patient is ready to go back to work! Chances are they do not have Medbay access, so you should let them out of Genetics and the Medbay main entrance.

				<p>If you've gotten this far, congratulations! You have mastered the art of cloning. Now, the real problem is how to resurrect yourself after that traitor had his way with you for cloning his target.

				</body>
				</html>
				"}


/obj/item/book/manual/ripley_build_and_repair
	name = "APLU \"Ripley\" Construction and Operation Manual"
	icon_state ="book"
	author = "Randall Varn, Einstein Engines Senior Mechanic"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "APLU \"Ripley\" Construction and Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ul.a {list-style-type: none; margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<center>
				<br>
				<span style='font-size: 12px;'><b>Weyland-Yutani - Building Better Worlds</b></span>
				<h1>Autonomous Power Loader Unit \"Ripley\"</h1>
				</center>
				<h2>Specifications:</h2>
				<ul class="a">
				<li><b>Class:</b> Autonomous Power Loader</li>
				<li><b>Scope:</b> Logistics and Construction</li>
				<li><b>Weight:</b> 820kg (without operator and with empty cargo compartment)</li>
				<li><b>Height:</b> 2.5m</li>
				<li><b>Width:</b> 1.8m</li>
				<li><b>Top speed:</b> 5km/hour</li>
				<li><b>Operation in vacuum/hostile environment: Possible</b>
				<li><b>Airtank volume:</b> 500 liters</li>
				<li><b>Devices:</b>
					<ul class="a">
					<li>Hydraulic clamp</li>
					<li>High-speed drill</li>
					</ul>
				</li>
				<li><b>Propulsion device:</b> Powercell-powered electro-hydraulic system</li>
				<li><b>Powercell capacity:</b> Varies</li>
				</ul>

				<h2>Construction:</h2>
				<ol>
					<li>Connect all exosuit parts to the chassis frame.</li>
					<li>Connect all hydraulic fittings and tighten them up with a wrench.</li>
					<li>Adjust the servohydraulics with a screwdriver.</li>
					<li>Wire the chassis (Cable is not included).</li>
					<li>Use the wirecutters to remove the excess cable if needed.</li>
					<li>Install the central control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the mainboard with a screwdriver.</li>
					<li>Install the peripherals control module (Not included. Use supplied datadisk to create one).</li>
					<li>Secure the peripherals control module with a screwdriver.</li>
					<li>Install the internal armor plating (Not included due to corporate regulations. Can be made using 5 metal sheets).</li>
					<li>Secure the internal armor plating with a wrench.</li>
					<li>Weld the internal armor plating to the chassis.</li>
					<li>Install the external reinforced armor plating (Not included due to corporate regulations. Can be made using 5 reinforced metal sheets).</li>
					<li>Secure the external reinforced armor plating with a wrench.</li>
					<li>Weld the external reinforced armor plating to the chassis.</li>
				</ol>

				<h2>Additional Information:</h2>
				<ul>
					<li>The firefighting variation is made in a similar fashion.</li>
					<li>A firesuit must be connected to the firefighter chassis for heat shielding.</li>
					<li>Internal armor is plasteel for additional strength.</li>
					<li>External armor must be installed in 2 parts, totalling 10 sheets.</li>
					<li>Completed mech is more resilient against fire, and is a bit more durable overall.</li>
					<li>The Company is determined to ensure the safety of its <s>investments</s> employees.</li>
				</ul>
				</body>
			</html>
			"}


/obj/item/book/manual/research_and_development
	name = "Research and Development 101"
	icon_state = "rdbook"
	author = "Dr. L. Ight"
	title = "Research and Development 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Science For Dummies</h1>
				So you want to further SCIENCE? Good man/woman/thing! However, SCIENCE is a complicated process even though it's quite easy. For the most part, it's a three step process:
				<ol>
					<li><b>Deconstruct</b> items in the Destructive Analyzer to advance technology or improve the design.</li>
					<li><b>Build</b> unlocked designs in the Protolathe and Circuit Imprinter.</li>
					<li><b>Repeat</b>!</li>
				</ol>

				Those are the basic steps to furthering science. What do you do science with, however? Well, you have four major tools: R&D Console, the Destructive Analyzer, the Protolathe, and the Circuit Imprinter.

				<h2>The R&D Console</h2>
				The R&D console is the cornerstone of any research lab. It is the central system from which the Destructive Analyzer, Protolathe, and Circuit Imprinter (your R&D systems) are controlled. More on those systems in their own sections.
				On its own, the R&D console acts as a database for all your technological gains and new devices you discover. So long as the R&D console remains intact, you'll retain all that SCIENCE you've discovered. Protect it though,
				because if it gets damaged, you'll lose your data!
				In addition to this important purpose, the R&D console has a disk menu that lets you transfer data from the database onto disk or from the disk into the database.
				It also has a settings menu that lets you re-sync with nearby R&D devices (if they've become disconnected), lock the console from the unworthy,
				upload the data to all other R&D consoles in the network (all R&D consoles are networked by default), connect/disconnect from the network, and purge all data from the database.<br><br>

				<b>NOTE:</b> The technology list screen, circuit imprinter, and protolathe menus are accessible by non-scientists. This is intended to allow 'public' systems for the plebians to utilize some new devices.

				<h2>Destructive Analyzer</h2>
				This is the source of all technology. Whenever you put a handheld object in it, it analyzes it and determines what sort of technological advancements you can discover from it. If the technology of the object is equal or higher then your current knowledge,
				you can destroy the object to further those sciences.
				Some devices (notably, some devices made from the protolathe and circuit imprinter) aren't 100% reliable when you first discover them. If these devices break down, you can put them into the Destructive Analyzer and improve their reliability rather than further science.
				If their reliability is high enough, it'll also advance their related technologies.

				<h2>Circuit Imprinter</h2>
				This machine, along with the Protolathe, is used to actually produce new devices. The Circuit Imprinter takes glass and various chemicals (depends on the design) to produce new circuit boards to build new machines or computers. It can even be used to print AI modules.

				<h2>Protolathe</h2>
				This machine is an advanced form of the Autolathe that produce non-circuit designs. Unlike the Autolathe, it can use processed metal, glass, solid phoron, silver, gold, and diamonds along with a variety of chemicals to produce devices.
				The downside is that, again, not all devices you make are 100% reliable when you first discover them.

				<h2>Reliability and You</h2>
				As it has been stated, many devices, when they're first discovered, do not have a 100% reliability. Instead,
				the reliability of the device is dependent upon a base reliability value, whatever improvements to the design you've discovered through the Destructive Analyzer,
				and any advancements you've made with the device's source technologies. To be able to improve the reliability of a device, you have to use the device until it breaks beyond repair. Once that happens, you can analyze it in a Destructive Analyzer.
				Once the device reaches a certain minimum reliability, you'll gain technological advancements from it.

				<h2>Building a Better Machine</h2>
				Many machines produced from circuit boards inserted into a machine frames require a variety of parts to construct. These are parts like capacitors, batteries, matter bins, and so forth. As your knowledge of science improves, more advanced versions are unlocked.
				If you use these parts when constructing something, its attributes may be improved.
				For example, if you use an advanced matter bin when constructing an autolathe (rather than a regular one), it'll hold more materials. Experiment around with stock parts of various qualities to see how they affect the end results! Be warned, however:
				Tier 3 and higher stock parts don't have 100% reliability and their low reliability may affect the reliability of the end machine.
				</body>
			</html>
			"}


/obj/item/book/manual/robotics_cyborgs
	name = "Cyborgs for Dummies"
	icon_state = "borgbook"
	author = "XISC"
	title = "Cyborgs for Dummies"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 18px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Cyborgs for Dummies</h1>

				<h2>Chapters</h2>

				<ol>
					<li><a href="#Equipment">Cyborg Related Equipment</a></li>
					<li><a href="#Modules">Cyborg Modules</a></li>
					<li><a href="#Construction">Cyborg Construction</a></li>
					<li><a href="#Maintenance">Cyborg Maintenance</a></li>
					<li><a href="#Repairs">Cyborg Repairs</a></li>
					<li><a href="#Emergency">In Case of Emergency</a></li>
				</ol>


				<h2><a name="Equipment">Cyborg Related Equipment</h2>

				<h3>Exosuit Fabricator</h3>
				The Exosuit Fabricator is the most important piece of equipment related to cyborgs. It allows the construction of the core cyborg parts. Without these machines, cyborgs cannot be built. It seems that they may also benefit from advanced research techniques.

				<h3>Cyborg Recharging Station</h3>
				This useful piece of equipment will suck power out of the power systems to charge a cyborg's power cell back up to full charge.

				<h3>Robotics Control Console</h3>
				This useful piece of equipment can be used to immobilize or destroy a cyborg. A word of warning: Cyborgs are expensive pieces of equipment, do not destroy them without good reason, or the Company may see to it that it never happens again.


				<h2><a name="Modules">Cyborg Modules</h2>
				When a cyborg is created it picks out of an array of modules to designate its purpose. There are 6 different cyborg modules.

				<h3>Standard Cyborg</h3>
				The standard cyborg module is a multi-purpose cyborg. It is equipped with various modules, allowing it to do basic tasks.<br>A Standard Cyborg comes with:
				<ul>
				  <li>Crowbar</li>
				  <li>Stun Baton</li>
				  <li>Health Analyzer</li>
				  <li>Fire Extinguisher</li>
				</ul>

				<h3>Engineering Cyborg</h3>
				The Engineering cyborg module comes equipped with various engineering-related tools to help with engineering-related tasks.<br>An Engineering Cyborg comes with:
				<ul>
				  <li>A basic set of engineering tools</li>
				  <li>Metal Synthesizer</li>
				  <li>Reinforced Glass Synthesizer</li>
				  <li>A Rapid-Fabrication-Device C-Class</li>
				  <li>Wire Synthesizer</li>
				  <li>Fire Extinguisher</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Mining Cyborg</h3>
				The Mining Cyborg module comes equipped with the latest in mining equipment. They are efficient at mining due to no need for oxygen, but their power cells limit their time in the mines.<br>A Mining Cyborg comes with:
				<ul>
				  <li>Jackhammer</li>
				  <li>Shovel</li>
				  <li>Mining Satchel</li>
				  <li>Built-in Optical Meson Scanners</li>
				</ul>

				<h3>Security Cyborg</h3>
				The Security Cyborg module is equipped with effective security measures used to apprehend and arrest criminals without harming them a bit.<br>A Security Cyborg comes with:
				<ul>
				  <li>Stun Baton</li>
				  <li>Handcuffs</li>
				  <li>Taser</li>
				</ul>

				<h3>Janitor Cyborg</h3>
				The Janitor Cyborg module is equipped with various cleaning-facilitating devices.<br>A Janitor Cyborg comes with:
				<ul>
				  <li>Mop</li>
				  <li>Hand Bucket</li>
				  <li>Cleaning Spray Synthesizer and Spray Nozzle</li>
				</ul>

				<h3>Service Cyborg</h3>
				The service cyborg module comes ready to serve your human needs. It includes various entertainment and refreshment devices. Occasionally some service cyborgs may have been referred to as "Bros."<br>A Service Cyborg comes with:
				<ul>
				  <li>Shaker</li>
				  <li>Industrial Dropper</li>
				  <li>Platter</li>
				  <li>Beer Synthesizer</li>
				  <li>Zippo Lighter</li>
				  <li>Rapid-Service-Fabricator (Produces various entertainment and refreshment objects)</li>
				  <li>Pen</li>
				</ul>

				<h2><a name="Construction">Cyborg Construction</h2>
				Cyborg construction is a rather easy process, requiring a decent amount of metal and a few other supplies.<br>The required materials to make a cyborg are:
				<ul>
				  <li>Metal</li>
				  <li>Two Flashes</li>
				  <li>One Power Cell (Preferably rated to 15000w)</li>
				  <li>Some electrical wires</li>
				  <li>One Human Brain</li>
				  <li>One Man-Machine Interface</li>
				</ul>
				Once you have acquired the materials, you can start on construction of your cyborg.<br>To construct a cyborg, follow the steps below:
				<ol>
				  <li>Start the Exosuit Fabricators constructing all of the cyborg parts</li>
				  <li>While the parts are being constructed, take your human brain, and place it inside the Man-Machine Interface</li>
				  <li>Once you have a Robot Head, place your two flashes inside the eye sockets</li>
				  <li>Once you have your Robot Chest, wire the Robot chest, then insert the power cell</li>
				  <li>Attach all of the Robot parts to the Robot frame</li>
				  <li>Insert the Man-Machine Interface (With the Brain inside) into the Robot Body</li>
				  <li>Congratulations! You have a new cyborg!</li>
				</ol>

				<h2><a name="Maintenance">Cyborg Maintenance</h2>
				Occasionally Cyborgs may require maintenance of a couple types, this could include replacing a power cell with a charged one, or possibly maintaining the cyborg's internal wiring.

				<h3>Replacing a Power Cell</h3>
				Replacing a Power cell is a common type of maintenance for cyborgs. It usually involves replacing the cell with a fully charged one, or upgrading the cell with a larger capacity cell.<br>The steps to replace a cell are as follows:
				<ol>
				  <li>Unlock the Cyborg's Interface by swiping your ID on it</li>
				  <li>Open the Cyborg's outer panel using a crowbar</li>
				  <li>Remove the old power cell</li>
				  <li>Insert the new power cell</li>
				  <li>Close the Cyborg's outer panel using a crowbar</li>
				  <li>Lock the Cyborg's Interface by swiping your ID on it, this will prevent non-qualified personnel from attempting to remove the power cell</li>
				</ol>

				<h3>Exposing the Internal Wiring</h3>
				Exposing the internal wiring of a cyborg is fairly easy to do, and is mainly used for cyborg repairs.<br>You can easily expose the internal wiring by following the steps below:
				<ol>
					<li>Follow Steps 1 - 3 of "Replacing a Cyborg's Power Cell"</li>
					<li>Open the cyborg's internal wiring panel by using a screwdriver to unsecure the panel</li>
				</ol>
				To re-seal the cyborg's internal wiring:
				<ol>
					<li>Use a screwdriver to secure the cyborg's internal panel</li>
					<li>Follow steps 4 - 6 of "Replacing a Cyborg's Power Cell" to close up the cyborg</li>
				</ol>

				<h2><a name="Repairs">Cyborg Repairs</h2>
				Occasionally a Cyborg may become damaged. This could be in the form of impact damage from a heavy or fast-travelling object, or it could be heat damage from high temperatures, or even lasers or Electromagnetic Pulses (EMPs).

				<h3>Dents</h3>
				If a cyborg becomes damaged due to impact from heavy or fast-moving objects, it will become dented. Sure, a dent may not seem like much, but it can compromise the structural integrity of the cyborg, possibly causing a critical failure.
				Dents in a cyborg's frame are rather easy to repair, all you need is to apply a welding tool to the dented area, and the high-tech cyborg frame will repair the dent under the heat of the welder.

				<h3>Excessive Heat Damage</h3>
				If a cyborg becomes damaged due to excessive heat, it is likely that the internal wires will have been damaged. You must replace those wires to ensure that the cyborg remains functioning properly.<br>To replace the internal wiring follow the steps below:
				<ol>
					<li>Unlock the Cyborg's Interface by swiping your ID</li>
					<li>Open the Cyborg's External Panel using a crowbar</li>
					<li>Remove the Cyborg's Power Cell</li>
					<li>Using a screwdriver, expose the internal wiring of the Cyborg</li>
					<li>Replace the damaged wires inside the cyborg</li>
					<li>Secure the internal wiring cover using a screwdriver</li>
					<li>Insert the Cyborg's Power Cell</li>
					<li>Close the Cyborg's External Panel using a crowbar</li>
					<li>Lock the Cyborg's Interface by swiping your ID</li>
				</ol>
				These repair tasks may seem difficult, but are essential to keep your cyborgs running at peak efficiency.

				<h2><a name="Emergency">In Case of Emergency</h2>
				In case of emergency, there are a few steps you can take.

				<h3>"Rogue" Cyborgs</h3>
				If the cyborgs seem to become "rogue", they may have non-standard laws. In this case, use extreme caution.
				To repair the situation, follow these steps:
				<ol>
					<li>Locate the nearest robotics console</li>
					<li>Determine which cyborgs are "Rogue"</li>
					<li>Press the lockdown button to immobilize the cyborg</li>
					<li>Locate the cyborg</li>
					<li>Expose the cyborg's internal wiring</li>
					<li>Check to make sure the LawSync and AI Sync lights are lit</li>
					<li>If they are not lit, pulse the LawSync wire using a multitool to enable the cyborg's LawSync</li>
					<li>Proceed to a cyborg upload console. The Company usually places these in the same location as AI upload consoles.</li>
					<li>Use a "Reset" upload moduleto reset the cyborg's laws</li>
					<li>Proceed to a Robotics Control console</li>
					<li>Remove the lockdown on the cyborg</li>
				</ol>

				<h3>As a last resort</h3>
				If all else fails in a case of cyborg-related emergency, there may be only one option. Using a Robotics Control console, you may have to remotely detonate the cyborg.
				<h3>WARNING:</h3> Do not detonate a borg without an explicit reason for doing so. Cyborgs are expensive pieces of company equipment, and you may be punished for detonating them without reason.

				</body>
			</html>
		"}

/obj/item/book/manual/wiki/security_space_law
	name = "Corporate Regulations"
	desc = "A set of corporate guidelines for keeping law and order on privately-owned space stations."
	icon_state = "bookSpaceLaw"
	author = "The Company"
	title = "Corporate Regulations"
	sub_page = "Corporate_Regulations"

/obj/item/book/manual/wiki/station_procedure
	name = "Station Procedure"
	desc = "A set of uniform procedures followed on all NanoTrasen installations."
	icon_state = "corporate-procedure"
	title = "The Company"
	title = "Station Procedure"
	sub_page = "Guide_to_Station_Procedure"

/obj/item/book/manual/medical_diagnostics_manual
	name = "Medical Diagnostics Manual"
	desc = "First, do no harm. A detailed medical practitioner's guide."
	icon_state = "bookMedical"
	author = "Medical Department"
	title = "Medical Diagnostics Manual"

/obj/item/book/manual/medical_diagnostics_manual/Initialize()
	. = ..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<br>
				<h1>The Oath</h1>

				<i>The Medical Oath sworn by recognised medical practitioners in the employ of [current_map.company_name]</i><br>

				<ol>
					<li>Now, as a new doctor, I solemnly promise that I will, to the best of my ability, serve humanity-caring for the sick, promoting good health, and alleviating pain and suffering.</li>
					<li>I recognise that the practice of medicine is a privilege with which comes considerable responsibility and I will not abuse my position.</li>
					<li>I will practise medicine with integrity, humility, honesty, and compassion-working with my fellow doctors and other colleagues to meet the needs of my patients.</li>
					<li>I shall never intentionally do or administer anything to the overall harm of my patients.</li>
					<li>I will not permit considerations of gender, race, religion, political affiliation, sexual orientation, nationality, or social standing to influence my duty of care.</li>
					<li>I will oppose policies in breach of human rights and will not participate in them. I will strive to change laws that are contrary to my profession's ethics and will work towards a fairer distribution of health resources.</li>
					<li>I will assist my patients to make informed decisions that coincide with their own values and beliefs and will uphold patient confidentiality.</li>
					<li>I will recognise the limits of my knowledge and seek to maintain and increase my understanding and skills throughout my professional life. I will acknowledge and try to remedy my own mistakes and honestly assess and respond to those of others.</li>
					<li>I will seek to promote the advancement of medical knowledge through teaching and research.</li>
					<li>I make this declaration solemnly, freely, and upon my honour.</li>
				</ol><br>

				<HR COLOR="steelblue" WIDTH="60%" ALIGN="LEFT">

				<iframe width='100%' height='100%' src="[config.wikiurl]Guide_to_Medicine&printable=yes&removelinks=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>

		"}


/obj/item/book/manual/wiki/engineering_guide
	name = "Engineering Textbook"
	icon_state ="bookEngineering2"
	author = "Engineering Encyclopedia"
	title = "Engineering Textbook"
	sub_page = "Guide_to_Engineering"

/obj/item/book/manual/chef_recipes
	name = "Chef Recipes"
	icon_state = "cooked_book"
	author = "Victoria Ponsonby"
	title = "Chef Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Food for Dummies</h1>
				Here is a guide on basic food recipes and also how to not poison your customers accidentally.

				<h3>Basics:</h3>
				Knead an egg and some flour to make dough. Bake that to make a bun or flatten and cut it.

				<h3>Burger:</h3>
				Put a bun and some meat into the microwave and turn it on. Then wait.

				<h3>Bread:</h3>
				Put some dough and an egg into the microwave and then wait.

				<h3>Waffles:</h3>
				Add two lumps of dough and 10 units of sugar to the microwave and then wait.

				<h3>Popcorn:</h3>
				Add 1 corn to the microwave and wait.

				<h3>Meat Steak:</h3>
				Put a slice of meat, 1 unit of salt, and 1 unit of pepper into the microwave and wait.

				<h3>Meat Pie:</h3>
				Put a flattened piece of dough and some meat into the microwave and wait.

				<h3>Boiled Spaghetti:</h3>
				Put the spaghetti (processed flour) and 5 units of water into the microwave and wait.

				<h3>Donuts:</h3>
				Add some dough and 5 units of sugar to the microwave and wait.

				<h3>Fries:</h3>
				Add one potato to the processor, then bake them in the microwave.


				</body>
			</html>
			"}


/obj/item/book/manual/barman_recipes
	name = "Barman Recipes"
	icon_state = "barbook"
	author = "Sir John Rose"
	title = "Barman Recipes"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				h3 {font-size: 13px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1>Drinks for Dummies</h1>
				Here's a guide for some basic drinks.

				<h3>Black Russian:</h3>
				Mix vodka and Kahlua into a glass.

				<h3>Cafe Latte:</h3>
				Mix milk and coffee into a glass.

				<h3>Classic Martini:</h3>
				Mix vermouth and gin into a glass.

				<h3>Gin Tonic:</h3>
				Mix gin and tonic into a glass.

				<h3>Grog:</h3>
				Mix rum and water into a glass.

				<h3>Irish Cream:</h3>
				Mix cream and whiskey into a glass.

				<h3>The Manly Dorf:</h3>
				Mix ale and beer into a glass.

				<h3>Mead:</h3>
				Mix enzyme, water, and sugar into a glass.

				<h3>Screwdriver:</h3>
				Mix vodka and orange juice into a glass.

				</body>
			</html>
			"}


/obj/item/book/manual/detective
	name = "The Film Noir: Proper Procedures for Investigations"
	icon_state ="bookDetective"
	author = "The Company"
	title = "The Film Noir: Proper Procedures for Investigations"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Detective Work</h1>

				Between your bouts of self-narration and drinking whiskey on the rocks, you might get a case or two to solve.<br>
				To have the best chance to solve your case, follow these directions:
				<p>
				<ol>
					<li>Go to the crime scene. </li>
					<li>Take your scanner and scan EVERYTHING (Yes, the doors, the tables, even the dog). </li>
					<li>Once you are reasonably certain you have every scrap of evidence you can use, find all possible entry points and scan them, too. </li>
					<li>Return to your office. </li>
					<li>Using your forensic scanning computer, scan your scanner to upload all of your evidence into the database.</li>
					<li>Browse through the resulting dossiers, looking for the one that either has the most complete set of prints, or the most suspicious items handled. </li>
					<li>If you have 80% or more of the print (The print is displayed), go to step 10, otherwise continue to step 8.</li>
					<li>Look for clues from the suit fibres you found on your perpetrator, and go about looking for more evidence with this new information, scanning as you go. </li>
					<li>Try to get a fingerprint card of your perpetrator, as if used in the computer, the prints will be completed on their dossier.</li>
					<li>Assuming you have enough of a print to see it, grab the biggest complete piece of the print and search the security records for it. </li>
					<li>Since you now have both your dossier and the name of the person, print both out as evidence and get security to nab your baddie.</li>
					<li>Give yourself a pat on the back and a bottle of the ship's finest vodka, you did it!</li>
				</ol>
				<p>
				It really is that easy! Good luck!

				</body>
			</html>"}

/obj/item/book/manual/nuclear
	name = "Fission Mailed: Nuclear Sabotage 101"
	icon_state ="bookNuclear"
	author = "Syndicate"
	title = "Fission Mailed: Nuclear Sabotage 101"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<h1>Nuclear Explosives 101</h1>
				Hello and thank you for choosing the Syndicate for your nuclear information needs. Today's crash course will deal with the operation of a Nuclear Fission Device.<br><br>

				First and foremost, DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE. Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done, to unbolt it, one must completely log in, which at this time may not be possible.<br>

				<h2>To make the nuclear device functional</h2>
				<ul>
					<li>Place the nuclear device in the designated detonation zone.</li>
					<li>Extend and anchor the nuclear device from its interface.</li>
					<li>Insert the nuclear authorisation disk into the slot.</li>
					<li>Type the numeric authorisation code into the keypad. This should have been provided.<br>
					<b>Note</b>: If you make a mistake, press R to reset the device.
					<li>Press the E button to log on to the device.</li>
				</ul><br>

				You now have activated the device. To deactivate the buttons at anytime, for example when you've already prepped the bomb for detonation, remove the authentication disk OR press R on the keypad.<br><br>
				Now the bomb CAN ONLY be detonated using the timer. Manual detonation is not an option. Toggle off the SAFETY.<br>
				<b>Note</b>: You wouldn't believe how many Syndicate Operatives with doctorates have forgotten this step.<br><br>

				So use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>
				<b>Note</b>: THE BOMB IS STILL SET AND WILL DETONATE<br><br>

				Now before you remove the disk, if you need to move the bomb, you can toggle off the anchor, move it, and re-anchor.<br><br>

				Remember the order:<br>
				<b>Disk, Code, Safety, Timer, Disk, RUN!</b><br><br>
				Intelligence Analysts believe that normal corporate procedure is for the Captain to secure the nuclear authentication disk.<br><br>

				Good luck!
				</body>
			</html>
			"}

/obj/item/book/manual/atmospipes
	name = "Pipes and You: Getting To Know Your Scary Tools"
	icon_state = "pipingbook"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "Pipes and You: Getting To Know Your Scary Tools"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Contents">Contents</a></h1>
				<ol>
					<li><a href="#Foreword">Author's Foreword</a></li>
					<li><a href="#Basic">Basic Piping</a></li>
					<li><a href="#Insulated">Insulated Pipes</a></li>
					<li><a href="#Devices">Atmospherics Devices</a></li>
					<li><a href="#HES">Heat Exchange Systems</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol><br>

				<h1><a name="Foreword"><U><B>HOW TO NOT SUCK QUITE SO HARD AT ATMOSPHERICS</B></U></a></h1><BR>
				<I>Or: What the fuck does a "pressure regulator" do?</I><BR><BR>

				Alright. It has come to my attention that a variety of people are unsure of what a "pipe" is and what it does.
				Apparently, there is an unnatural fear of these arcane devices and their "gases." Spooky, spooky. So,
				this will tell you what every device constructable by an ordinary pipe dispenser within atmospherics actually does.
				You are not going to learn what to do with them to be the super best person ever, or how to play guitar with passive gates,
				or something like that. Just what stuff does.<BR><BR>


				<h1><a name="Basic"><B>Basic Pipes</B></a></h1>
				<I>The boring ones.</I><BR>
				Most ordinary pipes are pretty straightforward. They hold gas. If gas is moving in a direction for some reason, gas will flow in that direction.
				That's about it. Even so, here's all of your wonderful pipe options.<BR>

				<ul>
				<li><b>Straight pipes:</b> They're pipes. One-meter sections. Straight line. Pretty simple. Just about every pipe and device is based around this
				standard one-meter size, so most things will take up as much space as one of these.</li>
				<li><b>Bent pipes:</b> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><b>Pipe manifolds:</b> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><b>4-way manifold:</b> A four-way junction.</li>
				<li><b>Pipe cap:</b> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh, use them to decorate your house or something.</li>
				<li><b>Manual valve:</b> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><b>Manual T-valve:</b> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>
				</ul>

				An important note here is that pipes are now done in three distinct lines - general, supply, and scrubber. You can move gases between these with a universal adapter. Use the correct position for the correct location.
				Connecting scrubbers to a supply position pipe makes you an idiot who gives everyone a difficult job. Insulated and HE pipes don't go through these positions.

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1>
				<li><I>Bent pipes:</I> Pipes with a 90 degree bend at the half-meter mark. My goodness.</li>
				<li><I>Pipe manifolds:</I> Pipes that are essentially a "T" shape, allowing you to connect three things at one point.</li>
				<li><I>4-way manifold:</I> A four-way junction.</li>
				<li><I>Pipe cap:</I> Caps off the end of a pipe. Open ends don't actually vent air, because of the way the pipes are assembled, so, uh. Use them to decorate your house or something.</li>
				<li><I>Manual Valve:</I> A valve that will block off airflow when turned. Can't be used by the AI or cyborgs, because they don't have hands.</li>
				<li><I>Manual T-Valve:</I> Like a manual valve, but at the center of a manifold instead of a straight pipe.</li><BR><BR>

				<h1><a name="Insulated"><B>Insulated Pipes</B></a></h1><BR>
				<I>Special Public Service Announcement.</I><BR>
				Our regular pipes are already insulated. These are completely worthless. Punch anyone who uses them.<BR><BR>

				<h1><a name="Devices"><B>Devices: </B></a></h1>
				<I>They actually do something.</I><BR>
				This is usually where people get frightened, afraid, and start calling on their gods and/or cowering in fear. Yes, I can see you doing that right now.
				Stop it. It's unbecoming. Most of these are fairly straightforward.<BR>

				<ul>
				<li><b>Gas pump:</b> Take a wild guess. It moves gas in the direction it's pointing (marked by the red line on one end). It moves it based on pressure, the maximum output being 15000 kPa (kilopascals).
				Ordinary atmospheric pressure, for comparison, is 101.3 kPa, and the minimum pressure of room-temperature pure oxygen needed to not suffocate in a matter of minutes is 16 kPa
				(though 18 kPa is preferred when using internals with pure oxygen, for various reasons). A high-powered variant will move gas more quickly at the expense of consuming more power. Do not turn the distribution loop up to 15000 kPa.
				You will make engiborgs cry and the Chief Engineer will beat you.</li>
				<li><b>Pressure regulator:</b> These replaced the old passive gates. You can choose to regulate pressure by input or output, and regulate flow rate. Regulating by input means that when input pressure is above the limit, gas will flow.
				Regulating by output means that when pressure is below the limit, gas will flow. Flow rate can be controlled.</li>
				<li><b>Unary vent:</b> The basic vent used in rooms. It pumps gas into the room, but can't suck it back out. Controlled by the room's air alarm system.</li>
				<li><b>Scrubber:</b> The other half of room equipment. Filters air, and can suck it in entirely in what's called a "panic siphon." Activating a panic siphon without very good reason will kill someone. Don't do it.</li>
				<li><b>Meter:</b> A little box with some gauges and numbers. Fasten it to any pipe or manifold and it'll read you the pressure in it. Very useful.</li>
				<li><b>Gas mixer:</b> Two sides are input, one side is output. Mixes the gases pumped into it at the ratio defined. The side perpendicular to the other two is "node 2," for reference, on non-mirrored mixers..
				Output is controlled by flow rate. There is also an "omni" variant that allows you to set input and output sections freely..</li>
				<li><b>Gas filter:</b> Essentially the opposite of a gas mixer. One side is input. The other two sides are output. One gas type will be filtered into the perpendicular output pipe,
				the rest will continue out the other side. Can also output from 0-4500 kPa. The "omni" vairant allows you to set input and output sections freely.</li>
				</ul>

				<h1><a name="HES"><B>Heat Exchange Systems</B></a></h1>
				<I>Will not set you on fire.</I><BR>
				These systems are used to only transfer heat between two pipes. They will not move gases or any other element, but will equalize the temperature (eventually). Note that because of how gases work (remember: pv=nRt),
				a higher temperature will raise pressure, and a lower one will lower temperature.<BR>

				<li><I>Pipe:</I> This is a pipe that will exchange heat with the surrounding atmosphere. Place in fire for superheating. Place in space for supercooling.</li>
				<li><I>Bent pipe:</I> Take a wild guess.</li>
				<li><I>Junction:</I> The point where you connect your normal pipes to heat exchange pipes. Not necessary for heat exchangers, but necessary for H/E pipes/bent pipes.</li>
				<li><I>Heat exchanger:</I> These funky-looking bits attach to an open pipe end. Put another heat exchanger directly across from it, and you can transfer heat across two pipes without having to have the gases touch.
				This normally shouldn't exchange with the ambient air, despite being totally exposed. Just don't ask questions.</li><BR>

				That's about it for pipes. Go forth, armed with this knowledge, and try not to break, burn down, or kill anything. Please.


				</body>
			</html>
			"}

/obj/item/book/manual/evaguide
	name = "EVA Gear and You: Not Spending All Day Inside"
	icon_state = "evabook"
	author = "Maria Crash, Senior Atmospherics Technician"
	title = "EVA Gear and You: Not Spending All Day Inside"
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>

				<h1><a name="Foreword">EVA Gear and You: Not Spending All Day Inside</a></h1>
				<I>Or: How not to suffocate because there's a hole in your shoes</I><BR>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Foreword">A foreword on using EVA gear</a></li>
					<li><a href="#Civilian">Donning a Civilian Suit</a></li>
					<li><a href="#Voidsuit">Putting on a Voidsuit</a></li>
					<li><a href="#Equipment">Cyclers and Other Modification Equipment</a></li>
					<li><a href="#Final">Final Checks</a></li>
				</ol>
				<br>

				EVA gear. Wonderful to use. It's useful for mining, engineering, and occasionally just surviving, if things are that bad. Most people have EVA training,
				but apparently there are some on a space station who don't. This guide should give you a basic idea of how to use this gear, safely. It's split into two sections:
				 Civilian suits and voidsuits.<BR><BR>

				<h2><a name="Civilian">Civilian Suits</a></h2>
				<I>The bulkiest things this side of Alpha Centauri</I><BR>
				These suits are the grey ones that are stored in EVA. They're the more simple to get on, but are also a lot bulkier, and provide less protection from environmental hazards such as radiation or physical impact.
				As Medical, Engineering, Security, and Mining all have voidsuits of their own, these don't see much use, but knowing how to put them on is quite useful anyways.<BR><BR>

				First, take the suit. It should be in three pieces: A top, a bottom, and a helmet. Put the bottom on first, shoes and the like will fit in it. If you have magnetic boots, however,
				put them on on top of the suit's feet. Next, get the top on, as you would a shirt. It can be somewhat awkward putting these pieces on, due to the makeup of the suit,
				but to an extent they will adjust to you. You can then find the snaps and seals around the waist, where the two pieces meet. Fasten these, and double-check their tightness.
				The red indicators around the waist of the lower half will turn green when this is done correctly. Next, put on whatever breathing apparatus you're using, be it a gas mask or a breath mask. Make sure the oxygen tube is fastened into it.
				Put on the helmet now, straightforward, and make sure the tube goes into the small opening specifically for internals. Again, fasten seals around the neck, a small indicator light in the inside of the helmet should go from red to off when all is fastened.
				There is a small slot on the side of the suit where an emergency oxygen tank or extended emergency oxygen tank will fit,
				but it is recommended to have a full-sized tank on your back for EVA.<BR><BR>

				These suits tend to be wearable by most species. They're large and flexible. They might be pretty uncomfortable for some, though, so keep that in mind.<BR><BR>

				<h2><a name="Voidsuit">Voidsuits</a></h2>
				<I>Heavy, uncomfortable, still the best option.</I><BR>
				These suits come in Engineering, Mining, and EVA. There's also a couple Medical Voidsuits in EVA. These provide a lot more protection than the standard suits.<BR><BR>

				Similarly to the other suits, these are split into three parts. Fastening the pant and top are mostly the same as the other spacesuits, with the exception that these are a bit heavier,
				though not as bulky. The helmet goes on differently, with the air tube feeding into the suit and out a hole near the left shoulder, while the helmet goes on turned ninety degrees counter-clockwise,
				and then is screwed in for one and a quarter full rotations clockwise, leaving the faceplate directly in front of you. There is a small button on the right side of the helmet that activates the helmet light.
				The tanks that fasten onto the side slot are emergency tanks, as well as full-sized oxygen tanks, leaving your back free for a backpack or satchel.<BR><BR>

				These suits generally only fit one species. Nanotrasen's are usually human-fitting by default, but there's equipment that can make modifications to the voidsuits to fit them to other species.<BR><BR>

				<h2><a name="Equipment">Modification Equipment</a></h2>
				<I>How to actually make voidsuits fit you.</I><BR>
				There's a variety of equipment that can modify voidsuits to fit species that can't fit into them, making life quite a bit easier.<BR><BR>

				The first piece of equipment is a suit cycler. This is a large machine resembling the storage pods that are in place in some places. These are machines that will automatically tailor a suit to certain specifications.
				The largest uses of them are for their cleaning functions and their ability to tailor suits for a species. Do not enter them physically. You will die from any of the functions being activated, and it will be painful.
				These machines can both tailor a suit between species, and between types. This means you can convert engineering voidsuits to atmospherics, or the other way. This is useful. Use it if you can.<BR><BR>

				There's also modification kits that let you modify suits yourself. These are extremely difficult to use unless you understand the actual construction of the suit. I do not reccomend using them unless no other option is available.

				<h2><a name="Final">Final Checks</a></h2>
				<ul>
					<li>Are all seals fastened correctly?</li>
					<li>If you have modified it manually, is absolutely everything sealed perfectly?</li>
					<li>Do you either have shoes on under the suit, or magnetic boots on over it?</li>
					<li>Do you have a mask on and internals on the suit or your back?</li>
					<li>Do you have a way to communicate with the station in case something goes wrong?</li>
					<li>Do you have a second person watching if this is a training session?</li><BR>
				</ul>

				If you don't have any further issues, go out and do whatever is necessary.

				</body>
			</html>
			"}

/obj/item/book/manual/gravitygenerator
	name = "Gravity Generator Operation Manual"
	icon_state ="bookEngineering2"
	author = "Gravity Generator CO."
	title = "Gravity Generator Operation Manual"

	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<a name="Foreword"><h1>Gravity Generation for dummies!</h1></a>
				Thank you for your purchase of the newest model of the SA Grade Gravity Generator! This operation manual will cover the basics required for safely operating and maintaining your gravity generation system.<br><br>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Saftey">Basic Saftey</a></li>
					<li><a href="#StartUp">Starting The System</a></li>
					<li><a href="#ShutDown">Shutting Down The System</a></li>
					<li><a href="#p8549">Procedure 8549 (Repairing Physical Damage)</a></li>
					<li><a href="#MiscProcedures">Other Maintence Procedures</a></li>
				</ol>
				<br>

				<a name="Saftey"><h2>Basic Saftey</h2><br></a>
				Before starting any maintence protocols a basic set of safety instructions are to be followed to ensure safe operation of the system. They are as follows:
				<ul>
					<li>Gather all proper radiation equipment including: A Class A full body radiation suit, proper eye protection (such as meson goggles), and a geiger counter if available.</li>
					<li>Announce over a station wide intercom that the gravity generator is going under maintence.</li>
					<li>Ensure there are no gas or chemical leaks inside the chamber before entering.</li>
					<li>Ensure all proper gear is gathered prior to entering which includes: radiation equipment, first aid equipment, and fire saftey equipment.<br></li>
					<b>Note</b>:If there is a fire in the chamber read: <a href="#p8548">Procedure 8548</a>
				</ul><br><br>

				<a name="StartUp"><h2>Starting The System</h2><br></a>
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li>
					<li>Do a complete inspection of the system and insure there are no physical defects.</li>
					<li>Locate the control panel on the gravity generator. This is located on the bottom most part of the generator.</li>
					<li>Locate the main beaker switch and switch it to the ON position.</li>
					<li>Wait for the charge to raise to 100 percent before proceeding.<br></li>
					<li>Ensure that the gravity systems are working. If not, examine the generator for any physical damage.<br></li>
					<b>Note</b>:If the startup procedure fails due to physical damage, read: <a href="#p8549">Procedure 8549</a>
				</ul><br><br>

				<a name="StartUp"><h2>Shutting Down The System</h2><br></a>
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li><br>
					<li>Locate the control panel on the gravity generator. This is located on the bottom most part of the generator.</li><br>
					<li>Locate the main beaker switch and switch it to the OFF position.</li><br>
					<li>Wait for the charge to drop to 0 percent before leaving.<br></li>
					<li>Ensure that there is no longer garvity.</a><br></li>
					<b>Note</b>:If the shutdown procedure fails, read: <a href="#p9142">Procedure 9142</a>
				</ul><br><br>

				<a name="p8549"><h2>Procedure 8549 (Repairing Physical Damage)</h2><br></a>
				In the case of physical damage to your gravity generation systems, follow the following steps:<br>
				<b>Note</b>:In the case of total destruction of the system, read:<a href="#p2482">Procedure 2482</a>
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li><br>
					<li>Follow: <a href="#ShutDown">Shutdown Procedure</a><br>
					<li>Ensure the framework is properly secured with a screwdriver.<br></li>
					<li>If the framework is damage, weld the damaged plating.<br></li>
					<li>Apply plasteel plating to the welded damaged plating.<br></li>
					<li>Secure the plasteel to the plating with a wrench.<br></li>
					<li>Follow the <a href="#StartUp">Startup procedure</a></li>
				</ul><br>

				<a name="MiscProcedures"><h2>Other Procedures</h2><br></a>
				The following procedures cover special cases that may come up. If your issue is not found below, please follow the shutdown procedure and contact Gravity Generator CO.<br>

				<a name="p2482">Procedure 2482 (Total system destruction)<br></a>
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li><br>
					<li>If there are any remaining parts of the generator, ensure they are no longer powered.</li><br>
					<li>Announce that the gravity generator is destroyed and gravity will be out.</a></li><br>
					<li>Contact Gravity Generator CO for a replacement.</li><br>
					<b>Note</b>:Due to the complexity of the generator systems, no on-site replacement can be done.
				</ul><br><br>

				<a name="p8548">Procedure 8548 (Fire in the chamber)<br></a>
				In the event of a fire in the gravity generator chamber, complete the following steps.
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li><br>
					<li>Gather fire saftey equipment.</li><br>
					<li>If the generator is on, enter the chamber and follow:<a href="#p9142">Procedure 9142</a></li><br>
					<li>Extinguish the fire in a safe manner.</li><br>
					<li>Regulate the pressure in the chamber and ensure no gas leaks or chemical leaks are present.<br></li>
					<li>Follow <a href="#p8549">Procedure 8549</a><br></li>
					<li>Follow <a href="#StartUp">Startup procedure</a></li>
				</ul><br><br>

				<a name="p9142">Procedure 9142 (Emergency Shutdown)<br></a>
				The following procedure is only to be used in case of an emergency. Use of it otherwise could lead to injury, death, malfunction of the systems, an explosion, or a massive release of radiation.
				<ul>
					<li>Ensure all steps in basic saftey are completed.</li><br>
					<li>Locate the control panel on the gravity generator. This is located on the bottom most part of the generator.</li><br>
					<li>Pry open the electrical panel with a crowbar.</a></li><br>
					<li>Press the red button.</li><br>
					<li>Replace the panel with a crowbar.<br></li>
					<li>If the generator does not shut down, immediately cut the power to the room to prevent the risk of death.</li><br>
					<li>Follow the appropriate maintence procedure.</li>
				</ul><br><br>

				</body>
			</html>
			"}

/obj/item/book/manual/psych
	name = "Sigmund Freud for Dummies"
	desc = "The number one must-have manual for teaching you how to love your mother!"
	icon_state = "bookMedical"
	author = "NTCC Odin Psychiatry Wing"
	title = "Sigmund Freud for Dummies"

/obj/item/book/manual/psych/Initialize()
	. = ..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<a name="Foreword"><h1>The Code:</h1></a>
				The discipline of psychiatry is a time-honored art passed down from sensei to padawan over the ages. Under any circumstance, disclosing the contents of this sacred text is a violation of your honor.<br><br>

				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#Traumas">Traumas 101</a></li>
					<li><a href="#Hypnosis">Hypnosis and You</a></li>
					<li><a href="#Chakras">The Chakra In You</a></li>
					<li><a href="#Isolation">Putting a Patient in Time-out</a></li>
					<li><a href="#Surgery">When You Alone Aren't Good Enough: Surgery and Drugs</a></li>
				</ol>
				<br>

				<a name="Traumas"><h2>Traumas 101</h2><br></a>
				In your tenure as a psychiatrist aboard your assigned station you will likely encounter those affected by brain damage. Science in this regard has progressed, and in your disposal are several tools to cure these addled men and women. Keep in mind these bulletins:
				<ul>
					<li>1: Always talk to your patient first. Doctor-patient counseling is often necessary to get a good diagnosis of the patient's psychoma, and not to mention it can go a long way to comforting them. Never start treatment without counseling!</li>
					<li>2: Some of the most common traumas you find will be those that affect the patient's physical actions, such as seizures or tourettes. These are typically remedied with 'chakra' therapy.</li>
					<li>3: The next most common traumas are those that affect the patient's behavior, such as phobias. These can be solved with hypnosis therapy.</li>
					<li>4: Beyond those two, some traumas may cause the patient to hallucinate. These are best solved with isolation therapy.</li>
					<li>5: Finally, some traumas escape easy categorization. In a few cases they can be solved with invasive brain surgery, but some traumas may only be suppressable with drug therapy.<br></li>
					<b>Remember!</b>: Never begin therapy without counseling the patient!
				</ul><br><br>

				<a name="Hypnosis"><h2>Hypnosis and You</h2><br></a>
				<ul>
					<li>1. Ensure that the patient is comfortably seated and secure.</li>
					<li>2: If the patient firmly does not believe in hypnosis, attempt to convince them. Hypnosis will not work on someone actively resisting it.</li>
					<li>3: Utilizing the purpose-built mesmetron pocketwatch, initiate hypnosis as per your training.</li>
					<li>3b: Once the patient has entered their slumber, stay with them! Do not leave them unattended, for their are highly vulnerable in this state!</li>
					<li>4: Whisper to the patient a pertintent hypnotic suggestion for their current psychosis, at your discretion.<br></li>
					<li>5: Release the patient from their trance.<br></li>
					<b>Note</b>: It falls upon you to carefully word your suggestion to best handle the patient's psychosis. You may wish to pair multiple suggestions.
				</ul><br><br>

				<a name="Chakras"><h2>The Chakra In You</h2><br></a>
				<ul>
					<li>1: Strap the patient into your therapy pod, equipped with phoron-enhanced quartz healing crystals.</li><br>
					<li>2: Ensure the patient is comfortable. Warn them of possible surges and difficulties..</li><br>
					<li>3: Initiate a neural scan, taking careful notice of the number of brain anomalies. Compare them to notes from your counseling.</li><br>
					<li>4: Evaluate the patient's condition, determine the optimal number of cycles.<br></li>
					<li>5: Query the patient, and attempt to discern if the operation was successful. If not, repeat the process. Tend to any patient contamination</a><br></li>
					<b>Note</b>: The therapy pod is equipped only to deal with brain abnormalities that produce tangible physical behavioural alterations, such as seizures. Mis-timed cycles may contaminate the patient.
				</ul><br><br>

				<a name="Isolation"><h2>Putting a Patient in Time-out</h2><br></a>
				<ul>
					<li>1: Ensure that the metronome in your isolation chamber is active and stabilized before handling the patient.</li><br>
					<li>2: Comfort the patient as you seal them in the isolation chamber. If they resist, use more rigorous persuasion.</a><br>
					<li>3: Monitor the patient throughout the operation from outside the isolation chamber.<br></li>
					<li>3b: Ensure that the patient remains isolated throughout. The therapy will not work otherwise.<br></li>
					<li>3c: Do not be afraid to periodically speak to the patient. This will even be necessary for diagnosis.<br></li>
					<li>4: Once you believe the patient to be cured, release them from the isolation chamber.<br></li>
					<li>5: If the patient has decieved you, repeat the operation with additional persuasion.</a></li>
				</ul><br>

				<a name="Surgery"><h2>When You Alone Aren't Good Enough: Surgery and Drugs</h2><br></a>
				Sometimes the therapy available to you just doesn't cut it. Don't get angry! Ensure the patient receives fair treatment, and prescribe appropriate action to your colleagues.
				<ul>
					<li>Surgery: Be advised, brain surgery is a complex and dangerous procedure and you should not prescribe unless drug therapy is simply not possible. Counsel the patient on the matter and send them down to the surgeon with a written report.</li><br>
					<li>Drug Therapy: A more reasonable and far safer option. Counsel the patient and fill out a prescription for the relevant chemical suppressant. Ensure that the patient and the chemist are both aware that these suppressants are temporary and require periodic re-administration.</li><br>
				</ul><br><br>

				<a name="Closing Statements"><h1>Post-Therapy Actions:</h1></a>
				After you believe a successful therapy has been conducted, your work does not end here. You must check and double-check the patient's wellbeing before releasing them for duty, conducting an after action counseling and keeping meticulous paperwork. You are advised to schedule the patient for a later check-up.
				Remember; once you have been afflicted with brain trauma you are over four times as likely to suffer it again! Keep your patient's best interests at heart.
				</body>
			</html>
			"}

/obj/item/book/manual/ka_custom
	name = "Guide to Custom Kinetic Accelerators"
	icon_state ="rulebook"
	author = "Quartermaster Burgs"
	title = "Guide to Custom Kinetic Accelerators"
	dat = {"<html>
				<head>
					<style>
						h1 {font-size: 21px; margin: 15px 0px 5px;}
						h2 {font-size: 15px; margin: 15px 0px 5px;}
						li {margin: 2px 0px 2px 15px;}
						ul {margin: 5px; padding: 0px;}
						ol {margin: 5px; padding: 0px 15px;}
						body {font-size: 13px; font-family: Verdana;}
					</style>
				</head>
				<body>
					<h1>Metal Snowflake: Your Guide to Custom Kinetic Accelerators</h1>
					<h2>by Quartermaster Burgs</h2>
					<br>
					<p>So you want to make your own custom kinetic accelerator. While it may look simple to take apart, swap, and modify parts to fit your working needs, there are a few things to keep in mind before assembling.</p>

					<p>Know your parts. To make a working kinetic accelerator, you require a power converter, a kinetic cell, and a frame to store it all on. Some parts are better for certain jobs than others. Some are more compact, more economical, more powerful, more quick, more durable. Mix and match parts to your liking, however there may be some parts that are incompatible with other parts due to software differences.</p>

					<p>A power converter contains a complex assembly that converts kinetic energy into destructive energy via powerful magnets and heat induction, which are perfect for destroying rock in areas with minimal atmosphere.</p>

					<p>A kinetic cell holds the kinetic energy and usually has a means of creating it, such as a lever, a pump, or an internal power source. Manual pumps are quite the common and wise choice given how electrical outlets and recharging station are not too common while out on the dig.</p>

					<p>A frame is quite literally a frame; the weapon's base. All frames contain special software that allows the components to interact with eachother easily and safely without causing sparks or other malfunctions. Some frames contain extra bonus software, such as over-clocking or recoil damping predictors.</p>

					<p>Assembly is very easy. First, you secure the power cell, then you secure the power converter, then you install any additional upgrade chips. The bolts will quite literally screw themselves securely. If you wish to remove the parts, a wrench is required to disassemble.</p>

					<p>It's best to test fire the weapon in a safe location before going out for a long haul. There are plenty of things that could go wrong with the assembly, but thankfully do to regulations and other legalwork, the weapon will prevent itself from firing if the software detects an issue. There is a digital screen located on the top of the frame that would state if there was anything wrong with the weapon if an attempt to fire is made. Here are the error codes for said weapon.</p>
					<br>
					<h2>Error Codes:</h2>

					<p>0: Means that there is a component connection issue. Ensure that the entire assembly (Frame, Power Converter, Cell) are secured together as one.</p>

					<p>101: Means that there is not enough voltage going into the power converter. Ensure that the cell is rated enough to handle the power consumption of the entire assembly.</p>

					<p>102: Means that there is not enough amps going into the power converter. Ensure that there are no other modules that may reduce the amount of amps going into the power converter.</p>

					<p>103: Means that there are not enough watts going into the power converter. Ensure that the power cell is rated enough to handle the power consumption of the entire assembly.</p>

					<p>201: Means that the frame is not rated to handle the entirety of the heat energy of the components. Either upgrade the frame, or downgrade the components.</p>
				</body>
			</html>
			"}

/obj/item/book/manual/wiki/battlemonsters
	name = "\improper Guide to Battlemonsters"
	icon_state ="battlemonsters"
	author = "Macro Toy Company"		 // Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	title = "Guide to Battlemonsters"
	sub_page = "Guide_to_Battlemonsters"

/obj/item/book/manual/pra_manifesto
	name = "hadiist manifesto"
	desc = "A compact red book with the ideas and guidance of Hadii for the Tajaran society."
	icon_state ="hadii-manifesto"
	title = "hadiist manifesto"
	author = "Al'Mari Hadii"
	w_class = 2.0
	dat = {"<html>
				<head>
					<style>
					h1 {font-size: 21px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					body {font-size: 13px; font-family: Verdana;}
					</style>
				</head>
				<body>
				<h1><center>Manifesto of the Parizahra Zhahrazjujz'tajara Akzatauzjauna'azahrazakahuz Hadii</center></h1>

				<b><center></b><br>\
				<br>\
				Written: Late 2432;<br> \
				First Published: February 2433<br> \
				Translated by Comrade Aurauz'hurl Aizhunua</center><br>\
				<small>A Rrak'narr is haunting the Njarir'Akhran. The Rrak'narr of classlessism. Where have not the Njarir'Akhran blasted classlessism? Where not have the nobility ruthlessly uprooted our supporters \
				like they were tearing up weeds from their gardens? Despite their dismissal, the fact that the Njarir'Akhran are so desperate to exterminate us brings us two inevitable facts:<br>\
				<br>\
				1) Revolutionary ideology is already cemented amongst Tajara.<br>\
				2) It is time for supporters of a classless society to throw off their cloaks and set aside their daggers and pick up the rifle to meet the reactionary bourgeois in the open field.<br>\
				<br>\
				To that end, Comrade Al'mari Hadii has coalesced the many supporters and thinkers of the Revolution to bring to life this manifesto of our people, our nation, and our Revolution.<br>\
				This is a Revolution that will make the Old Order buckle before the strength of the working class until it collapses into ruin. Remember, dear comrade, all of the contents of this manifesto are to justify one simple fact.<br>\
				This one fact has been unsuccessfully suppressed by the Njarir'Akhran, only to live on in the burning spirit of every man, woman, and kit. The simple fact that no Tajara is born inherently better than another.<br>\
				</body>
			</html>
			"}

/obj/item/book/manual/dominia_honor
	name = "dominian honor codex"
	desc = "A codex describing the main tenets of dominian honor."
	icon_state ="rulebook"
	title = "dominian honor codex"
	author = "Zalze Han'San"
	w_class = 2.0
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 21px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<a name="Foreword"><h1>Dominian Honor Codex:</h1></a>


				<h2><a name="Contents">Contents</a></h2>
				<ol>
					<li><a href="#I">Conduct toward Equals</a></li>
					<li><a href="#II">Conduct of Men</a></li>
					<li><a href="#III">Conduct of Women</a></li>
					<li><a href="#IV">Dueling Etiquette</a></li>
					<li><a href="#V">Conduct of a Soldier</a></li>
					<li><a href="#VI">On High and Low</a></li>
					<li><a href="#VII">Behavior amongst Foreigners and Enemies</a></li>
					<li><a href="#VIII">Behavior amongst Foreigners and Enemies</a></li>
					<li><a href="#IX">On Duty to Country and Emperor</a></li>
					<li><a href="#X">On Duty to Self</a></li>
				</ol>
				<br>

				<a name="I"><h2>Conduct toward Equals</h2><br></a>
				An honorable person will conduct himself in a manner that recognizes rich or poor, young or old, all are morally equal. Birth and wealth do not convey honor and a good reputation,
				your actions do. It is not what one thinks, but one does. Thus, a gentleman of good repute and standing should avoid conducting himself untowardly to his fellow man, that they may
				avoid unnecessarily coming to blows. Politeness and civility are the hallmarks of a reputable person. Thus, unless a person is known to of low repute and lacking honor,
				act civilly to all you meet.<BR><BR>

				<a name="II"><h2>Conduct of Men</h2><br></a>
				Men, of the sexes, must bear a responsibility of having a gentile and forgiving nature, while remaining upright and honorable. They, especially, are burdened with the
				responsibility of defending their honor - as outlined in Codex 4 - to the extreme if ncessary, for an honor that cannot be defended is not held, and an honor that cannot
				be lost is not an honor at all. They must be kind and generous to the weaker and poorer, upright and honest with their equals, and respectful and obedient to their
				superiors in rank or station.<BR><BR>

				<a name="III"><h2>Conduct of Women</h2><br></a>
				Women, while being noted on equal footing as men in matters of honor, cannot avoid the realities of being physically weaker. They must be equally vigorous and stalwart
				in their conduct, in being polite and upright to all they interact with. It is good - though not necessary - for women to manage a home and family's affairs. Chastity,
				modesty, and attention to detail - these are all traits of a woman of good repute.<BR><BR>

				<a name="IV"><h2>Dueling Etiquette</h2><br></a>
				There is no justice in the court of law for an offense of Slander, and to be Slandered is worse than death. To live a life of shame and ill repute is the lowest fate
				one can receive. It is thus that affairs of honor are brought to the contest of the duel - to satisfy both parties, defender and accuser. In a duel, a second for both
				sides must be present, as well as a physician. In some cases, a legal notary may be present to ensure its validity. In the cases of duels between men and women, or
				people of differing ages and physical capabilities, to ensure the uprightness, fairness and honor of the duel, guns may be used. These shall be inspected by both
				seconds upon being presented by the defendant in the duel. In a contest between two of equal physical ability, swords are preferable in use, as they do not necessarily
				inflict a mortal wound when one is not necessary to satisfy the Honor of the two parties.<BR><BR>

				<a name="V"><h2>Conduct of a Soldier</h2><br></a>
				Soldiers, of all professions, have the greatest responsibilities in society to be fair and gentle in some cases, and be harsh and punishing in others. Looting,
				bawdiness, pillaging, a lack of appropriate mercy, cruelty in killing, all hallmarks of a dishonorable soldier. A soldier must be dedicated to his task, dedicated in
				becoming a master of his task, and willing to die to complete it. A soldier in defeat, if he has given his all, is a soldier who has learned. No soldier should be
				afraid of defeat - for no soldier can win every battle - he should be afraid to not learn from it.<BR><BR>

				<a name="VI"><h2>On High and Low</h2><br></a>
				God, in His wisdom, sees fit to place some men high and some men low. This is does not make them any less equal in matters of honor. A powerful man, if he has been seen
				fit to be head over another, must not in any case abuse his authority or position. A man, if he has been seen fit to be placed under another's authority, must be
				dedicated and true in his work. There in no greater stain to a man of honor then to be a cruel task-master or an abuser of the weak and powerless. He has a
				responsibility to ensure those under him work efficiently, and they have a responsibility to not cheat their master.<BR><BR>

				<a name="VII"><h2>Behavior amongst Foreigners and Enemies</h2><br></a>
				When among foreigners, an honorable and respectful man must be honorable and respectful of their customs as much as he can, unless they be themselves against the code of
				Honor and the Edicts. Do not expect them to know or recognize our higher Code of Conduct. They, someday, will be brought under its reach - but until then, be as polite
				and respectful to them as they deserve. When amongst your enemies, be polite. If they are enemies in war, they are doing their duty as you are. Respect and honor your
				enemy unless he prove himself unworthy of it. In all cases, show that you are a better man then they are.<BR><BR>

				<a name="VIII"><h2>On Duty to Family and God</h2><br></a>
				A genteel and honorable person, in all cases, is loyal first to God first, his family second, king third, country fourth, and himself last. Your family are your closest
				friends, allies, and compatriots: you must rely upon them, and they must rely upon you. If a person has no family, he has nothing. Be upright and honest with your
				family, loyal, and keep your promises in all things - such as your dealings are with other men. Be loyal to God first and foremost - for if a man is without God, he is
				not living. It is God that gives us this opportunity to be honorable and just people.<BR><BR>

				<a name="IX"><h2>On Duty to Country and Emperor</h2><br></a>
				Dutiful should describe any honorable person. A person everyone know will keep their word, honor their word, and faithfully fulfill their word. And no more important
				word is given then an oath to King, and to Country. While some argue the Emperor is the Country, this codex is not one of philosophy. Obey the Emperor faithfully, serve
				him faithfully, and your country will prosper for it. Respectfully question the Emperor at the appropriate time if necessary and obey him in all right and honorable
				things.<BR><BR>

				<a name="X"><h2>On Duty to Self</h2><br></a>
				Your body, your mind, your honor - these three are the trinity of life. An honorable person keeps themselves in as good shape as they can and abstains from things such
				as overuse of hard liquors and substances which cloud the mind and hamper the body. Without a sound body and mind, nobody can maintain their honor and reputation.<BR><BR>

				</body>
			</html>
			"}

/obj/item/book/manual/tcfl_pamphlet
	name = "tau ceti foreign legion pamphlet"
	desc = "A simple pamphlet containing information about the Tau Ceti Foreign Legion."
	icon_state ="tcfl_book"
	title = "Tau Ceti foreign legion pamphlet"
	author = "Tau Ceti foreign legion recruitment center"
	w_class = 2.0
	dat = {"<html>
				<head>
					<style>
					h1 {font-size: 21px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					body {font-size: 13px; font-family: Verdana;}
					</style>
				</head>
				<body>
				<br>\
				The Tau Ceti Foreign Legion is a military force employed by the Republic of Biesel consisting of mostly volunteers of all recognized sentient citizens. It primarily
				comprises of immigrants and external parties seeking citizenship or stakes in Tau Ceti, which the Republic offers in exchange for participation. It can often be seen
				working with NanoTrasen assets wherever possible, extending operations slightly further than most NanoTrasen ERT officially reach. As such, the Foreign Legion can be
				seen regularly patrolling areas nearby the N.S.S. Aurora and the Romanovich Cloud.
				</body>
			</html>
			"}
