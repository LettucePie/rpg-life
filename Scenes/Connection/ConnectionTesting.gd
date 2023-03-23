extends Control


var SERVER_PORT = 44458
var HOST_IP = 0
var SERVER_IP = 0
var MAX_PLAYERS = 10

var enet_tree = null
var enet_state = null
var connection_state = ""
var peers = []

var status = ""
var user_adjectives = ["Happy", "Sad", "Purple", "Big", "Fast", "Yellow", "Fluffy", "Soft", "Angry"]
var user_nouns = ["Elephant", "Shoe", "Tomato", "Soda", "Cat", "Banana", "Water", "Cheetah"]
var user = ""

var mode_status_label = "User is: "
var input_label = ""


func _ready():
	$Panel.show()
	$VBoxContainer/Terminate.hide()
	enet_tree = get_tree().get_multiplayer("")
	enet_tree.connect("peer_connected", Callable(self, "_add_peer"))
	enet_tree.connect("connected_to_server", Callable(self, "_on_connection_success"))
	enet_tree.connect("connection_failed", Callable(self, "_on_connection_failure"))
	


func _initialize():
	user = ""
	status = ""
	connection_state = ""
	randomize()
	user_adjectives.shuffle()
	user = user_adjectives.front()
	user_nouns.shuffle()
	user += " " + user_nouns.front()
	var addresses = IP.get_local_addresses()
	for a in addresses:
		if a.contains("192.168") \
		or a.contains("10.0") \
		or a.contains("172."):
			HOST_IP = a
	SERVER_IP = 0
	$VBoxContainer/Client.disabled = true
	_set_status_label()


func _set_status_label() -> void:
	mode_status_label = "User is: " + user
	mode_status_label += "\n\n"
	mode_status_label += "Status is: " + status
	mode_status_label += "\n\n"
	mode_status_label += "User IP: " + str(HOST_IP)
	mode_status_label += "\n\n"
	if status == "Host":
		mode_status_label += "Target IP: " + str(HOST_IP)
	else:
		mode_status_label += "Target IP: " + str(SERVER_IP)
	mode_status_label += "\n\n"
	mode_status_label += "Connection: " + connection_state
	$ModeStatus.text = mode_status_label


func _update_input_label(new_line : String):
	input_label = new_line + "\n" + input_label
	$Input.text = input_label


func _on_Host_pressed():
	if status == "":
		print("Host Pressed")
		enet_state = ENetMultiplayerPeer.new()
		enet_state.create_server(SERVER_PORT, MAX_PLAYERS)
		enet_tree.set_multiplayer_peer(enet_state)
		status = "Host"
		_set_status_label()
		_revealTerminate()


func _add_peer(id):
	print("Adding Peer: ", id)
	if !peers.has(id):
		peers.append(id)
		_update_input_label("Peer Added: " + str(id))
	else:
		print("Peer ", id, " already added")
	connection_state = "Peers Connected : " + str(peers.size())
	_set_status_label()


func _on_Client_pressed():
	if status == "":
		print("Client Pressed")
		enet_state = ENetMultiplayerPeer.new()
		enet_state.create_client(SERVER_IP, SERVER_PORT)
		enet_tree.set_multiplayer_peer(enet_state)
		status = "Client"
		_set_status_label()
		_revealTerminate()


func _on_connection_success() -> void:
	connection_state = "Connected to Server!"
	_set_status_label()


func _on_connection_failure() -> void:
	connection_state = "Failure to connect to Server"
	_set_status_label()


func _on_Ping_pressed():
#	print(OS.get_ticks_msec())
	rpc("_helloFriend", user, str(Time.get_ticks_msec()))


func _on_ServerIP_text_changed(new_text):
	SERVER_IP = new_text
	$VBoxContainer/Client.disabled = false


func _on_Initialize_pressed():
	_initialize()
	$Panel.hide()


func _revealTerminate():
	$VBoxContainer/Host.hide()
	$VBoxContainer/Client.hide()
	$VBoxContainer/ServerIP.hide()
	$VBoxContainer/Terminate.show()


func _on_Terminate_pressed():
	if enet_state != null:
		enet_state.get_host().destroy()
	enet_state = null
	enet_tree.set_multiplayer_peer(null)
	$VBoxContainer/Host.show()
	$VBoxContainer/Client.show()
	$VBoxContainer/ServerIP.show()
	$VBoxContainer/ServerIP.text = ""
	$VBoxContainer/Terminate.hide()
	_initialize()


@rpc("any_peer")
func _helloFriend(peerName, message):
	_update_input_label("Peer: " + peerName + " has said: " + message)
