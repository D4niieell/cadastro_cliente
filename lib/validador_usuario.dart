import 'usuario.dart'; // Import Classe Usuario  // Importa o arquivo que contém a classe Usuario, usada na validação

// Classe responsável pelas validações do usuário  // Comentário original: descreve o propósito da classe
class ValidadorUsario {
  // Declara a classe ValidadorUsario, que agrupa os métodos de validação
  // Valida o nome do usuário  // Comentário original: descreve o método abaixo
  static bool validarNome(String nome) {
    // Método estático (não precisa instanciar a classe) que recebe um nome e retorna true ou false
    // Remover os espaços e verificar o tamanho  // Comentário original: explica a lógica do retorno
    return nome.trim().length >= 3; // trim() remove espaços das pontas; retorna true se o nome tiver 3 ou mais caracteres
  } // Fim do método validarNome

  // Valida o formato do e-mail  // Comentário original: descreve o método abaixo
  static bool validaEmail(String email) {
    // Método estático que recebe um e-mail e retorna true se o formato for válido
    // Define o padrão de e-mail  // Comentário original: explica a linha seguinte
    RegExp regra = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$'); // Cria uma expressão regular: texto sem @ nem espaços + "@" + texto sem @ nem espaços + "." + texto sem @ nem espaços

    return regra.hasMatch(email.trim()); // Remove espaços das pontas do e-mail e verifica se ele corresponde ao padrão definido
  } // Fim do método validaEmail

  // Valida o OD do usuário.  // Comentário original: descreve o método abaixo (OD = ID)
  static bool validaId(int? id) {
    // Método estático que recebe um ID (inteiro que pode ser nulo, por causa do "?") e retorna true ou false
    // o ID deve existir e ser maior que zero.  // Comentário original: explica a regra de validação
    return id != null &&
        id >
            0; // Retorna true somente se o ID não for nulo E for maior que zero
  } // Fim do método validaId

  // Valida os dados de um objeto Usuario  // Comentário original: descreve o método abaixo
  static String? validaUsuario(Usuario usuario) {
    // Método estático que recebe um objeto Usuario e retorna uma mensagem de erro (String) ou null se estiver tudo certo
    // Verifica o nome  // Comentário original: explica o bloco if abaixo
    if (!validarNome(usuario.nome)) {
      // Se o nome do usuário NÃO for válido (o "!" inverte o resultado)...
      return 'O nome deve possuir 3 caracteres!!!'; // ...interrompe o método e retorna a mensagem de erro sobre o nome
    } // Fim do if que verifica o nome

    // Verifica o e-mail  // Comentário original: explica o bloco if abaixo
    if (!validaEmail(usuario.email)) {
      // Se o e-mail do usuário NÃO for válido...
      return 'Informe um e-mail válido!!!'; // ...interrompe o método e retorna a mensagem de erro sobre o e-mail
    } // Fim do if que verifica o e-mail

    // Retorna null quando não existirem erros  // Comentário original: explica o retorno abaixo
    return null; // Se passou por todas as validações, retorna null indicando que não há erros
  } // Fim do método validaUsuario
} // Fim da classe ValidadorUsario
