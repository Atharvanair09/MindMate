class UsernamePrivacyValidation {
  final bool isValid;
  final String? reason;

  UsernamePrivacyValidation({required this.isValid, this.reason});
}

class UsernamePrivacyService {
  UsernamePrivacyService._();
  static final UsernamePrivacyService instance = UsernamePrivacyService._();

  static const List<String> _blockedNameTokens = [
    'atharva', 'nair',
    'rahul', 'sharma',
    'john', 'smith',
    'priya', 'patel',
    // Expanded common names
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
  ];

  UsernamePrivacyValidation validateUsername(String username) {
    if (username.isEmpty) {
      return UsernamePrivacyValidation(
        isValid: false,
        reason: 'Username cannot be empty.',
      );
    }

    // 1. Check for First Last pattern (e.g. "John Smith")
    if (RegExp(r'^[A-Z][a-zA-Z]+ [A-Z][a-zA-Z]+$').hasMatch(username)) {
      return UsernamePrivacyValidation(
        isValid: false,
        reason: 'For privacy reasons, usernames should not contain real names.\n\nPlease choose an anonymous nickname.',
      );
    }

    // 2. Tokenize by space, underscore, or camel case and check against blocked names
    // Example: "RahulSharma" -> "Rahul Sharma"
    final normalized = username.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2');
    final tokens = normalized.toLowerCase().split(RegExp(r'[\s_]+'));

    for (var token in tokens) {
      if (_blockedNameTokens.contains(token)) {
        return UsernamePrivacyValidation(
          isValid: false,
          reason: 'For privacy reasons, usernames should not contain real names.\n\nPlease choose an anonymous nickname.',
        );
      }
    }
    
    // Check if it's multiple capitalized words that wasn't caught by the dictionary but resembles a name format (First Last) without spaces
    // e.g. "DavidJohnson" which is split into tokens. If it has exactly two words and both are typical name length, it might be a name.
    // However, "ShadowFox" would also match this. We will rely on the dictionary. The problem says "Contain multiple capitalized words resembling a real name". 
    // The dictionary handles this if at least one token is in the dictionary.

    // 3. Obvious personal identity patterns
    if (RegExp(r'\d{3}-\d{2}-\d{4}').hasMatch(username) || // SSN
        RegExp(r'\d{10}').hasMatch(username) || // Phone
        username.contains('@')) { // Email
      return UsernamePrivacyValidation(
        isValid: false,
        reason: 'For privacy reasons, usernames should not contain real names.\n\nPlease choose an anonymous nickname.',
      );
    }

    return UsernamePrivacyValidation(isValid: true);
  }
}
