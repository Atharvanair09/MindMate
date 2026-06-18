// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInterventionLogCollection on Isar {
  IsarCollection<InterventionLog> get interventionLogs => this.collection();
}

const InterventionLogSchema = CollectionSchema(
  name: r'InterventionLog',
  id: 7864765470651090979,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'improvement': PropertySchema(
      id: 1,
      name: r'improvement',
      type: IsarType.string,
    ),
    r'interventionType': PropertySchema(
      id: 2,
      name: r'interventionType',
      type: IsarType.string,
    ),
    r'postMood': PropertySchema(
      id: 3,
      name: r'postMood',
      type: IsarType.string,
    ),
    r'preMood': PropertySchema(
      id: 4,
      name: r'preMood',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 5,
      name: r'startedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _interventionLogEstimateSize,
  serialize: _interventionLogSerialize,
  deserialize: _interventionLogDeserialize,
  deserializeProp: _interventionLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _interventionLogGetId,
  getLinks: _interventionLogGetLinks,
  attach: _interventionLogAttach,
  version: '3.1.0+1',
);

int _interventionLogEstimateSize(
  InterventionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.improvement;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.interventionType.length * 3;
  {
    final value = object.postMood;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.preMood;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _interventionLogSerialize(
  InterventionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeString(offsets[1], object.improvement);
  writer.writeString(offsets[2], object.interventionType);
  writer.writeString(offsets[3], object.postMood);
  writer.writeString(offsets[4], object.preMood);
  writer.writeDateTime(offsets[5], object.startedAt);
}

InterventionLog _interventionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InterventionLog();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.improvement = reader.readStringOrNull(offsets[1]);
  object.interventionType = reader.readString(offsets[2]);
  object.postMood = reader.readStringOrNull(offsets[3]);
  object.preMood = reader.readStringOrNull(offsets[4]);
  object.startedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _interventionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _interventionLogGetId(InterventionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _interventionLogGetLinks(InterventionLog object) {
  return [];
}

void _interventionLogAttach(
    IsarCollection<dynamic> col, Id id, InterventionLog object) {
  object.id = id;
}

extension InterventionLogQueryWhereSort
    on QueryBuilder<InterventionLog, InterventionLog, QWhere> {
  QueryBuilder<InterventionLog, InterventionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InterventionLogQueryWhere
    on QueryBuilder<InterventionLog, InterventionLog, QWhereClause> {
  QueryBuilder<InterventionLog, InterventionLog, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InterventionLog, InterventionLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterWhereClause> idBetween(
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

extension InterventionLogQueryFilter
    on QueryBuilder<InterventionLog, InterventionLog, QFilterCondition> {
  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
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

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
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

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'improvement',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'improvement',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'improvement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'improvement',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'improvement',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'improvement',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      improvementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'improvement',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interventionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'interventionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'interventionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interventionType',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      interventionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'interventionType',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'postMood',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'postMood',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'postMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'postMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'postMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'postMood',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      postMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'postMood',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preMood',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preMood',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preMood',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      preMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preMood',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterFilterCondition>
      startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension InterventionLogQueryObject
    on QueryBuilder<InterventionLog, InterventionLog, QFilterCondition> {}

extension InterventionLogQueryLinks
    on QueryBuilder<InterventionLog, InterventionLog, QFilterCondition> {}

extension InterventionLogQuerySortBy
    on QueryBuilder<InterventionLog, InterventionLog, QSortBy> {
  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByImprovement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'improvement', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByImprovementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'improvement', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByInterventionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionType', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByInterventionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionType', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByPostMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postMood', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByPostMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postMood', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy> sortByPreMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preMood', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByPreMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preMood', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }
}

extension InterventionLogQuerySortThenBy
    on QueryBuilder<InterventionLog, InterventionLog, QSortThenBy> {
  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByImprovement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'improvement', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByImprovementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'improvement', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByInterventionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionType', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByInterventionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionType', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByPostMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postMood', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByPostMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'postMood', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy> thenByPreMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preMood', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByPreMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preMood', Sort.desc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }
}

extension InterventionLogQueryWhereDistinct
    on QueryBuilder<InterventionLog, InterventionLog, QDistinct> {
  QueryBuilder<InterventionLog, InterventionLog, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QDistinct>
      distinctByImprovement({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'improvement', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QDistinct>
      distinctByInterventionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interventionType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QDistinct> distinctByPostMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'postMood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QDistinct> distinctByPreMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preMood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionLog, InterventionLog, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }
}

extension InterventionLogQueryProperty
    on QueryBuilder<InterventionLog, InterventionLog, QQueryProperty> {
  QueryBuilder<InterventionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InterventionLog, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<InterventionLog, String?, QQueryOperations>
      improvementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'improvement');
    });
  }

  QueryBuilder<InterventionLog, String, QQueryOperations>
      interventionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interventionType');
    });
  }

  QueryBuilder<InterventionLog, String?, QQueryOperations> postMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'postMood');
    });
  }

  QueryBuilder<InterventionLog, String?, QQueryOperations> preMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preMood');
    });
  }

  QueryBuilder<InterventionLog, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }
}
