extends HBoxContainer

var inventory = preload("res://Player/Inventory.tres")
onready var matterRef = {
	"Wood": $Wood/Sprite/ItemAmount,
	"Yarn": $Yarn/Sprite/ItemAmount,
	"Sand": $Sand/Sprite/ItemAmount,
	"Ore": $Ore/Sprite/ItemAmount,
	"PowerPrism": $PowerPrism/Sprite/ItemAmount
}

func _ready():
	inventory.connect("matterChanged", self, "_onMatterChanged")
	inventory.connect("matterUnlocked", self, "_onMatterUnlocked")
#	for mat in matterRef:                                         #AQUIIIIIIIIIIIIIIIIII
#		var isUnlocked = inventory.unlockedMatter.get(mat, false)
#		matterRef[mat].get_parent().visible = isUnlocked          #vemos se o material já existe. Se sim, ele aparece na tela
	updateAll()                                                   #chamamos uma atualização pra todas as matérias ao iniciar

func updateAll():
	for matter in matterRef.keys():                               #passamos em cada material por vez
		var matterAmount = inventory.getMatterAmount(matter)      #pegamos a quantia desse item
		updateMatter(matter, matterAmount)

func _onMatterChanged(thisMatter, amount):
	if matterRef.has(thisMatter):
		updateMatter(thisMatter, amount)

func updateMatter(thisMatter, amount):
	var matterLabel = matterRef[thisMatter]                       #pegamos uma referência ao label da matéria a ser editada
	matterLabel.text = str(amount)                                #converte int pra string

func _onMatterUnlocked(thisMatter):
	matterRef[thisMatter].get_parent().visible = true
