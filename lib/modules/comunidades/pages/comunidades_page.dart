import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:esig_utils/status.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/modules/comunidades/comunidades_controller.dart';
import 'package:sisater_mobile/models/comunidades/comunidades_list.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/listpage_appbar.dart';

class ComunidadesPage extends StatefulWidget {
  const ComunidadesPage({super.key});

  @override
  State<ComunidadesPage> createState() => _ComunidadesPageState();
}

class _ComunidadesPageState extends State<ComunidadesPage> {
  final ComunidadesController controller = Modular.get();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  final Debouncer debouncer = Debouncer();

  @override
  void initState() {
    controller.carregaComunidades();
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
      // Só carrega mais se não estiver fazendo busca por nome
      if (controller.statusCarregaComunidades == Status.CONCLUIDO) {
        setState(() {
          _isLoadingMore = true;
        });
        await controller.carregaMaisComunidades();
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
      appBar: listPageAppBar(context, 'Comunidades', 5),
      body: Observer(builder: (_) {
        if (controller.statusCarregaComunidades == Status.AGUARDANDO) {
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

        if (controller.statusCarregaComunidades == Status.ERRO) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erro ao carregar comunidades'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.carregaComunidades();
                  },
                  child: Text('Tentar novamente', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        if (controller.statusCarregaComunidades == Status.CONCLUIDO) {
          return Column(
            children: [
              const SizedBox(height: 12),
              // Botão de cadastrar nova comunidade
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
                    icon: const Icon(Icons.add_circle, size: 24, color: Colors.white,),
                    label: const Text('Cadastrar comunidade'),
                    onPressed: () {
                      Modular.to.pushNamed('/comunidades/cadastrar_comunidade');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Filtros e busca
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
                            hintText: 'Buscar por nome da comunidade',
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
              // Lista de comunidades
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.carregaComunidades();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: controller.comunidadesFiltradas.length + (_isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      // Se for o último item e estiver carregando, mostra o indicador
                      if (_isLoadingMore && index == controller.comunidadesFiltradas.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Themes.verdeBotao),
                            ),
                          ),
                        );
                      }
                      
                      final comunidade = controller.comunidadesFiltradas[index];
                      return _ComunidadeCardCustom(
                        comunidade: comunidade,
                        onVisualizar: () {
                          Modular.to.pushNamed('/comunidades/visualizar_comunidade', arguments: comunidade);
                        },
                        onEditar: () {
                          Modular.to.pushNamed('/comunidades/editar_comunidade', arguments: comunidade);
                        },
                        onDeletar: () {
                          _showDeleteDialog(comunidade);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return SizedBox();
      }),
    );
  }

  void _showDeleteDialog(ComunidadesList comunidade) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Apagar Comunidade?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
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
                Text(comunidade.name ?? ''),
                Text('Código da cidade: ${comunidade.cityCode ?? 'N/A'}'),
                const SizedBox(height: 10),
                const Text(
                  'Tem certeza que deseja apagar a Comunidade?',
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
                      // await controller.deleteComunidade(comunidade.id!);
                      // controller.carregaComunidades();
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
      await controller.carregaComunidades();
    } else {
      // Busca por nome
      await controller.carregaComunidadesPorNome(termo);
    }
  }
}

class _ComunidadeCardCustom extends StatelessWidget {
  final ComunidadesList comunidade;
  final VoidCallback onVisualizar;
  final VoidCallback onEditar;
  final VoidCallback onDeletar;

  const _ComunidadeCardCustom({
    required this.comunidade,
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
                      'Comunidade',
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
                (comunidade.name ?? 'Nome indisponível').toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              if (comunidade.description != null && comunidade.description!.isNotEmpty)
                Text(
                  comunidade.description!,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Código da cidade: ${comunidade.cityCode ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Distância: ',
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Tipo de acesso: ${comunidade.accessTypeText ?? 'N/A'}',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
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
}