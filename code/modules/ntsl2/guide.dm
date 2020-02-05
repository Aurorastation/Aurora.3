/obj/item/book/manual/ntsl2
	name = "NTSL2+ For Dummies"
	icon_state ="bookNTSL"
	author = "Brogrammer George"
	title = "NTSL2+ For Dummies"
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
				code {font-size: 8pt; line-spacing: 8pt; font-family: monospace; color: white; background-color:black;}
				</style>
				</head>
				<body>
				<h1>NTSL2+ For Dummies</h1>

				So you want to write NTSL2+ huh?<br>
				Well good luck to you. Over this short guide, we'll be detailing the setup and execution of basic programs, as well as documenting some more complicated functions.<br>

				<h2>Installing</h2>
				Firstly, if you're running this on a Telecommunications server, skip this step. It's already installed. Just, skip ahead to the Telecomms section...<br>
				Secondly, if you're running this on a Telecommunications server and this book is your only guide, re-evaluate touching the Telecommunications server until later.<br><br>

				<b>Step One:</b> Launch your computer or laptop.<br>
				<b>Step Two:</b> Configure it for private use. Anything with access to the NT/Net Software Download Tool will technically work, but you're clearly new here, so don't push your luck.<br>
				<b>Step Three:</b> Download <i>NTSL2+ Interpreter</i>. Patiently wait for the download. You've got time, right?<br>
				<b>Step Four:</b> You're done. Either learn to program or download someone else's code.<br>

				<h2>Running basic programs</h2>
				When inside the Interpreter, you'll be given a list of programs you can run that are stored on your harddrive. <b>Programs on your USB stick have to be copied over first.</b><br>
				Find a file you want to run, and click <b>EXEC</b>. This will cause the program to run.<br>
				Programs have <B>Refresh</B> and <B>Exit</B> buttons. These buttons cause the program to either refresh its terminal, or exit respectively. This isn't rocket science, but you are reading this guide for dummies..<br>
				Next is a big bold text that will be the title of the program. This isn't interactive, but makes it easier to tell your running programs apart.<br><br>
				Finally, is the big black previously mentioned <b>Terminal</b>. All your program output and interaction happens here.<br>
				Programs can output text here, in pretty patterns or whatever, but they can also output "Buttons". Parts of the terminal can be clicked to do things.<br>
				This will either run something within the program, ask you for input, or do nothing.<br><br>
				This encompasses the limitations of your interactions with the average program.<br>

				<h2>Running complicated programs</h2>
				You are not ready. Go back to Running basic programs.<br>

				<h2>Writing your first program.</h2>
				For this guide, I'll boldly assume you <b>already know some amount of programming.</b> If you can't program at all, avoid touching NTSL2+, this is not an entry level language. This is a bad language. Please. Run.<br><br>
				If you're still boldly willing to learn this language, we can begin with the most basic of programs. <b>Hello world</b>.<br><br>
				Firstly, create a new file in your File Browser. Call it whatever you want, but I recommend <B>Hello World</B>. Then open up the text editor.<br>
				Your basic Hello World is the following:<br>
				<code>print("Hello, World!")</code><br>
				If you've programmed before, you already know what this does. If you haven't, see the start of this section, but for convenience...<br>
				This program outputs the following text into the terminal when ran:<br>
				<code>Hello, World!</code><br>
				Simple enough. this demonstrates calling a function, <code>print</code>, and a raw string argument, <code>"Hello, World!"</code><br>
				NTSL2+ has a habit of hating people, so make sure you fully understand this. Play with that raw string argument, understand it. Test the limitations of this simple program, don't be afraid to break it.<br><br><br><br><br>
				If you spent long enough following my last instruction, you probably noticed something strange. <code>print "Hello, World!"</code> worked.<br>
				If you're new here, that's probably perfectly logical. If you've been programming for a while, this might be really weird. (Unless you still write python 2...).<br>
				This is because functions can <i>implicitly</i> be called with string or table <b>constructors</b> as an argument. This will make more sense later, hopefully.<br><br>
				Next, is a <b>For loop</b>. Like wise, make a new program, or edit your old one. I'm not your boss.<br>
				Fill it with:<br>
<code>for(i=0; i < 10; i++){<br>
&ensp;print `Number: \[i]`<br>
}</code><br>
				This code prints all the numbers from 0 to 9, with the text "Number: " in front of it.<br>
				Like last time, a lot of that code can still function if changed, play around with it.<br>
				Different this time, however, is the use of backticks. <code>`Number: \[i]`</code><br>
				These allow you to put <b>expressions</b> within your <b>string constructor</b>. Anything in square brackets, in this case, <code>\[i]</code> will be added to the string as the result of it's expression. So, the value of i.<br>
				You can also escape these square brackets with a backslash, if you ever wanted to use them raw like that.<br><br>
				Your last tutorial: User Input.<br>
				I'm going to throw a program at you, it'll contain a lot of words you've not been taught yet. But you might be ready now. Just try it out, play with the code, see what you can change.<br>
				The Code:<br>
<code>term.set_cursor(0,0)<br>
term.write("PROMPT")<br>
term.set_topic(0,0,#"PROMPT",1,"?prompt")<br>
term.set_cursor(0,1)<br>
<br>
when term.topic{<br>
&ensp;print(topic::sub(#"?prompt"))<br>
}</code><br>
				Don't worry, Don't be scared, I'll step through this with you.<br>
				<font size=4px>I'll be gentle.</font><br>
				First thing that happens is <code>term.set_cursor(0,0)</code>. We've got another function call here, but with <code>term.</code> ahead it. This means that the function being run, set_cursor, is inside the table called term.<br>
				The function itself moves the terminal cursor to position 0,0. You know how when stuff was printed it appeared on a new line? You can change where that starts with this.<br>
				<code>term.write</code> is a lot like <code>print</code> but instead of writing a line, it just writes what you put in. Doesn't move the cursor down for next time.<br>
				<code>term.set_topic</code> is the way you make <i>fun buttons!</i> The first two arguments are an x and y coordinate, just like what we did when we moved the cursor. The second two are width and height, they're the size of the button. Lastly, is the topic value. This is what we'll get back when <code>term.topic</code> is called. if this starts with a question mark like it does here, it'll ask for user input, and change how it's returned to compensate. so <code>?prompt</code> when pushed, and the text "hi" is entered, will return with <code>prompt?hi</code><br>
				Confusing? Probably. Don't stress.<br>
				We then move the cursor again, this time one line down.<br>
				Next, is this "when", thing. When is used to <b>Hook to events</b>, with <code>term.topic</code> being the most commonly used event for standard computers.<br>
				In this case, it means the stuff in the block is executed when term.topic is called, and it sets the <code>topic</code> value to whatever the topic stuff was, which was talked about in the term.set_topic section. That's where you get that. Not so confusing, was it?<br>
				Now what about <code>topic::sub(#"?prompt")</code>? Once again, easier than it looks. Firstly, <code>::sub</code> Just like how . was used to get something in a table, :: can be used to too. But in this case, it makes whatever asked for it the first argument. So, this becomes <code>topic.sub(topic...</code>.<br>
				"sub" itself is a string function, this can either be accessed from strings themselves, like above, or through literally asking the string table via string.sub. The string library has a whole bunch of fun things relating to text.<br>
				This gets a substring from the input string, in the form of <code>sub(string, start, length)</code>. If the start and length aren't in the actual string, fuckery happens.<br>
				<code>#"?prompt"</code> gets the length of the string "?prompt", which we use to only get the parts of the string we care about, because in this case, we don't need the actual topic string.<br><br>
				This is all still probably a little confusing, but as always, just play with the code, edit it till it breaks, then fix it again, you'll get the hang of it.<br><br>

				<h2>The Whole Syntax</h2>
				Wow, you really got this far, huh? Bold. You uh, sure you don't want to go back..? Play with the examples some more? No..? Alright...<br><br>

				<i>The rest of this page appears to be nothing but mad scribbles...</i><br><br>

				<h2>Telecomms</h2>
				So you've mastered the syntax, and the libraries, and you're finally ready for telecomms? Alright, don't say I didn't warn you.<br><br>

				<h3>Receiving</h3>
				To receive messages, hook into the <code>tcomm.onmessage</code> event. This gives you access to:<br>
				<ul>
					<li><b>content</b>: The message sent; converted to text for convenience.</li>
					<li><b>source</b>: The name of the person who sent the message.</li>
					<li><b>job</b>: What their job is.</li>
					<li><b>freq</b>: What radio frequency they think they wanted</li>
					<li><b>pass</b>: Is it actually being sent? Probably going to be 1.</li>
					<li><b>ref</b>: A signal reference. This is only important if you plan to play with people's voices.</li>
					<li><b>verb</b>: How the message is enunciated.</li>
					<li><b>language</b>: What language they spoke.</li>
				</ul>

				<h3>Sending</h3>
				To send messages, just use the <code>tcomm.broadcast</code> function. This takes the following arguments, all of which are optional.<br>
				<ul>
					<li><b>content</b>: The message sent; Converted to someone's voice.</li>
					<li><b>source</b>: Name of the voice to mimic.</li>
					<li><b>job</b>: What job to emulate.</li>
					<li><b>freq</b>: What radio frequency you want</li>
					<li><b>pass</b>: Is it actually being sent? Probably going to be 1, if you actually want the message sent. This is used to silence ref'd messages.</li>
					<li><b>ref</b>: A signal reference. Set this to the one you were given in the onmessage function to modify it. Doesn't do anything if it wasn't that.</li>
					<li><b>verb</b>: How the message is enunciated.</li>
					<li><b>language</b>: What language to output in.</li>
				</ul><br><br>

				<h3>Special Notes</h3>
				If your program is too slow, then a message might get out before your code can tell the server what it should actually say. If changes to people's voices don't seem to do anything, try immediently stopping the message when you get it handed, then just send out a fake one with broadcast later.<br><br>

				<h2>Networking</h2>
				Networking is important if you want two programs to talk to each other. Even more important if you want to control Telecomms from your personal laptop, ignoring the dangers of that.<br><br>
				Networking is just like Telecomms, simple sending and hooking. Because NTSL2+ is written by the lowest bidder, security functions aren't default. Write your own.<br><br>

				<h3>Receiving</h3>
				Unlike telecomms, you've got to use a special hook name. So this time, hooking is like so: <code>when net.subscribe("something"){}</code><br>
				You can still use that as many times as you like, but make sure your hook name is important. You'll be sending messages to that.<br>
				net.subscribe events are given access to one variable, <code>message</code>. This is whatever the other side of it, net.message, sends.<br><br>

				<h3>Sending</h3>
				Sending is easier, just call <code>net.message("something", data)</code> Data is optional, and "something" should be exactly what you've hooked to in your other program.<br>
				This will send this message to <b>Any program listening, including malicious ones or ones you own.</b> Ensuring communication is done securely is left as an exercise to the reader, but I recommend randomly generating new hook names and handing them back and forth with each message.<br><br>

				<h3>Special Notes</h3>
				Net messages can't contain complicated data. You can send a list over, or a list of lists, and so on, or strings or numbers, but that's it. No functions nor events. Mutating a message on one side can never effect it on the other.</br><br><br>

				<h2>Final Notes</h2>
				This is a language with a lot of "guessing". It will try to run your code no-matter how broken it is, and it will never tell you what you've done wrong.<br>
				Think HTML but it hates you more.<br><br>
				That being said, when in doubt, keep poking the language. Break it into little pieces and try those. NTSL2+ is a lot more usable than NTSL, take that and run with it.<br><br>
				Most importantly, <b>Stay sane, try not to die.</b>

				</body>
			</html>
			"}
