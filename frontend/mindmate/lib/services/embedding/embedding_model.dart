import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'dart:typed_data';
import 'dart:math';

class SimpleTokenizer {
  final Map<String, int> vocab;
  final int maxLen;

  SimpleTokenizer(this.vocab, {this.maxLen = 512});

  List<int> tokenize(String text) {
    text = text.toLowerCase();
    // simple punctuation splitting
    text = text.replaceAllMapped(RegExp(r'([^\w\s])'), (m) => ' ${m[1]} ');
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    List<int> tokens = [vocab['[CLS]'] ?? 101];

    for (var word in words) {
      if (tokens.length >= maxLen - 1) break;
      
      var chars = word.split('');
      var start = 0;
      while (start < chars.length) {
        var end = chars.length;
        var found = false;
        while (start < end) {
          var substr = chars.sublist(start, end).join('');
          if (start > 0) substr = '##$substr';
          
          if (vocab.containsKey(substr)) {
            tokens.add(vocab[substr]!);
            start = end;
            found = true;
            break;
          }
          end--;
        }
        if (!found) {
          tokens.add(vocab['[UNK]'] ?? 100);
          break;
        }
        if (tokens.length >= maxLen - 1) break;
      }
    }

    tokens.add(vocab['[SEP]'] ?? 102);
    return tokens;
  }
}

class EmbeddingModel {
  OrtSession? _session;
  SimpleTokenizer? _tokenizer;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    OrtEnv.instance.init();
    
    // Load vocab
    final vocabString = await rootBundle.loadString('assets/models/vocab.txt');
    final lines = vocabString.split('\n');
    final vocab = <String, int>{};
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty) vocab[line] = i;
    }
    _tokenizer = SimpleTokenizer(vocab);

    // Load model
    final rawAssetFile = await rootBundle.load('assets/models/model.onnx');
    final bytes = rawAssetFile.buffer.asUint8List();
    _session = OrtSession.fromBuffer(bytes, OrtSessionOptions());

    _isInitialized = true;
  }

  void release() {
    _session?.release();
    OrtEnv.instance.release();
    _isInitialized = false;
  }

  Future<List<double>> generateAsync(String text) async {
    if (!_isInitialized || _session == null || _tokenizer == null) {
      throw Exception('Model not initialized');
    }

    final tokens = _tokenizer!.tokenize(text);
    final inputIds = Int64List.fromList(tokens);
    final attentionMask = Int64List.fromList(List.filled(tokens.length, 1));
    final tokenTypeIds = Int64List.fromList(List.filled(tokens.length, 0));

    final inputIdsTensor = OrtValueTensor.createTensorWithDataList(inputIds, [1, tokens.length]);
    final attentionMaskTensor = OrtValueTensor.createTensorWithDataList(attentionMask, [1, tokens.length]);
    final tokenTypeIdsTensor = OrtValueTensor.createTensorWithDataList(tokenTypeIds, [1, tokens.length]);

    final inputs = {
      'input_ids': inputIdsTensor,
      'attention_mask': attentionMaskTensor,
      'token_type_ids': tokenTypeIdsTensor,
    };

    final runOptions = OrtRunOptions();
    final outputs = await _session!.runAsync(runOptions, inputs);

    inputIdsTensor.release();
    attentionMaskTensor.release();
    tokenTypeIdsTensor.release();
    runOptions.release();

    final outputValue = outputs?[0]?.value;
    
    List<List<double>> sequenceOutput = [];
    if (outputValue is List) {
      final batch = outputValue[0] as List;
      for (var i = 0; i < batch.length; i++) {
        final tokenEmbeddings = (batch[i] as List).cast<double>();
        sequenceOutput.add(tokenEmbeddings);
      }
    }

    final dim = sequenceOutput.first.length;
    final pooled = List<double>.filled(dim, 0.0);
    for (var i = 0; i < sequenceOutput.length; i++) {
      for (var j = 0; j < dim; j++) {
        pooled[j] += sequenceOutput[i][j];
      }
    }
    
    double norm = 0;
    for (var j = 0; j < dim; j++) {
      pooled[j] /= sequenceOutput.length;
      norm += pooled[j] * pooled[j];
    }
    
    norm = sqrt(norm);
    if (norm > 0) {
      for (var j = 0; j < dim; j++) {
        pooled[j] /= norm;
      }
    }

    if (outputs != null) {
      for (var element in outputs) {
        element?.release();
      }
    }

    return pooled;
  }
}
