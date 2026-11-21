extends RefCounted

const NOMES := ["carta alta", "um par", "dois pares", "trinca", "sequência",
	"flush", "full house", "quadra", "straight flush"]

# Cada carta é um inteiro de 0 a 51. O naipe ocupa os dois bits inferiores.
static func valor(carta: int) -> int:
	return (carta >> 2) + 2

static func melhor(cartas: Array[int]) -> int:
	var melhor_pontuacao := 0
	for a in range(3):
		for b in range(a + 1, 4):
			for c in range(b + 1, 5):
				for d in range(c + 1, 6):
					for e in range(d + 1, 7):
						var cinco: Array[int] = [cartas[a], cartas[b], cartas[c], cartas[d], cartas[e]]
						melhor_pontuacao = maxi(melhor_pontuacao, _cinco(cinco))
	return melhor_pontuacao

static func nome(pontos: int) -> String:
	return NOMES[pontos >> 20]

static func _pontos(categoria: int, valores: Array[int]) -> int:
	var pontos := categoria << 20
	for i in range(valores.size()):
		pontos |= valores[i] << ((4 - i) * 4)
	return pontos

static func _cinco(cartas: Array[int]) -> int:
	var contagem: Array[int] = []
	contagem.resize(15)
	contagem.fill(0)
	var flush := true
	for carta in cartas:
		contagem[valor(carta)] += 1
		flush = flush and carta % 4 == cartas[0] % 4
	var grupos: Array[int] = []
	var pares: Array[int] = []
	var soltas: Array[int] = []
	var trinca := 0
	var quadra := 0
	for rank in range(14, 1, -1):
		match contagem[rank]:
			4: quadra = rank
			3: trinca = rank
			2: pares.append(rank)
			1: soltas.append(rank)
		if contagem[rank] > 0:
			grupos.append(rank)
	var sequencia := 0
	if grupos.size() == 5:
		if grupos[0] - grupos[4] == 4:
			sequencia = grupos[0]
		elif grupos == [14, 5, 4, 3, 2]:
			sequencia = 5
	if flush and sequencia:
		return _pontos(8, [sequencia])
	if quadra:
		return _pontos(7, [quadra, soltas[0]])
	if trinca and not pares.is_empty():
		return _pontos(6, [trinca, pares[0]])
	if flush:
		return _pontos(5, grupos)
	if sequencia:
		return _pontos(4, [sequencia])
	if trinca:
		return _pontos(3, [trinca, soltas[0], soltas[1]])
	if pares.size() == 2:
		return _pontos(2, [pares[0], pares[1], soltas[0]])
	if pares.size() == 1:
		return _pontos(1, [pares[0], soltas[0], soltas[1], soltas[2]])
	return _pontos(0, soltas)
