import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<String?> savePdfFromBase64(String base64Data, String fileName) async {
    try {
      // Limpa o base64 removendo o prefixo se existir
      String cleanBase64 = _cleanBase64String(base64Data);
      
      // Decodifica o base64 para bytes
      List<int> bytes = base64Decode(cleanBase64);
      
      // Obtém o diretório de documentos externos
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception('Não foi possível acessar o diretório de armazenamento');
      }
      
      // Cria o diretório se não existir
      Directory documentsDir = Directory('${externalDir.path}/Documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }
      
      // Cria o arquivo
      File file = File('${documentsDir.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      return file.path;
    } catch (e) {
      return null;
    }
  }
  
  static String _cleanBase64String(String base64) {
    // Remove prefixos comuns de base64
    final regex = RegExp(r'data:application/pdf(;charset=.*?)?;base64,');
    return base64.replaceFirst(regex, '');
  }
  
  static Future<String?> savePdfToTemporary(String base64Data, String fileName) async {
    try {
      String cleanBase64 = _cleanBase64String(base64Data);
      List<int> bytes = base64Decode(cleanBase64);
      
      Directory tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      return file.path;
    } catch (e) {
      return null;
    }
  }
  
  static Future<bool> copyToExternalStorage(String sourcePath, String fileName) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception('Não foi possível acessar o diretório de armazenamento');
      }
      
      Directory documentsDir = Directory('${externalDir.path}/Documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }
      
      File sourceFile = File(sourcePath);
      File destinationFile = File('${documentsDir.path}/$fileName');
      
      await sourceFile.copy(destinationFile.path);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static Future<String?> getExternalStoragePath() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        return '${externalDir.path}/Documents';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> salvarPdf(String nomeArquivo, List<int> bytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$nomeArquivo.pdf');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<String?> salvarPdfTemporario(String nomeArquivo, List<int> bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$nomeArquivo.pdf');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  Future<bool> copiarPdf(String caminhoOrigem, String nomeDestino) async {
    try {
      final arquivoOrigem = File(caminhoOrigem);
      if (!await arquivoOrigem.exists()) {
        return false;
      }

      final directory = await getApplicationDocumentsDirectory();
      final arquivoDestino = File('${directory.path}/$nomeDestino.pdf');
      
      await arquivoOrigem.copy(arquivoDestino.path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> obterCaminhoArmazenamento() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      return null;
    }
  }
}