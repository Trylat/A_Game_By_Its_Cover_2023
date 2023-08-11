'''
@brief This is a signal bus that allow everyone
to broadcast a message to all listeners.

The only difference with other implementation seen on the internet
is that you need to add your signal in this file before using it.

And every files can access all signals and connect a method, disconnect a method,
emit a signal, etc.

Please don't use emit_signal("signal name"), but signalName.emit().
This prevent renamming the signal somewhere and making typos.
We don't want to search the wrongy bady written signal in all files,
because we decided to use const strings values instead of the signal.
'''
extends Node

signal OnNewSpawnPoint
signal OnMoonFragmentCollected
signal onPlayerDeath
