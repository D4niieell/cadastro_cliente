// Importa o arquivo que contém a classe BancoLocal (acesso ao banco de dados).
import 'package:cadastro_cliente/banco_local.dart';
// Importa o arquivo que contém a classe Usuario (modelo de dados).
import 'package:cadastro_cliente/usuario.dart';
// Importa os widgets do Material Design do Flutter (telas, botões, campos etc.).
import 'package:flutter/material.dart';
// Importa a biblioteca sqflite, que permite usar o SQLite no Flutter.
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
// Importa a biblioteca path, usada para montar caminhos de arquivos.
import 'package:path/path.dart'; // Manipula caminho

// Função principal: é o ponto de entrada onde o Dart começa a executar o app.
void main() {
  // runApp inicia o aplicativo, exibindo o widget MeuAplicativo na tela.
  runApp(const MeuAplicativo()); // Inicia o app
} // Fim da função main.

// Classe principal do APP.
// StatelessWidget: widget que não possui estado interno que muda.
class MeuAplicativo extends StatelessWidget {
  // Construtor constante; repassa a "key" (identificador do widget) para a classe pai.
  const MeuAplicativo({super.key});

  // Indica que estamos sobrescrevendo o método build da classe pai.
  @override
  // O método build descreve como o widget é desenhado na tela.
  Widget build(BuildContext context) {
    // Retorna um MaterialApp, que é a estrutura base de um app Material Design.
    return const MaterialApp(
      // Remove a faixa "DEBUG" exibida no canto da tela.
      debugShowCheckedModeBanner: false,
      // Define qual widget será a tela inicial do app.
      home: TelaInicial(), // Primeira tela.
    ); // Material App
  } // Fim do método build.
} // Fim da classe MeuAplicativo.

// Tela de Cadastro e consulta
// StatefulWidget: widget que possui estado, ou seja, pode mudar durante o uso.
class TelaInicial extends StatefulWidget {
  // Construtor constante; repassa a "key" para a classe pai.
  const TelaInicial({super.key});

  // Indica que estamos sobrescrevendo o método da classe pai.
  @override
  // Cria o objeto de estado que vai controlar esta tela.
  State<TelaInicial> createState() => _TelaInicialState();
} // Fim da classe TelaInicial.

// Classe de estado da tela (o "_" no início a torna privada ao arquivo).
class _TelaInicialState extends State<TelaInicial> {
  // Cria um objeto BancoLocal para acessar o banco de dados.
  final banco = BancoLocal(); // Objeto responsável por SQLITE

  // Controlador do campo de texto do ID (lê e limpa o que foi digitado).
  final id = TextEditingController(); // Controla o ID
  // Controlador do campo de texto do nome.
  final nome = TextEditingController(); // Controla o campo nome
  // Controlador do campo de texto do e-mail.
  final email = TextEditingController(); // Controla o campo e-mail

  // Variável de texto que guarda a mensagem/resultado mostrado na tela (começa vazia).
  String resultado = ''; // Mensagem exibida na tela

  // Cadastra um usuário no SQLite
  // Função assíncrona (async) que não retorna valor (Future<void>).
  Future<void> cadastrarUsuario() async {
    // Valida se os campos foram preenchidos
    // Se o nome OU o e-mail estiverem vazios, entra no bloco abaixo.
    if (nome.text.isEmpty || email.text.isEmpty) {
      // setState avisa o Flutter que o estado mudou e que a tela deve ser redesenhada.
      setState(() {
        // Define a mensagem de erro de validação.
        resultado = 'Preencha todos os Campos!!!';
      }); // Fim do setState.
      // Encerra a função aqui, sem tentar cadastrar.
      return;
    } // Fim do if.

    // Inicia um bloco que tenta executar o código e captura possíveis erros.
    try {
      // Cria um objeto da classe Usuario
      // Monta um Usuario com o nome e o e-mail digitados pelo usuário.
      Usuario usuario = Usuario(nome: nome.text, email: email.text);

      // Envia os dados para o BD
      // Chama o método cadastrar do banco e espera (await) terminar.
      await banco.cadastrar(usuario);

      // Se o widget já saiu da tela (não está mais "montado"), interrompe a função.
      if (!mounted) return;

      // Apaga o texto do campo nome.
      nome.clear(); // Limpa o campo nome.
      // Apaga o texto do campo e-mail.
      email.clear(); // Limpa o campo e-mail.

      // Atualiza a tela com a mensagem de sucesso.
      setState(() {
        // Define a mensagem de sucesso.
        resultado = 'Usuário cadastrado com SUCESSO!!!';
      }); // Fim do setState.
    } catch (erro) {
      // Se ocorrer qualquer exceção no try, o código cai aqui com o erro em "erro".
      // Executo caso ocorra um exceção.
      // Mostra o erro no console de depuração.
      print('Erro as cadastrar usuário: $erro');

      // Atualiza a tela com a mensagem de falha.
      setState(() {
        // Define a mensagem de erro exibida ao usuário.
        resultado = 'Não foi possível cadastar o usuário';
      }); // Fim do setState.
    } finally {
      // O bloco finally sempre é executado, haja erro ou não.
      // Executado com ou sem exceção.
      // Mostra no console que a operação terminou.
      print('Operação de inserção finalizada!!!');
    } // Fim do try/catch/finally.
  } // Fim da função cadastrarUsuario.

  // Função assíncrona que consulta todos os usuários e mostra na tela.
  Future<void> consultarUsuarios() async {
    // Inicia o bloco que tenta executar a consulta.
    try {
      // Busca uma lista de objetos
      // Pede ao banco a lista de usuários e espera o resultado.
      List<Usuario> usuarios = await banco.lista();

      // Se a tela não está mais ativa, interrompe a função.
      if (!mounted) return;

      // Cria um texto vazio para montar o resultado.
      String texto = ''; // Armazena o resultado da consulta

      // Percorre os usuários encotrados.
      // Repete o bloco abaixo para cada usuário da lista.
      for (var usuario in usuarios) {
        // Adiciona ao texto o ID e o nome do usuário, e pula uma linha.
        texto += '${usuario.id} - ${usuario.nome}\n';
        // Adiciona o e-mail e pula duas linhas (deixa uma linha em branco).
        texto += '${usuario.email}\n\n';
      } // Fim do for.

      // Atualiza a tela com o texto montado.
      setState(() {
        // Coloca o texto final na variável exibida na tela.
        resultado = texto; // Atualiza o texto da tela.
      }); // Fim do setState.
    } catch (erro) {
      // Captura qualquer erro ocorrido durante a consulta.
      // Mostra uma mensagem no console.
      print('Operação de consulta finalizada!!!');
    } // Fim do try/catch.
  } // Fim da função consultarUsuarios.

  // Sobrescreve o método dispose da classe pai.
  @override
  // dispose é chamado quando a tela é destruída; serve para liberar recursos.
  void dispose() {
    // Libera da memória o controlador do campo nome.
    nome.dispose(); // Libera o controlador nome
    // Libera da memória o controlador do campo e-mail.
    email.dispose(); // Libera o controlador nome
    // Chama o dispose da classe pai para finalizar corretamente.
    super.dispose(); // Libera o controlador nome
  } // Fim do método dispose.

  // Altera o nome e o e-mail de um usuário
  // Função assíncrona que altera os dados de um usuário existente.
  Future<void> alterarUsuario() async {
    // Inicia o bloco que tenta executar a alteração.
    try {
      // Tenta converter o texto do ID em número inteiro; se não der, resulta em null.
      int? codigo = int.tryParse(id.text); // Conversão do ID para inteiro

      // Verifica os campos necessários
      // Se o ID for inválido, ou nome/e-mail estiverem vazios, entra no bloco.
      if (codigo == null || nome.text.isEmpty || email.text.isEmpty) {
        // Atualiza a tela com a mensagem de validação.
        setState(() {
          // Define a mensagem pedindo os dados corretos.
          resultado = 'Informe um ID válido, nome e e-mail';
        }); // Fim do setState.
        // Encerra a função sem alterar nada.
        return;
      } // Fim do if.

      // Executa a alteração no SQLite
      // Chama o método alterar do banco; retorna quantas linhas foram alteradas.
      int quantidade = await banco.alterar(codigo, nome.text, email.text);

      // Atualiza a tela conforme o resultado da alteração.
      setState(() {
        // Se pelo menos uma linha foi alterada...
        if (quantidade > 0) {
          // ...mostra mensagem de sucesso.
          resultado = 'Usuário alterado com SUCESSO!!!';
        } else {
          // Caso contrário, nenhum usuário com esse ID foi encontrado.
          resultado = 'Usuário não encontrado!!!';
        } // Fim do if/else.
      }); // Fim do setState.

      // Limpa o campo ID.
      id.clear();
      // Limpa o campo nome.
      nome.clear();
      // Limpa o campo e-mail.
      email.clear();
    } catch (erro) {
      // Captura qualquer erro ocorrido na alteração.
      // Mostra o erro no console.
      print('Erro ao alterar: $erro');

      // Atualiza a tela com a mensagem de falha.
      setState(() {
        // Define a mensagem de erro exibida ao usuário.
        resultado = 'Não foi possível alterar o usuário!!!';
      }); // Fim do setState.
    } // Fim do try/catch.
  } // Fim da função alterarUsuario.

  // Excluir um usuário do SQLite
  // Função assíncrona que exclui um usuário pelo ID.
  Future<void> excluirUsuario() async {
    // Inicia o bloco que tenta executar a exclusão.
    try {
      // Converte o texto do ID em inteiro (ou null se for inválido).
      int? codigo = int.tryParse(id.text); //Converte o ID

      // Simulação de erro
      // Se o ID digitado for 999, forçamos um erro de teste.
      if (codigo == 999) {
        // Lança uma exceção propositalmente para testar o catch.
        throw Exception('Isto é uma falha simulada!!!');
      } // Fim do if.

      // Verifica de o ID foi informado corretamente
      // Se o ID for nulo (inválido ou vazio), entra no bloco.
      if (codigo == null) {
        // Atualiza a tela com a mensagem de validação.
        setState(() {
          // Pede um ID válido ao usuário.
          resultado = 'Informe um ID válido!!!';
        }); // Fim do setState.
        // Encerra a função sem excluir nada.
        return;
      } // Fim do if.

      // Chama o método excluir do banco; retorna quantas linhas foram removidas.
      int quantidade = await banco.excluir(codigo);

      // Atualiza a tela conforme o resultado da exclusão.
      setState(() {
        // Se pelo menos uma linha foi removida...
        if (quantidade > 0) {
          // ...mostra mensagem de sucesso.
          resultado = 'Usuário excluído com sucesso!!!';
        } else {
          // Caso contrário, nenhum usuário com esse ID foi encontrado.
          resultado = 'Usuário não encontrado!!!';
        } // Fim do if/else.
      }); // Fim do setState.

      // Apaga o texto do campo ID.
      id.clear(); // Limpa somente o campo ID
    } catch (erro) {
      // Captura qualquer erro ocorrido na exclusão (inclusive o simulado).
      // Mostra o erro no console.
      print('Erro ao excluir: $erro');

      // Atualiza a tela com a mensagem de falha.
      setState(() {
        // Define a mensagem de erro exibida ao usuário.
        resultado = ('Não foi possível excluir o usuário');
      }); // Fim do setState.
    } // Fim do try/catch.
  } // Fim da função excluirUsuario.

  // Sobrescreve o método build da classe State.
  @override
  // Constrói a interface visual da tela.
  Widget build(BuildContext context) {
    // Scaffold é a estrutura básica de uma tela (barra superior, corpo etc.).
    return Scaffold(
      // Barra superior com o título da tela.
      appBar: AppBar(title: const Text('Cadastro de usuários')),

      // Corpo (conteúdo principal) da tela.
      body: Padding(
        // Espaçamento interno de 20 pixels em todos os lados.
        padding: const EdgeInsets.all(20),

        // Os elementos serão organizados em uma coluna (um abaixo do outro).
        child: Column(
          // Faz os filhos ocuparem toda a largura disponível.
          crossAxisAlignment: CrossAxisAlignment.stretch,

          // Lista de widgets que ficam dentro da coluna.
          children: [
            // Campo para digitar o ID.
            // Campo de texto para o usuário digitar.
            TextField(
              // Liga o campo ao controlador do ID.
              controller: id,
              // Exibe o teclado numérico.
              keyboardType: TextInputType.number,
              // Define a aparência do campo.
              decoration: const InputDecoration(
                // Texto de rótulo exibido no campo.
                labelText: 'ID do usuário (Alterar ou excluir)',
              ), // Fim do InputDecoration.
            ), // Fim do TextField do ID.
            // Campo para digitar o nome.
            // Campo de texto para o nome.
            TextField(
              // Liga o campo ao controlador do nome.
              controller: nome,
              // Define o rótulo do campo.
              decoration: const InputDecoration(labelText: 'Nome'),
            ), // Fim do TextField do nome.
            // Campo para digitar o e-mail.
            // Campo de texto para o e-mail.
            TextField(
              // Liga o campo ao controlador do e-mail.
              controller: email,
              // Define o rótulo do campo.
              decoration: InputDecoration(labelText: 'E-mail'),
            ), // Fim do TextField do e-mail.
            // Cria um espaço vazio vertical de 20 pixels.
            const SizedBox(height: 20),

            // Botão cadastro
            // Botão elevado (com relevo).
            ElevatedButton(
              // Ao clicar, executa a função cadastrarUsuario.
              onPressed: cadastrarUsuario,
              // Texto exibido dentro do botão.
              child: const Text('Cadastrar'),
            ), // Fim do botão Cadastrar.
            // Botão Consultar
            // Botão elevado para consultar.
            ElevatedButton(
              // Ao clicar, executa a função consultarUsuarios.
              onPressed: consultarUsuarios,
              // Texto exibido dentro do botão.
              child: const Text('Consultar usuários'),
            ), // Fim do botão Consultar.
            // Botão para alterar (Ainda sem funcionalidade)
            // Botão elevado para alterar.
            ElevatedButton(
              // Ao clicar, executa a função alterarUsuario.
              onPressed: alterarUsuario,
              // Texto exibido dentro do botão.
              child: const Text('Alterar usuário'),
            ), // Fim do botão Alterar.
            // Botão para Excluir (Ainda sem funcionalidade)
            // Botão elevado para excluir.
            ElevatedButton(
              // Ao clicar, executa a função excluirUsuario.
              onPressed: excluirUsuario,
              // Texto exibido dentro do botão.
              child: const Text('Excluir Usuário'),
            ), // Fim do botão Excluir.
            // Cria outro espaço vazio vertical de 20 pixels.
            const SizedBox(height: 20),

            // Espaço reservado para exibir os resultados
            // Expanded ocupa o espaço restante; SingleChildScrollView permite rolar o texto.
            Expanded(child: SingleChildScrollView(child: Text(resultado))),
          ], // Fim da lista de filhos da coluna.
        ), // Fim da Column.
      ), // Fim do Padding.
    ); // Fim do Scaffold.
  } // Fim do método build.
} // Fim da classe _TelaInicialState.
