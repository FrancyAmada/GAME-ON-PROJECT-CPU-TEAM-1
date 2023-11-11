extends MarginContainer

@onready var label = $MarginContainer/Label

const max_width = 700
var text = ""

const letters = [
	"In times gone by, we were close as Kinad and Nanad, sharing meat and mead around the fire. But since our father passed, distance divided us. I know you bear the burden of leadership alone since being named Datu. You need not carry it in solitude. Remember who you were before the crown. Should you need counsel or comfort, I am still here. No tide or tremor could sway the love between brothers.",
	"The children cry at night from nightmares not their own. Our healers' remedies do little to soothe their terrors. My own wife hasn't slept in weeks, so tormented by visions of shadows crawling from beneath our hut. People look to me, but I have no comfort to give them. I beg you, let us leave these cursed lands and sail south as our ancestors did. Guide us back into the light before madness consumes us all.",
	"The rainy season has already begun, earlier than normal. The rivers are swelling, and some homes at the edge of town have flooded. My neighbors and I have been working day and night to reinforce the dams and direct the waters. But we are just simple folk, not engineers. We need guidance from someone wiser. I don't mean to add to your heavy burdens, but please lend your wisdom so we can protect our families and homes. My door is always open if you wish to personally assess the situation. We are grateful for any help you can provide.",
	"I hope this letter finds you well. The children are both growing so fast - Diego started walking this week, and little Kamila is becoming such a chatterbox. For Diego's birthday, I wanted to make his favorite boiled corn cakes with honey glaze. But the corn harvest was meager this season, and honey is so costly at market. I know resources are scarce for all now. But perhaps you could spare just a small ration of corn and honey, as a kindness for your loyal subject and friend? I would be forever grateful. May the gods bless you and your family.",
	"I hope you and your family are keeping safe. The children miss playing with your little ones - they keep asking when we'll visit your village again. I remember fondly the puppet shows and songs your folk would delight us with. My Lina's birthday approaches soon. In times of peace, we'd have celebrated with a feast. I know such merrymaking is impossible now, but perhaps you could send just a small gift? Any trinket or sweet would make Lina smile again. I wish you and yours continued health. May we reunite for happier days.",
	"As we work to rebuild homes damaged in the recent storms, our supplies of wood and thatch run short. I would not ask if need were not dire. But we require more timber, rope and straw to make it through the rainy months. I understand resources are limited, but we will compensate whatever can be spared. Please send what you can, so no families remain unsheltered. We owe you and your line a great debt for guiding us through this crisis.",
	"Word came from the southern villages of your victory over the ghastly forces plaguing our land. At long last, a ray of light pierces the darkness! I always knew you had the spirit of your ancestors. We celebrate here, but still anxiously await your arrival. I've prepared your favorite stew with the spices you love. Come home soon, dear friend - reclaim your place by the hearth and regale us with tales of your valor over delicious food and drink! You are always missed here.",
	"The mango trees have finally borne fruit again - it's been so long since we feasted on their sweetness! Little Nina squeals with laughter as the juice drips down her chin. She tries to eat them faster than I can peel. Save me from this sticky child! I can't wait to make pickled mangoes - you must come visit when the batches are ready. We'll stay up late like we used to, remembering old times and dreaming of new ones. There is still joy to be found, my friend.",
	"Monsoon rains continue to batter our huts. The ground is muddy seas, impassable on foot. It reminds me of the summer we decided to build a raft to pole across the flooded fields, only to sink up to our waists! We got such a scolding afterwards, but oh how we laughed. Come visit when you can. We'll watch the storms from my porch as we did as boys, sipping ginger tea and telling tall tales. My home is always open to you, in fair weather or foul.",
	"The children have not stopped talking about your visit last week! They were utterly delighted by the shadow puppets you made for them. Little Kalina has scarcely let go of the dancing girl figure since. You would make a wonderful father yourself someday. Come back soon to share more songs, games, and stories. It does them good to see you smile and hear your laughter fill our home. You always were like family to us.",
	"As the summer fades, I find myself longing for the carefree days of youth we spent down by the lake. Do you remember diving into the cool, clear waters? And the juicy plums we would pick, gorging ourselves until our stomachs ached? Let us recreate such simple joys again soon. Leave your carved throne for awhile and join me to swim, feast, and pretend our only concerns are the grumbling hunger of two growing boys.",
	"The harvest is finally done! My back aches from long days bending in the fields, but it is satisfying work. Come celebrate with us - there will be a feast tonight of fresh fish and stewed vegetables. My mother is roasting corn and making her famous coconut cakes. There will be music and dancing under the moonlight too. Leave your headache-inducing ledgers for one night and join our merriment! Savor the fruits of our labor and be merry. You are greatly missed, my friend.",
	"The mango tree behind my hut has borne more fruit than my family can eat! Already we've made pickled mangoes, sweet mango jam, even mango rice cakes. But there's still so much left. Please come take a basketful home to your family. The children will love the sweetness. We can sit on my porch, sipping cool mango juice and watching the sunset. No talks of politics or troubles - just two friends sharing a fruitful harvest. Come soon, before they spoil!"
]

func _ready():
	var random_index : int = randi() % letters.size()
	var random_letter = letters[random_index]
	set_text(random_letter)

func set_text(new_text):
	label.text = new_text
	
	await resized
	custom_minimum_size.x = min(size.x, max_width)
	
	if size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.x +24

func _on_timer_timeout():
	var random_index : int = randi() % letters.size()
	var random_letter = letters[random_index]
	set_text(random_letter)
