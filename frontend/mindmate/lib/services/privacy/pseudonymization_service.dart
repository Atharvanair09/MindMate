class PseudonymizationService {
  PseudonymizationService._();
  static final PseudonymizationService instance = PseudonymizationService._();

  static const List<String> _aliasPool = [
    'Knight', 'Mage', 'Ranger', 'Guardian', 'Scout',
    'Archer', 'Alchemist', 'Druid', 'Monk', 'Bard'
  ];

  static const Set<String> _knownNames = {
    'rahul', 'kartik', 'atharva', 'nair', 'sharma', 'john', 'smith', 'priya', 'patel',
    'james', 'mary', 'robert', 'patricia', 'michael', 'linda',
    'william', 'elizabeth', 'david', 'barbara', 'richard', 'susan',
    'joseph', 'jessica', 'thomas', 'sarah', 'charles', 'karen',
    'christopher', 'nancy', 'daniel', 'lisa', 'matthew', 'betty',
    'anthony', 'margaret', 'mark', 'sandra', 'donald', 'ashley',
    'steven', 'kimberly', 'paul', 'emily', 'andrew', 'donna',
    'joshua', 'michelle', 'kenneth', 'dorothy', 'kevin', 'carol',
    'brian', 'amanda', 'george', 'melissa', 'edward', 'deborah',
    'ronald', 'stephanie', 'timothy', 'rebecca', 'jason', 'sharon',
    'jeffrey', 'laura', 'ryan', 'cynthia', 'jacob', 'kathleen',
    'gary', 'amy', 'nicholas', 'shirley', 'eric', 'angela',
    'jonathan', 'helen', 'stephen', 'anna', 'larry', 'brenda',
    'justin', 'pamela', 'scott', 'nicole', 'brandon', 'emma',
    'benjamin', 'samantha', 'samuel', 'katherine', 'gregory', 'christine',
    'frank', 'debra', 'alexander', 'rachel', 'raymond', 'catherine',
    'patrick', 'carolyn', 'jack', 'janet', 'dennis', 'ruth',
    'jerry', 'maria', 'tyler', 'heather', 'aaron', 'diane',
    'jose', 'virginia', 'adam', 'julie', 'henry', 'joyce',
    'nathan', 'victoria', 'douglas', 'olivia', 'zachary', 'kelly',
    'peter', 'christina', 'kyle', 'lauren', 'walter', 'joan',
    'ethan', 'evelyn', 'jeremy', 'judith', 'harold', 'megan',
    'keith', 'cheri', 'christian', 'alice', 'roger', 'ann',
    'noah', 'jean', 'gerald', 'doris', 'carl', 'andrea',
    'terry', 'jacqueline', 'sean', 'kathryn', 'austin', 'hannah',
    'arthur', 'gloria', 'lawrence', 'teresa', 'jesse', 'martha',
    'dylan', 'sara', 'bryan', 'janice', 'joe', 'amelia',
    'jordan', 'mia', 'billy', 'chloe', 'bruce', 'eunice',
  };

  // conversationId -> mapping (name -> alias)
  final Map<String, Map<String, String>> _conversationMappings = {};
  
  // conversationId -> number of aliases used
  final Map<String, int> _conversationAliasIndex = {};

  bool isKnownName(String name) {
    return _knownNames.contains(name.toLowerCase());
  }

  Map<String, String> getAliasMapping(String conversationId) {
    return _conversationMappings[conversationId] ?? {};
  }

  String sanitizeText(String text, String conversationId) {
    _conversationMappings.putIfAbsent(conversationId, () => {});
    _conversationAliasIndex.putIfAbsent(conversationId, () => 0);

    final mapping = _conversationMappings[conversationId]!;
    
    final RegExp relRegex = RegExp(
      r'\b(?:(?:my|our|his|her|their|a|an|the|your)\s+)?(friend|teacher|parent|sibling|coworker|manager|partner|classmate|relative)\s+([A-Za-z]+)\b',
      caseSensitive: false,
    );

    String result = text.replaceAllMapped(relRegex, (match) {
      String relationship = match.group(1)!;
      String name = match.group(2)!;
      String lowerName = name.toLowerCase();

      if (_knownNames.contains(lowerName)) {
        if (!mapping.containsKey(lowerName)) {
          int index = _conversationAliasIndex[conversationId]!;
          String alias = _aliasPool[index % _aliasPool.length];
          mapping[lowerName] = alias;
          _conversationAliasIndex[conversationId] = index + 1;
        }
        
        String capRel = relationship[0].toUpperCase() + relationship.substring(1).toLowerCase();
        return '$capRel-${mapping[lowerName]}';
      }
      return match.group(0)!;
    });

    final RegExp wordRegex = RegExp(r'\b[A-Za-z]+\b');
    result = result.replaceAllMapped(wordRegex, (match) {
      String word = match.group(0)!;
      String lowerWord = word.toLowerCase();
      
      if (_knownNames.contains(lowerWord)) {
        if (!mapping.containsKey(lowerWord)) {
          int index = _conversationAliasIndex[conversationId]!;
          String alias = _aliasPool[index % _aliasPool.length];
          mapping[lowerWord] = alias;
          _conversationAliasIndex[conversationId] = index + 1;
        }
        return mapping[lowerWord]!;
      }
      return word;
    });

    return result;
  }
}
