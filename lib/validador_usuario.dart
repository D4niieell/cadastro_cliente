// lib/validador_usuario.dart
// validador_usuario.dart

// Importa o arquivo que contém a classe Usuario, para que ela possa
// ser usada como tipo de parâmetro no método validaUsuario.
import 'usuario.dart'; // Import Classe Usuario

// Declara a classe responsável pelas validações do usuário.
// Todos os métodos são "static", ou seja, podem ser chamados
// diretamente pela classe, sem criar um objeto:
// ValidadorUsario.validarNome('Maria')
class ValidadorUsario {
  // Valida o nome do usuário (apenas o tamanho)
  // Recebe uma String e devolve true (válido) ou false (inválido).
  static bool validarNome(String nome) {
    // trim() remove os espaços do início e do final da String.
    // O resultado é guardado em uma nova variável, sem alterar o original.
    String nomeTratado = nome.trim();

    // Compara o tamanho do nome tratado:
    // >= 3  -> tem no mínimo 3 caracteres
    // <= 60 -> tem no máximo 60 caracteres
    // O operador && exige que as duas condições sejam verdadeiras.
    // O resultado da expressão (true/false) é retornado diretamente.
    return nomeTratado.length >= 3 && nomeTratado.length <= 60;
  }

  // Verifica se o nome possui números
  static bool contemNumeros(String nome) {
    // Cria uma expressão regular (RegExp).
    // O prefixo r'...' indica "raw string": a barra invertida não é
    // interpretada como caractere de escape.
    // [0-9] é uma classe de caracteres: casa com qualquer dígito de 0 a 9.
    RegExp regra = RegExp(r'[0-9]');

    // hasMatch() devolve true se encontrar o padrão em QUALQUER parte
    // do texto. Como não há âncoras (^ e $), basta existir um dígito.
    return regra.hasMatch(nome);
  }

  // Verifica se o nome possui somente caracteres permitidos.
  // Permite letras maiúsculas, minúsculas e acentuadas, e espaços
  // entre as palavras.
  static bool validaCaracteresNome(String nome) {
    // Explicação do padrão r'^[a-zA-ZÀ-ÿ]+( [a-zA-ZÀ-ÿ]+)*$':
    // ^            -> início do texto
    // [a-zA-ZÀ-ÿ]+ -> uma ou mais letras (a-z, A-Z e acentuadas de À a ÿ)
    // ( [a-zA-ZÀ-ÿ]+)* -> zero ou mais repetições de: UM espaço + letras
    //                     (impede espaços duplicados ou no início/fim)
    // $            -> fim do texto
    // Obs.: o intervalo À-ÿ também inclui os símbolos × (multiplicação)
    // e ÷ (divisão), que não são letras. É uma pequena imprecisão.
    RegExp regra = RegExp(r'^[a-zA-ZÀ-ÿ]+( [a-zA-ZÀ-ÿ]+)*$');

    // Remove espaços externos e testa se o nome inteiro segue o padrão.
    return regra.hasMatch(nome.trim());
  }

  // Verifica se o usuário informou pelo menos dois nomes
  static bool validaNomeCompleto(String nome) {
    // Remove os espaços do início e do final, para que um espaço
    // sobrando na borda não seja contado como separador de nomes.
    String nomeTratado = nome.trim();

    // contains(' ') retorna true se existir ao menos um espaço
    // no meio do texto, indicando mais de uma palavra.
    return nomeTratado.contains(' ');
  }

  // Valida o formato do e-mail
  static bool validaEmail(String email) {
    // Explicação do padrão r'^[^@\s]+@[^@\s]+\.[^@\s]+$':
    // ^          -> início do texto
    // [^@\s]+    -> um ou mais caracteres que NÃO sejam "@" nem espaço
    //               (parte local, antes do @)
    // @          -> o símbolo @ literal
    // [^@\s]+    -> um ou mais caracteres que NÃO sejam "@" nem espaço
    //               (nome do domínio)
    // \.         -> um ponto literal (a barra invertida "escapa" o ponto)
    // [^@\s]+    -> um ou mais caracteres (extensão, como "com" ou "br")
    // $          -> fim do texto
    // É uma validação simples de formato, não garante que o e-mail exista.
    RegExp regra = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    // Remove espaços externos e testa o e-mail contra o padrão.
    return regra.hasMatch(email.trim());
  }

  // Valida o ID do usuário.
  // O tipo "int?" significa que o valor pode ser um inteiro ou null.
  static bool validaId(int? id) {
    // O ID é válido somente se não for nulo E for maior que zero.
    // Se id for null, o && interrompe a avaliação (curto-circuito),
    // então "id > 0" nem chega a ser executado, evitando erro.
    return id != null && id > 0;
  }

  // Valida os dados de um objeto Usuario.
  // Retorna "String?": uma mensagem de erro (String) ou null se tudo
  // estiver correto.
  static String? validaUsuario(Usuario usuario) {
    // Obtém o nome do objeto e remove os espaços externos.
    String nome = usuario.nome.trim();
    // Obtém o e-mail do objeto e remove os espaços externos.
    String email = usuario.email.trim();

    // Verifica o tamanho do nome.
    // O "!" inverte o resultado: entra no bloco se o nome for INVÁLIDO.
    if (!validarNome(usuario.nome)) {
      // Descobre qual foi o problema: nome curto ou nome longo.
      if (nome.length < 3) {
        // Interrompe o método e devolve a mensagem de erro.
        return 'O nome deve possuir 3 caracteres!!!';
        // Sugestão: o texto mais preciso seria "no mínimo 3 caracteres".
      }

      // Se não é curto, só pode estar acima de 60 caracteres.
      return 'O nome deve possuir no máximo 60 caracteres!!!';
    }

    // Verifica se o nome contém números.
    // Entra no bloco se contemNumeros retornar true.
    if (contemNumeros(nome)) {
      // Interrompe e devolve a mensagem de erro correspondente.
      return 'O nome não pode conter números';
    }

    // Verifica se o nome contém caracteres inválidos (símbolos, etc.).
    // Entra no bloco se o nome NÃO passar na validação de caracteres.
    if (!validaCaracteresNome(nome)) {
      // Os parênteses aqui são opcionais; o return funciona sem eles.
      return ('O nome contém caracteres inválidos!!!');
    }

    // Verifica se foi informado o nome completo (nome + sobrenome).
    // Entra no bloco se não houver espaço separando as palavras.
    if (!validaNomeCompleto(nome)) {
      return 'Informe o nome completo!!!';
    }

    // Verifica se o e-mail ultrapassa 100 caracteres.
    if (email.length > 100) {
      return 'O e-mail deve possuir no máximo 100 caracteres!!!';
    }

    // Verifica o formato do e-mail.
    // Entra no bloco se o e-mail NÃO for válido.
    if (!validaEmail(usuario.email)) {
      return 'Informe um e-mail válido!!!';
    }

    // Se nenhuma validação falhou, retorna null,
    // que significa "nenhum erro encontrado".
    return null;
  }
}
