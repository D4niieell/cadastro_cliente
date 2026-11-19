// banco_local.dart

// >> Importa o pacote sqflite, que permite usar o SQLite no Flutter/Dart
import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
// >> Importa o pacote path, que oferece funções como join() para montar caminhos de arquivos
import 'package:path/path.dart'; // Manipula caminho

// >> Importa o arquivo que contém a classe Usuario (modelo de dados)
import 'usuario.dart'; // Importa a classe Usuario

// >> Declara a classe responsável por todas as operações com o banco de dados local
class BancoLocal {
  // >> Atributo que guarda a conexão. O "?" indica que pode ser nulo (ainda não aberta)
  Database? banco; // Guardando a conexão com o BD

  // >> Método assíncrono que abre (ou reaproveita) o banco e devolve a conexão
  Future<Database> abrirBanco() async {
    // Reutiliza a conexão se o banco já estiver aberto.
    // >> Verifica se existe conexão e se ela ainda está aberta ("!" garante que não é nulo)
    if (banco != null && banco!.isOpen) {
      // >> Devolve a conexão existente, evitando abrir o banco novamente
      return banco!;
    }

    // >> Obtém o diretório padrão onde o sistema guarda bancos de dados; await espera o resultado
    String pasta = await getDatabasesPath(); // Pasta do banco de dados
    // >> Junta a pasta com o nome do arquivo, formando o caminho completo (cadastro.db)
    String arquivo = join(pasta, 'cadastro.db'); // Nome e local do arquivo

    // >> Abre o banco (criando o arquivo se não existir) e guarda a conexão no atributo "banco"
    banco = await openDatabase(
      // >> Primeiro parâmetro: o caminho do arquivo do banco
      arquivo, // Caminho completo do BD
      // >> Versão do banco; útil para controlar futuras migrações/atualizações da estrutura
      version: 1, // Versão Inicial do BD
      // >> Função executada apenas na primeira vez, quando o banco é criado
      onCreate: (db, version) async {
        // >> Executa o comando SQL que cria a tabela "usuarios"
        await db.execute('''CREATE TABLE usuarios (
            -- >> id: número inteiro, chave primária, gerado automaticamente a cada insert
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            -- >> nome: texto obrigatório (não aceita nulo)
            nome TEXT NOT NULL,
            -- >> email: texto obrigatório e único (não permite e-mails repetidos)
            email TEXT NOT NULL UNIQUE
          )
         ''');
      },
    );

    // >> Devolve a conexão recém-aberta ("!" afirma que não é nula neste ponto)
    return banco!; // Retorna a conexão aberta
  }

  // Cadastro de um novo usuário
  // >> Método assíncrono que recebe um objeto Usuario e o grava no banco (não retorna valor)
  Future<void> cadastrar(Usuario usuario) async {
    // >> Obtém a conexão com o banco (abrindo-a se necessário)
    final db = await abrirBanco();

    // >> Insere na tabela "usuarios"; paraMap() converte o objeto em Map (coluna: valor)
    await db.insert('usuarios', usuario.paraMap());
  }

  // Consulta todos os usuários cadastrados
  // >> Método assíncrono que devolve uma lista de objetos Usuario
  Future<List<Usuario>> lista() async {
    // >> Obtém a conexão com o banco
    final db = await abrirBanco(); // Obtém o banco

    // Consulta os registro na tabela usuários.
    // >> Equivale a "SELECT * FROM usuarios"; retorna uma lista de Maps (um por linha)
    final registros = await db.query('usuarios');

    // Cria uma lista vazia de objetos (tabela usuarios.)
    // >> Lista que receberá os objetos Usuario convertidos
    List<Usuario> usuarios = [];

    // Percorre os registros retornados pelo SQLite.
    // >> Laço que repete o bloco para cada linha retornada pela consulta
    for (var registro in registros) {
      // Converter o MAP de um objeto
      // >> doMap() transforma o Map da linha em um objeto Usuario
      Usuario usuario = Usuario.doMap(registro);

      // Adiciona o objeto na lista
      // >> Coloca o usuário convertido dentro da lista
      usuarios.add(usuario);
    }

    // >> Devolve a lista completa de usuários
    return usuarios;
  }

  // Altera o nome e o e-mail de um usuário
  // >> Recebe o id do usuário e os novos dados; retorna o nº de linhas alteradas (int)
  Future<int> alterar(int id, String nome, String email) async {
    // >> Obtém a conexão com o banco
    final db = await abrirBanco(); // Obtém o banco

    // >> Executa o UPDATE e retorna a quantidade de registros afetados
    return await db.update(
      // >> Nome da tabela onde a alteração será feita
      'usuarios', // Tabela que será alterada
      // >> Map com as colunas a atualizar e seus novos valores
      {
        // >> Atualiza a coluna nome
        'nome': nome, // Novo Nome
        // >> Atualiza a coluna email
        'email': email, // Novo e-mail
      },
      // >> Filtro do UPDATE; o "?" é substituído pelo valor de whereArgs (evita SQL Injection)
      where: 'id = ?', // Condição WHERE
      // >> Valor que substitui o "?" na condição acima
      whereArgs: [id], // Valor utilizado na condição
    );
  }

  // Exclui um usuário pelo ID
  // >> Recebe o id e retorna o nº de linhas excluídas (int)
  Future<int> excluir(int id) async {
    // >> Obtém a conexão com o banco
    final db = await abrirBanco(); // Obtém banco

    // >> Executa o DELETE e retorna a quantidade de registros removidos
    return await db.delete(
      // >> Tabela da qual o registro será removido
      'usuarios', // Tabela utilizada
      // >> Condição: apaga apenas a linha cujo id seja igual ao informado
      where: 'id = ?', // Condição WHERE
      // >> Valor que substitui o "?" na condição
      whereArgs: [id], // ID do usuário.
    );
  }

  // Pesquisa de um usuário pelo ID
  // >> Retorna um Usuario ou null (o "?" indica que pode não encontrar nada)
  Future<Usuario?> buscaPorId(int id) async {
    // Abre o BD
    // >> Obtém a conexão com o banco
    final db = await abrirBanco();

    // Consulta o registro
    // exemplo: select * from usuarios where id = ???
    // >> Faz o SELECT filtrando pelo id; o resultado é uma lista de Maps
    final registros = await db.query(
      // >> Tabela consultada
      'usuarios',
      // >> Condição: somente a linha com o id desejado
      where: 'id = ?',
      // >> Valor que substitui o "?" na condição
      whereArgs: [id],
    );

    // Verificação de encontrou algum registro
    // >> Se a lista estiver vazia, nenhum usuário tem esse id
    if (registros.isEmpty) {
      // >> Retorna null indicando que não foi encontrado
      return null;
    }

    // Converter o registro encontrado em um objeto para manipução
    // >> Pega a primeira (e única) linha e a converte em Usuario com doMap()
    return Usuario.doMap(registros.first);
  }
}
