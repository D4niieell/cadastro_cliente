// * 1. Validação do nome completo
// O nome do usuário deverá:

// - Possuir no mínimo 3 caracteres.
// - Possuir no máximo 60 caracteres.
// - Possuir pelo menos um nome e um sobrenome.
// - Permitir nomes compostos e múltiplos sobrenomes.
// - Permitir letras maiúsculas, minúsculas e acentuadas.
// - Permitir espaços entre as palavras.
// - Não permitir números.
// - Não permitir caracteres especiais, como @, #, $, %, &, entre outros.
// - Desconsiderar espaços em branco no início e no final do nome.

// Exemplos de nomes válidos:

// - Carlos Augusto
// - Joice Pereira Sales
// - Maria da Silva
// - João Pedro dos Santos
// - Ana Júlia Oliveira

// Exemplos de nomes inválidos:

// - Carlos
// - Joice123 Pereira
// - Maria@Silva
// - 123456
// - Campo vazio ou contendo somente espaços

// * 2. Validação do e-mail

// O e-mail deverá:

// - Possuir um formato válido.
// - Possuir no máximo 100 caracteres.
// - Não conter espaços em branco entre seus caracteres.
// - Ser armazenado em letras minúsculas.
// - Desconsiderar espaços no início e no final.

// * 3. Validação do ID

// O ID utilizado nas operações de alteração e exclusão deverá:

// - Ser um número inteiro.
// - Ser maior que zero.

// * 4. Mensagens de validação

// O aplicativo deverá apresentar mensagens específicas quando uma regra não for atendida.

// Exemplos:

// - O nome deve possuir pelo menos 3 caracteres!
// - O nome deve possuir no máximo 60 caracteres!
// - Informe o nome completo!
// - O nome não pode conter números!
// - O nome contém caracteres inválidos!
// - Informe um e-mail válido!
// - O e-mail deve possuir no máximo 100 caracteres!
// - Informe um ID válido!

// * Orientações

// - Utilize a classe ValidadorUsuario já existente.
// - Utilize os métodos de manipulação de strings estudados.
// - Utilize expressões regulares para verificar os caracteres permitidos.
// - As validações deverão funcionar tanto no cadastro quanto na alteração.
// - Não altere a estrutura da tabela do SQLite.
// - Não utilize novas bibliotecas.
// - Mantenha o tratamento de exceções existente.

// * Entrega

// Apresente o aplicativo funcionando e demonstre pelo menos cinco situações de validação, incluindo:

// 1. Cadastro de um usuário com nome completo válido.
// 2. Cadastro de um usuário com nome composto e múltiplos sobrenomes.
// 3. Tentativa de cadastro com números no nome.
// 4. Tentativa de cadastro sem sobrenome.
// 5. Tentativa de alteração com dados inválidos.

// Exemplo para aceitar acentos.
// - Permitir letras maiúsculas, minúsculas e acentuadas.

// RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ ]+$');

// validacaoUsuario.dart

class ValidadorUsuario {
  // Letras (inclusive acentuadas) separadas por espaços
  static final RegExp _regexNome = RegExp(
    r'^[A-Za-zÀ-ÖØ-öø-ÿ]+(\s+[A-Za-zÀ-ÖØ-öø-ÿ]+)*$',
  );

  // Formato básico de e-mail
  static final RegExp _regexEmail = RegExp(
    r'^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$',
  );

  // Retorna null se o nome for válido; senão, a mensagem de erro.
  static String? validarNome(String? nome) {
    final texto = (nome ?? '').trim();

    if (texto.isEmpty) {
      return 'Informe o nome completo!';
    }
    if (texto.length < 3) {
      return 'O nome deve possuir pelo menos 3 caracteres!';
    }
    if (texto.length > 60) {
      return 'O nome deve possuir no máximo 60 caracteres!';
    }
    if (RegExp(r'\d').hasMatch(texto)) {
      return 'O nome não pode conter números!';
    }
    if (!_regexNome.hasMatch(texto)) {
      return 'O nome contém caracteres inválidos!';
    }
    final palavras = texto.split(RegExp(r'\s+'));
    if (palavras.length < 2) {
      return 'Informe o nome completo!';
    }
    return null;
  }

  // Retorna null se o e-mail for válido; se não, a mensagem de erro.
  static String? validarEmail(String? email) {
    final texto = (email ?? '').trim().toLowerCase();

    if (texto.isEmpty || texto.contains(' ')) {
      return 'Informe um e-mail válido!';
    }
    if (texto.length > 100) {
      return 'O e-mail deve possuir no máximo 100 caracteres!';
    }
    if (!_regexEmail.hasMatch(texto)) {
      return 'Informe um e-mail válido!';
    }
    return null;
  }

  // Retorna null se o ID for válido; se não, a mensagem de erro.
  static String? validarId(String? entrada) {
    final id = int.tryParse((entrada ?? '').trim());
    if (id == null || id <= 0) {
      return 'Informe um ID válido!';
    }
    return null;
  }

  // Normaliza antes de salvar no banco.
  static String normalizarNome(String nome) =>
      nome.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String normalizarEmail(String email) => email.trim().toLowerCase();

  static String? validarUsuario(String nome, String email) {
    return validarNome(nome) ?? validarEmail(email);
  }
}
