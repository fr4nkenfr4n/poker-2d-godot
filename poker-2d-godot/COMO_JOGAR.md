# Poker à Mesa

Abra `project.godot` no Godot 4.7 e pressione **F5**. O protótipo é uma mesa local
de Texas Hold’em Limit com dois lugares e fichas fictícias.

- Cada jogador começa com 200 fichas. Os blinds são 5 e 10.
- O botão de dealer alterna a cada mão. O dealer age primeiro no pré-flop.
- As apostas e os aumentos são de 10 no pré-flop e no flop, e de 20 no turn
  e no river, com até três ações agressivas por rodada. O valor é limitado
  pelas fichas que ambos podem cobrir.
- Use **Passar**, **Pagar**, **Apostar**, **Aumentar** ou **Desistir** conforme
  as opções disponíveis. Em caso de all-in pago, a mesa revela todas as
  comunitárias restantes e resolve a mão.
- Clique em **Próxima mão** para continuar com as fichas atuais ou em
  **Reiniciar partida** quando um dos jogadores ficar sem fichas.
