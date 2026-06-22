import 'dart:math';

/// Result of analyzing a journal entry's emotional content.
class JournalAnalysisResult {
  /// Overall sentiment: -1.0 (very negative) to +1.0 (very positive)
  final double sentimentScore;

  /// Stress level: 0.0 (no stress) to 1.0 (extreme stress)
  final double stressScore;

  /// Energy level: 0.0 (exhausted) to 1.0 (very energetic)
  final double energyScore;

  /// Detected emotional keywords from the text
  final List<String> emotionalKeywords;

  /// When the analysis was performed
  final DateTime analysisTimestamp;

  JournalAnalysisResult({
    required this.sentimentScore,
    required this.stressScore,
    required this.energyScore,
    required this.emotionalKeywords,
    required this.analysisTimestamp,
  });

  @override
  String toString() =>
      'JournalAnalysisResult(sentiment: ${sentimentScore.toStringAsFixed(3)}, '
      'stress: ${stressScore.toStringAsFixed(3)}, '
      'energy: ${energyScore.toStringAsFixed(3)}, '
      'keywords: $emotionalKeywords)';
}

/// On-device, privacy-first sentiment analyzer using a weighted keyword lexicon.
///
/// No data leaves the device. No external API calls. Deterministic output.
/// Uses AFINN-style scoring with negation awareness and dedicated
/// stress / energy sub-lexicons.
class JournalSentimentAnalyzer {
  // Singleton
  static final JournalSentimentAnalyzer instance =
      JournalSentimentAnalyzer._internal();
  JournalSentimentAnalyzer._internal();

  // ──────────────────────────────────────────────
  // Negation words – flip the sign of the next token
  // ──────────────────────────────────────────────
  static const Set<String> _negators = {
    'not', "n't", 'no', 'never', 'neither', 'nobody', 'nothing',
    'nowhere', 'nor', 'cannot', "can't", "won't", "wouldn't",
    "shouldn't", "couldn't", "don't", "doesn't", "didn't",
    "isn't", "aren't", "wasn't", "weren't", 'hardly', 'barely',
    'scarcely', 'seldom', 'without',
  };

  // ──────────────────────────────────────────────
  // Sentiment Lexicon  (word → weight in [-5, +5])
  // ──────────────────────────────────────────────
  static const Map<String, double> _sentimentLexicon = {
    // ── Strong negative ──
    'terrible': -4, 'horrible': -4, 'awful': -4, 'dreadful': -4,
    'miserable': -4, 'depressed': -4, 'devastated': -4, 'hopeless': -4,
    'suicidal': -5, 'worthless': -4, 'desperate': -4, 'agonizing': -4,
    'unbearable': -4, 'tormented': -4, 'suffering': -4, 'nightmare': -4,
    'hate': -4, 'hated': -4, 'loathe': -4, 'despise': -4, 'abhor': -4,
    'worst': -4, 'destroyed': -4, 'ruined': -4, 'broken': -3,

    // ── Moderate negative ──
    'bad': -3, 'sad': -3, 'unhappy': -3, 'upset': -3, 'angry': -3,
    'frustrated': -3, 'annoyed': -3, 'irritated': -3, 'disappointed': -3,
    'stressed': -3, 'anxious': -3, 'worried': -3, 'nervous': -3,
    'afraid': -3, 'scared': -3, 'fearful': -3, 'lonely': -3,
    'isolated': -3, 'overwhelmed': -3, 'exhausted': -3, 'tired': -2,
    'fatigued': -3, 'drained': -3, 'burnt': -3, 'burnout': -3,
    'pain': -3, 'painful': -3, 'hurt': -3, 'crying': -3, 'cried': -3,
    'cry': -2, 'sob': -3, 'grief': -3, 'mourning': -3, 'lost': -2,
    'confused': -2, 'helpless': -3, 'trapped': -3, 'stuck': -2,
    'failure': -3, 'failed': -3, 'fail': -2, 'rejected': -3,
    'abandoned': -3, 'neglected': -3, 'ignored': -2, 'insecure': -2,
    'doubtful': -2, 'guilty': -3, 'ashamed': -3, 'embarrassed': -2,
    'regret': -3, 'remorse': -3, 'resentful': -3, 'bitter': -2,
    'jealous': -2, 'envious': -2, 'disgusted': -3, 'numb': -2,
    'empty': -2, 'void': -2, 'dark': -1, 'gloomy': -2, 'bleak': -3,
    'difficult': -2, 'hard': -1, 'tough': -1, 'struggle': -2,
    'struggling': -2, 'suffer': -3, 'agitated': -2, 'restless': -2,
    'tense': -2, 'panicked': -3, 'panic': -3, 'terrified': -4,
    'suck': -2, 'sucks': -2,
    'worse': -3, 'worsening': -3, 'declining': -2, 'deteriorating': -3,
    'negative': -2, 'pessimistic': -2, 'hopelessness': -4,
    'sleepless': -2, 'insomnia': -3,

    // ── Mild negative ──
    'bored': -1, 'boring': -1, 'dull': -1, 'meh': -1, 'blah': -1,
    'uneasy': -1, 'uncomfortable': -1, 'unsure': -1, 'uncertain': -1,
    'lazy': -1, 'sluggish': -1, 'slow': -1, 'distracted': -1,

    // ── Strong positive ──
    'amazing': 4, 'wonderful': 4, 'fantastic': 4, 'excellent': 4,
    'outstanding': 4, 'incredible': 4, 'brilliant': 4, 'magnificent': 4,
    'superb': 4, 'marvelous': 4, 'extraordinary': 4, 'phenomenal': 4,
    'ecstatic': 5, 'elated': 4, 'overjoyed': 4, 'thrilled': 4,
    'euphoric': 5, 'blissful': 4, 'blessed': 3, 'love': 3,
    'loved': 3, 'adore': 4, 'perfect': 4, 'best': 4,
    'paradise': 4, 'heavenly': 4,

    // ── Moderate positive ──
    'good': 2, 'great': 3, 'happy': 3, 'glad': 2, 'pleased': 2,
    'joyful': 3, 'cheerful': 3, 'delighted': 3, 'content': 2,
    'satisfied': 2, 'grateful': 3, 'thankful': 3, 'appreciative': 2,
    'excited': 3, 'enthusiastic': 3, 'eager': 2, 'motivated': 3,
    'inspired': 3, 'creative': 2, 'productive': 2, 'accomplished': 3,
    'proud': 3, 'confident': 3, 'strong': 2, 'empowered': 3,
    'hopeful': 3, 'optimistic': 3, 'positive': 2, 'bright': 2,
    'peaceful': 3, 'calm': 2, 'relaxed': 2, 'serene': 3,
    'comfortable': 2, 'safe': 2, 'secure': 2, 'warm': 1,
    'caring': 2, 'kind': 2, 'generous': 2, 'compassionate': 2,
    'supportive': 2, 'encouraging': 2, 'fun': 2, 'enjoyable': 2,
    'enjoy': 2, 'enjoyed': 2, 'beautiful': 3, 'lovely': 3,
    'nice': 1, 'pleasant': 2, 'refreshed': 2, 'rejuvenated': 3,
    'energized': 3, 'energetic': 3, 'vibrant': 3, 'alive': 2,
    'well': 1, 'better': 2, 'improving': 2, 'progress': 2,
    'successful': 3, 'success': 3, 'achieved': 3, 'achievement': 3,
    'win': 2, 'won': 2, 'victory': 3, 'triumph': 3,
    'focused': 2, 'determined': 2, 'resilient': 3,

    // ── Mild positive ──
    'okay': 1, 'ok': 1, 'fine': 1, 'alright': 1, 'decent': 1,
    'fair': 1, 'interesting': 1, 'curious': 1, 'engaged': 1,
    'steady': 1, 'stable': 1, 'balanced': 1, 'normal': 0,
  };

  // ──────────────────────────────────────────────
  // Stress Lexicon  (word → weight 0–5, higher = more stress)
  // ──────────────────────────────────────────────
  static const Map<String, double> _stressLexicon = {
    'stressed': 4, 'stress': 4, 'stressful': 4, 'pressure': 3,
    'overwhelmed': 4, 'overloaded': 4, 'overworked': 4, 'burnout': 5,
    'burnt': 4, 'deadline': 3, 'deadlines': 3, 'exam': 3, 'exams': 3,
    'test': 2, 'tests': 2, 'assignment': 2, 'assignments': 2,
    'anxious': 4, 'anxiety': 4, 'worried': 3, 'worry': 3, 'worrying': 3,
    'panicked': 4, 'panic': 4, 'nervous': 3, 'tense': 3, 'tension': 3,
    'frustrated': 3, 'frustrating': 3, 'frustration': 3,
    'angry': 3, 'furious': 4, 'rage': 4, 'irritated': 2,
    'sleepless': 3, 'insomnia': 4, 'restless': 3,
    'rushing': 3, 'rush': 2, 'hurry': 2, 'chaotic': 3, 'chaos': 3,
    'crisis': 4, 'emergency': 4, 'urgent': 3,
    'conflict': 3, 'argue': 2, 'argument': 3, 'fight': 3,
    'demanding': 3, 'intense': 2, 'hectic': 3,
    'helpless': 4, 'hopeless': 4, 'desperate': 4, 'trapped': 4,
    'stuck': 2, 'struggling': 3, 'struggle': 3,
    'difficult': 2, 'tough': 2, 'hard': 1, 'challenging': 2,
    'burden': 3, 'suffering': 4, 'agitated': 3,
    // Anti-stress (negative stress markers)
    'relaxed': -3, 'calm': -3, 'peaceful': -3, 'serene': -3,
    'tranquil': -3, 'chill': -2, 'easygoing': -2, 'carefree': -3,
    'zen': -2, 'meditated': -2, 'meditation': -2,
  };

  // ──────────────────────────────────────────────
  // Energy Lexicon  (word → weight -5 to +5)
  // Positive = high energy, negative = low energy
  // ──────────────────────────────────────────────
  static const Map<String, double> _energyLexicon = {
    // Low energy (negative values)
    'exhausted': -4, 'tired': -3, 'fatigued': -4, 'drained': -4,
    'sleepy': -3, 'drowsy': -3, 'lethargic': -4, 'sluggish': -3,
    'weak': -3, 'weary': -3, 'burnt': -3, 'burnout': -4,
    'numb': -2, 'flat': -2, 'lifeless': -4, 'depleted': -4,
    'lazy': -2, 'unmotivated': -3, 'apathetic': -3, 'listless': -3,
    'heavy': -2, 'slow': -2, 'collapsed': -4, 'crashed': -3,
    'insomnia': -3, 'sleepless': -3, "couldn't sleep": -3,
    'sleep': -1, // Mentioning sleep often = concern about it

    // High energy (positive values)
    'energized': 4, 'energetic': 4, 'active': 3, 'vibrant': 3,
    'alive': 3, 'refreshed': 3, 'rejuvenated': 4, 'invigorated': 4,
    'motivated': 3, 'driven': 3, 'inspired': 3, 'pumped': 3,
    'excited': 3, 'enthusiastic': 3, 'eager': 2, 'dynamic': 3,
    'strong': 2, 'powerful': 3, 'productive': 3, 'focused': 2,
    'alert': 2, 'awake': 2, 'rested': 3, 'slept well': 3,
    'exercise': 2, 'exercised': 3, 'workout': 3, 'ran': 2,
    'running': 2, 'gym': 2, 'walked': 1, 'walk': 1,
  };

  /// Analyze a text and return a full analysis result.
  JournalAnalysisResult analyzeText(String text) {
    if (text.trim().isEmpty) {
      return JournalAnalysisResult(
        sentimentScore: 0.0,
        stressScore: 0.0,
        energyScore: 0.5,
        emotionalKeywords: [],
        analysisTimestamp: DateTime.now(),
      );
    }

    final normalizedText = text.toLowerCase();
    final words = _tokenize(normalizedText);

    // ── Sentiment ──
    final sentimentResult = _scoreLexicon(words, _sentimentLexicon);
    final rawSentiment = sentimentResult.score;
    final sentimentKeywords = sentimentResult.keywords;

    // ── Stress ──
    final stressResult = _scoreLexicon(words, _stressLexicon);
    final rawStress = stressResult.score;
    final stressKeywords = stressResult.keywords;

    // ── Energy ──
    final energyResult = _scoreLexicon(words, _energyLexicon);
    final rawEnergy = energyResult.score;
    final energyKeywords = energyResult.keywords;

    // Normalize scores
    final sentimentScore = _normalizeSentiment(rawSentiment, words.length);
    final stressScore = _normalizeStress(rawStress, words.length);
    final energyScore = _normalizeEnergy(rawEnergy, words.length);

    // Collect unique keywords
    final allKeywords = <String>{
      ...sentimentKeywords,
      ...stressKeywords,
      ...energyKeywords,
    }.toList()
      ..sort();

    return JournalAnalysisResult(
      sentimentScore: sentimentScore,
      stressScore: stressScore,
      energyScore: energyScore,
      emotionalKeywords: allKeywords.take(10).toList(),
      analysisTimestamp: DateTime.now(),
    );
  }

  /// Tokenize text into words, preserving contractions.
  List<String> _tokenize(String text) {
    // Replace common punctuation but keep apostrophes in contractions
    final cleaned = text
        .replaceAll(RegExp(r"[^\w\s'\-]"), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return cleaned.split(' ').where((w) => w.isNotEmpty).toList();
  }

  /// Score a token list against a lexicon, handling negation.
  ({double score, List<String> keywords}) _scoreLexicon(
      List<String> words, Map<String, double> lexicon) {
    double totalScore = 0;
    final keywords = <String>[];
    bool negateNext = false;
    int negateWindow = 0; // How many words the negation covers

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      // Check for negation
      if (_negators.contains(word) ||
          (word.endsWith("n't") && word.length > 3)) {
        negateNext = true;
        negateWindow = 3; // Negation affects next 3 words
        continue;
      }

      // Check bigrams (current + next word)
      if (i < words.length - 1) {
        final bigram = '$word ${words[i + 1]}';
        if (lexicon.containsKey(bigram)) {
          double score = lexicon[bigram]!;
          if (negateNext) {
            score = -score * 0.75; // Negation dampens slightly
          }
          totalScore += score;
          keywords.add(negateNext ? 'NOT $bigram' : bigram);
          i++; // Skip next word
          if (negateNext) {
            negateWindow--;
            if (negateWindow <= 0) negateNext = false;
          }
          continue;
        }
      }

      // Check single word
      if (lexicon.containsKey(word)) {
        double score = lexicon[word]!;
        if (negateNext) {
          score = -score * 0.75;
        }
        totalScore += score;
        keywords.add(negateNext ? 'NOT $word' : word);
      }

      // Decrement negation window
      if (negateNext) {
        negateWindow--;
        if (negateWindow <= 0) negateNext = false;
      }
    }

    return (score: totalScore, keywords: keywords);
  }

  /// Normalize sentiment to [-1.0, +1.0] using sigmoid-like scaling.
  double _normalizeSentiment(double rawScore, int wordCount) {
    if (wordCount == 0) return 0.0;
    // Scale by word count to be fair to short vs long entries
    final adjusted = rawScore / max(1, sqrt(wordCount));
    // Sigmoid mapping to [-1, 1]
    final normalized = (2.0 / (1.0 + exp(-adjusted * 0.5))) - 1.0;
    return double.parse(normalized.clamp(-1.0, 1.0).toStringAsFixed(4));
  }

  /// Normalize stress to [0.0, 1.0].
  double _normalizeStress(double rawScore, int wordCount) {
    if (wordCount == 0) return 0.0;
    final adjusted = rawScore / max(1, sqrt(wordCount));
    // Map positive raw stress to [0, 1]
    final normalized = 1.0 / (1.0 + exp(-adjusted * 0.6));
    // Shift so that 0 raw → 0.15 (slight baseline), not 0.5
    final shifted = ((normalized - 0.5) * 1.7).clamp(0.0, 1.0);
    return double.parse(shifted.toStringAsFixed(4));
  }

  /// Normalize energy to [0.0, 1.0].
  /// Positive raw energy → high energy, negative → low energy.
  double _normalizeEnergy(double rawScore, int wordCount) {
    if (wordCount == 0) return 0.5; // Neutral
    final adjusted = rawScore / max(1, sqrt(wordCount));
    // Sigmoid to [0, 1]
    final normalized = 1.0 / (1.0 + exp(-adjusted * 0.6));
    return double.parse(normalized.clamp(0.0, 1.0).toStringAsFixed(4));
  }
}

