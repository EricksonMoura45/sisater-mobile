import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sisater_mobile/models/autenticacao/usuario_dados.dart';
import 'package:sisater_mobile/modules/beneficiario_menu/beneficiario_controller.dart';
import 'package:sisater_mobile/modules/app_store.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:esig_utils/status.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class BeneficiarioPerfilPage extends StatefulWidget {
  const BeneficiarioPerfilPage({super.key});

  @override
  State<BeneficiarioPerfilPage> createState() => _BeneficiarioPerfilPageState();
}

class _BeneficiarioPerfilPageState extends State<BeneficiarioPerfilPage> {
  final BeneficiarioController _controller = Modular.get();
  final AppStore _appStore = Modular.get();
  final ImagePicker _picker = ImagePicker();
  
  UsuarioDados? usuarioDados;
  bool _isChangingPhoto = false; // Estado para controlar alteração de foto

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // O image_picker já solicita permissões automaticamente quando necessário
    // Esta função pode ser usada para mostrar informações sobre permissões
    print('Permissões serão solicitadas automaticamente quando necessário');
  }

  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadUserData() async {
    print('=== DEBUG PERFIL: Iniciando carregamento de dados do usuário ===');
    
    // First try to get from AppStore
    if (_appStore.usuarioDados != null) {
      print('=== DEBUG PERFIL: Dados encontrados no AppStore ===');
      print('=== DEBUG PERFIL: Nome: ${_appStore.usuarioDados?.name} ===');
      print('=== DEBUG PERFIL: Document: ${_appStore.usuarioDados?.document} ===');
      print('=== DEBUG PERFIL: Foto: ${_appStore.usuarioDados?.foto} ===');
      
      setState(() {
        usuarioDados = _appStore.usuarioDados;
      });
    } else {
      print('=== DEBUG PERFIL: Dados não encontrados no AppStore, carregando da API ===');
      // If not in AppStore, try to load from API
      final dadosUsuario = await _controller.carregarDadosUsuario();
      if (dadosUsuario != null) {
        print('=== DEBUG PERFIL: Dados carregados da API com sucesso ===');
        print('=== DEBUG PERFIL: Nome: ${dadosUsuario.name} ===');
        print('=== DEBUG PERFIL: Document: ${dadosUsuario.document} ===');
        print('=== DEBUG PERFIL: Foto: ${dadosUsuario.foto} ===');
        
        setState(() {
          usuarioDados = dadosUsuario;
        });
        // Update AppStore
        _appStore.usuarioDados = dadosUsuario;
      } else {
        print('=== DEBUG PERFIL: Erro ao carregar dados da API ===');
      }
    }
  }

  // Método para recarregar dados do usuário
  Future<void> _reloadUserData() async {
    print('=== DEBUG PERFIL: Recarregando dados do usuário ===');
    
    // Sempre carregar da API para garantir dados mais recentes
    final dadosUsuario = await _controller.carregarDadosUsuario();
    if (dadosUsuario != null) {
      print('=== DEBUG PERFIL: Dados recarregados da API com sucesso ===');
      print('=== DEBUG PERFIL: Nome: ${dadosUsuario.name} ===');
      print('=== DEBUG PERFIL: Document: ${dadosUsuario.document} ===');
      print('=== DEBUG PERFIL: Foto: ${dadosUsuario.foto} ===');
      
      // Update AppStore
      _appStore.usuarioDados = dadosUsuario;
      _appStore.persistirDadosLogin();
      
      // Update local state
      setState(() {
        usuarioDados = dadosUsuario;
      });
    } else {
      print('=== DEBUG PERFIL: Erro ao recarregar dados da API ===');
    }
  }

  Widget _buildProfileImage() {
    print('=== DEBUG PERFIL: Construindo imagem ===');
    print('=== DEBUG PERFIL: usuarioDados?.foto: ${usuarioDados?.foto} ===');
    print('=== DEBUG PERFIL: usuarioDados?.foto != null: ${usuarioDados?.foto != null} ===');
    print('=== DEBUG PERFIL: usuarioDados?.foto.isNotEmpty: ${usuarioDados?.foto?.isNotEmpty} ===');
    
    // Se estiver alterando a foto, mostrar indicador de carregamento
    if (_isChangingPhoto) {
      print('=== DEBUG PERFIL: Mostrando indicador de carregamento ===');
      return Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Themes.verdeBotao),
              ),
              SizedBox(height: 8),
              Text(
                'Alterando...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (usuarioDados?.foto != null && usuarioDados!.foto!.isNotEmpty) {
      String fotoData = usuarioDados!.foto!;
      
      // Verificar se é base64 com prefixo data:image
      if (fotoData.startsWith('data:image/')) {
        print('=== DEBUG PERFIL: Detectado base64 com prefixo data:image ===');
        
        // Remover o prefixo data:image/png;base64, ou similar
        String base64Data = fotoData;
        if (fotoData.contains(';base64,')) {
          base64Data = fotoData.split(';base64,').last;
          print('=== DEBUG PERFIL: Prefixo removido, base64 limpo ===');
        }
        
        try {
          // Converter base64 para bytes
          final Uint8List imageBytes = Uint8List.fromList(base64Decode(base64Data));
          print('=== DEBUG PERFIL: Base64 convertido para bytes com sucesso ===');
          
          return Image.memory(
            imageBytes,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('=== DEBUG PERFIL: Erro ao carregar imagem base64: $error ===');
              return Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
              );
            },
          );
        } catch (e) {
          print('=== DEBUG PERFIL: Erro ao decodificar base64: $e ===');
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.grey,
            ),
          );
        }
      } else if (fotoData.startsWith('http://') || fotoData.startsWith('https://')) {
        // Se for uma URL completa
        print('=== DEBUG PERFIL: Detectado URL completa: $fotoData ===');
        return Image.network(
          fotoData,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('=== DEBUG PERFIL: Imagem carregada com sucesso ===');
              return child;
            }
            print('=== DEBUG PERFIL: Carregando imagem: ${loadingProgress.expectedTotalBytes != null ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).round() : 0}% ===');
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('=== DEBUG PERFIL: Erro ao carregar imagem: $error ===');
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        );
      } else {
        // Se não for base64 nem URL, pode ser um caminho relativo
        print('=== DEBUG PERFIL: Detectado caminho relativo: $fotoData ===');
        String fotoUrl = 'https://api.sisater.com.br/$fotoData';
        print('=== DEBUG PERFIL: URL da foto ajustada: $fotoUrl ===');
        
        return Image.network(
          fotoUrl,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              print('=== DEBUG PERFIL: Imagem carregada com sucesso ===');
              return child;
            }
            print('=== DEBUG PERFIL: Carregando imagem: ${loadingProgress.expectedTotalBytes != null ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).round() : 0}% ===');
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('=== DEBUG PERFIL: Erro ao carregar imagem: $error ===');
            return Container(
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        );
      }
    } else {
      print('=== DEBUG PERFIL: Mostrando ícone padrão ===');
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.person,
          size: 60,
          color: Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        // Show loading if we don't have user data yet
        if (usuarioDados == null && _controller.statusCarregarDadosUsuario == Status.AGUARDANDO) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              leading: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Themes.verdeBotao,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.keyboard_arrow_left,
                        size: 32, color: Colors.white),
                  ),
                ),
                onTap: () {
                  Modular.to.pop();
                }
              ),
              title: const Text(
                'Perfil',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF212529),
                ),
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            leading: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Themes.verdeBotao,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.keyboard_arrow_left,
                      size: 32, color: Colors.white),
                ),
              ),
              onTap: () {
                Modular.to.pop();
              }
            ),
            title: const Text(
              'Perfil',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Color(0xFF212529),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Profile Picture Section
                Center(
                  child: Column(
                    children: [
                      // Profile Picture
                      Observer(
                        builder: (_) {
                          print('=== DEBUG PERFIL: Observer detectou mudança ===');
                          print('=== DEBUG PERFIL: usuarioDados?.foto: ${usuarioDados?.foto} ===');
                          
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: _buildProfileImage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Change Photo Button
                      GestureDetector(
                        onTap: _isChangingPhoto ? null : () => _showChangePhotoDialog(context),
                        child: Text(
                          'Alterar Foto',
                          style: TextStyle(
                            color: _isChangingPhoto ? Colors.grey.shade400 : const Color(0xFF6C757D),
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // User Information Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Row(
                        children: [
                          const Text(
                            'Nome: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF495057),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              usuarioDados?.name ?? 'Não informado',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // CPF
                      Row(
                        children: [
                          const Text(
                            'CPF: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF495057),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              usuarioDados?.document ?? '000.000.000-00',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Logout Button
                Center(
                  child: GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF6C757D),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.exit_to_app_outlined,
                            color: Color(0xFF6C757D),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Sair',
                            style: TextStyle(
                              color: Color(0xFF6C757D),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

  void _showChangePhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Alterar Foto',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Camera Option
                MaterialButton(
                  padding: const EdgeInsets.all(12),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: _isChangingPhoto ? Colors.grey : Themes.verdeBotao,
                  onPressed: _isChangingPhoto ? null : () async {
                    Navigator.of(context).pop();
                    await _pickImageFromCamera();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isChangingPhoto)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _isChangingPhoto ? 'Alterando...' : 'Câmera',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Gallery Option
                MaterialButton(
                  padding: const EdgeInsets.all(12),
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: _isChangingPhoto ? Colors.grey : Themes.verdeBotao,
                  onPressed: _isChangingPhoto ? null : () async {
                    Navigator.of(context).pop();
                    await _pickImageFromGallery();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isChangingPhoto)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        const Icon(Icons.photo_library, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _isChangingPhoto ? 'Alterando...' : 'Galeria',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _processAndUploadImage(image);
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _showPermissionDialog(
          'Permissão de Câmera',
          'Para tirar fotos do seu perfil, é necessário permitir o acesso à câmera. Você pode ativar esta permissão nas configurações do seu dispositivo.',
        );
      } else {
        _showErrorSnackBar('Erro ao capturar foto: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        await _processAndUploadImage(image);
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        _showPermissionDialog(
          'Permissão de Galeria',
          'Para selecionar fotos da sua galeria, é necessário permitir o acesso às fotos. Você pode ativar esta permissão nas configurações do seu dispositivo.',
        );
      } else {
        _showErrorSnackBar('Erro ao selecionar foto: $e');
      }
    }
  }

  Future<void> _processAndUploadImage(XFile image) async {
    try {
      // Definir estado de carregamento
      setState(() {
        _isChangingPhoto = true;
      });
      
      // Convert image to base64
      final File imageFile = File(image.path);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Upload image
      final bool success = await _controller.alterarFoto(base64Image);

      if (success) {
        // Recarregar dados do usuário da API usando o método dedicado
        await _reloadUserData();
        
        // Resetar estado de carregamento
        setState(() {
          _isChangingPhoto = false;
        });
        
        // Forçar rebuild adicional para garantir atualização da foto
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
        
        _showSuccessSnackBar('Foto alterada com sucesso!');
      } else {
        setState(() {
          _isChangingPhoto = false; // Resetar estado de carregamento
        });
        _showErrorSnackBar(_controller.fotoError ?? 'Erro ao alterar foto');
      }
    } catch (e) {
      setState(() {
        _isChangingPhoto = false; // Resetar estado de carregamento
      });
      _showErrorSnackBar('Erro ao processar imagem: $e');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Tem certeza que deseja sair da aplicação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _appStore.logout();
              },
              child: const Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}