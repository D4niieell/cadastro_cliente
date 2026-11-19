// main.dart

// Importa a classe BancoLocal, responsável pelas operações no SQLite.
import 'package:cadastro_cliente/banco_local.dart';
// Importa a classe Usuario (modelo com id, nome e e-mail).
import 'package:cadastro_cliente/usuario.dart';
// Importa os widgets do Flutter no estilo Material Design.
import 'package:flutter/material.dart';
// Importa o pacote sqflite, que permite usar o SQLite no Flutter.
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
// Importa o pacote path, que ajuda a montar caminhos de arquivos.
import 'package:path/path.dart'; // Manipula caminho

// Importa a classe que valida os dados do usuário (arquivo local do projeto).
import 'validador_usuario.dart'; // Manipulo o objeto validador

// Função principal: ponto de entrada de todo app Dart/Flutter.
void main() {
  // runApp inicia o app e coloca o widget MeuAplicativo na raiz da árvore.
  runApp(const MeuAplicativo()); // Inicia o app
}

// Classe principal do APP.
// StatelessWidget: widget sem estado interno que muda ao longo do tempo.
class MeuAplicativo extends StatelessWidget {
  // Construtor constante; repassa a "key" (identificador do widget) para a classe pai.
  const MeuAplicativo({super.key});

  // Anotação indicando que o método abaixo sobrescreve o da classe pai.
  @override
  // build descreve como o widget é desenhado na tela.
  Widget build(BuildContext context) {
    // Retorna o MaterialApp, que configura o app (tema, rotas, tela inicial etc.).
    return const MaterialApp(
      // Esconde a faixa "DEBUG" no canto superior da tela.
      debugShowCheckedModeBanner: false,
      // Define qual widget será a primeira tela exibida.
      home: TelaInicial(), // Primeira tela.
    ); // Material App
  }
}

// Tela de Cadastro e consulta
// StatefulWidget: widget que possui estado mutável (a tela muda conforme o uso).
class TelaInicial extends StatefulWidget {
  // Construtor constante, repassando a key para a classe pai.
  const TelaInicial({super.key});

  // Sobrescreve o método da classe pai.
  @override
  // Cria o objeto de estado que guardará os dados e a lógica da tela.
  State<TelaInicial> createState() => _TelaInicialState();
}

// Classe de estado da tela (o "_" no início a torna privada ao arquivo).
class _TelaInicialState extends State<TelaInicial> {
  // Cria uma instância de BancoLocal para acessar o banco de dados.
  final banco = BancoLocal(); // Objeto responsável por SQLITE

  // Controlador do campo de texto do ID (lê e altera o texto digitado).
  final id = TextEditingController(); // Controla o ID
  // Controlador do campo de texto do nome.
  final nome = TextEditingController(); // Controla o campo nome
  // Controlador do campo de texto do e-mail.
  final email = TextEditingController(); // Controla o campo e-mail

  // Variável que guarda o texto mostrado na área de resultados; começa vazia.
  String resultado = ''; // Mensagem exibida na tela

  // Cadastra um usuário no SQLite
  // Método assíncrono (async) pois acessar o banco leva tempo; retorna Future<void>.
  Future<void> cadastrarUsuario() async {
    // Cria um objeto Usuario com dados da tela.
    Usuario usuario = Usuario(
      // Nome digitado, já sem espaços no início e no fim.
      nome: nome.text
          .trim(), // Remove os espaços do ínicio e do fim da variável nome
      // E-mail digitado, sem espaços externos e em letras minúsculas.
      email: email.text.trim().toLowerCase(), // Remove espaços externos e converte o email para minusculo
    );

    // Enviar o objeto para a classe responsável pela validação
    // Retornar uma mensagem de erro ou null
    // String? permite null: null significa "nenhum erro encontrado".
    String? erroValidacao = ValidadorUsario.validaUsuario(usuario);

    // Verifica de existe algum erro de validação
    // Se for diferente de null, há uma mensagem de erro.
    if (erroValidacao != null) {
      // setState avisa o Flutter que o estado mudou e a tela deve ser redesenhada.
      setState(() {
        // Guarda a mensagem de erro para ser exibida na tela.
        resultado = erroValidacao; //Exibe a mensagem de erro
      });

      // Sai do método, impedindo que o código continue.
      return; // Encerro o método sem acessar o BD
    }

    // Bloco try: tenta executar o código que pode gerar exceção.
    try {
      // Cria um objeto da classe Usuario
      // Cria outro Usuario (dentro do try), desta vez usando os textos sem tratamento (sem trim/lowercase).
      Usuario usuario = Usuario(nome: nome.text, email: email.text);

      // Envia os dados para o BD
      // await espera o cadastro no banco terminar antes de seguir.
      await banco.cadastrar(usuario);

      // Se o widget já saiu da tela (não está mais "montado"), interrompe para evitar erro.
      if (!mounted) return;

      // Esvazia o campo de nome na tela.
      nome.clear(); // Limpa o campo nome.
      // Esvazia o campo de e-mail na tela.
      email.clear(); // Limpa o campo e-mail.

      // Atualiza a tela com a mensagem de sucesso.
      setState(() {
        resultado = 'Usuário cadastrado com SUCESSO!!!';
      });
      // Captura qualquer exceção ocorrida no try; "erro" guarda o problema.
    } catch (erro) {
      // Executo caso ocorra um exceção.
      // Imprime o erro no console (útil para depuração).
      print('Erro as cadastrar usuário: $erro');

      // Atualiza a tela com a mensagem de falha.
      setState(() {
        resultado = 'Não foi possível cadastar o usuário';
      });
      // Bloco finally: roda sempre, tendo dado erro ou não.
    } finally {
      // Executado com ou sem exceção.
      // Imprime no console que a operação terminou.
      print('Operação de inserção finalizada!!!');
    }
  }

  // Lista todos os usuários cadastrados e mostra na tela.
  Future<void> consultarUsuarios() async {
    // Tenta executar a consulta.
    try {
      // Busca uma lista de objetos
      // Pede ao banco todos os usuários e espera o retorno.
      List<Usuario> usuarios = await banco.lista();

      // Se a tela não existe mais, interrompe.
      if (!mounted) return;

      // Variável de texto que acumulará todos os usuários formatados.
      String texto = ''; // Armazena o resultado da consulta

      // Percorre os usuários encotrados.
      // Laço for-in: percorre cada usuário da lista.
      for (var usuario in usuarios) {
        // Adiciona uma linha "id - nome" e quebra de linha.
        texto += '${usuario.id} - ${usuario.nome}\n';
        // Adiciona o e-mail e uma linha em branco para separar os usuários.
        texto += '${usuario.email}\n\n';
      }

      // Redesenha a tela com o texto montado.
      setState(() {
        resultado = texto; // Atualiza o texto da tela.
      });
      // Captura exceções da consulta.
    } catch (erro) {
      // Apenas imprime uma mensagem no console (não mostra erro na tela).
      print('Operação de consulta finalizada!!!');
    }
  }

  // Sobrescreve o método dispose da classe pai.
  @override
  // dispose é chamado quando a tela é destruída; serve para liberar recursos.
  void dispose() {
    // Libera a memória usada pelo controlador do nome.
    nome.dispose(); // Libera o controlador nome
    // Libera a memória usada pelo controlador do e-mail.
    email.dispose(); // Libera o controlador nome
    // Chama o dispose da classe pai para concluir a limpeza.
    super.dispose(); // Libera o controlador nome
  }

  // Altera o nome e o e-mail de um usuário
  Future<void> alterarUsuario() async {
    // Remove espaço externo e tentar converte o ID para int
    // Caso não seja possível a conversão, retorna null
    // tryParse converte texto em int; devolve null se o texto não for um número.
    int? codigo = int.tryParse(id.text.trim());

    // Valida se o ID é um número inteiro e maior que zero
    // Se for null OU se a validação do ID falhar, entra no bloco.
    if (codigo == null || !ValidadorUsario.validaId(codigo)) {
      // Atualiza a tela com a mensagem de ID inválido.
      setState(() {
        resultado = 'Informe um ID válido!!!';
      });

      // Sai do método sem alterar nada.
      return; // Encerra o método se o ID for inválido
    }

    // Cria um objeto Usuario com os novos dados
    Usuario usuario = Usuario(
      // ID do registro que será alterado.
      id: codigo, // ID do usuário que será alterado
      // Novo nome, sem espaços nas pontas.
      nome: nome.text.trim(), //Remove espaços externos
      // Novo e-mail, sem espaços e em minúsculas.
      email: email.text.trim().toLowerCase(), // Padroniza o e-mail
    );

    // Valida o nome e e-mail
    // Retorna uma mensagem de erro ou null se estiver tudo certo.
    String? erroValidacao = ValidadorUsario.validaUsuario(usuario);

    // Verifica se existe algum erro de validação
    if (erroValidacao != null) {
      // Mostra o erro na tela.
      setState(() {
        resultado = erroValidacao; // Exibe a mensagem de erro
      });
      // Sai do método sem tocar no banco.
      return; //Encerra o método sem alterar o banco
    }

    // Tenta executar a alteração no banco.
    try {
      // Executa a alteração no SQLite
      // Chama o banco passando ID, nome e e-mail; retorna quantas linhas foram alteradas.
      int quantidade = await banco.alterar(codigo, nome.text, email.text);

      // Se a tela não existe mais, interrompe.
      if (!mounted) return;

      // Atualiza a tela conforme o resultado.
      setState(() {
        // Se ao menos uma linha foi alterada, deu certo.
        if (quantidade > 0) {
          resultado = 'Usuário alterado com SUCESSO!!!';
          // Caso contrário, nenhum registro tinha esse ID.
        } else {
          resultado = 'Usuário não encontrado!!!';
        }
      });

      // Limpa o campo do ID.
      id.clear();
      // Limpa o campo do nome.
      nome.clear();
      // Limpa o campo do e-mail.
      email.clear();
      // Captura exceções da alteração.
    } catch (erro) {
      // Imprime o erro no console.
      print('Erro ao alterar: $erro');

      // Mostra mensagem de falha na tela.
      setState(() {
        resultado = 'Não foi possível alterar o usuário!!!';
      });
    }
  }

  // Excluir um usuário do SQLite
  Future<void> excluirUsuario() async {
    // Tenta executar a exclusão.
    try {
      // Converte o texto do campo ID em int (sem trim neste caso); null se inválido.
      int? codigo = int.tryParse(id.text); //Converte o ID

      // Simulação de erro
      // Se o ID digitado for 999, força uma falha de propósito (para testar o catch).
      if (codigo == 999) {
        // Lança uma exceção com uma mensagem de teste.
        throw Exception('Isto é uma falha simulada!!!');
      }

      // Verifica de o ID foi informado corretamente
      // Se a conversão falhou, o ID é inválido.
      if (codigo == null) {
        // Mostra a mensagem de ID inválido.
        setState(() {
          resultado = 'Informe um ID válido!!!';
        });
        // Sai do método.
        return;
      }

      // Pede ao banco para excluir; retorna quantas linhas foram removidas.
      int quantidade = await banco.excluir(codigo);

      // Atualiza a tela com o resultado.
      setState(() {
        // Se removeu pelo menos uma linha, deu certo.
        if (quantidade > 0) {
          resultado = 'Usuário excluído com sucesso!!!';
          // Senão, o ID não existia.
        } else {
          resultado = 'Usuário não encontrado!!!';
        }
      });

      // Limpa o campo do ID após excluir.
      id.clear(); // Limpa somente o campo ID
      // Captura qualquer exceção (inclusive a simulada com o ID 999).
    } catch (erro) {
      // Imprime o erro no console.
      print('Erro ao excluir: $erro');

      // Mostra mensagem de falha na tela.
      setState(() {
        resultado = ('Não foi possível excluir o usuário');
      });
    }
  }

  // Pesquisa de um usuário pelo ID
  Future<void> buscarUsuario() async {
    // Converter o ID digitado para inteiro
    // Converte o texto (sem espaços externos) para int; null se não for número.
    int? codigo = int.tryParse(id.text.trim());

    // Se a validação do ID falhar, entra no bloco.
    if (!ValidadorUsario.validaId(codigo)) {
      // Mostra a mensagem de ID inválido.
      setState(() {
        resultado = 'Informe um ID válido!!!';
      });
      // Sai do método.
      return;
    }

    // Tenta executar a busca.
    try {
      // Consulta o usuário no SQLite
      // O "!" garante ao Dart que codigo não é null (já foi validado acima). Retorna null se não achar.
      Usuario? usuario = await banco.buscaPorId(codigo!);

      // Se a tela não existe mais, interrompe.
      if (!mounted) return;

      // Verifica se encontrou o resultado
      // null significa que nenhum usuário tem esse ID.
      if (usuario == null) {
        // Mostra a mensagem de não encontrado.
        setState(() {
          resultado = 'Usuário não encontrado!!!';
        });
        // Sai do método.
        return;
      }

      // Exibe os dados do usuário encontrado
      setState(() {
        // Monta o texto "id - nome" + quebra de linha + e-mail (strings adjacentes são concatenadas).
        resultado =
            '${usuario.id} - ${usuario.nome}\n'
            '${usuario.email}';
      });
      // Captura exceções da busca.
    } catch (erro) {
      // Se a tela não existe mais, interrompe.
      if (!mounted) return;

      // Mostra mensagem de falha na tela.
      setState(() {
        resultado = 'Não foi possível buscar o ID';
      });
      // Sempre executa ao final, com ou sem erro.
    } finally {
      // Imprime no console que a pesquisa terminou.
      print('Operação de pesquisa finalizada');
    }
  }

  // Sobrescreve o build da classe State.
  @override
  // Constrói a interface da tela.
  Widget build(BuildContext context) {
    // Scaffold: estrutura básica de uma tela Material (barra superior, corpo etc.).
    return Scaffold(
      // Barra superior com o título da tela.
      appBar: AppBar(title: const Text('Cadastro de usuários')),

      // Corpo (conteúdo principal) da tela.
      body: Padding(
        // Margem interna de 20 pixels em todos os lados.
        padding: const EdgeInsets.all(20),

        // Column organiza os filhos na vertical.
        child: Column(
          // Faz os filhos ocuparem toda a largura disponível.
          crossAxisAlignment: CrossAxisAlignment.stretch,

          // Lista de widgets exibidos dentro da coluna.
          children: [
            // Campo para digitar o ID.
            TextField(
              // Liga o campo ao controlador do ID.
              controller: id,
              // Abre o teclado numérico.
              keyboardType: TextInputType.number,
              // Define o visual do campo.
              decoration: const InputDecoration(
                // Texto de rótulo exibido no campo.
                labelText: 'ID do usuário (Alterar ou excluir)',
              ),
            ),

            // Campo para digitar o nome.
            TextField(
              // Liga o campo ao controlador do nome.
              controller: nome,
              // Rótulo do campo.
              decoration: const InputDecoration(labelText: 'Nome'),
            ),

            // Campo para digitar o e-mail.
            TextField(
              // Liga o campo ao controlador do e-mail.
              controller: email,
              // Rótulo do campo.
              decoration: InputDecoration(labelText: 'E-mail'),
            ),

            // Espaço vertical vazio de 20 pixels entre os campos e os botões.
            const SizedBox(height: 20),

            // Botão cadastro
            ElevatedButton(
              // Ao clicar, chama o método de cadastro.
              onPressed: cadastrarUsuario,
              // Texto exibido no botão.
              child: const Text('Cadastrar'),
            ),

            // Botão Consultar
            ElevatedButton(
              // Ao clicar, chama o método que lista os usuários.
              onPressed: consultarUsuarios,
              // Texto do botão.
              child: const Text('Consultar usuários'),
            ),

            // Botão para alterar (Ainda sem funcionalidade)
            ElevatedButton(
              // Ao clicar, chama o método de alteração.
              onPressed: alterarUsuario,
              // Texto do botão.
              child: const Text('Alterar usuário'),
            ),

            // Botão para Excluir (Ainda sem funcionalidade)
            ElevatedButton(
              // Ao clicar, chama o método de exclusão.
              onPressed: excluirUsuario,
              // Texto do botão.
              child: const Text('Excluir Usuário'),
            ),

            // Botão para Excluir (Ainda sem funcionalidade)
            ElevatedButton(
              // Ao clicar, chama o método de busca por ID.
              onPressed: buscarUsuario,
              // Texto do botão.
              child: const Text('Busca por ID'),
            ),

            // Outro espaço vertical de 20 pixels antes da área de resultados.
            const SizedBox(height: 20),

            // Espaço reservado para exibir os resultados
            // Expanded ocupa o espaço restante; SingleChildScrollView permite rolar o texto longo.
            Expanded(child: SingleChildScrollView(child: Text(resultado))),
          ],
        ),
      ),
    );
  }
}
