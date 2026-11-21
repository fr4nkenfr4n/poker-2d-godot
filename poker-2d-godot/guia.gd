extends RefCounted

const TEXTO := """
OBJETIVO

Ganhe o pote, ou seja, as fichas apostadas na mão. Você pode ganhar se o rival desistir ou se tiver a melhor mão quando as cartas forem reveladas. Em caso de empate, o pote é dividido.

COMO AS CARTAS SÃO DISTRIBUÍDAS

Você e o rival recebem duas cartas privadas cada. Use exatamente cinco cartas para formar sua melhor mão, escolhendo entre suas duas cartas e as cinco comunitárias. Você pode usar as duas cartas privadas, apenas uma ou até jogar com as cinco cartas da mesa.

• Pré-flop: cada jogador recebe as duas cartas privadas e começa a primeira rodada de apostas.
• Flop: três cartas comunitárias são abertas.
• Turn: a quarta carta comunitária é aberta.
• River: a quinta carta comunitária é aberta.

Há uma rodada de apostas em cada fase. Se os dois continuarem após a última, as cartas privadas são comparadas. Se um jogador colocar todas as suas fichas e a aposta for paga, a mesa revela as comunitárias restantes.

BLINDS E APOSTAS

Os blinds são apostas obrigatórias antes de ver as cartas. Nesta mesa, o dealer coloca 5 e o outro jogador coloca 10. O marcador de dealer alterna entre os jogadores a cada mão. O dealer age primeiro no pré-flop. A partir do flop, o outro jogador começa.

• Passar: mantenha-se na mão quando não houver valor a pagar.
• Pagar: iguale o valor apostado pelo rival nesta rodada.
• Apostar: coloque fichas quando ainda não houver aposta na rodada.
• Aumentar: suba o valor que o rival precisará igualar.
• Desistir: saia da mão e entregue o pote ao rival.

Nesta mesa Limit, as apostas e os aumentos são normalmente de 10 no pré-flop e no flop, e de 20 no turn e no river. A mesa limita o valor às fichas que os dois podem cobrir.

MÃOS DA MAIS FORTE À MAIS FRACA

1. Straight flush: cinco cartas consecutivas do mesmo naipe. De 10 até ás, é chamado de royal flush.
2. Quadra: quatro cartas do mesmo valor.
3. Full house: uma trinca e um par.
4. Flush: cinco cartas do mesmo naipe.
5. Sequência: cinco cartas consecutivas de qualquer naipe. O ás também pode valer 1 em A–2–3–4–5.
6. Trinca: três cartas do mesmo valor.
7. Dois pares: dois pares de valores diferentes.
8. Um par: duas cartas do mesmo valor.
9. Carta alta: vence a maior carta quando nenhuma combinação acima se forma.

Se os dois tiverem a mesma categoria, compare primeiro o valor da combinação. Por exemplo, um par de reis vence um par de damas. Se a combinação tiver o mesmo valor, compare as cartas restantes da mão de cinco, da maior para a menor. Se as cinco cartas tiverem os mesmos valores, é empate. Os naipes não desempatam.

EXEMPLO

Suas cartas são A♠ e J♣. Na mesa estão A♦, A♥, 7♠, 7♦ e 2♣. Sua melhor mão é A♠, A♦, A♥, 7♠ e 7♦, um full house de ases com setes.
"""
