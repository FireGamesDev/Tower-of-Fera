extends Control

class_name Joystick

@onready var back = $Background/Back
@onready var front = $Background/Handle/Front

var can_move = true

# If the joystick is receiving inputs.
var is_working := false

# The joystick output.
var output := Vector2.ZERO

# FIXED: The joystick doesn't move.
# DYNAMIC: Every time the joystick area is pressed, the joystick position is set on the touched position.
# FOLLOWING: If the finger moves outside the joystick background, the joystick follows it.
enum JoystickMode {FIXED, DYNAMIC, FOLLOWING}

@export var joystick_mode := JoystickMode.FIXED

# REAL: return a vector with a lenght beetween 0 (deadzone) and 1; useful for implementing different velocity or acceleration.
# NORMALIZED: return a normalized vector.
enum VectorMode {REAL, NORMALIZED}

@export var vector_mode := VectorMode.REAL

# The color of the button when the joystick is in use.
@export var _pressed_color := Color.GRAY

# The number of directions, e.g. a D-pad is joystick with 4 directions, keep 0 for a free joystick.
@export var directions := 0 # (int, 0, 12)

# It changes the angle of symmetry of the directions.
#export(int, -180, 180) 
@export var symmetry_angle := 90

#If the handle is inside this range, in proportion to the background size, the output is zero.
@export var dead_zone := 0.1 # (float, 0, 0.5)

#The max distance the handle can reach, in proportion to the background size.
@export var clamp_zone := 1.0 # (float, 0.5, 2)

#VISIBILITY_ALWAYS = Always visible.
#VISIBILITY_TOUCHSCREEN_ONLY = Visible on touch screens only.
enum VisibilityMode {ALWAYS , TOUCHSCREEN_ONLY }

@export var visibility_mode := VisibilityMode.ALWAYS

@onready var _background := $Background
@onready var _handle := $Background/Handle
@onready var _original_color : Color = _handle.self_modulate
@onready var _original_position : Vector2 = _background.position

var _touch_index :int = -1

func _ready() -> void:
	Globals.joystick = self
	#if not OS.has_touchscreen_ui_hint() and visibility_mode == VisibilityMode.TOUCHSCREEN_ONLY:
	#	hide()

func _touch_started(event: InputEventScreenTouch) -> bool:
	return event.pressed and _touch_index == -1

func _touch_ended(event: InputEventScreenTouch) -> bool:
	return not event.pressed and _touch_index == event.index

func _input(event: InputEvent) -> void:
	if not (event is InputEventScreenTouch or event is InputEventScreenDrag):
		return
		
	if !Globals.can_shoot or Globals.is_ended:
		return

	if event is InputEventScreenTouch:
		if _touch_started(event):
			if (joystick_mode == JoystickMode.DYNAMIC or joystick_mode == JoystickMode.FOLLOWING):
				if !_is_inside_Menu_button(event.position, Globals.menu_button_in_game):
					if !_is_inside_control_circle(event.position, _background):
						_center_control(_background, event.position)
			if _is_inside_control_circle(event.position, _background):
				_touch_index = event.index
				_handle.self_modulate = _pressed_color
				_update_joystick(event.position)
			
		elif _touch_ended(event):
			_reset()
	
	elif event is InputEventScreenDrag and _touch_index == event.index:
		_update_joystick(event.position)

func _center_control(control: Control, new_global_position: Vector2) -> void:
	control.global_position = new_global_position - (control.size / 2)
	#control.rect_global_position = new_global_position - control.rect_pivot_offset

func _reset_handle():
	_center_control(_handle, _background.global_position + (_background.size / 2))

func _reset():
	_touch_index = -1
	is_working = false
	output = Vector2.ZERO
	_handle.self_modulate = _original_color
	if joystick_mode != JoystickMode.DYNAMIC:
		_background.position = _original_position
	_reset_handle()

func _is_inside_control_rect(global_position: Vector2, control: Control) -> bool:
	var x: bool = global_position.x > control.global_position.x and global_position.x < control.global_position.x + (control.size.x * control.scale.x)
	var y: bool = global_position.y > control.global_position.y and global_position.y < control.global_position.y + (control.size.y * control.scale.y)
	return x and y
	
func _is_inside_Menu_button(global_position: Vector2, control: Control) -> bool:
	var x: bool = global_position.x > control.global_position.x and global_position.x < control.global_position.x + (control.size.x * control.scale.x)
	var y: bool = global_position.y > control.global_position.y and global_position.y < control.global_position.y + (control.size.y * control.scale.y)
	return x and y

func _is_inside_control_circle(global_position: Vector2, control: Control) -> bool:
	var ray := control.size.x * control.scale.x / 2
	var center := control.global_position + Vector2(ray, ray)
	var ray_position := global_position - center
	return ray_position.length_squared() < ray * ray

func _following(vector: Vector2):
	var clamp_size :float = clamp_zone * _background.size.x / 2
	if vector.length() > clamp_size:
		var radius := vector.normalized() * clamp_size
		var delta := vector - radius
		var new_pos :Vector2 = _background.position + delta
		new_pos.x = clamp(new_pos.x, -_background.size.x / 2, size.x - _background.size.x / 2)
		new_pos.y = clamp(new_pos.y, -_background.size.y / 2, size.y - _background.size.y / 2)
		_background.position = new_pos

func _directional_vector(vector: Vector2, n_directions: int, _symmetry_angle := PI/2) -> Vector2:
	var angle := (vector.angle() + _symmetry_angle) / (PI / n_directions)
	angle = floor(angle) if angle >= 0 else ceil(angle)
	if abs(angle) as int % 2 == 1:
		angle = angle + 1 if angle >= 0 else angle - 1
	angle *= PI / n_directions
	angle -= _symmetry_angle
	return Vector2(cos(angle), sin(angle)) * vector.length()

func _update_joystick(event_position: Vector2):
	if !can_move:
		return
	var ray : float = _background.size.x / 2
	var dead_size := dead_zone * ray
	var clamp_size := clamp_zone * ray
	
	var center : Vector2 = _background.global_position + (_background.size / 2)
	var vector : Vector2 = event_position - center
	
	if vector.length() > dead_size:
		if directions > 0:
			vector = _directional_vector(vector, directions, deg_to_rad(symmetry_angle))
		
		if vector_mode == VectorMode.NORMALIZED:
			output = vector.normalized()
			_center_control(_handle, output * clamp_size + center)
		elif vector_mode == VectorMode.REAL:
			var clamped_vector := vector.limit_length(clamp_size)
			output = vector.normalized() * (clamped_vector.length() - dead_size) / (clamp_size - dead_size)
			_center_control(_handle, clamped_vector + center)
		
		is_working = true
		if joystick_mode == JoystickMode.FOLLOWING:
			_following(vector)
	else:
		is_working = false
		output = Vector2.ZERO
		_reset_handle()
		
func _is_inside_joystick(event):
	return _is_inside_control_circle(event.position, $Background)
	
func _set_joystick_default_pos():
	_background.position = _original_position
	_reset()
