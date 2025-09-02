import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:esig_utils/status.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_list.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/unidade_producao_controller.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/listpage_appbar.dart';

class UnidadeProducaoPage extends StatefulWidget {
  const UnidadeProducaoPage({super.key});

  @override
  State<UnidadeProducaoPage> createState() => _UnidadeProducaoPageState();
}

class _UnidadeProducaoPageState extends State<UnidadeProducaoPage> {
  UnidadeProducaoController controller = Modular.get();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final Debouncer debouncer = Debouncer();

  @override
  void initState() {
    controller.carregarUnidades();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    debouncer.cancel();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore) {
      if (controller.statusCarregaUnidadesPorNome == Status.NAO_CARREGADO) {
        return;
      } else {
        setState(() {
          _isLoadingMore = true;
        });
        await controller.carregarMaisUnidades();
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F9),
      appBar: listPageAppBar(context, 'Unidades de Produção', 7),
      body: Observer(builder: (_) {
        if (controller.statusCarregaUnidades == Status.AGUARDANDO) {
          return SingleChildScrollView(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        }

        if (controller.statusCarregaUnidades == Status.ERRO) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar unidades de produção',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.mensagemErro.isNotEmpty 
                      ? controller.mensagemErro 
                      : 'Ocorreu um erro inesperado',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.carregarUnidades,
                  child: const Text('Tentar novamente', style: TextStyle(color: Themes.verdeBotao)),
                ),
              ],
            ),
          );
        }

        if (controller.statusCarregaUnidades == Status.CONCLUIDO) {
          return Column(
            children: [
              const SizedBox(height: 12),
              // Botão de cadastrar nova unidade - SEMPRE VISÍVEL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Themes.verdeBotao,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    icon: const Icon(Icons.add_circle, size: 24, color: Colors.white),
                    label: const Text('Cadastrar unidade de produção'),
                    onPressed: () {
                      Modular.to.pushNamed('cadastrar');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filtros e busca - SEMPRE VISÍVEL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Themes.verdeBotao,
                        side: BorderSide(color: Themes.verdeBotao, width: 1.5),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      icon: const Icon(Icons.tune, size: 20),
                      label: const Text('Filtros'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar unidade de produção',
                            suffixIcon: Icon(Icons.search, color: Themes.cinzaTexto),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (termo) {
                            debouncer.debounce(
                              duration: Duration(milliseconds: 500),
                              onDebounce: () {
                                atualizaTermoBusca(termo);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Conteúdo principal
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.carregarUnidades();
                  },
                  child: controller.unidadesFiltradas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.agriculture,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma unidade de produção encontrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Cadastre uma nova unidade para começar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                                              : ListView.separated(
                            controller: _scrollController,
                            itemCount: controller.unidadesFiltradas.length + (_isLoadingMore ? 1 : 0),
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, index) {
                              // Se for o último item e estiver carregando, mostra o indicador
                              if (_isLoadingMore && index == controller.unidadesFiltradas.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Themes.verdeBotao),
                                    ),
                                  ),
                                );
                              }
                              
                              final unidade = controller.unidadesFiltradas[index];
                              return _UnidadeProducaoCardCustom(
                                unidade: unidade,
                                onVisualizar: () {
                                  Modular.to.pushNamed('visualizar', arguments: unidade);
                                },
                                onEditar: () {
                                  Modular.to.pushNamed('editar', arguments: unidade);
                                },
                                onDeletar: () {
                                  _showDeleteDialog(unidade);
                                },
                              );
                            },
                          ),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  void _showDeleteDialog(UnidadedeProducaoList unidade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Apagar Unidade de Produção?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                child: Icon(Icons.close, color: Themes.vermelhoTexto, size: 30),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${unidade.id}'),
                Text('Nome: ${unidade.productionUnitNormal?.name ?? 'Não informado'}'),
                const SizedBox(height: 10),
                const Text(
                  'Tem certeza que deseja apagar a Unidade de Produção?',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(17),
                    minWidth: MediaQuery.of(context).size.width,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    colorBrightness: Brightness.dark,
                    color: Themes.vermelhoTexto,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await controller.deleteUnidadeDeProducao(unidade.id!);
                    },
                    child: const Text(
                      'Sim, tenho certeza.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void atualizaTermoBusca(String termo) async {
    if (termo.isEmpty) {
      // Reset da busca - volta para a lista completa
      await controller.carregarUnidades();
    } else {
      // Busca por nome
      await controller.carregarUnidadesPorNome(termo);
    }
  }
}

class _UnidadeProducaoCardCustom extends StatelessWidget {
  final UnidadedeProducaoList unidade;
  final VoidCallback onVisualizar;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;

  const _UnidadeProducaoCardCustom({
    required this.unidade,
    required this.onVisualizar,
    required this.onEditar,
    required this.onDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Card(
        color: Themes.cinzaBackground,
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Themes.verdeTags,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Unidade de Produção',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                unidade.productionUnitNormal?.name?.toUpperCase() ?? 'NOME NÃO INFORMADO',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Data de Criação: ${_formatarData(unidade.createdAt)}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              if (unidade.productionUnitNormal?.street != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Endereço: ${unidade.productionUnitNormal!.street}${unidade.productionUnitNormal!.number != null ? ', ${unidade.productionUnitNormal!.number}' : ''}',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
              if (unidade.productionUnitNormal?.legalArea != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Área Legal: ${unidade.productionUnitNormal!.legalArea} ha',
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, color: Themes.cinzaTexto, size: 18),
                      tooltip: 'Visualizar',
                      onPressed: onVisualizar,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Themes.cinzaTexto, size: 18),
                      tooltip: 'Editar',
                      onPressed: onEditar,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Themes.vermelhoTexto, size: 18),
                      tooltip: 'Deletar',
                      onPressed: onDeletar,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarData(int? timestamp) {
    if (timestamp == null) return 'N/A';
    
    try {
      final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return DateFormat('dd/MM/yyyy').format(data);
    } catch (e) {
      return 'Data inválida';
    }
  }
}