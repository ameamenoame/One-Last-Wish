extends Node


var current_npc = null # tracks what player is interacting with
var in_dialog = false # tracks whether player is in a dialogue
var mouse_0 = load("res://Assets/mouse_0.png")
var mouse_1 = load("res://Assets/mouse_1.png")
#var char_movement = true
var int_able = true # tracks player interaction status
var dia_track = {} # complete list tracking how many times each NPC has been spoken to
#var near_portal = false # tracks doors 
var current_animation = 0
var current_frame = 0
var puzzle_1_finished = false
var puzzle_2_finished = false
var diary_read = false
var current_puzzle = 1
var is_retry = false
var ended = false