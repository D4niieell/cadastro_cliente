void main() {
  String nome = '   Carlos Henrique   ';
  print(nome);
  print(nome.trim());

  String nomeVazio = '    ';
  print(nome.isEmpty);
  print(nomeVazio.trim().isEmpty);

  if (nome.length < 3) {
    print('Nome inválido!!!');
  } else {
    print('Nome inválido!!!');
  }

  var email = 'maria@email.com';

  email = email.toLowerCase();

  if (email.contains('@')) {
    print('O e-mail contém o @ : $email!!!');
  } else {
    print('O e-mail não contém o @!!!');
  }

  RegExp regra = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  if (regra.hasMatch(email)) {
    print('E-mail válido!!!');
  } else {
    print('E-mail inválido!!!');
  }
}
