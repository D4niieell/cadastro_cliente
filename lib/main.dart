// >> Importa a classe BancoLocal, que contém os métodos de acesso ao SQLite (cadastrar, listar, alterar, excluir).
import 'package:cadastro_cliente/banco_local.dart';
// >> Importa a classe Usuario, que representa um usuário (id, nome, e-mail).
import 'package:cadastro_cliente/usuario.dart';
// >> Importa o pacote Material do Flutter, com widgets prontos (Scaffold, TextField, botões etc.).
import 'package:flutter/material.dart';
// >> Importa o pacote sqflite, que permite usar o banco SQLite no Flutter.
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
// >> Importa o pacote path, que ajuda a montar caminhos de arquivos (ex.: onde fica o arquivo do banco).
import 'package:path/path.dart'; // Manipula caminho

// >> Importa a classe ValidadorUsario, responsável por validar nome, e-mail e ID.
import 'validador_usuario.dart'; // Manipula o objeto validador

// >> Função principal: é o ponto de entrada de todo app Dart/Flutter.
void main() {
  // >> runApp infla o widget informado e o coloca na tela. Aqui, inicia o widget MeuAplicativo.
  runApp(const MeuAplicativo()); // Inicia o app
}

// Classe principal do APP.
// >> StatelessWidget: widget sem estado, ou seja, não muda depois de construído.
class MeuAplicativo extends StatelessWidget {
  // >> Construtor constante; "super.key" repassa a chave (key) ao widget pai.
  const MeuAplicativo({super.key});

  // >> Indica que este método sobrescreve o método build da classe pai.
  @override
  // >> build descreve como o widget é desenhado; recebe o contexto (posição do widget na árvore).
  Widget build(BuildContext context) {
    // >> Retorna o MaterialApp, widget raiz que configura tema, navegação e telas do app.
    return const MaterialApp(
      // >> Remove a faixa vermelha "DEBUG" do canto da tela.
      debugShowCheckedModeBanner: false,
      // >> Define qual widget será a tela inicial do app.
      home: TelaInicial(), // Primeira tela.
    ); // Material App
  }
}

// Tela de Cadastro e consulta
// >> StatefulWidget: widget COM estado, ou seja, a tela pode ser redesenhada quando os dados mudam.
class TelaInicial extends StatefulWidget {
  // >> Construtor constante da tela.
  const TelaInicial({super.key});

  // >> Indica sobrescrita do método da classe pai.
  @override
  // >> Cria o objeto de estado (_TelaInicialState) que guarda os dados e a lógica da tela.
  State<TelaInicial> createState() => _TelaInicialState();
}

// >> Classe de estado da tela; o "_" no início a torna privada ao arquivo.
class _TelaInicialState extends State<TelaInicial> {
  // >> Cria o objeto que faz a comunicação com o banco SQLite.
  final banco = BancoLocal(); // Objeto responsável por SQLite

  // >> Controlador do campo de texto do ID: permite ler/limpar o que foi digitado.
  final id = TextEditingController(); // Controla o ID
  // >> Controlador do campo de texto do nome.
  final nome = TextEditingController(); // Controla o campo nome
  // >> Controlador do campo de texto do e-mail.
  final email = TextEditingController(); // Controla o campo e-mail

  // >> Variável de texto que guarda a mensagem/resultado mostrada na parte de baixo da tela.
  String resultado = ''; // Mensagem exibida na tela

  // Cadastra um usuário no SQLite
  // >> Método assíncrono (async): pode aguardar (await) operações demoradas, como acessar o banco.
  Future<void> cadastrarUsuario() async {
    // Cria um objeto Usuario com dados da tela.
    // >> Declara a variável "usuario" e cria um objeto Usuario com o texto digitado.
    Usuario usuario = Usuario(
      // >> Nome digitado, com espaços do início e do fim removidos.
      nome: nome.text
          .trim(), // Remove os espaços do ínicio e do fim da variável nome
      // >> E-mail digitado, com espaços do início e do fim removidos.
      email: email.text
          .trim(), // Remove espaços externos e converte o email para minusculo
    );

    // Enviar o objeto para a classe responsável pela validação
    // Retornar uma mensagem de erro ou null
    // >> Chama o validador; retorna um texto de erro (String) ou null se estiver tudo certo.
    String? erroValidacao = ValidadorUsario.validaUsuario(usuario);

    // Verifica de existe algum erro de validação
    // >> Se for diferente de null, existe um erro.
    if (erroValidacao != null) {
      // >> setState avisa o Flutter que os dados mudaram e a tela deve ser redesenhada.
      setState(() {
        // >> Guarda a mensagem de erro para ser exibida na tela.
        resultado = erroValidacao; // Exibe a mensagem de erro
      });

      // >> Sai do método imediatamente, sem tentar gravar no banco.
      return; // Encerra o método sem acessar o BD
    }

    // >> Inicia um bloco try: tenta executar o código; se ocorrer exceção, vai para o catch.
    try {
      // Cria um objeto da classe Usuario
      // >> Cria outro objeto Usuario (dentro do try) usando os textos dos campos.
      Usuario usuario = Usuario(nome: nome.text, email: email.text);

      // Envia os dados para o BD
      // >> Chama o método cadastrar do banco e AGUARDA (await) a gravação terminar.
      await banco.cadastrar(usuario);

      // >> Se a tela já foi removida da árvore (não está "mounted"), interrompe para evitar erro.
      if (!mounted) return;

      // >> Apaga o texto do campo nome.
      nome.clear(); // Limpa o campo nome.
      // >> Apaga o texto do campo e-mail.
      email.clear(); // Limpa o campo e-mail.

      // >> Atualiza a tela com a mensagem de sucesso.
      setState(() {
        // >> Define o texto de sucesso.
        resultado = 'Usuário cadastrado com SUCESSO!!!';
      });
      // >> Captura qualquer exceção ocorrida no try; "erro" guarda o problema.
    } catch (erro) {
      // Executo caso ocorra um exceção.
      // >> Mostra o erro no console (útil para depuração).
      print('Erro as cadastrar usuário: $erro');

      // >> Atualiza a tela com mensagem de falha.
      setState(() {
        // >> Define a mensagem de erro amigável para o usuário.
        resultado = 'Não foi possível cadastar o usuário';
      });
      // >> O bloco finally sempre executa, com ou sem erro.
    } finally {
      // Executado com ou sem exceção.
      // >> Mensagem no console indicando que a operação terminou.
      print('Operação de inserção finalizada!!!');
    }
  }

  // >> Método assíncrono que busca todos os usuários do banco e mostra na tela.
  Future<void> consultarUsuarios() async {
    // >> Inicia o bloco de tentativa.
    try {
      // Busca uma lista de objetos
      // >> Chama banco.lista() e aguarda; o resultado é uma lista de objetos Usuario.
      List<Usuario> usuarios = await banco.lista();

      // >> Se a tela não existe mais, interrompe o método.
      if (!mounted) return;

      // >> Texto vazio que será montado com os dados de cada usuário.
      String texto = ''; // Armazena o resultado da consulta

      // Percorre os usuários encotrados.
      // >> Laço for-each: repete o bloco para cada usuário da lista.
      for (var usuario in usuarios) {
        // >> Adiciona uma linha com "ID - Nome" e quebra de linha (\n).
        texto += '${usuario.id} - ${usuario.nome}\n';
        // >> Adiciona o e-mail e duas quebras de linha (deixa uma linha em branco entre usuários).
        texto += '${usuario.email}\n\n';
      }

      // >> Atualiza a tela com o texto montado.
      setState(() {
        // >> Coloca o texto da consulta na variável exibida na tela.
        resultado = texto; // Atualiza o texto da tela.
      });
      // >> Captura exceções durante a consulta.
    } catch (erro) {
      // >> Apenas imprime uma mensagem no console (não mostra o erro real nem avisa o usuário).
      print('Operação de consulta finalizada!!!');
    }
  }

  // >> Indica sobrescrita do método dispose da classe State.
  @override
  // >> dispose é chamado quando a tela é destruída; serve para liberar recursos da memória.
  void dispose() {
    // >> Libera da memória o controlador do nome.
    nome.dispose(); // Libera o controlador nome
    // >> Libera da memória o controlador do e-mail.
    email.dispose(); // Libera o controlador nome
    // >> Chama o dispose da classe pai para concluir a limpeza.
    super.dispose(); // Libera o controlador nome
  }

  // Altera o nome e o e-mail de um usuário
  // >> Método assíncrono que atualiza nome e e-mail de um usuário existente.
  Future<void> alterarUsuario() async {
    // Remove espaço externo e tentar converte o ID para int
    // Caso não seja possível a conversão, retorna null
    // >> tryParse converte texto em inteiro; devolve null se o texto não for um número válido.
    int? codigo = int.tryParse(id.text.trim());

    // Valida se o ID é um número inteiro e maior que zero
    // >> Se a conversão falhou (null) OU o validador reprovou o ID, entra no if.
    if (codigo == null || !ValidadorUsario.validaId(codigo)) {
      // >> Atualiza a tela.
      setState(() {
        // >> Limpa a mensagem (fica vazia, sem informar o motivo ao usuário).
        resultado = '';
      });

      // >> Sai do método, pois o ID é inválido.
      return; // Encerra o método se o ID for inválido
    }

    // Cria um objeto Usuario com os novos dados
    // >> Monta um objeto Usuario com id, nome e e-mail atualizados.
    Usuario usuario = Usuario(
      // >> ID do usuário que será alterado.
      id: codigo, // ID do usuario que será alterado
      // >> Nome sem espaços nas pontas.
      nome: nome.text.trim(), // Remove espaços externos
      // >> E-mail sem espaços nas pontas e em letras minúsculas.
      email: email.text.trim().toLowerCase(), // Padroniza o e-mail
    );

    // Valida o nome e e-mail
    // >> Executa a validação do objeto; retorna mensagem de erro ou null.
    String? erroValidacao = ValidadorUsario.validaUsuario(usuario);

    // Verifica se existe algum erro de validação
    // >> Se houver erro, entra no if.
    if (erroValidacao != null) {
      // >> Atualiza a tela.
      setState(() {
        // >> Exibe a mensagem de erro de validação.
        resultado = erroValidacao; // Exibe a mensagem de erro
      });
      // >> Sai do método sem alterar nada no banco.
      return; // Encerra o método sem alterar o banco
    }

    // >> Inicia o bloco de tentativa.
    try {
      // Executa a alteração no SQLite
      // >> Converte o ID novamente (aqui sem trim) e cria uma nova variável "codigo" local ao try.
      int? codigo = int.tryParse(id.text); // Conversão do ID para inteiro

      // Verifica os campos necessários
      // >> Verifica se o ID é nulo ou se nome/e-mail estão vazios.
      if (codigo == null || nome.text.isEmpty || email.text.isEmpty) {
        // >> Atualiza a tela.
        setState(() {
          // >> Mensagem pedindo para preencher os campos corretamente.
          resultado = 'Informe um ID válido, nome e e-mail';
        });
        // >> Sai do método.
        return;
      }

      // Executa a alteração no SQLite
      // >> Chama banco.alterar e guarda quantas linhas foram alteradas (0 = ninguém encontrado).
      int quantidade = await banco.alterar(codigo, nome.text, email.text);

      // >> Atualiza a tela com o resultado da alteração.
      setState(() {
        // >> Se pelo menos uma linha foi alterada...
        if (quantidade > 0) {
          // >> ...mostra mensagem de sucesso.
          resultado = 'Usuário alterado com SUCESSO!!!';
          // >> Caso contrário...
        } else {
          // >> ...informa que o ID não existe no banco.
          resultado = 'Usuário não encontrado!!!';
        }
      });

      // >> Limpa o campo ID.
      id.clear();
      // >> Limpa o campo nome.
      nome.clear();
      // >> Limpa o campo e-mail.
      email.clear();
      // >> Captura exceções ocorridas durante a alteração.
    } catch (erro) {
      // >> Mostra o erro no console.
      print('Erro ao alterar: $erro');

      // >> Atualiza a tela com mensagem de falha.
      setState(() {
        // >> Mensagem de erro para o usuário.
        resultado = 'Não foi possível alterar o usuário!!!';
      });
    }
  }

  // Excluir um usuário do SQLite
  // >> Método assíncrono que remove um usuário pelo ID.
  Future<void> excluirUsuario() async {
    // >> Inicia o bloco de tentativa.
    try {
      // >> Converte o texto do ID em inteiro (ou null se for inválido).
      int? codigo = int.tryParse(id.text); // Converte o ID

      // Simulação de erro
      // >> Se o ID digitado for 999, força um erro de propósito (para testar o catch).
      if (codigo == 999) {
        // >> Lança uma exceção manualmente; o fluxo pula para o catch.
        throw Exception('Isto é uma falha simulada!!!');
      }

      // Verifica de o ID foi informado corretamente
      // >> Se o ID é nulo (campo vazio ou texto inválido), entra no if.
      if (codigo == null) {
        // >> Atualiza a tela.
        setState(() {
          // >> Pede um ID válido.
          resultado = 'Informe um ID válido!!!';
        });
        // >> Sai do método.
        return;
      }

      // >> Chama banco.excluir e guarda quantas linhas foram apagadas.
      int quantidade = await banco.excluir(codigo);

      // >> Atualiza a tela com o resultado.
      setState(() {
        // >> Se alguma linha foi excluída...
        if (quantidade > 0) {
          // >> ...mostra mensagem de sucesso.
          resultado = 'Usuário excluído com sucesso!!!';
          // >> Caso contrário...
        } else {
          // >> ...informa que o usuário não existe.
          resultado = 'Usuário não encontrado!!!';
        }
      });

      // >> Limpa apenas o campo ID.
      id.clear(); // Limpa somente o campo ID
      // >> Captura exceções (inclusive a simulada).
    } catch (erro) {
      // >> Mostra o erro no console.
      print('Erro ao excluir: $erro');

      // >> Atualiza a tela com mensagem de falha.
      setState(() {
        // >> Mensagem de erro para o usuário (os parênteses são opcionais).
        resultado = ('Não foi possível excluir o usuário');
      });
    }
  }

  // >> Sobrescreve o método build da classe State.
  @override
  // >> Constrói a interface visual da tela; é chamado novamente a cada setState.
  Widget build(BuildContext context) {
    // >> Scaffold: estrutura básica de uma tela Material (barra superior, corpo etc.).
    return Scaffold(
      // >> Barra superior com o título da tela.
      appBar: AppBar(title: const Text('Cadastro de usuários')),

      // >> Corpo principal da tela.
      body: Padding(
        // >> Margem interna de 20 pixels em todos os lados.
        padding: const EdgeInsets.all(20),

        // >> Coluna: organiza os widgets filhos um abaixo do outro.
        child: Column(
          // >> Faz os filhos ocuparem toda a largura disponível.
          crossAxisAlignment: CrossAxisAlignment.stretch,

          // >> Lista de widgets que compõem a coluna.
          children: [
            // Campo para digitar o ID.
            // >> Campo de texto do ID.
            TextField(
              // >> Liga o campo ao controlador "id".
              controller: id,
              // >> Abre o teclado numérico.
              keyboardType: TextInputType.number,
              // >> Define a aparência do campo.
              decoration: const InputDecoration(
                // >> Rótulo exibido sobre o campo.
                labelText: 'ID do usuário (Alterar ou excluir)',
              ),
            ),

            // Campo para digitar o nome.
            // >> Campo de texto do nome.
            TextField(
              // >> Liga o campo ao controlador "nome" e define o rótulo "Nome".
              controller: nome,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),

            // Campo para digitar o e-mail.
            // >> Campo de texto do e-mail.
            TextField(
              // >> Liga o campo ao controlador "email".
              controller: email,
              // >> Define o rótulo "E-mail" (aqui sem const, mas funciona igual).
              decoration: InputDecoration(labelText: 'E-mail'),
            ),

            // >> Espaço vazio de 20 pixels de altura entre os campos e os botões.
            const SizedBox(height: 20),

            // Botão cadastro
            // >> Botão elevado (com relevo).
            ElevatedButton(
              // >> Ao tocar, executa o método cadastrarUsuario.
              onPressed: cadastrarUsuario,
              // >> Texto exibido dentro do botão.
              child: const Text('Cadastrar'),
            ),

            // Botão Consultar
            // >> Botão para listar os usuários.
            ElevatedButton(
              // >> Ao tocar, executa consultarUsuarios.
              onPressed: consultarUsuarios,
              // >> Texto do botão.
              child: const Text('Consultar usuários'),
            ),

            // Botão para alterar (Ainda sem funcionalidade)
            // >> Botão para alterar um usuário.
            ElevatedButton(
              // >> Ao tocar, executa alterarUsuario.
              onPressed: alterarUsuario,
              // >> Texto do botão.
              child: const Text('Alterar usuário'),
            ),

            // Botão para Excluir (Ainda sem funcionalidade)
            // >> Botão para excluir um usuário.
            ElevatedButton(
              // >> Ao tocar, executa excluirUsuario.
              onPressed: excluirUsuario,
              // >> Texto do botão.
              child: const Text('Excluir Usuário'),
            ),

            // >> Outro espaço de 20 pixels antes da área de resultados.
            const SizedBox(height: 20),

            // Espaço reservado para exibir os resultados
            // >> Expanded ocupa todo o espaço restante; SingleChildScrollView permite rolar o texto se for longo; Text exibe a variável "resultado".
            Expanded(child: SingleChildScrollView(child: Text(resultado))),
          ],
        ),
      ),
    );
  }
}
