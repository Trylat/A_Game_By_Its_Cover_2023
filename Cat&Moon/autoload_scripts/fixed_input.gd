'''
There is a bug in godot that prevent from assigning binary inputs and analog inputs.
The joystick will always reset the button/action to 0 when not used.
See https://github.com/godotengine/godot/issues/45628#issuecomment-782014123.
and https://github.com/godotengine/godot/pull/30890#issuecomment-833173710
'''

class_name FixedInput

static func is_action_pressed(action: StringName) -> bool:
	var isPressed: bool = false
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var eventKey = event as InputEventKey
			isPressed = Input.is_key_pressed(eventKey.physical_keycode)
		elif event is InputEventJoypadButton:
			var eventJoyButton = event as InputEventJoypadButton
			# For some reason, the default device ID is -1 and Input.is_joy_button_pressed
			# always return false.
			var deviceID = 0 if (eventJoyButton.device == -1) else eventJoyButton.device
			isPressed = Input.is_joy_button_pressed(deviceID, eventJoyButton.button_index)
		elif event is InputEventMouseButton:
			var eventMouseButton = event as InputEventMouseButton
			isPressed = Input.is_mouse_button_pressed(eventMouseButton.button_index)
		elif event is InputEventJoypadMotion:
			# Input.get_action_strength always return 0 for some reasons.
			isPressed = Input.get_action_raw_strength(action) > InputMap.action_get_deadzone(action)
		else:
			continue
		
		if isPressed:
			break
	return isPressed
	
static func get_binary_axis(negative_action: StringName, positive_action: StringName) -> float:
	if (is_action_pressed(positive_action)):
		return 1.0
	elif (is_action_pressed(negative_action)):
		return -1.0
	else:
		return 0.0

static func get_vector(negative_x: StringName, positive_x: StringName, negative_y: StringName, positive_y: StringName) -> Vector2:
	var returnVector := Vector2.ZERO
	returnVector.x = get_binary_axis(negative_x, positive_x)
	returnVector.y = get_binary_axis(negative_y, positive_y)
	return returnVector.normalized()
