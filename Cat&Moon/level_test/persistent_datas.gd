'''
Used to track datas between application's sessions.
For example, to keep the progression of the player between levels.
'''
class_name PersistentDatas extends Resource

@export var currentLevelIndex: int = 0 # The level index of the current/last level played.
