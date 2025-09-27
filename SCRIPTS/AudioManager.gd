extends Node

var masterBusIndex = 0 # 0db é o volume máx, sendo -80db o silêncio total

func _ready():
	var masterVolumeDB = linear2db(0.3) #AUDIO = 30%
	AudioServer.set_bus_volume_db(masterBusIndex, masterVolumeDB)

# Função pra mudar o volume dos efeitos sonoros para o valor de um slider (de 0.0 a 1.0)
func setSfxVolume(volumeValue: float):
	var sfxIndex = AudioServer.get_bus_index("SFX")
	var volumeDB = linear2db(volumeValue)
	AudioServer.set_bus_volume_db(sfxIndex, volumeDB)
