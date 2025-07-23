
extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerSeekZone = $PlayerSeekZone
onready var hurtbox = $Hurtbox
onready var wanderController = $WanderController

export var acceleration = 20
export var maxSpeed = 50
export var friction = 400
export var wanderTarget = 4
const EnemyDeathEffect = preload("res://Effects/DirebriarDeathEffect.tscn")
