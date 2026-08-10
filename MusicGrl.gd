extends AudioStreamPlayer2D
#esta esena music_grtl.tscn se tiene que dar de alta en project settings autoload , para que suene .
const level_music = preload("res://assets/E_bow MAGIC.wav")           #cancion a sonar en el plano general , no se agrega a l nodo strew

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = level_music
	volume_db = volume
	play()
	
func _play_music_level():
	_play_music(level_music)
