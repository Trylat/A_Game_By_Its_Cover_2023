extends State

#Actions that are performed when we enter the state
func state_process(_variant):
	self.playback.travel("dead")
