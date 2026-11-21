extends RefCounted

const Mao = preload("res://mao.gd")
const FASES := ["Pré-flop", "Flop", "Turn", "River"]
const INICIAIS := 200

var fichas: Array[int] = [INICIAIS, INICIAIS]
var apostas: Array[int] = [0, 0]
var jogador: Array[int] = []
var rival: Array[int] = []
var mesa: Array[int] = []
var baralho: Array[int] = []
var pote := 0
var rodada := 0
var botao := 1
var vez := 0
var acoes := 0
var aumentos := 0
var encerrada := true
var revelar := false
var resultado := ""
var ultima_acao := ""

func nova_mao() -> void:
	if not encerrada:
		return
	if fichas.has(0):
		fichas.assign([INICIAIS, INICIAIS])
		botao = 1
	botao = 1 - botao
	vez = botao
	baralho.assign(range(52))
	baralho.shuffle()
	jogador.clear()
	rival.clear()
	mesa.clear()
	for i in range(2):
		jogador.append(baralho.pop_back())
		rival.append(baralho.pop_back())
	pote = 0
	rodada = 0
	acoes = 0
	aumentos = 0
	apostas.fill(0)
	encerrada = false
	revelar = false
	resultado = ""
	ultima_acao = "Blinds de 5 / 10"
	var limite := mini(fichas[0], fichas[1])
	_pagar(botao, mini(5, limite))
	_pagar(1 - botao, mini(10, limite))
	if fichas.has(0) and apostas[0] == apostas[1]:
		_showdown()

func falta_pagar() -> int:
	return maxi(apostas[0], apostas[1]) - apostas[vez]

func valor_aumento() -> int:
	if encerrada or aumentos >= 3:
		return 0
	var falta := falta_pagar()
	var capacidade := mini(fichas[vez] - falta, fichas[1 - vez])
	return clampi(capacidade, 0, 10 if rodada < 2 else 20)

func agir(acao: String) -> void:
	if encerrada:
		return
	var atual := vez
	var quem := "Você" if atual == 0 else "Rival"
	var falta := falta_pagar()
	match acao:
		"desistir":
			if falta > 0:
				ultima_acao = quem + " desistiu"
				_entregar(1 - atual, "Você ganhou por desistência." if atual == 1 else "Rival ganhou por desistência.")
			return
		"aumentar":
			var aumento := valor_aumento()
			if aumento == 0:
				return
			_pagar(atual, falta + aumento)
			aumentos += 1
			ultima_acao = "%s %s para %d" % [quem, "aumentou" if apostas[1 - atual] > 0 else "apostou", apostas[atual]]
		"acompanhar":
			_pagar(atual, falta)
			ultima_acao = "%s %s" % [quem, "pagou %d" % falta if falta else "passou"]
		_:
			return
	acoes += 1
	if apostas[0] == apostas[1]:
		if fichas.has(0):
			_showdown()
			return
		if acoes >= 2:
			_avancar()
			return
	vez = 1 - atual

func acao_rival() -> void:
	if encerrada or vez != 1:
		return
	var forte := Mao.valor(rival[0]) == Mao.valor(rival[1])
	if rodada == 0:
		forte = forte or (Mao.valor(rival[0]) >= 11 and Mao.valor(rival[1]) >= 11)
	else:
		var cartas := rival.duplicate()
		cartas.append_array(mesa)
		for carta in rival:
			var repeticoes := 0
			for outra in cartas:
				if Mao.valor(carta) == Mao.valor(outra):
					repeticoes += 1
			forte = forte or repeticoes >= 2
	var sorteio := randf()
	if not forte and falta_pagar() >= 10 and sorteio < 0.25:
		agir("desistir")
	elif valor_aumento() > 0 and sorteio < (0.50 if forte else 0.12):
		agir("aumentar")
	else:
		agir("acompanhar")

func _pagar(assento: int, valor: int) -> void:
	fichas[assento] -= valor
	apostas[assento] += valor
	pote += valor

func _avancar() -> void:
	if rodada == 3:
		_showdown()
		return
	rodada += 1
	acoes = 0
	aumentos = 0
	apostas.fill(0)
	vez = 1 - botao
	_distribuir(3 if rodada == 1 else 1)

func _distribuir(quantidade: int) -> void:
	baralho.pop_back()
	for i in range(quantidade):
		mesa.append(baralho.pop_back())

func _showdown() -> void:
	if mesa.is_empty():
		_distribuir(3)
	while mesa.size() < 5:
		_distribuir(1)
	revelar = true
	var suas := jogador.duplicate()
	suas.append_array(mesa)
	var dele := rival.duplicate()
	dele.append_array(mesa)
	var seus_pontos := Mao.melhor(suas)
	var pontos_rival := Mao.melhor(dele)
	if seus_pontos == pontos_rival:
		fichas[0] += pote >> 1
		fichas[1] += pote >> 1
		resultado = "Empate com %s. Pote dividido (%d para cada)." % [Mao.nome(seus_pontos), pote >> 1]
		pote = 0
		encerrada = true
	else:
		var ganhador := 0 if seus_pontos > pontos_rival else 1
		var frase := "Você ganhou" if ganhador == 0 else "Rival ganhou"
		_entregar(ganhador, "%s com %s. Pote de %d fichas." % [frase, Mao.nome(maxi(seus_pontos, pontos_rival)), pote])

func _entregar(ganhador: int, frase: String) -> void:
	fichas[ganhador] += pote
	pote = 0
	resultado = frase
	encerrada = true
