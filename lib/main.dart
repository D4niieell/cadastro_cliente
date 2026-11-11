import 'package:cadastro_cliente/banco_local.dart'; // Importa a classe que gerencia o banco de dados local
import 'package:cadastro_cliente/usuario.dart'; // Importa o modelo (classe) de usuário
import 'package:flutter/material.dart'; // Importa os widgets do Material Design do Flutter
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
import 'package:path/path.dart'; // Manipula caminho

void main() {
  // Função principal, ponto de entrada do programa
  runApp(const MeuAplicativo()); // Inicia o app
}

// Classe principal do APP.
class MeuAplicativo extends StatelessWidget {
  // Widget sem estado (não muda após construído)
  const MeuAplicativo({
    super.key,
  }); // Construtor constante; repassa a chave (key) para a classe pai

  @override // Indica que estamos sobrescrevendo um método da classe pai
  Widget build(BuildContext context) {
    // Método que constrói a interface do widget
    return const MaterialApp(
      // Widget raiz que configura o app com Material Design
      debugShowCheckedModeBanner:
          false, // Remove a faixa "DEBUG" do canto da tela
      home: TelaInicial(), // Primeira tela.
    ); // Material App
  }
}

// Tela de Cadastro e consulta
class TelaInicial extends StatefulWidget {
  // Widget com estado (a tela muda conforme a interação)
  const TelaInicial({super.key}); // Construtor constante com chave

  @override // Sobrescreve método da classe pai
  State<TelaInicial> createState() => _TelaInicialState(); // Cria o objeto de estado associado a esta tela
}

class _TelaInicialState extends State<TelaInicial> {
  // Classe de estado: guarda os dados e a lógica da tela (o "_" a torna privada)
  final banco = BancoLocal(); // Objeto responsável por SQLITE

  final id = TextEditingController(); // Controla o ID
  final nome = TextEditingController(); // Controla o campo nome
  final email = TextEditingController(); // Controla o campo e-mail

  String resultado = ''; // Mensagem exibida na tela

  // Cadastra um usuário no SQLite
  Future<void> cadastrarUsuario() async {
    // Método assíncrono que não retorna valor
    // Valida se os campos foram preenchidos
    if (nome.text.isEmpty || email.text.isEmpty) {
      // Verifica se nome ou e-mail estão vazios
      setState(() {
        // Avisa o Flutter que o estado mudou, para redesenhar a tela
        resultado = 'Preencha todos os Campos!!!'; // Define a mensagem de erro de validação
      });
      return; // Interrompe a execução do método
    }

    try {
      // Inicia o bloco que pode gerar exceções
      // Envia os dados para o BD
      await banco.cadastrar(
        nome.text,
        email.text,
      ); // Chama o método de cadastro e aguarda concluir

      nome.clear(); // Limpa o campo nome.
      email.clear(); // Limpa o campo e-mail.

      setState(() {
        // Atualiza a tela
        resultado =
            'Usuário cadastrado com SUCESSO!!!'; // Define a mensagem de sucesso
      });
    } catch (erro) {
      // Captura qualquer erro ocorrido no bloco try
      // Executo caso ocorra um exceção.
      print(
        'Erro as cadastrar usuário: $erro',
      ); // Exibe o erro no console de depuração

      setState(() {
        // Atualiza a tela
        resultado =
            'Não foi possível cadastar o usuário'; // Define a mensagem de falha
      });
    } finally {
      // Bloco que sempre é executado
      // Executando com ou sem exceção
      print(
        'Operação de inserção finalizada!!!',
      ); // Mostra no console que a operação terminou
    }
  }

  Future<void> consultarUsuarios() async {
    // Método assíncrono que consulta os usuários
    final usuarios = await banco.listar(); // Busca os registros no BD

    try {
      // Inicia o bloco que pode gerar exceções
      String texto = ''; // Armazena o resultado da consulta

      // Percorre os usuários encotrados.
      for (var usuario in usuarios) {
        // Repete o código para cada usuário da lista
        texto += '${usuario['id']} - ${usuario['nome']}\n'; // Adiciona o ID e o nome, com quebra de linha
        texto += '${usuario['email']}\n\n'; // Adiciona o e-mail, com uma linha em branco depois
      }

      setState(() {
        // Atualiza a tela
        resultado = texto; // Atualiza o texto da tela.
      });
    } catch (erro) {
      // Captura qualquer erro ocorrido no bloco try
      print(
        'Operação de consulta finalizada!!!',
      ); // Mostra uma mensagem no console
    }
  }

  @override // Sobrescreve método da classe pai
  void dispose() {
    // Chamado quando a tela é destruída
    nome.dispose(); // Libera o controlador nome
    email.dispose(); // Libera o controlador nome
    super.dispose(); // Libera o controlador nome
  }

  // Altera o nome e o e-mail de um usuário
  Future<void> alterarUsuario() async {
    // Método assíncrono para alterar um usuário
    try {
      // Inicia o bloco que pode gerar exceções
      int? codigo = int.tryParse(id.text); // Conversão do ID para inteiro

      // Verifica os campos necessários
      if (codigo == null || nome.text.isEmpty || email.text.isEmpty) {
        // Checa se o ID é inválido ou se falta nome/e-mail
        setState(() {
          // Atualiza a tela
          resultado = 'Informe um ID válido, nome e e-mail'; // Define a mensagem de erro
        });
        return; // Interrompe a execução do método
      }

      // Executa a alteração no SQLite
      int quantidade = await banco.alterar(
        codigo,
        nome.text,
        email.text,
      ); // Altera o registro e recebe quantas linhas foram afetadas

      setState(() {
        // Atualiza a tela
        if (quantidade > 0) {
          // Se ao menos uma linha foi alterada
          resultado = 'Usuário alterado com SUCESSO!!!'; // Mensagem de sucesso
        } else {
          // Caso nenhuma linha tenha sido alterada
          resultado = 'Usuário não encontrado!!!'; // Mensagem informando que o ID não existe
        }
      });

      id.clear(); // Limpa o campo ID
      nome.clear(); // Limpa o campo nome
      email.clear(); // Limpa o campo e-mail
    } catch (erro) {
      // Captura qualquer erro ocorrido no bloco try
      print('Erro ao alterar: $erro'); // Exibe o erro no console de depuração

      setState(() {
        // Atualiza a tela
        resultado = 'Não foi possível alterar o usuário!!!'; // Define a mensagem de falha
      });
    }
  }

  // Excluir um usuário do SQLite
  Future<void> excluirUsuario() async {
    // Método assíncrono para excluir um usuário
    try {
      // Inicia o bloco que pode gerar exceções
      int? codigo = int.tryParse(id.text); // Converte o ID

      // Simulação de erro
      if (codigo == 999) {
        // Se o ID digitado for 999
        throw Exception(
          'Isto é uma falha simulada!!!',
        ); // Lança uma exceção propositalmente para testar o catch
      }

      // Verifica de o ID foi informado corretamente
      if (codigo == null) {
        // Se a conversão falhou (campo vazio ou não numérico)
        setState(() {
          // Atualiza a tela
          resultado = 'Informe um ID válido!!!'; // Define a mensagem de erro
        });
        return; // Interrompe a execução do método
      }

      int quantidade = await banco.excluir(
        codigo,
      ); // Exclui o registro e recebe quantas linhas foram afetadas

      setState(() {
        // Atualiza a tela
        if (quantidade > 0) {
          // Se ao menos uma linha foi excluída
          resultado = 'Usuário excluído com sucesso!!!'; // Mensagem de sucesso
        } else {
          // Caso nenhuma linha tenha sido excluída
          resultado = 'Usuário não encontrado!!!'; // Mensagem informando que o ID não existe
        }
      });

      id.clear(); // Limpa somente o campo ID
    } catch (erro) {
      // Captura qualquer erro ocorrido no bloco try
      print('Erro ao excluir: $erro'); // Exibe o erro no console de depuração

      setState(() {
        // Atualiza a tela
        resultado = ('Não foi possível excluir o usuário'); // Define a mensagem de falha
      });
    }
  }

  @override // Sobrescreve método da classe pai
  Widget build(BuildContext context) {
    // Constrói a interface da tela
    return Scaffold(
      // Estrutura básica de uma tela Material (barra superior, corpo, etc.)
      appBar: AppBar(
        title: const Text('Cadastro de usuários'),
      ), // Barra superior com o título da tela

      body: Padding(
        // Corpo da tela, com espaçamento interno
        padding: const EdgeInsets.all(
          20,
        ), // Margem de 20 pixels em todos os lados

        child: Column(
          // Organiza os widgets filhos na vertical
          crossAxisAlignment: CrossAxisAlignment
              .stretch, // Faz os filhos ocuparem toda a largura disponível

          children: [
            // Lista de widgets exibidos na coluna
            // Campo para digitar o ID.
            TextField(
              // Campo de entrada de texto
              controller: id, // Liga o campo ao controlador do ID
              keyboardType: TextInputType.number, // Exibe o teclado numérico
              decoration: const InputDecoration(
                // Define a aparência do campo
                labelText: 'ID do usuário (Alterar ou excluir)', // Rótulo exibido no campo
              ),
            ),

            // Campo para digitar o nome.
            TextField(
              // Campo de entrada de texto
              controller: nome, // Liga o campo ao controlador do nome
              decoration: const InputDecoration(
                labelText: 'Nome',
              ), // Define o rótulo "Nome"
            ),

            // Campo para digitar o e-mail.
            TextField(
              // Campo de entrada de texto
              controller: email, // Liga o campo ao controlador do e-mail
              decoration: InputDecoration(
                labelText: 'E-mail',
              ), // Define o rótulo "E-mail"
            ),

            const SizedBox(
              height: 20,
            ), // Espaço vertical de 20 pixels entre os widgets
            // Botão cadastro
            ElevatedButton(
              // Botão com elevação (destaque)
              onPressed:
                  cadastrarUsuario, // Ao clicar, executa o método de cadastro
              child: const Text('Cadastrar'), // Texto exibido no botão
            ),

            // Botão Consultar
            ElevatedButton(
              // Botão com elevação (destaque)
              onPressed:
                  consultarUsuarios, // Ao clicar, executa o método de consulta
              child: const Text('Consultar usuários'), // Texto exibido no botão
            ),

            // Botão para alterar (Ainda sem funcionalidade)
            ElevatedButton(
              // Botão com elevação (destaque)
              onPressed:
                  alterarUsuario, // Ao clicar, executa o método de alteração
              child: const Text('Alterar usuário'), // Texto exibido no botão
            ),

            // Botão para Excluir (Ainda sem funcionalidade)
            ElevatedButton(
              // Botão com elevação (destaque)
              onPressed:
                  excluirUsuario, // Ao clicar, executa o método de exclusão
              child: const Text('Excluir Usuário'), // Texto exibido no botão
            ),

            const SizedBox(
              height: 20,
            ), // Espaço vertical de 20 pixels entre os widgets
            // Espaço reservado para exibir os resultados
            Expanded(
              child: SingleChildScrollView(child: Text(resultado)),
            ), // Ocupa o espaço restante e permite rolar o texto do resultado
          ],
        ),
      ),
    );
  }
}
