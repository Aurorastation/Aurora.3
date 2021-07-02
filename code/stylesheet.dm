client/script = {"<style>
body					{font-family: Verdana, sans-serif;}

h1, h2, h3, h4, h5, h6	{color: #0000ff;font-family: Georgia, Verdana, sans-serif;}

em						{font-style: normal;font-weight: bold;}

.motd					{color: #638500;font-family: Verdana, sans-serif;}
.motd h1, .motd h2, .motd h3, .motd h4, .motd h5, .motd h6
						{color: #638500;text-decoration: underline;}
.motd a, .motd a:link, .motd a:visited, .motd a:active, .motd a:hover
						{color: #638500;}

.prefix					{font-weight: bold;}
.log_message			{color: #386AFF;	font-weight: bold;}

/* OOC */
.ooc					{font-weight: bold;}
.aooc					{font-weight: bold; color: #960018;}
.ooc img.text_tag		{width: 32px; height: 10px;}

.ooc .everyone			{color: #002eb8;}
.ooc .looc				{color: #6699CC;}
.ooc .adminlooc			{color: #3BBF6E;}
.ooc .elevated			{color: #2e78d9;}
.ooc .moderator			{color: #184880;}
.ooc .developer			{color: #1b521f;}
.ooc .admin				{color: #b82e00;}
.ooc .ccia				{color: #22a9b4;}

/* Admin: Private Messages */
.pm  .howto				{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.pm  .in				{color: #ff0000;}
.pm  .out				{color: #ff0000;}
.pm  .other				{color: #0000ff;}

/* Admin: Channels */
.mod_channel			{color: #735638;	font-weight: bold;}
.mod_channel .admin		{color: #b82e00;	font-weight: bold;}
.admin_channel			{color: #9611D4;	font-weight: bold;}
.cciaasay				{color: #22a9b4;	font-weight: bold;}
.devsay					{color: #1b521f;	font-weight: bold;}

/* Radio: Misc */
.deadsay				{color: #530FAD;}
.radio					{color: #008000;}
.deptradio				{color: #ff00ff;}	/* when all other department colors fail */
.newscaster				{color: #750000;}

/* Radio Channels */
.comradio				{color: #193A7A;}
.syndradio				{color: #6D3F40;}
.bluespaceradio			{color: #1883A3;}
.centradio				{color: #5C5C8A;}
.airadio				{color: #FF00FF;}
.entradio				{color: #bd893c;}

.secradio				{color: #A30000;}
.penradio				{color: #DB1270;}
.engradio				{color: #A66300;}
.medradio				{color: #0a5c47;}
.sciradio				{color: #993399;}
.supradio				{color: #5F4519;}
.srvradio				{color: #6eaa2c;}

/* Miscellaneous */
.name					{font-weight: bold;}
.say					{}
.alert					{color: #ff0000;}
.vote					{color: #6c18c0}
h1.alert, h2.alert		{color: #000000;}

.emote					{font-style: italic;}

.psychic				{color: #56d277;}

/* Game Messages */

.attack					{color: #ff0000;}
.moderate				{color: #CC0000;}
.disarm					{color: #990000;}
.passive				{color: #660000;}

.danger					{color: #ff0000; font-weight: bold;}
.warning				{color: #ff0000; font-style: italic;}
.rose					{color: #ff5050;}
.info					{color: #0000CC;}
.notice					{color: #000099;}
.subtle					{color: #000099; font-size: 75%; font-style: italic;}
.alium					{color: #00ff00;}
.cult					{color: #800080; font-weight: bold; font-style: italic;}

.reflex_shoot			{color: #000099; font-style: italic;}

/* Languages */

.alien					{color: #543354;}
.tajaran				{color: #803B56;}
.tajaran_signlang		{color: #941C1C;}
.skrell					{color: #00CED1;}
.vaurca                 {color: #9e9e39;}
.soghun					{color: #228B22;}
.solcom					{color: #22228B;}
.soghun_alt				{color: #024402;}
.changeling				{color: #800080;}
.rough					{font-family: "Trebuchet MS", cursive, sans-serif;}
.say_quote				{font-family: Georgia, Verdana, sans-serif;}
.yassa					{color: #400987;}
.delvahhi				{color: #5E2612; font-weight: bold;}
.siiktau				{color: #A52A2A;}
.freespeak				{color: #FF4500; font-family: "Trebuchet MS", cursive, sans-serif;}
.tradeband				{color: #5C16C6; font-family: Georgia, Verdana, sans-serif;}

.interface				{color: #330033;}

.good                   {color: #4f7529; font-weight: bold;}
.bad                    {color: #ee0000; font-weight: bold;}

BIG IMG.icon 			{width: 32px; height: 32px;}

/* // DARKMODE // */

.darkmode h1, .darkmode h2, .darkmode h3, .darkmode h4, .darkmode h5, .darkmode h6	{color: #a4bad6; font-family: Georgia, Verdana, sans-serif;}

/* MOTD */
.darkmode .motd {color: #a4bad6;	font-family: Verdana, sans-serif;}
.darkmode .motd h1, .darkmode .motd h2, .darkmode .motd h3, .darkmode .motd h4, .darkmode .motd h5, .darkmode .motd h6 {color: #a4bad6;	text-decoration: underline;}
.darkmode .motd a, .darkmode .motd a:link, .darkmode .motd a:visited, .darkmode .motd a:active, .darkmode .motd a:hover {color: #a4bad6;}

.darkmode a {color: #397ea5;}
.darkmode a:visited {color: #7c00e6;}

/* LOG */
.darkmode .log_message			{color: #386aff;	font-weight: bold;}

.darkmode .ooc .everyone		{color: #3c5dc0;}
.darkmode .ooc .looc			{color: #6699CC;}
.darkmode .ooc .adminlooc		{color: #3BBF6E;}
.darkmode .ooc .elevated		{color: #1b521f;}
.darkmode .ooc .moderator		{color: #184880;}
.darkmode .ooc .developer		{color: #2c7731;}
.darkmode .ooc .admin			{color: #d43500;}
.darkmode .ooc .ccia			{color: #22a9b4;}
.darkmode .aooc					{color: #d1021e;}

/* Admin: Private Messages */
.darkmode .pm  .howto			{color: #ff0000;	font-weight: bold;		font-size: 200%;}
.darkmode .pm  .in				{color: #ff0000;}
.darkmode .pm  .out				{color: #ff0000;}
.darkmode .pm  .other			{color: #0000ff;}

/* Admin: Channels */
.darkmode .mod_channel			{color: #735638;	font-weight: bold;}
.darkmode .mod_channel .admin	{color: #d43500;	font-weight: bold;}
.darkmode .admin_channel		{color: #9611D4;	font-weight: bold;}
.darkmode .cciaasay				{color: #22a9b4;	font-weight: bold;}
.darkmode .devsay				{color: #2c7731;	font-weight: bold;}

/* Radio: Misc */
.darkmode .deadsay				{color: #9269c7;}
.darkmode .radio				{color: #00a700;}
.darkmode .deptradio			{color: #ff00ff;}	/* when all other department colors fail */
.darkmode .newscaster			{color: #b43c3c;}

/* Radio Channels */
.darkmode .comradio				{color: #5b8deb;}
.darkmode .syndradio			{color: #ac6667;}
.darkmode .centradio			{color: #7272a7;}
.darkmode .airadio				{color: #ec00ec;}
.darkmode .entradio				{color: #cfcfcf;}

.darkmode .secradio				{color: #f01f1f;}
.darkmode .engradio				{color: #cc7b01;}
.darkmode .medradio				{color: #0f7e62;}
.darkmode .sciradio				{color: #c03bc0;}
.darkmode .supradio				{color: #c09141;}
.darkmode .srvradio				{color: #7fc732;}

/* Miscellaneous */
.darkmode .alert				{color: #d82020;}
.darkmode .vote					{color: #9933ff;}
.darkmode h1.alert, .darkmode h2.alert		{color: #a4bad6;}

/* Game Messages */
.darkmode .attack				{color: #ff0000;}
.darkmode .moderate				{color: #cc0000;}
.darkmode .disarm				{color: #990000;}
.darkmode .passive				{color: #660000;}

.darkmode .danger				{color: #c51e1e; font-weight: bold}
.darkmode .warning				{color: #c51e1e; font-style: italic;}
.darkmode .boldannounce			{color: #c51e1e; font-weight: bold;}
.darkmode .rose					{color: #ff5050;}
.darkmode .info					{color: #6685f5;}
.darkmode .notice				{color: #6685f5;}
.darkmode .subtle				{color: #6e6eff; font-size: 75%; font-style: italic;}
.darkmode .alium				{color: #00ff00;}
.darkmode .cult					{color: #aa1c1c;}

/* Languages */
.darkmode .alien				{color: #ad67ad;}
.darkmode .tajaran				{color: #b15377;}
.darkmode .tajaran_signlang		{color: #cc2c2c;}
.darkmode .skrell				{color: #00CED1;}
.darkmode .vaurca				{color: #b9b943;}
.darkmode .soghun				{color: #2cad2c;}
.darkmode .solcom				{color: #5f5fd4;}
.darkmode .soghun_alt			{color: #1d9b1d;}
.darkmode .changeling			{color: #ad14ad;}
.darkmode .yassa				{color: #6323b6;}
.darkmode .delvahhi				{color: #914123; font-weight: bold;}
.darkmode .siiktau				{color: #be3434;}
.darkmode .revenant				{color: #1ca5aa; font-style: italic;}
.darkmode .freespeak			{color: #FF4500; font-family: "Trebuchet MS", cursive, sans-serif;}
.darkmode .tradeband			{color: #782CE8; font-family: Georgia, Verdana, sans-serif;}

.darkmode .interface			{color: #750e75;}

.darkmode .good					{color: #4f7529; font-weight: bold;}
.darkmode .bad					{color: #ee0000; font-weight: bold;}

</style>"}