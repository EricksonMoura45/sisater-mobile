import 'package:esig_utils/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sisater_mobile/modules/beneficiario_ater/beneficiario_ater_controller.dart';
import 'package:sisater_mobile/shared/utils/widgets/beneficiario_card.dart';
import 'package:sisater_mobile/shared/utils/widgets/listpage_appbar.dart';

class BeneficiariosAterPage extends StatefulWidget {
  const BeneficiariosAterPage({super.key});

  @override
  State<BeneficiariosAterPage> createState() => _BeneficiariosAterPageState();
}

class _BeneficiariosAterPageState extends State<BeneficiariosAterPage> {

  BeneficiarioAterController controller = Modular.get();

  @override
  void initState() {
    controller.carregaBeneficiarios();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: listPageAppBar(context, 'Beneficiários de Ater'),
        body: Observer(builder: (_){
          if (controller.statusCarregaBeneficiarios == Status.AGUARDANDO) {
            return SingleChildScrollView(
              child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
              children: List.generate(4, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
                        ),
                      );
                    }),
                  ),
                ),
            );
}

          if(controller.statusCarregaBeneficiarios == Status.ERRO){
            return Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text('Erro ao carregar beneficiários'),
            SizedBox(height: 10),
            ElevatedButton(
             onPressed: () {
            controller.carregaBeneficiarios();
          },
          child: Text('Tentar novamente'),
        ),
      ],
    ),
  );
          }
          
          if(controller.statusCarregaBeneficiarios == Status.CONCLUIDO){
          return Column(
            children: [
              SizedBox(height: 10,),
              _buildSearchBar(controller),
              SizedBox(height: 10,),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async{

                    await controller.carregaBeneficiarios();
                    
                  },
                  child: ListView.builder(
                            itemCount: controller.beneficiariosFiltrados.length,
                            itemBuilder: (_, index) {
                              final beneficiario = controller.beneficiariosFiltrados[index];
                              return BeneficiarioCard(
                                key: ValueKey(beneficiario.id),
                                beneficiarioAter: beneficiario);
                            },
                            //separatorBuilder: (_, __) => Divider(),
                          ),
                ),
              ),
            ],
          );
          }
        else{
          return SizedBox();
        }  
        })
      ),
    );
  }

  Widget _buildSearchBar(BeneficiarioAterController controller) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: 'Buscar beneficiário',
        hintText: 'Digite nome',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: controller.atualizaTermoBusca, // Chama o método do controller
    ),
  );
 }


}