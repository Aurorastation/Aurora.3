# Aurorastation
![Aurora Logo](https://wiki.aurorastation.org/images/6/6b/Main_page_banner1.png)

**[Website](https://aurorastation.org/)**

**[Code](https://github.com/Aurorastation/Aurora.3)**

---

### LICENSE
Aurorastation is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.

If you wish to develop and host this codebase in a closed source manner you may use all commits prior to `1420675200 +0000`, which are licensed under GPL v3.  The major change here is that if you host a server using any code licensed under AGPLv3 you are required to provide full source code for your servers users as well including addons and modifications you have made.

See [here](https://www.gnu.org/licenses/why-affero-gpl.html) for more information.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.

### GETTING THE CODE
The simplest way to obtain the code is using the github .zip feature.

Click [here](https://github.com/Aurorastation/Aurora.3/archive/master.zip) to get the latest stable code as a .zip file, then unzip it to wherever you want.

If you wish to develop for or using this codebase, please read the "Development" section.

### DEVELOPMENT
Note: If you wish to develop for our codebase, please take a look at the guides under .github/guides and the github wiki, as they outlines the guidelines for contributing to our codebase, which outline both the process for, and the guidelines you must follow to, have your PRs merged.

To develop for or using this codebase, the following tools are part of our toolchail:

- An updated and supported Windows Operating System version. (It might be possible to successfully follow the same general steps in other OSes, but they are untested)
- [BYOND](https://www.byond.com/download/), with an active account ([Register](https://secure.byond.com/Join) if you do not have one already)
- [Git](https://git-scm.com/downloads)
- [Visual Studio Code (VSC)](https://code.visualstudio.com/download)
- A GitHub account

Prepare the development environment:

1. Create a fork of this repository. Once logged in Github and while viewing this repository, click the "Fork" ribbon, or simply click [here](https://github.com/Aurorastation/Aurora.3/fork), give it a name and follow the forking instructions
1. Download and install BYOND, login into it
1. Download and install Git and VSC
1. Create a folder in which you wish to keep the repository files, preferably on an SSD, then right click → "Git Bash Here". A new command prompt should appear.
1. Inside the fork you have created above, click the "Code" ribbon and copy the URL under the HTTPS section
1. Run the command `git clone URL_FROM_ABOVE`, changing the "URL_FROM_ABOVE" text with the URL you have copied before, and let it run to completion
1. Open VSC and select "Open Folder", select the newly created folder
1. Accept the prompts, install the extensions that are suggested, login to those who asks you to, reboot VSC as requested/needed

You are now ready to develop for or using the Aurorastation codebase. Please note that while you might be able to develop using different tools, we neither recommend nor support them.

If you intend to submit changes to us, please **create a new branch, do not edit the master branch**, you can do so in VSC by bringing up the command palette with CTRL+SHIFT+P and run the command "Git: Create Branch From", select the master branch, give a name for the new one and then hit enter.

You can then perform changes, commit them to said branch, push the changes to your fork, and then create a pull request on our repository, in order to have it evaluated and eventually merged into our master branch.

To update your master branch when ours is updated, simply go to your fork, click the "Sync fork" ribbon and then "Update Branch".

You can always [join us on our Discord server](https://discord.gg/0sYA49zHYGnKWM9p) for any questions.

### INSTALLATION

This is a source code-only release, so the next step is to compile the server files.

**Using BYOND tools natively is not supported**, you need to either:
- Compile the server into a runnable binary using the build tools documented [here](tools/build/README.md).
- Follow the instructions in the **Development** section. You can skip the creation of a GitHub account and the use of Git if you intend to manually update your server, but it's recommended not to.

Once you are inside VSC, with the codebase folder opened and all the extensions installed, simply hit CTRL+F5 (Run without debugging) to compile the source code. This might take a little, after which you should see DreamMaker and/or DreamSeeker popping up, and then the full client UI.

You can close DreamMaker.

You will find the server file, aurorastation.**dmb**, inside the folder.

If you see any errors or warnings, something has gone wrong - possibly a corrupt download or the files have been extracted wrong, or there may be a code issue on the main repo. Feel free to ask on [our Discord server](https://discord.gg/0sYA49zHYGnKWM9p) for help.

Once that's done, open up the config folder.  You'll want to edit config.txt to set the probabilities for different gamemodes in Secret and to set your server location so that all your players don't get disconnected at the end of each round.  It's recommended you don't turn on the gamemodes with probability 0, as they have various issues and aren't currently being tested, so they may have unknown and bizarre bugs.

You'll also want to edit admins.txt to remove the default admins and add your own.  "Head Admin/Dev" is the highest level of access, and the other recommended admin levels for now are "Primary Administrator", "Secondary Administrator" and "Moderator".  The format is:

    byondkey - Rank

where the BYOND key must be in lowercase and the admin rank must be properly capitalised.  There are a bunch more admin ranks, but these two should be enough for most servers, assuming you have trustworthy admins.

Finally, to start the server, run Dream Daemon and enter the path to your compiled aurorastation.dmb file.  Make sure to set the port to the one you  specified in the config.txt, and set the Security box to 'Trusted'.  Then press GO and the server should start up and be ready to join.

---

### UPDATING

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

If you used the zip method, you'll need to download the zip file again and unzip it somewhere else, and then copy the /config and /data folders over.

If you used the git method, you simply need to type this in to git bash:

    git pull

When this completes, copy over your /data and /config folders again, just in case.

When you have done this, you'll need to recompile the code, but then it should work fine.

---

### Configuration

For a basic setup, simply copy every file from config/example to config.

For more advanced setups, setting the server `tick_lag` in the config as well as configuring SQL are good first steps.


#### Permissions

Permissions with file-based config are handled through `admin_ranks.json`
and `admins.txt`. To add yourself as the admin, simply find the rank with
the suitable permissions from the `admin_ranks.json` file, copy its `"name"`
field value, and input that into `admins.txt` like so:

```cfg
myckeyhere - Head Admin/Dev
```

---

### SQL Setup

The SQL backend for the library and stats tracking requires a MySQL server, as does the optional SQL saves system. Your server details go in config/dbconfig.txt, and initial database setup is done with [flyway](https://flywaydb.org/). Detailed instructions can be found [here](https://github.com/Aurorastation/Aurora.3/tree/master/SQL).

---

### Discord Bot

The Aurorastation codebase uses a built-in Discord bot to interface with Discord. Some of its features rely on the MySQL database, specifically, channel storage and configuration. So a database is required for its operation. If that is present, then setup is relatively easy: simply set up the `config/discord.txt` file according to the example located in the `config/example/` folder, and populate the database with appropriate channel and server information.

At present, there is no built in GUI for doing the latter. So direct database modification is required unless you set up the python companion bot. The python companion bot is BOREALIS II, and can be located [here](https://github.com/Aurorastation/BOREALISbot2). Though not required, it makes database modification easier. See commands that start with `channel_`.
