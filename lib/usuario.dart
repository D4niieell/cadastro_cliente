// Define a classe Usuario, que representa um usuário do sistema (modelo de dados)
class Usuario {
  int? id; // Identificador de usuário no Banco de Dados
  String nome; // Nome de usuário
  String email; // E-mail do usuário

  // Construtor da classe, usando parâmetros nomeados (entre chaves)
  Usuario({
    this.id, // Opcional, pois SQLite pode gerar o ID automaticamente
    required this.nome, // Nome obrigatório
    required this.email, // E-mal obrigatório
  });

  // Converte o OBJETO em MAP
  // Método que retorna um Map com chave (String) e valor (Object?), formato usado pelo sqflite para inserir/atualizar
  Map<String, Object?> paraMap() {
    // Retorna o Map com os campos nome e email; o id fica de fora para o SQLite gerá-lo (autoincremento)
    return {'nome': nome, 'email': email};
  }

  // Converte de um MAP em OBJETO
  // Método estático: pode ser chamado sem criar uma instância (Usuario.doMap(...)); recebe os dados vindos do banco
  static Usuario doMap(Map<String, Object> dados) {
    // Cria e retorna um novo objeto Usuario preenchido com os dados do Map
    return Usuario(
      id: dados['id'] as int, // Lê a chave 'id' do Map e converte (cast) para int
      nome: dados['nome'] as String, // Lê a chave 'nome' do Map e converte para String
      email: dados['email'] as String,); // Lê a chave 'email' do Map e converte para String
  }
}
