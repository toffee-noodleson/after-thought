extends Node

signal player_face_right(right: bool)
signal on_player_level_up
signal on_player_death
signal on_projectile_enemy_hit(global_pos: Vector2)
signal on_attack_1_enemy_hit
signal on_attack_2_enemy_hit
signal on_enemy_death(global_pos: Vector2)
signal on_core_hit
signal on_gem_pickup(xp: float)
