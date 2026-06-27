// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pattern_insight.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPatternInsightCollection on Isar {
  IsarCollection<PatternInsight> get patternInsights => this.collection();
}

const PatternInsightSchema = CollectionSchema(
  name: r'PatternInsight',
  id: -7369783964514393551,
  properties: {
    r'associationType': PropertySchema(
      id: 0,
      name: r'associationType',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 1,
      name: r'confidence',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'generatedAt': PropertySchema(
      id: 3,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'isDemoData': PropertySchema(
      id: 4,
      name: r'isDemoData',
      type: IsarType.bool,
    ),
    r'patternName': PropertySchema(
      id: 5,
      name: r'patternName',
      type: IsarType.string,
    ),
    r'supportingEvidence': PropertySchema(
      id: 6,
      name: r'supportingEvidence',
      type: IsarType.long,
    )
  },
  estimateSize: _patternInsightEstimateSize,
  serialize: _patternInsightSerialize,
  deserialize: _patternInsightDeserialize,
  deserializeProp: _patternInsightDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _patternInsightGetId,
  getLinks: _patternInsightGetLinks,
  attach: _patternInsightAttach,
  version: '3.1.0+1',
);

int _patternInsightEstimateSize(
  PatternInsight object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.associationType.length * 3;
  bytesCount += 3 + object.confidence.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.patternName.length * 3;
  return bytesCount;
}

void _patternInsightSerialize(
  PatternInsight object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.associationType);
  writer.writeString(offsets[1], object.confidence);
  writer.writeString(offsets[2], object.description);
  writer.writeDateTime(offsets[3], object.generatedAt);
  writer.writeBool(offsets[4], object.isDemoData);
  writer.writeString(offsets[5], object.patternName);
  writer.writeLong(offsets[6], object.supportingEvidence);
}

PatternInsight _patternInsightDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PatternInsight();
  object.associationType = reader.readString(offsets[0]);
  object.confidence = reader.readString(offsets[1]);
  object.description = reader.readString(offsets[2]);
  object.generatedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isDemoData = reader.readBool(offsets[4]);
  object.patternName = reader.readString(offsets[5]);
  object.supportingEvidence = reader.readLong(offsets[6]);
  return object;
}

P _patternInsightDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _patternInsightGetId(PatternInsight object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _patternInsightGetLinks(PatternInsight object) {
  return [];
}

void _patternInsightAttach(
    IsarCollection<dynamic> col, Id id, PatternInsight object) {
  object.id = id;
}

extension PatternInsightQueryWhereSort
    on QueryBuilder<PatternInsight, PatternInsight, QWhere> {
  QueryBuilder<PatternInsight, PatternInsight, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PatternInsightQueryWhere
    on QueryBuilder<PatternInsight, PatternInsight, QWhereClause> {
  QueryBuilder<PatternInsight, PatternInsight, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PatternInsightQueryFilter
    on QueryBuilder<PatternInsight, PatternInsight, QFilterCondition> {
  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'associationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'associationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'associationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'associationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      associationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'associationType',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'confidence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'confidence',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      confidenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'confidence',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      isDemoDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDemoData',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'patternName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'patternName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'patternName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'patternName',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      patternNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'patternName',
        value: '',
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      supportingEvidenceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supportingEvidence',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      supportingEvidenceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supportingEvidence',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      supportingEvidenceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supportingEvidence',
        value: value,
      ));
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterFilterCondition>
      supportingEvidenceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supportingEvidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PatternInsightQueryObject
    on QueryBuilder<PatternInsight, PatternInsight, QFilterCondition> {}

extension PatternInsightQueryLinks
    on QueryBuilder<PatternInsight, PatternInsight, QFilterCondition> {}

extension PatternInsightQuerySortBy
    on QueryBuilder<PatternInsight, PatternInsight, QSortBy> {
  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByAssociationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associationType', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByAssociationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associationType', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByPatternName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternName', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortByPatternNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternName', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortBySupportingEvidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportingEvidence', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      sortBySupportingEvidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportingEvidence', Sort.desc);
    });
  }
}

extension PatternInsightQuerySortThenBy
    on QueryBuilder<PatternInsight, PatternInsight, QSortThenBy> {
  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByAssociationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associationType', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByAssociationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'associationType', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByPatternName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternName', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenByPatternNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'patternName', Sort.desc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenBySupportingEvidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportingEvidence', Sort.asc);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QAfterSortBy>
      thenBySupportingEvidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportingEvidence', Sort.desc);
    });
  }
}

extension PatternInsightQueryWhereDistinct
    on QueryBuilder<PatternInsight, PatternInsight, QDistinct> {
  QueryBuilder<PatternInsight, PatternInsight, QDistinct>
      distinctByAssociationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'associationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct> distinctByConfidence(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct>
      distinctByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDemoData');
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct> distinctByPatternName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'patternName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PatternInsight, PatternInsight, QDistinct>
      distinctBySupportingEvidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportingEvidence');
    });
  }
}

extension PatternInsightQueryProperty
    on QueryBuilder<PatternInsight, PatternInsight, QQueryProperty> {
  QueryBuilder<PatternInsight, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PatternInsight, String, QQueryOperations>
      associationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'associationType');
    });
  }

  QueryBuilder<PatternInsight, String, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<PatternInsight, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<PatternInsight, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<PatternInsight, bool, QQueryOperations> isDemoDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDemoData');
    });
  }

  QueryBuilder<PatternInsight, String, QQueryOperations> patternNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'patternName');
    });
  }

  QueryBuilder<PatternInsight, int, QQueryOperations>
      supportingEvidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportingEvidence');
    });
  }
}
