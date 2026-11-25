// lib/endereco.dart
// endereco.dart

// Declara a classe Endereco, que representa um endereço pertencente a um usuário
class Endereco {
  int? id; // Identificando do endereço (PK)
  // Campo nullable (?) porque o id só existe depois que o banco gera o valor
  int usuarioId; // ID do usuário (FK)
  // Liga este endereço ao usuário dono dele
  String logradouro; // Nome da rua, alameda, avenida ou similar
  // Texto com o nome da via
  int numero; // Número do imóvel na rua
  // Número inteiro do imóvel
  String cidade; // Cidade do endereço
  // Texto com o nome da cidade

  // Construtor da classe, usa parâmetros nomeados (entre chaves)
  Endereco({
    this.id, // ID opcional, gerado automaticamente
    // "this.id" atribui direto ao campo; sem "required", pode ficar nulo
    required this.usuarioId, // ID gerado automaticamente na tabela usuario
    // "required" obriga a informar o valor ao criar o objeto
    required this.logradouro, // Logradouro obrigatório
    // Atribui o valor ao campo logradouro, é obrigatório
    required this.numero, // Número obrigatório
    // Atribui o valor ao campo numero, é obrigatório
    required this.cidade, // Cidade obrigatório
    // Atribui o valor ao campo cidade, é obrigatório
  }); // Fecha a lista de parâmetros e termina a declaração do construtor

  // Converte o objeto Endereco em MAP
  // Método de instância que devolve um Map (chave: nome da coluna, valor: dado), formato usado pelo banco (ex.: sqflite)
  Map<String, Object?> paraMap() {
    return {
      // Retorna um Map literal com os dados do objeto
      'usuario_id': usuarioId, // Chave é o nome da coluna no banco; valor é o ID do usuário (FK)
      'logradouro': logradouro, // Coluna logradouro recebe o nome da via
      'numero': numero, // Coluna numero recebe o número do imóvel
      'cidade': cidade, // Coluna cidade recebe o nome da cidade
    }; // Fecha o Map; o "id" fica de fora de propósito, pois o banco o gera sozinho (autoincremento)
  } // Fecha o método paraMap

  // Método estático (pertence à classe, não a uma instância): converte um Map vindo do banco em um objeto Endereco
  static Endereco doMap(Map<String, Object?> dados) {
    return Endereco(
      // Cria e retorna um novo objeto Endereco
      id: dados['id'] as int?, // Lê a coluna 'id' e converte para int anulável (pode ser nulo)
      usuarioId:
          dados['usuario_id']
              as int, // Lê a coluna 'usuario_id' e converte para int (não nulo)
      logradouro:
          dados['logradouro']
              as String, // Lê a coluna 'logradouro' e converte para String
      numero:
          dados['numero'] as int, // Lê a coluna 'numero' e converte para int
      cidade:
          dados['cidade']
              as String, // Lê a coluna 'cidade' e converte para String
    ); // Fecha a chamada do construtor e encerra o return
  } // Fecha o método doMap
} // Fecha a classe Endereco
