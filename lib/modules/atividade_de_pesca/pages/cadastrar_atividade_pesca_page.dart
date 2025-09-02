import 'package:esig_utils/size_screen.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividadePescaPost.dart';
import 'package:sisater_mobile/models/atividade_de_pesca/atividade_pesca.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/beneficiario_ater.dart';
import 'package:sisater_mobile/models/comunidades/comunidade_selecionavel.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/widgets/build_input_field.dart';
import 'package:sisater_mobile/modules/atividade_de_pesca/atividade_de_pesca_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';

class CadastrarAtividadePescaPage extends StatefulWidget {
  const CadastrarAtividadePescaPage({super.key});

  @override
  State<CadastrarAtividadePescaPage> createState() => _CadastrarAtividadePescaPageState();
}

class _CadastrarAtividadePescaPageState extends State<CadastrarAtividadePescaPage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AtividadeDePescaController controller = Modular.get();

  final nomeEmbarcacaoController = TextEditingController();
  final nomeAnteriorController = TextEditingController();
  final comprimentoController = TextEditingController();
  final bocaController = TextEditingController();
  final pontalController = TextEditingController();
  final tonLiquidaController = TextEditingController();
  final tonBrutaController = TextEditingController();
  final matCascoController = TextEditingController();
  final anoConstrucaoController = TextEditingController();
  final situacaoAtualController = TextEditingController();
  final tripulatesController = TextEditingController();
  final propulsaoController = TextEditingController();
  final inscCapitaniaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregar municípios quando a página for inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarMunicipios();
    });
  }

  void _abrirSelecaoBeneficiario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecione o Beneficiário',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (controller.beneficiarioSelecionado != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                controller.changeBeneficiarioAterSelecionado(null);
                              });
                            },
                            child: const Text(
                              'Limpar',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.beneficiariosAter.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Ordenar beneficiários alfabeticamente por nome
                        final beneficiariosOrdenados = List<BeneficiarioAter>.from(controller.beneficiariosAter)
                          ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                        
                        final beneficiario = beneficiariosOrdenados[index];
                        final isSelected = controller.beneficiarioSelecionado?.id == beneficiario.id;
                        return ListTile(
                          title: Text(
                            beneficiario.name ?? 'Nome não informado',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: Radio<BeneficiarioAter>(
                            value: beneficiario,
                            groupValue: controller.beneficiarioSelecionado,
                            activeColor: const Color(0xFF28A745),
                            onChanged: (BeneficiarioAter? newValue) {
                              setState(() {
                                controller.changeBeneficiarioAterSelecionado(newValue);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE9ECEF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Color(0xFF212529),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Atualizar o estado da página principal
                              this.setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF28A745),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Cadastrar Atividade de Pesca', false, ''),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
                    child: Text('Todos os campos com obrigatórios devem ser preenchidos.(*)', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),       
                  SizedBox(height: 20,),
                  buildFields(),  
                ],
              ),
            ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao,
      onPressed: () async {

        if(controller.comunidadeSelecionada == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Preencha o campo Municipio.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if(controller.beneficiarioSelecionado == null){
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção!'),
              content: const Text('Selecione o Beneficiário.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } 
      
        if (formKey.currentState!.validate()) {

          FocusScope.of(context).unfocus();

          Fisherman atividadePesca = 
          Fisherman(
            beneficiaryId: controller.beneficiarioSelecionado!.id,
            currentVesselName: nomeEmbarcacaoController.text,
            previousVesselName: nomeAnteriorController.text,
            length: int.tryParse(comprimentoController.text),
            beam: bocaController.text,
            depth: pontalController.text,
            netTon: tonLiquidaController.text,
            grossTon: tonBrutaController.text,
            hullMaterial: matCascoController.text,
            constructionYear: int.tryParse(anoConstrucaoController.text),
            currentStatus: situacaoAtualController.text,
            crewNumber: int.tryParse(tripulatesController.text),
            propulsion: propulsaoController.text,
            captaincyRegistration: inscCapitaniaController.text,
          );

          AtividadePescaPost atividadePescaPost = 
          AtividadePescaPost(
            fisherman: atividadePesca,
          );

          await controller.postAtividadePesca(atividadePescaPost);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Observer(builder: (_){

            if(controller.statusPostAtividadePesca == Status.AGUARDANDO){
              return CircularProgressIndicator(
                color: Colors.white,
              );
            }
            else if(controller.statusPostAtividadePesca == Status.ERRO){
              return Text(
            'Cadastrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else if(controller.statusPostAtividadePesca == Status.CONCLUIDO){
              return Text(
            'Cadastrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
            else{
              return Text(
            'Cadastrar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          );
            }
          },)
        ],
      ),
    )      ),
    );
  }

  Widget buildFields(){
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       
           Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Município do Beneficiário*',
                  style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
              ),
                    
              Observer(builder: (_) {
                if (controller.statusCarregaMunicipios == Status.AGUARDANDO) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                if (controller.statusCarregaMunicipios == Status.ERRO) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Erro ao carregar municípios. Tente novamente.',
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            controller.carregarMunicipios();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                }
                
                if (controller.comunidadesSelecionaveis.isEmpty && controller.statusCarregaMunicipios == Status.CONCLUIDO) {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Nenhum município encontrado.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  );
                }
                
                if (controller.comunidadesSelecionaveis.isEmpty) {
                  return const SizedBox();
                }
                
                return DropdownButtonFormField<ComunidadeSelecionavel>(
                  hint: Text('Selecione entre as opções'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                   key: const ValueKey('MuniBenDropdown'),
                   isExpanded: true,
                   value: controller.comunidadeSelecionada,
                  items: controller.comunidadesSelecionaveis.map(
                    (e) => DropdownMenuItem<ComunidadeSelecionavel>(
                      value: e,
                      key: ValueKey(e.code),
                      child: Text(e.name ?? 'Sem nome'),
                      )).toList(), 
                  onChanged: (value) {
                    controller.changeComunidadeSelecionada(value);
                    // Carregar beneficiários quando o município for alterado
                    if (value != null) {
                      controller.carregarBeneficiariosAter(value.code ?? '');
                    }
                    // Limpar beneficiário selecionado quando mudar o município
                    controller.changeBeneficiarioAterSelecionado(null);
                  }
                  );
              }),
      
               SizedBox(height: 10,),
               
               // Campo Beneficiário - só aparece quando município for selecionado
               Observer(builder: (_) {
                 if (controller.comunidadeSelecionada == null) {
                   return const SizedBox();
                 }
                 
                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         'Beneficiário*',
                         style: const TextStyle(
                         fontSize: 18, fontWeight: FontWeight.bold)),
                     ),
                     SizedBox(height: 5),
                     GestureDetector(
                       onTap: () {
                         _abrirSelecaoBeneficiario();
                       },
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                         decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey.shade400),
                           borderRadius: BorderRadius.circular(10),
                         ),
                         child: Row(
                           children: [
                             Expanded(
                               child: Text(
                                 controller.beneficiarioSelecionado == null
                                     ? 'Selecione o beneficiário'
                                     : controller.beneficiarioSelecionado!.name ?? 'Nome não informado',
                                 style: TextStyle(
                                   color: controller.beneficiarioSelecionado == null
                                       ? Colors.grey.shade600
                                       : Colors.black,
                                 ),
                               ),
                             ),
                             Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                           ],
                         ),
                       ),
                     ),
                     SizedBox(height: 10),
                     
                     // Mensagem de validação para o campo beneficiário
                     if (controller.beneficiarioSelecionado == null)
                       Padding(
                         padding: const EdgeInsets.only(left: 12),
                         child: Text(
                           'Campo obrigatório',
                           style: TextStyle(
                             color: Colors.red,
                             fontSize: 12,
                           ),
                         ),
                       ),
                     
                     Observer(builder: (_){
                       if(controller.statusCarregaBeneficiariosAter == Status.AGUARDANDO){
                         return const Center(child: CircularProgressIndicator());
                       } 
                       if(controller.statusCarregaBeneficiariosAter == Status.CONCLUIDO){
                         return SizedBox();
                       }
                       else if(controller.statusCarregaBeneficiariosAter == Status.ERRO) {
                         return Container(
                           padding: const EdgeInsets.all(16.0),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.red),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: Column(
                             children: [
                               const Text(
                                 'Erro ao carregar beneficiários. Tente novamente.',
                                 style: TextStyle(color: Colors.red),
                               ),
                               const SizedBox(height: 8),
                               ElevatedButton(
                                 onPressed: () {
                                   if (controller.comunidadeSelecionada != null) {
                                     controller.carregarBeneficiariosAter(controller.comunidadeSelecionada!.code ?? '');
                                   }
                                 },
                                 child: const Text('Tentar novamente'),
                               ),
                             ],
                           ),
                         );
                       }
                       else if(controller.beneficiariosAter.isEmpty && controller.statusCarregaBeneficiariosAter == Status.CONCLUIDO) {
                         return Container(
                           padding: const EdgeInsets.all(16.0),
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.orange),
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: const Text(
                             'Nenhum beneficiário encontrado para este município.',
                             style: TextStyle(color: Colors.orange),
                           ),
                         );
                       }
                       
                       if (controller.beneficiariosAter.isEmpty) {
                         return const SizedBox();
                       }
                       
                       return const SizedBox();
                     }),
                   ],
                 );
               }),
               
      
          buildInputField(
                label: 'Nome atual da Embarcação',
                controller: nomeEmbarcacaoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Nome anterior da Embarcação',
                controller: nomeAnteriorController,
          ),
          buildInputField(
                label: 'Comprimento (m)',
                controller: comprimentoController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Boca (m)',
                controller: bocaController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Pontal (m)',
                controller: pontalController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Tonelada Líquida (t)',
                controller: tonLiquidaController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Tonelada Bruta (t)',
                controller: tonBrutaController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Material do Casco',
                controller: matCascoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Ano de Construção',
                controller: anoConstrucaoController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Situação Atual',
                controller: situacaoAtualController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Nº de tripulantes *',
                controller: tripulatesController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Propulsão',
                controller: propulsaoController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),
          buildInputField(
                label: 'Inscrição na Capitania dos Portos',
                controller: inscCapitaniaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório.';
                  }
                  return null;
                },
              ),      
        ],
      ),
    );
  }
}