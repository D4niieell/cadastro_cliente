import 'package:sqflite/sqflite.dart'; // Biblioteca do SQLite
import 'package:path/path.dart'; // Manipula caminho

import 'usuario.dart'; // Importa a classe Usuario

// Declara a classe responsável por gerenciar o banco de dados local
class BancoLocal {
  Database?
  banco; // Guardando a conexão com o BD (pode ser nula, por isso o "?")

  // Método assíncrono que abre (ou reutiliza) a conexão com o banco e a retorna
  Future<Database> abrirBanco() async {
    // Reutiliza a conexão se o banco já estiver aberto.
    // Verifica se a variável não é nula E se a conexão ainda está aberta
    if (banco != null && banco!.isOpen) {
      // Retorna a conexão existente ("!" garante ao Dart que não é nula)
      return banco!;
    } // Fim do if

    // Busca o diretório padrão onde o sqflite guarda os bancos no dispositivo
    String pasta = await getDatabasesPath(); // Pasta do banco de dados
    // Junta a pasta com o nome do arquivo, formando o caminho completo
    String arquivo = join(pasta, 'cadastro.db'); // Nome e local do arquivo

    // Abre o banco (cria o arquivo se não existir) e guarda a conexão na variável
    banco = await openDatabase(
      arquivo, // Caminho completo do BD
      version: 1, // Versão Inicial do BD
      // Função executada apenas na primeira vez, quando o banco é criado
      onCreate: (db, version) async {
        // Executa o comando SQL que cria a tabela de usuários
        await db.execute('''CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
          )
         ''');
        // Explicação do SQL acima:
        // id: número inteiro, chave primária, gerado automaticamente a cada novo registro
        // nome: texto, obrigatório (NOT NULL)
        // email: texto, obrigatório e não pode se repetir (UNIQUE)
      }, // Fim do onCreate
    ); // Fim do openDatabase

    return banco!; //Retorna a conexão aberta
  } // Fim do método abrirBanco

  // Cadastro de um novo usuário
  // Recebe um objeto Usuario e não retorna valor (Future<void>)
  Future<void> cadastrar(Usuario usuario) async {
    // Obtém a conexão com o banco (abrindo-a se necessário)
    final db = await abrirBanco();

    // Insere na tabela 'usuarios' o objeto convertido em Map (coluna: valor)
    await db.insert('usuarios', usuario.paraMap());
  } // Fim do método cadastrar

  // Consulta todos os usuários cadastrados
  // Retorna uma lista de objetos Usuario
  Future<List<Usuario>> lista() async {
    final db = await abrirBanco(); // Obtém o banco

    // Consulta os registro na tabela usuários.
    // Equivale a: SELECT * FROM usuarios (retorna uma lista de Maps)
    final registros = await db.query('usuarios');

    // Cria uma lista vazia de objetos (tabela usuarios.)
    List<Usuario> usuarios = [];

    // Percorre os registros retornados pelo SQLite.
    for (var registro in registros) {
      // Converter o MAP de um objeto
      // Transforma cada Map (linha da tabela) em um objeto Usuario
      Usuario usuario = Usuario.doMap(registro);

      // Adiciona o objeto na lista
      usuarios.add(usuario);
    } // Fim do for

    // Retorna a lista completa de usuários
    return usuarios;
  } // Fim do método lista

  // Altera o nome e o e-mail de um usuário
  // Retorna um int com a quantidade de linhas alteradas
  Future<int> alterar(int id, String nome, String email) async {
    final db = await abrirBanco(); // Obtém o banco

    // Executa o UPDATE e retorna o número de registros afetados
    return await db.update(
      'usuarios', // Tabela que será alterada
      {
        'nome': nome, // Novo Nome
        'email': email, // Novo e-mail
      },
      where: 'id = ?', // Condição WHERE
      whereArgs: [id], // Valor utilizado na condição (substitui o "?", evitando SQL Injection)
    ); // Fim do update
  } // Fim do método alterar

  // Exclui um usuário pelo ID
  // Retorna um int com a quantidade de linhas excluídas
  Future<int> excluir(int id) async {
    final db = await abrirBanco(); // Obtém banco

    // Executa o DELETE e retorna o número de registros removidos
    return await db.delete(
      'usuarios', // Tabela utilizada
      where: 'id = ?', // Condição WHERE
      whereArgs: [id], // ID do usuário.
    ); // Fim do delete
  } // Fim do método excluir
} // Fim da classe BancoLocal
