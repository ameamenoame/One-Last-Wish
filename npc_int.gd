extends Area2D


# Adds these idenfiers to the inspector tab for easy access and modification
export(bool) var dia_flag = true
export(String) var dia_id
#export(Array) var dia_lines
export(int) var max_dia = 1# set as number of dialogues 
export(int) var dia_times = 0 

#nready var dia_times = 0
#onready var MAX_DIA = dia_lines.size() - 1