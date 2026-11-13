// Declara a classe Usuario, que representa um usuário do sistema
class Usuario {
  // Declara o atributo id, que aceita valor nulo (int?) por ser gerado pelo banco
  int? id; // Identificado do usuário no BD
  // Declara o atributo nome, do tipo texto, que não pode ser nulo
  String nome; // Nome do usuário
  // Declara o atributo email, do tipo texto, que não pode ser nulo
  String email; // E-mail do usuário

  // Construtor da classe, que usa parâmetros nomeados (entre chaves)
  Usuario({
    // Inicializa o atributo id diretamente com o valor recebido (this.id)
    this.id, // Opcional, pois SQLite pode gerar o ID automáticamente
    // Inicializa o atributo nome; "required" obriga a informar esse parâmetro
    required this.nome, // Nome obrigatório
    // Inicializa o atributo email; "required" obriga a informar esse parâmetro
    required this.email, // E-mail Obrigatório
    // Fecha a lista de parâmetros e encerra o construtor
  });

  // Comentário que descreve a função abaixo
  // Converte o objeto em MAP
  // Método que transforma o objeto em um Map (chave/valor), formato aceito pelo SQLite
  Map<String, Object?> paraMap() {
    // Retorna um Map com as chaves 'nome' e 'email' associadas aos valores do objeto
    // (o id fica de fora para que o banco o gere automaticamente)
    return {'nome': nome, 'email': email};
    // Fecha o método paraMap
  }

  // Comentário que descreve a função abaixo
  // Converte de um MAP em Objeto
  // Método estático (chamado sem criar uma instância) que recebe um Map vindo do banco
  // e devolve um objeto Usuario
  static Usuario doMap(Map<String, Object?> dados) {
    // Cria e retorna um novo objeto Usuario com os dados do Map
    return Usuario(
      // Lê o valor da chave 'id' e o converte para int
      id: dados['id'] as int,
      // Lê o valor da chave 'nome' e o converte para String
      nome: dados['nome'] as String,
      // Lê o valor da chave 'email' e o converte para String
      email: dados['email'] as String,
      // Fecha a chamada do construtor Usuario
    );
    // Fecha o método doMap
  }
  // Fecha a classe Usuario
}
