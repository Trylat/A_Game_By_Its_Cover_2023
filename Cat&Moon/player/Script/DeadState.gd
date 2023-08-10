extends State

#Actions that are performed when we enter the state
func state_process(variant):
	self.playback.travel("dead")
