# Guia de Configuração do Guerreiro no Godot

Este guia detalha como configurar a cena `warrior.tscn` e o script `warrior.gd` no seu projeto.

## 1. Configuração dos Inputs (Controles)
Para que o script funcione, o Godot precisa saber quais teclas correspondem a cada ação.
1. Vá em **Project (Projeto)** -> **Project Settings (Configurações do Projeto)**.
2. Clique na aba **Input Map (Mapa de Entradas)**.
3. Adicione as seguintes ações e vincule as teclas desejadas (ex: Botão esquerdo do mouse, Tecla Z, etc):
   - `attack1`
   - `attack2`
   - `guard`
   - *(As direções ui_left, ui_right, ui_up, ui_down já vêm configuradas por padrão no Godot).*

## 2. Configurando as Animações
O script espera animações com nomes específicos. No nó `AnimationPlayer` da cena `warrior.tscn`:
1. Crie uma nova biblioteca de animações (se necessário).
2. Crie as animações com estes nomes exatos:
   - `idle`
   - `run`
   - `Attack 1`
   - `Attack 2`
   - `guard`
3. Dentro de cada animação, adicione uma trilha de **Propriedade (Property Track)** apontando para o `Sprite2D` e a propriedade `texture` ou `frame` (se estiver usando Spritesheet) para animar o seu guerreiro com os arquivos da pasta `warrior`.

## 3. Configurando o Sprite
1. Abra a cena `warrior.tscn`.
2. Selecione o nó `Sprite2D`.
3. Arraste uma das imagens da sua pasta `warrior` (geralmente do estado Idle) para a propriedade **Texture** no Inspetor.

## 4. Ajustando a Colisão
1. Selecione o nó `CollisionShape2D`.
2. No Inspetor, ajuste o tamanho do retângulo para que ele cubra o corpo do seu personagem de forma adequada.

## 5. Como o Script Funciona
- **Máquina de Estados**: O personagem só pode atacar se estiver no chão e não estiver defendendo.
- **Normalização**: O movimento diagonal não é mais rápido que o horizontal.
- **Sinais**: O script usa o sinal `animation_finished` do `AnimationPlayer` para saber quando um ataque terminou e permitir que o jogador se mova novamente.

---
Se precisar de ajustes na velocidade ou força da aceleração, você pode alterar os valores diretamente no Inspetor do nó `Warrior`, pois as variáveis estão marcadas com `@export`.
