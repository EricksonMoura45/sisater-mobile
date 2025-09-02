import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/organizacoes_fater/selecionaveis/metodo_ater.dart';
import 'package:sisater_mobile/modules/atendimento/atendimento_controller.dart';
import 'package:sisater_mobile/modules/atendimento/repository/atendimento_repository.dart';
import 'package:sisater_mobile/models/atendimento/chat_card.dart';

class FinalizarAtendimentoPage extends StatefulWidget {
  const FinalizarAtendimentoPage({super.key});

  @override
  State<FinalizarAtendimentoPage> createState() => _FinalizarAtendimentoPageState();
}

class _FinalizarAtendimentoPageState extends State<FinalizarAtendimentoPage> {
  final AtendimentoRepository atendimentoRepository = Modular.get();
  final AtendimentoController atendimentoController = Modular.get();

  List<MetodoAter> metodos = [];
  MetodoAter? metodoSelecionado;
  bool loading = false;
  String? error;

  ChatCard? chat;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      chat = Modular.args.data as ChatCard?;
      await carregarMetodos();
    });
  }

  Future<void> carregarMetodos() async {
    setState(() { loading = true; error = null; });
    try {
      metodos = await atendimentoRepository.listaMetodos();
      setState(() { loading = false; });
    } catch (e) {
      setState(() { error = 'Erro ao carregar métodos'; loading = false; });
    }
  }

  Future<void> finalizarAtendimento() async {
    if (chat == null || metodoSelecionado == null) return;
    setState(() { loading = true; error = null; });
    try {
      final sucesso = await atendimentoRepository.finalizarChat(chat!.id!, metodoSelecionado!.id!);
      if (sucesso) {
        Navigator.of(context).pop(true);
      } else {
        setState(() { error = 'Erro ao finalizar atendimento'; loading = false; });
      }
    } catch (e) {
      setState(() { error = 'Erro ao finalizar atendimento'; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        title: const Text(
          'Finalizar atendimento',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Para finalizar o atendimento, escolha o método de ATER',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<MetodoAter>(
                      value: metodoSelecionado,
                      items: metodos.map((m) => DropdownMenuItem(
                        value: m,
                        child: Text(m.name ?? 'Sem nome'),
                      )).toList(),
                      onChanged: (m) => setState(() => metodoSelecionado = m),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Método de ATER *',
                        labelStyle: TextStyle(fontSize: 13, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        isDense: true,
                      ),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    ],
                    // Espaço para empurrar os botões para baixo
                    const Spacer(),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: loading ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF666666),
                  side: const BorderSide(color: Color(0xFFCCCCCC)),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                child: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00995D),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                onPressed: (metodoSelecionado != null && !loading)
                    ? finalizarAtendimento
                    : null,
                child: const Text('Finalizar Atendimento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}