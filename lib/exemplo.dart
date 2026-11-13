// Função principal: ponto de entrada de todo programa Dart
void main() {
  // Cria uma String com espaços em branco no início e no fim
  String nome = '   Carlos Henrique   ';
  // Imprime o nome original, mantendo os espaços extras
  print(nome);
  // Imprime o nome sem os espaços das extremidades (trim remove espaços no início e no fim)
  print(nome.trim());

  // Cria uma String que contém apenas espaços em branco
  String nomeVazio = '    ';
  // Imprime false: 'nome' tem conteúdo, então não está vazia
  print(nome.isEmpty);
  // Remove os espaços de 'nomeVazio' e verifica se ficou vazia: imprime true
  print(nomeVazio.trim().isEmpty);

  // Verifica se o tamanho do nome (contando os espaços) é menor que 3 caracteres
  if (nome.length < 3) {
    // Executado se o nome tiver menos de 3 caracteres
    print('Nome inválido!!!');
  } else {
    // Executado se o nome tiver 3 ou mais caracteres
    // (atenção: a mensagem aqui está igual à do 'if', provavelmente deveria ser 'Nome válido!!!')
    print('Nome inválido!!!');
  }

  // Declara a variável 'email' com tipo inferido (String) a partir do valor atribuído
  var email = 'maria@email.com';

  // Converte o e-mail para letras minúsculas e guarda o resultado na própria variável
  email = email.toLowerCase();

  // Verifica se o e-mail contém o caractere '@'
  if (email.contains('@')) {
    // Executado se houver '@'; $email insere o valor da variável no texto (interpolação)
    print('O e-mail contém o @ : $email!!!');
  } else {
    // Executado se não houver '@'
    print('O e-mail não contém o @!!!');
  }

  // Cria uma expressão regular (RegExp) para validar o formato do e-mail.
  // O prefixo r indica "raw string", ou seja, as barras invertidas são tratadas literalmente.
  // ^            -> início do texto
  // [^@\s]+      -> um ou mais caracteres que não sejam '@' nem espaço (parte antes do @)
  // @            -> o caractere '@'
  // [^@\s]+      -> um ou mais caracteres que não sejam '@' nem espaço (domínio)
  // \.           -> um ponto literal
  // [^@\s]+      -> um ou mais caracteres que não sejam '@' nem espaço (ex.: 'com')
  // $            -> fim do texto
  RegExp regra = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // Testa se o e-mail corresponde ao padrão definido na expressão regular
  if (regra.hasMatch(email)) {
    // Executado se o e-mail seguir o formato esperado
    print('E-mail válido!!!');
  } else {
    // Executado se o e-mail não seguir o formato esperado
    print('E-mail inválido!!!');
  }
}
