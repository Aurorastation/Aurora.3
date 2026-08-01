How to use this:

- Uncomment ENABLE_BYOND_TRACY in your config.txt.
- Run the server through VSC / Dream Daemon and perform whatever actions you wish to profile.
- Close the server. You should now have a .utracy file in <repo>/data/profiler.
- Open tools/tracy/replay/rtracy.exe and point it at that .utracy file.
- Open tools/tracy/client/capture.exe and connect to your localhost 'server'.
- Profit! Don't forget to delete the .utracy when you're done. Or don't.

There is an included README PDF in tools/tracy/client which goes over in
excruciating detail what all the Tracy software is capable of.
