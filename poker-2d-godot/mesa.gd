extends Node2D

const Partida = preload("res://partida.gd")
const Mao = preload("res://mao.gd")
const RANKS := ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
const NAIPES := ["♠", "♥", "♣", "♦"]
const MARFIM := Color("#f5e8cf")
const OURO := Color("#efc388")

var partida := Partida.new()
var botoes: Array[Button] = []

func _ready() -> void:
	for i in range(3):
		var botao := Button.new()
		botao.position = Vector2(195 + 190 * i, 576)
		botao.size = Vector2(180, 46)
		botao.add_theme_font_size_override("font_size", 18)
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("#173c3a") if i != 1 else Color("#835633")
		estilo.border_color = Color("#bd9165")
		estilo.set_border_width_all(1)
		estilo.set_corner_radius_all(7)
		botao.add_theme_stylebox_override("normal", estilo)
		var hover := estilo.duplicate() as StyleBoxFlat
		hover.bg_color = estilo.bg_color.lightened(0.22)
		botao.add_theme_stylebox_override("hover", hover)
		botao.add_theme_stylebox_override("pressed", hover)
		botao.pressed.connect(_acao.bind(i))
		add_child(botao)
		botoes.append(botao)
	partida.nova_mao()
	_atualizar()

func _acao(indice: int) -> void:
	if partida.encerrada:
		partida.nova_mao()
	elif partida.vez == 0:
		partida.agir(["desistir", "acompanhar", "aumentar"][indice])
	else:
		return
	_atualizar()

func _atualizar() -> void:
	for botao in botoes:
		botao.show()
		botao.disabled = partida.vez != 0
	if partida.encerrada:
		botoes[0].hide()
		botoes[2].hide()
		botoes[1].disabled = false
		botoes[1].text = "Reiniciar partida" if partida.fichas.has(0) else "Próxima mão"
	elif partida.vez == 0:
		var falta := partida.falta_pagar()
		var aumento := partida.valor_aumento()
		botoes[0].text = "Desistir"
		botoes[0].disabled = falta == 0
		botoes[1].text = "Pagar %d" % falta if falta else "Passar"
		botoes[2].text = "%s %d" % ["Aumentar para" if partida.apostas.max() > 0 else "Apostar",
			maxi(partida.apostas[0], partida.apostas[1]) + aumento]
		botoes[2].disabled = aumento == 0
	else:
		botoes[0].hide()
		botoes[2].hide()
		botoes[1].text = "Vez do rival…"
		get_tree().create_timer(0.65).timeout.connect(_rival)
	queue_redraw()

func _rival() -> void:
	partida.acao_rival()
	_atualizar()

func _texto(texto: String, centro: float, base: float, tamanho: int, cor := MARFIM) -> void:
	var fonte := ThemeDB.fallback_font
	var largura := fonte.get_string_size(texto, HORIZONTAL_ALIGNMENT_LEFT, -1, tamanho).x
	draw_string(fonte, Vector2(centro - largura * 0.5, base), texto,
		HORIZONTAL_ALIGNMENT_LEFT, -1, tamanho, cor)

func _oval(centro: Vector2, raios: Vector2, cor: Color) -> void:
	var contorno := PackedVector2Array()
	for i in range(80):
		var angulo := TAU * i / 80.0
		contorno.append(centro + Vector2(cos(angulo), sin(angulo)) * raios)
	draw_colored_polygon(contorno, cor)

func _carta(carta: int, caixa: Rect2) -> void:
	var estilo := StyleBoxFlat.new()
	estilo.set_corner_radius_all(7)
	estilo.set_border_width_all(1)
	estilo.border_color = Color("#d3a66c")
	estilo.bg_color = Color("#181f25") if carta == -2 else Color("#743841") if carta == -1 else MARFIM
	draw_style_box(estilo, caixa)
	var centro := caixa.get_center()
	if carta == -2:
		_texto("·", centro.x, centro.y + 8, 22, OURO)
	elif carta == -1:
		_texto("◇", centro.x, centro.y + 9, 25, OURO)
	else:
		var tinta := Color("#9e273e") if carta % 2 else Color("#192c31")
		_texto(RANKS[Mao.valor(carta) - 2], centro.x, caixa.position.y + caixa.size.y * 0.40, int(caixa.size.x * 0.34), tinta)
		_texto(NAIPES[carta % 4], centro.x, caixa.position.y + caixa.size.y * 0.80, int(caixa.size.x * 0.42), tinta)

func _draw() -> void:
	draw_rect(Rect2(0, 0, 960, 640), Color("#15191f"))
	_oval(Vector2(480, 305), Vector2(469, 220), Color("#211715"))
	_oval(Vector2(480, 287), Vector2(468, 217), Color("#674130"))
	_oval(Vector2(480, 280), Vector2(450, 197), Color("#bc8959"))
	_oval(Vector2(480, 280), Vector2(441, 190), Color("#123d36"))
	_oval(Vector2(480, 280), Vector2(423, 175), Color("#1d5148"))

	_texto("TEXAS HOLD’EM", 122, 38, 19, OURO)
	_texto("LIMIT • BLINDS 5 / 10", 122, 61, 12)
	_texto("RIVAL  ·  %d FICHAS%s" % [partida.fichas[1], "  ·  DEALER" if partida.botao == 1 else ""], 480, 49, 18)
	for i in range(partida.rival.size()):
		var carta := partida.rival[i] if partida.revelar else -1
		_carta(carta, Rect2(425 + 57 * i, 63, 52, 67))

	var fase: String = "Fim da mão" if partida.encerrada else Partida.FASES[partida.rodada]
	_texto(fase, 480, 176, 17, OURO)
	for i in range(5):
		var carta := partida.mesa[i] if i < partida.mesa.size() else -2
		_carta(carta, Rect2(287 + 79 * i, 193, 70, 96))
	var pote := partida.pote
	_texto("POTE  ·  %d" % pote if pote else "POTE ENTREGUE", 480, 327, 23, OURO)
	_texto(partida.resultado if partida.encerrada else partida.ultima_acao, 480, 363, 18)
	for i in range(partida.jogador.size()):
		_carta(partida.jogador[i], Rect2(389 + 94 * i, 395, 84, 116))
	_texto("VOCÊ  ·  %d FICHAS%s" % [partida.fichas[0], "  ·  DEALER" if partida.botao == 0 else ""], 480, 543, 19, OURO)
	if not partida.encerrada and partida.vez == 0:
		_texto("SUA VEZ", 480, 566, 13)
