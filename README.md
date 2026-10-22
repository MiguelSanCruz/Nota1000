# Nota 1000 📱📚

> Aplicativo mobile desenvolvido em **Flutter** focado em estudos e simulados baseados em questões reais do **ENEM** (Exame Nacional do Ensino Médio), com suporte offline completo utilizando banco de dados local SQLite.

---

## 🚀 Sobre o Projeto

O **Nota 1000** nasceu com o objetivo de oferecer aos estudantes uma ferramenta prática, rápida para treinar seus conhecimentos com questões oficiais do ENEM. Na primeira inicialização, o aplicativo processa uma base de dados local em formato JSON e a estrutura em um banco de dados relacional SQLite no dispositivo, garantindo alta performance nas consultas por disciplina e matéria.

---

## ✨ Funcionalidades da Versão 1.0

- **Inicialização Inteligente (Asset para SQLite):** Leitura automática do arquivo `questoes.json` via `rootBundle` na primeira execução e população das tabelas relacionais locais.
- **Filtros Dinâmicos:** Consulta flexível de questões por matéria ou disciplinas específicas (`getQuestionsByMateria` / `getQuestionsByMultipleMaterias`).
- **Ambiente de Simulado (`QuizPage`):** Interface dinâmica para responder às questões sequencialmente, registrando o histórico de escolhas do aluno (`_respostasDoAluno`) sem interrupções de feedback imediato.
- **Tela de Gabarito Detalhado (`AnswersPage`):** 
  - Listagem em barras coloridas indicando visualmente acertos (verde) e erros (vermelho).
  - Componentes expansíveis (`ExpansionTile`) para detalhar o enunciado, a alternativa escolhida pelo aluno e a resposta correta de cada questão.
- **Navegação Segura:** Uso de rotas nomeadas (`/`, `/home`, `/quiz`, `/answers`) com passagem tipada de argumentos via `ModalRoute.settings.arguments`.

---

## 🛠️ Stack Tecnológica

O projeto foi construído utilizando tecnologias modernas do ecossistema Flutter:

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Banco de Dados Local:** [`sqflite`](https://pub.dev/packages/sqflite) + [`path_provider`](https://pub.dev/packages/path_provider)
- **Gerenciamento de Ativos:** `rootBundle` (Leitura de JSON estático)
- **Navegação:** Sistema nativo de rotas nomeadas do Flutter

---

## 📂 Arquitetura e Organização de Pastas

O projeto adota uma estrutura modularizada para separar responsabilidades de dados, regras de negócio e interface:

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart             # Definição de cores globais
│   │   └── app_text_styles.dart        # Estilos de texto da aplicação
│   └── utils/
│       └── app_routes.dart             # Mapeamento e gestão das rotas
├── data/
│   ├── datasources/
│   │   └── database_helper.dart        # Conexão e gestão do banco de dados SQLite
│   ├── models/
│   │   └── question_model.dart         # Modelo de dados da questão
│   └── repositories/
│       └── question_repository.dart    # Repositório de dados e consultas SQL
├── presentation/
│   ├── controllers/
│   │   └── app_controller.dart         # Controlo de estado e lógica de negócio
│   ├── views/
│   │   ├── answers/
│   │   │   └── answers_page.dart       # Tela de gabarito e revisão
│   │   ├── home/
│   │   │   └── home_page.dart          # Tela principal do aplicativo
│   │   ├── login/
│   │   │   └── login_page.dart          # Tela de autenticação/login
│   │   └── quiz/
│   │       └── quiz_page.dart          # Tela do simulado
│   └── widgets/
│       └── custom_appbar.dart          # Componentes visuais reutilizáveis (AppBar personalizada)
├── main.dart                           # Ponto de entrada da aplicação
└── my_app.dart                         # Configuração do MaterialApp, temas e rotas

assets/
└── json/
    └── questoes.json                   # Base de dados em JSON com as questões do ENEM
```
---

## 🗄️ Estrutura do Banco de Dados Local

O SQLite local é estruturado em duas tabelas principais vinculadas por relacionamento:
1. **`questions`**: Armazena metadados da questão (`question_index`, ano, disciplina, matéria, contexto, enunciado, gabarito).
2. **`alternatives`**: Armazena as opções de resposta ligadas à questão correspondente através do campo `question_index`.

---

## ⚙️ Como Executar o Projeto

Siga os passos abaixo para clonar e rodar o projeto em sua máquina:

### Pré-requisitos
Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado em seu ambiente.

### Passo a passo

1. Clone o repositório:
   ```bash
   git clone [https://github.com/seu-usuario/nota-1000.git](https://github.com/seu-usuario/nota-1000.git)