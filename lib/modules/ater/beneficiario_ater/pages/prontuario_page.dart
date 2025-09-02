import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:esig_utils/status.dart';
import 'package:sisater_mobile/modules/ater/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/pdf_service.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'dart:io';

class ProntuarioPage extends StatefulWidget {
  const ProntuarioPage({super.key});

  @override
  State<ProntuarioPage> createState() => _ProntuarioPageState();
}

class _ProntuarioPageState extends State<ProntuarioPage> {
  BeneficiarioAterController controller = Modular.get();
  int? beneficiarioId;

  @override
  void initState() {
    super.initState();
    // Reset do estado do controller
    controller.resetProntuarioState();
    
    _carregarDadosBeneficiario();
  }

  void _carregarDadosBeneficiario() {
    final args = Modular.args.data as Map<String, dynamic>?;
    if (args != null) {
      beneficiarioId = args['beneficiarioId'] as int?;
      if (beneficiarioId != null) {
        _carregarProntuario();
      }
    }
  }

  Future<void> _carregarProntuario() async {
    if (beneficiarioId != null) {
      print('=== DEBUG PRONTUARIO PAGE: Iniciando carregamento para beneficiário $beneficiarioId ===');
      
      // Verifica se já existe um prontuário carregado
      if (controller.prontuario != null && controller.statusCarregaProntuario == Status.CONCLUIDO) {
        print('=== DEBUG PRONTUARIO PAGE: Prontuário já carregado, pulando carregamento ===');
        return;
      }
      
      // Aguarda um frame para garantir que o estado seja atualizado
      await Future.delayed(const Duration(milliseconds: 100));
      
      await controller.carregarProntuario(beneficiarioId!);
      print('=== DEBUG PRONTUARIO PAGE: Carregamento concluído. Status: ${controller.statusCarregaProntuario} ===');
    }
  }

  Future<void> _visualizarProntuario() async {
    // Mostra loading
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return const AlertDialog(
    //       content: Row(
    //         children: [
    //           CircularProgressIndicator(),
    //           SizedBox(width: 20),
    //           Text('Carregando prontuário...'),
    //         ],
    //       ),
    //     );
    //   },
    // );

    try {
      // Obtém o PDF base64 do controller
      final pdfBase64 = controller.getProntuarioPdfBase64();
      if (pdfBase64 == null) {
        Navigator.of(context).pop(); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: PDF não disponível'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Salva o PDF temporariamente para visualização
      final fileName = 'prontuario_beneficiario_$beneficiarioId.pdf';
      final savedPath = await PdfService.savePdfFromBase64(pdfBase64, fileName);

      Navigator.of(context).pop(); // Remove loading

      if (savedPath != null) {
        // Navega para a página de visualização passando o caminho do arquivo
        final arguments = {
          'pdfPath': savedPath,
          'fileName': fileName,
          'beneficiarioId': beneficiarioId,
        };
        
        print('=== DEBUG: Navegando para visualizar prontuário ===');
        print('=== DEBUG: Arguments: $arguments ===');
        print('=== DEBUG: PDF Path: $savedPath ===');
        print('=== DEBUG: File exists: ${File(savedPath).existsSync()} ===');
        
        Modular.to.pushNamed('/beneficiarios_ater/visualizar_prontuario', arguments: arguments);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar prontuário'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Remove loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Prontuário', false, ''),
      body: Observer(builder: (_) {
        print('=== DEBUG PRONTUARIO PAGE: Observer rebuild. Status: ${controller.statusCarregaProntuario} ===');
        
        // Se ainda não iniciou o carregamento
        if (controller.statusCarregaProntuario == Status.NAO_CARREGADO) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Iniciando carregamento...'),
              ],
            ),
          );
        }
        
        // Se está carregando
        if (controller.statusCarregaProntuario == Status.AGUARDANDO) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Carregando prontuário...'),
              ],
            ),
          );
        }

        // Se houve erro
        if (controller.statusCarregaProntuario == Status.ERRO) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.prontuarioError ?? 'Erro ao carregar prontuário',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _carregarProntuario,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        // Se carregou com sucesso
        if (controller.statusCarregaProntuario == Status.CONCLUIDO && controller.prontuario != null) {
          final prontuario = controller.prontuario!;
          final data = prontuario.data;

          // Verifica se os dados estão disponíveis
          if (data == null) {
            return const Center(
              child: Text('Dados do prontuário não disponíveis'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card de informações do prontuário
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: Themes.verdeBotao,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Informações do Prontuário',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildInfoRow('Nome:', data.beneficiary_name ?? 'Não informado'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Gerado em:', data.generated_at ?? 'Não informado'),
                        const SizedBox(height: 8),
                        _buildInfoRow('Arquivo:', data.filename ?? 'prontuario.pdf'),
                        const SizedBox(height: 20),
                        const Text(
                          'Clique no botão abaixo para visualizar o prontuário completo.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Botão para visualizar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _visualizarProntuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Themes.verdeBotao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    icon: const Icon(Icons.visibility, size: 24, color: Colors.white),
                    label: const Text('Visualizar Prontuário'),
                  ),
                ),
              ],
            ),
          );
        }

        // Estado padrão
        return const Center(
          child: Text('Nenhum prontuário disponível'),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}