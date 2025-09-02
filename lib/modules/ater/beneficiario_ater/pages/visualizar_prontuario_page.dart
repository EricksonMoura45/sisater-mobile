import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

class VisualizarProntuarioPage extends StatefulWidget {
  const VisualizarProntuarioPage({super.key});

  @override
  State<VisualizarProntuarioPage> createState() => _VisualizarProntuarioPageState();
}

class _VisualizarProntuarioPageState extends State<VisualizarProntuarioPage> {
  String? _pdfPath;
  String? _error;
  String? fileName;
  int? beneficiarioId;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPdfFromArguments();
  }

  void _loadPdfFromArguments() {
    try {
      final args = Modular.args.data as Map<String, dynamic>?;
      if (args != null) {
        _pdfPath = args['pdfPath'] as String?;
        fileName = args['fileName'] as String?;
        beneficiarioId = args['beneficiarioId'] as int?;
        
        print('=== DEBUG: PDF Path: $_pdfPath ===');
        print('=== DEBUG: File Name: $fileName ===');
        print('=== DEBUG: Beneficiario ID: $beneficiarioId ===');
        
        if (_pdfPath != null && _pdfPath!.isNotEmpty) {
          // Verifica se o arquivo existe
          final file = File(_pdfPath!);
          if (!file.existsSync()) {
            print('=== DEBUG: Arquivo não encontrado: $_pdfPath ===');
            setState(() {
              _error = 'Arquivo PDF não encontrado no caminho: $_pdfPath';
            });
          }
        } else {
          print('=== DEBUG: Caminho do PDF é nulo ou vazio ===');
          setState(() {
            _error = 'Caminho do PDF não informado.';
          });
        }
      } else {
        print('=== DEBUG: Argumentos não informados ===');
        setState(() {
          _error = 'Dados do prontuário não informados.';
        });
      }
    } catch (e) {
      print('=== DEBUG: Erro ao carregar PDF: $e ===');
      setState(() {
        _error = 'Erro ao carregar o PDF: $e';
      });
    }
  }

  Future<void> _sharePdf() async {
    if (_pdfPath != null && _pdfPath!.isNotEmpty) {
      try {
        final file = File(_pdfPath!);
        if (file.existsSync()) {
          await Share.shareXFiles(
            [XFile(_pdfPath!)],
            text: 'Prontuário do Beneficiário - ${fileName ?? 'prontuario.pdf'}',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Arquivo PDF não encontrado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao compartilhar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          'Prontuário',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: MediaQuery.of(context).size.width / 20,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: _pdfPath != null && _error == null
          ? FloatingActionButton(
              onPressed: _sharePdf,
              backgroundColor: Themes.verdeBotao,
              foregroundColor: Colors.white,
              tooltip: 'Compartilhar PDF',
              child: const Icon(Icons.share),
            )
          : null,
      body: _error != null
          ? Center(
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
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Modular.to.pop(),
                    child: const Text('Voltar'),
                  ),
                ],
              ),
            )
          : _pdfPath != null
              ? Column(
                  children: [
                    // Header com informações do arquivo
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[100],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prontuário do Beneficiário',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (fileName != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Arquivo: $fileName',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (beneficiarioId != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'ID: $beneficiarioId',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (_totalPages > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.description,
                                  size: 16,
                                  color: Themes.verdeBotao,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Página ${_currentPage + 1} de $_totalPages',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Themes.verdeBotao,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Visualizador do PDF
                    Expanded(
                      child: PDFView(
                        filePath: _pdfPath!,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: true,
                        pageFling: true,
                        pageSnap: true,
                        defaultPage: 0,
                        fitPolicy: FitPolicy.WIDTH,
                        preventLinkNavigation: false,
                        onRender: (pages) {
                          print('=== DEBUG: PDF renderizado com $pages páginas ===');
                          setState(() {
                            _totalPages = pages ?? 0;
                          });
                        },
                        onError: (error) {
                          print('=== DEBUG: Erro ao renderizar PDF: $error ===');
                          setState(() {
                            _error = 'Erro ao renderizar PDF: $error';
                          });
                        },
                        onPageError: (page, error) {
                          print('=== DEBUG: Erro na página $page: $error ===');
                        },
                        onPageChanged: (page, total) {
                          print('=== DEBUG: Página $page de $total ===');
                          setState(() {
                            _currentPage = page ?? 0;
                            _totalPages = total ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text('PDF não disponível.'),
                ),
    );
  }
} 