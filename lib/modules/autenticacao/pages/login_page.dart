import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_empty_error/snackbar.dart';
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
        if (status == StatusLogin.ERRO) {
          FocusScope.of(OneContext().context!).unfocus();
          getEsigSnackBar(
            status.mensagem,
            duracao: 12,
            padding: const EdgeInsets.symmetric(vertical: 10),
            icon: Icons.error,
            corFundo: Colors.red,
            context: OneContext().context,
          );
          controller.statusLogin = StatusLogin.DESLOGADO;
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
            'Bem-vindos',
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
          await controller.login(
            _loginController.text.replaceAll(RegExp(r'[^0-9]'), ''),
            _senhaController.text,
          );
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
}