import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
import 'package:path/path.dart'; // Manipula caminho

// Classe responsável por todas as operações com o banco de dados local
class BancoLocal {
  Database? banco; // Guardando a conexão com o BD

  // Método que abre (ou reaproveita) a conexão com o banco; é assíncrono, pois abrir o banco leva tempo
  Future<Database> abrirBanco() async {
    // Reutiliza a conexão se o banco já estiver aberto.
    if (banco != null && banco!.isOpen) {
      return banco!; // O "!" garante ao Dart que a variável não é nula neste ponto
    }

    String pasta = await getDatabasesPath(); // Pasta do banco de dados
    String arquivo = join(pasta, 'cadastro.db'); // Nome e local do arquivo

    // Abre o banco; se o arquivo não existir, ele será criado
    banco = await openDatabase(
      arquivo, // Caminho completo do BD
      version: 1, // Versão Inicial do BD
      // Executado somente na primeira vez, quando o banco é criado
      onCreate: (db, version) async {
        // Executa um comando SQL para criar a tabela de usuários
        await db.execute('''CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identificador único, gerado automaticamente
            nome TEXT NOT NULL, -- Nome do usuário, obrigatório
            email TEXT NOT NULL UNIQUE -- E-mail obrigatório e que não pode se repetir
          )
         ''');
      },
    );

    return banco!; //Retorna a conexão aberta
  }

  // Cadastro de um novo usuário
  Future<void> cadastrar(String nome, String email) async {
    final db =
        await abrirBanco(); // Obtém o banco (abre a conexão, se necessário)

    // Insere uma nova linha na tabela, usando um mapa de coluna: valor
    await db.insert('usuarios', {'nome': nome, 'email': email});
  }

  // Consulta todos os usuários cadastrados
  //Future<List<Map<String, Object?>>> listar() async {
  Future<List> listar() async {
    final db = await abrirBanco(); // Obtém o banco
    return await db.query(
      'usuarios',
    ); // Retorna todas as linhas da tabela (equivale a SELECT * FROM usuarios)
  }

  // Altera o nome e o e-mail de um usuário
  // Retorna o número de linhas que foram alteradas
  Future<int> alterar(int id, String nome, String email) async {
    final db = await abrirBanco(); // Obtém o banco

    return await db.update(
      'usuarios', // Tabela que será alterada
      {
        'nome': nome, // Novo Nome
        'email': email, // Novo e-mail
      },
      where: 'id = ?', // Condição WHERE
      whereArgs: [id], // Valor utilizado na condição
    );
  }

  // Exclui um usuário pelo ID
  // Retorna o número de linhas que foram excluídas
  Future<int> excluir(int id) async {
    final db = await abrirBanco(); // Obtém banco

    return await db.delete(
      'usuarios', // Tabela utilizada
      where: 'id = ?', // Condição WHERE
      whereArgs: [id], // ID do usuário.
    );
  }
}
