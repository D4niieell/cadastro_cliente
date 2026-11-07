// Importa o arquivo que contém a classe BancoLocal (acesso ao banco de dados)
import 'package:cadastro_cliente/banco_local.dart';
// Importa o arquivo que contém a classe/modelo Usuario
import 'package:cadastro_cliente/usuario.dart';
// Importa os widgets do Material Design (visual do app)
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
import 'package:path/path.dart'; // Manipula caminho

// Função principal: é o ponto de partida de todo app Dart/Flutter
void main() {
  runApp(const MeuAplicativo()); // Inicia o app
}

// Classe principal do APP.
// StatelessWidget = widget sem estado (não muda depois de criado)
class MeuAplicativo extends StatelessWidget {
  // Construtor constante; "super.key" repassa a chave ao widget pai
  const MeuAplicativo({super.key});

  // Indica que estamos sobrescrevendo o método build da classe pai
  @override
  // build descreve a interface que esse widget desenha na tela
  Widget build(BuildContext context) {
    // MaterialApp é a raiz de um app que usa Material Design
    return const MaterialApp(
      // Remove a faixa "DEBUG" do canto da tela
      debugShowCheckedModeBanner: false,
      home: TelaInicial(), // Primeira tela.
    ); // Material App
  }
}

// Tela de Cadastro e consulta
// StatefulWidget = widget com estado (a tela se atualiza quando os dados mudam)
class TelaInicial extends StatefulWidget {
  // Construtor constante com a chave do widget
  const TelaInicial({super.key});

  // Indica que estamos sobrescrevendo o método createState
  @override
  // Cria o objeto de estado que guarda os dados e a lógica da tela
  State<TelaInicial> createState() => _TelaInicialState();
}

// Classe de estado da tela (o "_" no início a torna privada ao arquivo)
class _TelaInicialState extends State<TelaInicial> {
  final banco = BancoLocal(); // Objeto responsável por SQLITE

  final id = TextEditingController(); // Controla o ID
  final nome = TextEditingController(); // Controla o campo nome
  final email = TextEditingController(); // Controla o campo e-mail

  String resultado = ''; // Mensagem exibida na tela

  // Cadastra um usuário no SQLite
  // Future<void> = função assíncrona que não retorna valor
  Future<void> cadastrarUsuario() async {
    // Valida se os campos foram preenchidos
    if (nome.text.isEmpty || email.text.isEmpty) {
      // setState avisa o Flutter que algo mudou e que a tela deve ser redesenhada
      setState(() {
        // Define a mensagem de erro que será exibida
        resultado = 'Preencha todos os Campos!!!';
      });
      // Encerra a função aqui, sem cadastrar nada
      return;
    }

    // try/catch: tenta executar o bloco e captura erros, se ocorrerem
    try {
      // Simulação de erro
      if (codigo == 999) {
        throw Exception('Isto é uma falha simulada');
      }

      // Envia os dados para o BD
      // "await" espera o banco terminar antes de seguir para a próxima linha
      await banco.cadastrar(nome.text, email.text);

      id.clear(); // Limpa o campo id.
      nome.clear(); // Limpa o campo nome.
      email.clear(); // Limpa o campo e-mail.

      // Redesenha a tela com a mensagem de sucesso
      setState(() {
        resultado = 'Usuário cadastrado com SUCESSO!!!';
      });
    } catch (erro) {
      // Executo caso ocorra um exceção.
      // Mostra o erro no console (útil para depuração)
      print('Erro as cadastrar usuário: $erro');

      // Redesenha a tela com a mensagem de falha
      setState(() {
        resultado = 'Não foi possível cadastar o usuário';
      });
    }
  }

  // Busca todos os usuários do banco e mostra na tela
  Future<void> consultarUsuarios() async {
    final usuarios = await banco.listar(); // Busca os registros no BD

    String texto = ''; // Armazena o resultado da consulta

    // Percorre os usuários encotrados.
    for (var usuario in usuarios) {
      // Adiciona ao texto uma linha com "id - nome" e quebra de linha (\n)
      texto += '${usuario['id']} - ${usuario['nome']}\n';
      // Adiciona o e-mail e deixa uma linha em branco para separar os usuários
      texto += '${usuario['email']}\n\n';
    }

    // Redesenha a tela com o texto montado
    setState(() {
      resultado = texto; // Atualiza o texto da tela.
    });
  }

  // dispose é chamado quando a tela é destruída
  @override
  void dispose() {
    nome.dispose(); // Libera o controlador nome
    email.dispose(); // Libera o controlador nome
    super.dispose(); // Libera o controlador nome
  }

  // Altera o nome e o e-mail de um usuário
  Future<void> alterarUsuario() async {
    int? codigo = int.tryParse(id.text); // Conversão do ID para inteiro

    // Verifica os campos necessários
    // (codigo será null se o texto digitado não for um número válido)
    if (codigo == null || nome.text.isEmpty || email.text.isEmpty) {
      setState(() {
        // Mensagem de erro de validação
        resultado = 'Informe um ID válido, nome e e-mail';
      });
      // Interrompe a função sem alterar nada
      return;
    }

    // Inicia o bloco "try": tenta executar o código abaixo.
    // Se qualquer linha der erro, o Dart pula direto para o "catch"
    try {
      // Chama a função "alterar" do banco, passando o ID, o novo nome e o novo e-mail.
      // "await" espera o banco terminar antes de continuar.
      // "quantidade" recebe o número de linhas que foram alteradas no banco
      int quantidade = await banco.alterar(codigo, nome.text, email.text);

      // setState avisa o Flutter que algo mudou e que a tela deve ser redesenhada
      setState(() {
        // Se pelo menos uma linha foi alterada, a alteração deu certo
        if (quantidade > 0) {
          // Define a mensagem de sucesso que será exibida na tela
          resultado = 'Usuário alterado com sucesso!!';
        } else {
          // Nenhuma linha foi alterada: o ID informado não existe no banco
          // Define a mensagem informando que o usuário não foi encontrado
          resultado = 'Usuário não encontrado!!!';
        }
      });

      // Limpa o campo de texto do ID
      id.clear();
      // Limpa o campo de texto do nome
      nome.clear();
      // Limpa o campo de texto do e-mail
      email.clear();
      // Inicia o bloco "catch": só é executado se ocorrer um erro dentro do "try".
      // A variável "erro" guarda a informação do que deu errado
    } catch (erro) {
      // Mostra o erro no console (útil para depuração durante o desenvolvimento)
      print('Erro ao alterar usuário: $erro');

      // Redesenha a tela com a mensagem de falha para o usuário
      setState(() {
        // Define a mensagem de erro que será exibida na tela
        resultado = 'Não foi possível alterar o usuário';
      });
    }

    // Executa a alteração no SQLite
    // "quantidade" recebe o número de linhas que foram alteradas
    int quantidade = await banco.alterar(codigo, nome.text, email.text);

    setState(() {
      // Se pelo menos uma linha foi alterada, deu certo
      if (quantidade > 0) {
        resultado = 'Usuário alterado com SUCESSO!!!';
      } else {
        // Nenhuma linha alterada: o ID não existe no banco
        resultado = 'Usuário não encontrado!!!';
      }
    });

    // Limpa os três campos de texto após a operação
    id.clear();
    nome.clear();
    email.clear();
  }

  // Excluir um usuário do SQLite
  Future<void> excluirUsuario() async {
    int? codigo = int.tryParse(id.text); //Converte o ID

    // Verifica de o ID foi informado corretamente
    if (codigo == null) {
      setState(() {
        // Mensagem de erro de validação
        resultado = 'Informe um ID válido!!!';
      });
      // Interrompe a função sem excluir nada
      return;
    }

    // "quantidade" recebe o número de linhas excluídas
    int quantidade = await banco.excluir(codigo);

    setState(() {
      // Se pelo menos uma linha foi excluída, deu certo
      if (quantidade > 0) {
        resultado = 'Usuário excluído com sucesso!!!';
      } else {
        // Nenhuma linha excluída: o ID não existe no banco
        resultado = 'Usuário não encontrado!!!';
      }
    });

    id.clear(); // Limpa somente o campo ID
  }

  // Constrói a interface da tela
  @override
  Widget build(BuildContext context) {
    // Scaffold é a estrutura básica de uma tela (barra superior, corpo, etc.)
    return Scaffold(
      // Barra superior com o título da tela
      appBar: AppBar(title: const Text('Cadastro de usuários')),

      // Conteúdo principal da tela
      body: Padding(
        // Margem interna de 20 pixels em todos os lados
        padding: const EdgeInsets.all(20),

        // Column organiza os widgets filhos um embaixo do outro
        child: Column(
          // Faz os filhos ocuparem toda a largura disponível
          crossAxisAlignment: CrossAxisAlignment.stretch,

          // Lista de widgets exibidos na coluna
          children: [
            // Campo para digitar o ID.
            TextField(
              // Liga o campo ao controlador "id" (permite ler/limpar o texto)
              controller: id,
              // Mostra o teclado numérico
              keyboardType: TextInputType.number,
              // Aparência do campo
              decoration: const InputDecoration(
                // Texto de rótulo que aparece sobre o campo
                labelText: 'ID do usuário (Alterar ou excluir)',
              ),
            ),

            // Campo para digitar o nome.
            TextField(
              // Liga o campo ao controlador "nome"
              controller: nome,
              // Rótulo do campo
              decoration: const InputDecoration(labelText: 'Nome'),
            ),

            // Campo para digitar o e-mail.
            TextField(
              // Liga o campo ao controlador "email"
              controller: email,
              // Rótulo do campo
              decoration: InputDecoration(labelText: 'E-mail'),
            ),

            // Espaço vazio de 20 pixels de altura entre os widgets
            const SizedBox(height: 20),

            // Botão cadastro
            ElevatedButton(
              // Função chamada quando o botão é pressionado
              onPressed: cadastrarUsuario,
              // Texto exibido dentro do botão
              child: const Text('Cadastrar'),
            ),

            // Botão Consultar
            ElevatedButton(
              // Chama a função que lista os usuários
              onPressed: consultarUsuarios,
              child: const Text('Consultar usuários'),
            ),

            // Botão para alterar (Ainda sem funcionalidade)
            ElevatedButton(
              // Chama a função que altera um usuário
              onPressed: alterarUsuario,
              child: const Text('Alterar usuário'),
            ),

            // Botão para Excluir (Ainda sem funcionalidade)
            ElevatedButton(
              // Chama a função que exclui um usuário
              onPressed: excluirUsuario,
              child: const Text('Excluir Usuário'),
            ),

            // Outro espaço de 20 pixels antes da área de resultados
            const SizedBox(height: 20),

            // Espaço reservado para exibir os resultados
            // Expanded ocupa todo o espaço que sobrar na tela;
            // SingleChildScrollView permite rolar se o texto for grande;
            // Text mostra o conteúdo da variável "resultado"
            Expanded(child: SingleChildScrollView(child: Text(resultado))),
          ],
        ),
      ),
    );
  }
}
