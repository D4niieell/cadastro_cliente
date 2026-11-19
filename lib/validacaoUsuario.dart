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

// [COMENTÁRIO] Declara a classe que agrupa todas as regras de validação de usuário.
// [COMENTÁRIO] Todos os membros são "static", então não é preciso criar um objeto para usá-los.
class ValidadorUsuario {
  // Letras (inclusive acentuadas) separadas por espaços
  // [COMENTÁRIO] Declara a expressão regular do nome como constante estática e privada (o "_" torna privado).
  // [COMENTÁRIO] "final" garante que ela seja criada uma única vez e nunca reatribuída.
  static final RegExp _regexNome = RegExp(
    // [COMENTÁRIO] "^" = início do texto; "[A-Za-zÀ-ÖØ-öø-ÿ]+" = uma ou mais letras (maiúsculas, minúsculas e acentuadas).
    // [COMENTÁRIO] "(\s+[...]+)*" = zero ou mais grupos formados por espaço(s) seguido(s) de outra palavra; "$" = fim do texto.
    r'^[A-Za-zÀ-ÖØ-öø-ÿ]+(\s+[A-Za-zÀ-ÖØ-öø-ÿ]+)*$',
    // [COMENTÁRIO] Fecha a chamada do construtor RegExp.
  );

  // Formato básico de e-mail
  // [COMENTÁRIO] Declara a expressão regular do e-mail, também estática, privada e imutável.
  static final RegExp _regexEmail = RegExp(
    // [COMENTÁRIO] "^[a-z0-9._%+\-]+" = parte local (antes do @) com letras minúsculas, números e . _ % + -.
    // [COMENTÁRIO] "@[a-z0-9.\-]+" = o arroba e o domínio; "\.[a-z]{2,}$" = ponto final e extensão com 2+ letras (ex.: .com).
    r'^[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$',
    // [COMENTÁRIO] Fecha a chamada do construtor RegExp.
  );

  // Retorna null se o nome for válido; senão, a mensagem de erro.
  // [COMENTÁRIO] Método que recebe um nome (pode ser nulo) e devolve uma String de erro ou null se estiver tudo certo.
  static String? validarNome(String? nome) {
    // [COMENTÁRIO] Se "nome" for nulo usa '' (string vazia); depois remove espaços do início e do fim com trim().
    final texto = (nome ?? '').trim();

    // [COMENTÁRIO] Verifica se o texto ficou vazio (campo vazio ou só com espaços).
    if (texto.isEmpty) {
      // [COMENTÁRIO] Retorna a mensagem pedida para campo vazio.
      return 'Informe o nome completo!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Verifica se o nome tem menos de 3 caracteres.
    if (texto.length < 3) {
      // [COMENTÁRIO] Retorna a mensagem de tamanho mínimo.
      return 'O nome deve possuir pelo menos 3 caracteres!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Verifica se o nome tem mais de 60 caracteres.
    if (texto.length > 60) {
      // [COMENTÁRIO] Retorna a mensagem de tamanho máximo.
      return 'O nome deve possuir no máximo 60 caracteres!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Procura qualquer dígito (\d) no texto; hasMatch retorna true se encontrar algum.
    if (RegExp(r'\d').hasMatch(texto)) {
      // [COMENTÁRIO] Retorna a mensagem específica para nomes com números.
      return 'O nome não pode conter números!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Se o texto NÃO (!) casar com a regex de nome, há caracteres especiais ou inválidos.
    if (!_regexNome.hasMatch(texto)) {
      // [COMENTÁRIO] Retorna a mensagem de caracteres inválidos (@, #, $, etc.).
      return 'O nome contém caracteres inválidos!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Divide o nome em palavras usando um ou mais espaços como separador (\s+).
    final palavras = texto.split(RegExp(r'\s+'));
    // [COMENTÁRIO] Se houver menos de 2 palavras, falta o sobrenome.
    if (palavras.length < 2) {
      // [COMENTÁRIO] Retorna a mensagem pedindo o nome completo.
      return 'Informe o nome completo!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Passou por todas as regras: retorna null, indicando que o nome é válido.
    return null;
    // [COMENTÁRIO] Fecha o método validarNome.
  }

  // Retorna null se o e-mail for válido; se não, a mensagem de erro.
  // [COMENTÁRIO] Método que valida o e-mail e devolve a mensagem de erro ou null.
  static String? validarEmail(String? email) {
    // [COMENTÁRIO] Trata nulo como '', remove espaços das pontas e converte tudo para minúsculas.
    final texto = (email ?? '').trim().toLowerCase();

    // [COMENTÁRIO] Reprova se estiver vazio ou se tiver algum espaço no meio do e-mail.
    if (texto.isEmpty || texto.contains(' ')) {
      // [COMENTÁRIO] Retorna a mensagem genérica de e-mail inválido.
      return 'Informe um e-mail válido!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Verifica se o e-mail ultrapassa 100 caracteres.
    if (texto.length > 100) {
      // [COMENTÁRIO] Retorna a mensagem de tamanho máximo do e-mail.
      return 'O e-mail deve possuir no máximo 100 caracteres!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] Se o texto NÃO casar com a regex de e-mail, o formato é inválido.
    if (!_regexEmail.hasMatch(texto)) {
      // [COMENTÁRIO] Retorna a mensagem de e-mail inválido.
      return 'Informe um e-mail válido!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] E-mail válido: retorna null.
    return null;
    // [COMENTÁRIO] Fecha o método validarEmail.
  }

  // Retorna null se o ID for válido; se não, a mensagem de erro.
  // [COMENTÁRIO] Método que valida o ID digitado (recebido como texto).
  static String? validarId(String? entrada) {
    // [COMENTÁRIO] Tenta converter o texto em inteiro; int.tryParse retorna null se não for um número inteiro válido.
    final id = int.tryParse((entrada ?? '').trim());
    // [COMENTÁRIO] Reprova se a conversão falhou (null) ou se o número for zero ou negativo.
    if (id == null || id <= 0) {
      // [COMENTÁRIO] Retorna a mensagem de ID inválido.
      return 'Informe um ID válido!';
      // [COMENTÁRIO] Fecha o bloco do if.
    }
    // [COMENTÁRIO] ID válido: retorna null.
    return null;
    // [COMENTÁRIO] Fecha o método validarId.
  }

  // Normaliza antes de salvar no banco.
  // [COMENTÁRIO] Limpa o nome: trim() tira espaços das pontas e replaceAll troca sequências de espaços por um só.
  static String normalizarNome(String nome) =>
      nome.trim().replaceAll(RegExp(r'\s+'), ' ');

  // [COMENTÁRIO] Normaliza o e-mail: remove espaços das pontas e converte para minúsculas (como exige o enunciado).
  static String normalizarEmail(String email) => email.trim().toLowerCase();

  // [COMENTÁRIO] Valida nome e e-mail juntos, retornando a primeira mensagem de erro encontrada ou null.
  static String? validarUsuario(String nome, String email) {
    // [COMENTÁRIO] O operador "??" usa o erro do nome se existir; se for null (nome válido), valida o e-mail.
    return validarNome(nome) ?? validarEmail(email);
    // [COMENTÁRIO] Fecha o método validarUsuario.
  }
  // [COMENTÁRIO] Fecha a classe ValidadorUsuario.
}
