import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobx/mobx.dart';
import 'package:one_context/one_context.dart';
import 'package:sisater_mobile/modules/autenticacao/autenticacao_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  AutenticacaoController controller = Modular.get();

  final TextEditingController _loginController = TextEditingController();

  final TextEditingController _senhaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ReactionDisposer loginDisposer;

  final maskCpf = MaskTextInputFormatter(mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});


  @override
  void initState() {
    loginDisposer = reaction(
      (_) => controller.statusLogin,
      (StatusLogin status) {
        if (status == StatusLogin.ERRO && mounted) {
          // Usar o contexto da página atual em vez de OneContext
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              FocusScope.of(context).unfocus();
              // Mostrar aviso mais sutil primeiro (snackbar)
              _showErrorSnackBar(controller.mensagemErroLogin);
              // Resetar o status após um delay
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  controller.statusLogin = StatusLogin.DESLOGADO;
                }
              });
            }
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildLogoApp(context),
                    const SizedBox(height: 30),
                    _buildLoginInput(),
                    const SizedBox(height: 20),
                    _buildPassInput(),
                    _buildBotaoEsqueciSenha(context),
                  ],
                ))
          ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: _buildBotaoLogin(context),
      ),
    );
  }

  Widget _buildLogoApp(BuildContext context) {
    return const Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bem-vindo',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 25),
          ),
          Text(
            'SISATER - PARÁ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Themes.verdeBotao, fontSize: 25),
          ),
          Text(
            'O Sistema de Acompanhamento das Atividades de Assistência Técnica e Extensão Rural',
            style: TextStyle(
                fontWeight: FontWeight.w200, color: Themes.cinzaTexto, fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget _buildBotaoEsqueciSenha(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: Themes.verdeBotao,
              value: controller.manterLogado, 
              onChanged: (bool? value){
                setState(() {
                  controller.manterLogado = value ?? false;
                });
              }),
              const Text(
                'Lembrar-me', 
              style: TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.normal, 
                color: Themes.cinzaTexto),)
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () async {
              Modular.to.navigate('/esqueci_senha');
            },
            child: const Text(
              'Esqueceu a senha?',
              style: TextStyle(
                color: Themes.cinzaBotao,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotaoCadastro(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Não possui cadastro? ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: () async {
              Modular.to.navigate('/autocadastro');
            },
            child: const Text(
              'Criar conta',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Themes.corBaseApp,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotaoLogin(BuildContext context) {
    return Observer(
      builder: (_) {
        if (controller.statusLogin == StatusLogin.AGUARDANDO) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        } else {
          return _botaoLogin(context);
        }
      },
    );
  }

  Widget _buildLoginInput() {
    return InputWidget(
      controller: _loginController,
      corErro: Colors.red,
      corBackground: Colors.white,
      corTexto: Themes.pretoTexto,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      mostrarButton: false,
      inputType: TextInputType.emailAddress,
      obscure: false,
      formatters: [maskCpf],
      hintTexto: 'CPF',
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Themes.cinzaTexto,
        fontSize: 16,
      ),
      validator: (String? login) {
        if (login?.isEmpty ?? false) {
          return 'Login inválido';
        }
        return null;
      },
    );
  }

  Widget _buildPassInput() {
    return InputWidget(
      controller: _senhaController,
      corErro: Colors.red,
      corBackground: Colors.white,
      corTexto: Themes.pretoTexto,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      hintTexto: 'Senha',
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Themes.cinzaTexto,
        fontSize: 16,
      ),
      mostrarButton: true,
      obscure: true,
      validator: (String? login) {
        if (login?.isEmpty ?? false) {
          return 'Senha inválida';
        }
        return null;
      },
    );
  }

  Widget _botaoLogin(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          FocusScope.of(context).unfocus();
          
          // Verificar se os campos estão preenchidos
          if (_loginController.text.trim().isEmpty || _senhaController.text.trim().isEmpty) {
            _showErrorSnackBar('Por favor, preencha todos os campos');
            return;
          }
          
          await controller.login(
            _loginController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            _senhaController.text,
          );
          
          // Limpar senha após tentativa de login
          _senhaController.clear();
        }
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Entrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    // Verificar se o contexto ainda é válido
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Erro no Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message.isNotEmpty ? message : 'Credenciais inválidas',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Por favor, verifique suas credenciais e tente novamente.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Limpar o campo de senha após fechar o diálogo
                _senhaController.clear();
                // Focar no campo de senha para facilitar nova tentativa
                FocusScope.of(context).requestFocus(FocusNode());
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message.isNotEmpty ? message : 'Erro no login',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}