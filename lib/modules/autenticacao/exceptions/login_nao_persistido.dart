class LoginNaoPersistidoException implements Exception {
  final String msg;
  LoginNaoPersistidoException([
    this.msg =
        'Erro ao salvar seus dados. Você precisará fazer login novamente na próxima sessão.',
  ]);
}