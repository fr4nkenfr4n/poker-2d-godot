extends Control

const Guia = preload("res://guia.gd")
const MARFIM := Color("#f5e8cf")
const OURO := Color("#efc388")

var painel_menu: VBoxContainer
var painel_extras: VBoxContainer
var novo_jogo: Button
var voltar: Button

func _ready() -> void:
	var fundo := ColorRect.new()
	fundo.color = Color("#15191f")
	add_child(fundo)
	fundo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	painel_menu = VBoxContainer.new()
	painel_menu.position = Vector2(300, 158)
	painel_menu.custom_minimum_size.x = 360
	painel_menu.add_theme_constant_override("separation", 20)
	add_child(painel_menu)
	var titulo := _titulo("Poker à Mesa", 48)
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	painel_menu.add_child(titulo)
	var modalidade := _titulo("Texas Hold’em Limit", 22)
	modalidade.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	painel_menu.add_child(modalidade)
	novo_jogo = _botao(painel_menu, "Novo jogo", _jogar)
	_botao(painel_menu, "Extras", _mostrar_extras)

	painel_extras = VBoxContainer.new()
	painel_extras.position = Vector2(105, 32)
	painel_extras.size = Vector2(750, 576)
	painel_extras.add_theme_constant_override("separation", 14)
	add_child(painel_extras)
	painel_extras.add_child(_titulo("Como jogar Texas Hold’em", 32))
	var guia := RichTextLabel.new()
	guia.size_flags_vertical = Control.SIZE_EXPAND_FILL
	guia.focus_mode = Control.FOCUS_ALL
	guia.add_theme_font_size_override("normal_font_size", 18)
	guia.add_theme_color_override("default_color", MARFIM)
	guia.text = Guia.TEXTO
	painel_extras.add_child(guia)
	voltar = _botao(painel_extras, "Voltar ao menu", _mostrar_menu)
	_mostrar_menu()

func _input(evento: InputEvent) -> void:
	if painel_extras.visible and evento.is_action_pressed("ui_cancel"):
		_mostrar_menu()
		get_viewport().set_input_as_handled()

func _mostrar_menu() -> void:
	painel_extras.hide()
	painel_menu.show()
	novo_jogo.grab_focus()

func _mostrar_extras() -> void:
	painel_menu.hide()
	painel_extras.show()
	voltar.grab_focus()

func _jogar() -> void:
	get_tree().change_scene_to_file("res://mesa.tscn")

func _titulo(texto: String, tamanho: int) -> Label:
	var titulo := Label.new()
	titulo.text = texto
	titulo.add_theme_font_size_override("font_size", tamanho)
	titulo.add_theme_color_override("font_color", OURO)
	return titulo

func _botao(painel: VBoxContainer, texto: String, acao: Callable) -> Button:
	var botao := Button.new()
	botao.text = texto
	botao.custom_minimum_size.y = 48
	botao.add_theme_font_size_override("font_size", 19)
	botao.pressed.connect(acao)
	painel.add_child(botao)
	return botao
