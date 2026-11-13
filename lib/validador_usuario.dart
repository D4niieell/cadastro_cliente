import 'usuario.dart'; // Import Classe Usuario

// Classe responsável pelas validações do usuário
class ValidadorUsario {
  // Valida o nome do usuário
  static bool validarNome(String nome) {
    // Remover os espaços e verificar o tamanho
    return nome.trim().length >= 3;
  }

  // Valida o formato do e-mail
  static bool validaEmail(String email) {
    // Define o padrão de e-mail
    RegExp regra = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    return regra.hasMatch(email.trim());
  }

  // Valida o OD do usuário.
  static bool validaId(int? id) {
    // o ID deve existir e ser maior que zero.
    return id != null && id > 0;
  }

  // Valida os dados de um objeto Usuario
  static String? validaUsuario(Usuario usuario) {
    // Verifica o nome
    if (!validarNome(usuario.nome)) {
      return 'O nome deve possuir 3 caracteres!!!';
    }

    // Verifica o e-mail
    if (!validaEmail(usuario.email)) {
      return 'Informe um e-mail válido!!!';
    }

    // Retorna null quando não existirem erros
    return null;
  }
}
