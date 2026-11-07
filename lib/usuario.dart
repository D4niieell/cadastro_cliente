class Usuario {
  int? id; // Identificador de usuário no Banco de Dados
  String nome; // Nome de usuário
  String email; // E-mail do usuário

  Usuario({
    this.id, // Opcional, pois SQLite pode gerar o ID automaticamente
    required this.nome, // Nome obrigatório
    required this.email, // E-mal obrigatório
  });
}
