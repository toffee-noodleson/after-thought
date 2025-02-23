
extends Node


const SOUND_BLADE = "blade"
const SOUND_CLICK = "click"
const SOUND_CORE_DAMAGE = "core_damage"
const SOUND_IMPACT = "impact"
const SOUND_KILL = "kill"
const SOUND_GAMEOVER = "gameover1"
const SOUND_AXE = "axe"
const SOUND_MUSIC1 = "music1"
const SOUND_PICKUP = "pickup"
const SOUND_BOSS_ARRIVE = "boss_arrive"
const SOUND_JUMP = "jump"
const SOUND_KNIFE = "knife"


var SOUNDS: Dictionary = {
	SOUND_BLADE: preload("res://assets/Audio/Blade Swing A.wav"),
	SOUND_CLICK: preload("res://assets/Audio/Click Bell.wav"),
	SOUND_CORE_DAMAGE: preload("res://assets/Audio/damage.wav"),
	SOUND_IMPACT: preload("res://assets/Audio/impact.wav"),
	SOUND_KILL: preload("res://assets/Audio/Fantasy_Game_Weapon_Impact.wav"),
	SOUND_GAMEOVER: preload("res://assets/Audio/game_over.ogg"),
	SOUND_AXE: preload("res://assets/Audio/General Weapon Whoosh C.wav"),
	SOUND_MUSIC1: preload("res://assets/Audio/Flowing Rocks.ogg"),
	SOUND_PICKUP: preload("res://assets/Audio/phaseJump1.ogg"),
	SOUND_JUMP: preload("res://assets/Audio/jump.wav"),
	SOUND_KNIFE: preload("res://assets/Audio/Knife.wav")
	
}


func play_clip(player: AudioStreamPlayer2D, clip_key: String) -> void:
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
