extends VBoxContainer

func _ready():
	
	if Globals.is_units_meters():
		set_feet(false)
		set_meters(true)
		$Meter_Using.disabled = true
		$Feet_Using.disabled = false
	else:
		set_feet(true)
		set_meters(false)
		$Meter_Using.disabled = false
		$Feet_Using.disabled = true

func set_feet(v):
	$Feet_Using.button_pressed = v
	
func set_meters(v):
	$Meter_Using.button_pressed = v

func _on_meter_using_pressed():
	
	$Meter_Using.disabled = true
	$Feet_Using.disabled = false
	Globals.set_is_using_meters(true)
	
	if $Feet_Using.button_pressed:
		set_feet(false)


func _on_feet_using_pressed():
	
	$Meter_Using.disabled = false
	$Feet_Using.disabled = true
	Globals.set_is_using_meters(false)
	
	if $Meter_Using.button_pressed:
		set_meters(false)
