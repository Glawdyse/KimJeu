import 'dart:io';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf_text/pdf_text.dart';

class PdfUtils {
  /// Extraction depuis des BYTES (fiable Windows/macOS/Linux/Android/iOS)
  static Future<String> extractTextFromBytes(Uint8List bytes) async {
    // 1) Syncfusion depuis bytes
    try {
      final document = PdfDocument(inputBytes: bytes);
      final extractor = PdfTextExtractor(document);
      final buffer = StringBuffer();
      for (int i = 0; i < document.pages.count; i++) {
        final pageText =
            extractor.extractText(startPageIndex: i, endPageIndex: i) ?? '';
        if (pageText.trim().isNotEmpty) buffer.writeln(pageText);
      }
      document.dispose();
      final text = _postProcess(buffer.toString());
      if (text.isNotEmpty && text.trim().length >= 20) return text;
    } catch (_) {
      // ignore pour fallback
    }

    // 2) Fallback pdf_text: nécessite un chemin => on écrit un temp
    try {
      final tempDir = Directory.systemTemp;
      final tempFile =
      File('${tempDir.path}/mq_pdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await tempFile.writeAsBytes(bytes, flush: true);
      try {
        final doc = await PDFDoc.fromPath(tempFile.path);
        final text = await doc.text;
        final processed = _postProcess(text);
        if (processed.isNotEmpty && processed.trim().length >= 20) {
          return processed;
        }
      } finally {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
    } catch (_) {}

    throw Exception(
      'Impossible d’extraire le texte du PDF (bytes). Le document semble être scanné (images) '
          'ou protégé/endommagé. Utilise un PDF “texte” (OCR activé).',
    );
  }

  /// Extraction depuis un CHEMIN (si disponible)
  static Future<String> extractTextFromPath(String path, {String? password}) async {
    final file = File(path);
    if (!await file.exists()) {
      throw Exception('Fichier introuvable: $path');
    }

    // 1) Syncfusion via fichier
    try {
      final bytes = await file.readAsBytes();
      PdfDocument document;
      try {
        document = PdfDocument(inputBytes: bytes);
      } catch (_) {
        if (password != null) {
          document = PdfDocument(inputBytes: bytes, password: password);
        } else {
          document = PdfDocument(inputBytes: bytes, password: '');
        }
      }
      final extractor = PdfTextExtractor(document);
      final buffer = StringBuffer();
      for (int i = 0; i < document.pages.count; i++) {
        final pageText =
            extractor.extractText(startPageIndex: i, endPageIndex: i) ?? '';
        if (pageText.trim().isNotEmpty) buffer.writeln(pageText);
      }
      document.dispose();

      final text = _postProcess(buffer.toString());
      if (text.isNotEmpty && text.trim().length >= 20) return text;
    } catch (_) {
      // ignore pour fallback
    }

    // 2) Fallback pdf_text
    try {
      final doc = await PDFDoc.fromPath(path);
      final text = await doc.text;
      final processed = _postProcess(text);
      if (processed.isNotEmpty && processed.trim().length >= 20) return processed;
    } catch (_) {}

    throw Exception(
      'Impossible d’extraire le texte du PDF. Le document semble être scanné (images) '
          'ou protégé/endommagé. Utilise un PDF “texte” (OCR activé).',
    );
  }

  static String _postProcess(String input) {
    final cleaned =
    input.replaceAll(RegExp(r'[^\x09\x0A\x0D\x20-\x7E\u0080-\uFFFF]'), ' ');
    final squashed = cleaned
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    return squashed.length > 20000 ? squashed.substring(0, 20000) : squashed;
  }
}