// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_reflection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyReflectionCollection on Isar {
  IsarCollection<WeeklyReflection> get weeklyReflections => this.collection();
}

const WeeklyReflectionSchema = CollectionSchema(
  name: r'WeeklyReflection',
  id: 1474801262821904417,
  properties: {
    r'averageBurnoutScore': PropertySchema(
      id: 0,
      name: r'averageBurnoutScore',
      type: IsarType.double,
    ),
    r'averageMoodScore': PropertySchema(
      id: 1,
      name: r'averageMoodScore',
      type: IsarType.double,
    ),
    r'burnoutTrend': PropertySchema(
      id: 2,
      name: r'burnoutTrend',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 3,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'generatedAt': PropertySchema(
      id: 4,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'keyPatterns': PropertySchema(
      id: 5,
      name: r'keyPatterns',
      type: IsarType.stringList,
    ),
    r'moodTrend': PropertySchema(
      id: 6,
      name: r'moodTrend',
      type: IsarType.string,
    ),
    r'negativeIndicators': PropertySchema(
      id: 7,
      name: r'negativeIndicators',
      type: IsarType.stringList,
    ),
    r'positiveIndicators': PropertySchema(
      id: 8,
      name: r'positiveIndicators',
      type: IsarType.stringList,
    ),
    r'suggestion': PropertySchema(
      id: 9,
      name: r'suggestion',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(
      id: 10,
      name: r'summary',
      type: IsarType.string,
    ),
    r'weekEndDate': PropertySchema(
      id: 11,
      name: r'weekEndDate',
      type: IsarType.dateTime,
    ),
    r'weekStartDate': PropertySchema(
      id: 12,
      name: r'weekStartDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weeklyReflectionEstimateSize,
  serialize: _weeklyReflectionSerialize,
  deserialize: _weeklyReflectionDeserialize,
  deserializeProp: _weeklyReflectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'weekStartDate': IndexSchema(
      id: 7906057668223877157,
      name: r'weekStartDate',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'weekStartDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyReflectionGetId,
  getLinks: _weeklyReflectionGetLinks,
  attach: _weeklyReflectionAttach,
  version: '3.1.0+1',
);

int _weeklyReflectionEstimateSize(
  WeeklyReflection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.burnoutTrend.length * 3;
  bytesCount += 3 + object.keyPatterns.length * 3;
  {
    for (var i = 0; i < object.keyPatterns.length; i++) {
      final value = object.keyPatterns[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.moodTrend.length * 3;
  bytesCount += 3 + object.negativeIndicators.length * 3;
  {
    for (var i = 0; i < object.negativeIndicators.length; i++) {
      final value = object.negativeIndicators[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.positiveIndicators.length * 3;
  {
    for (var i = 0; i < object.positiveIndicators.length; i++) {
      final value = object.positiveIndicators[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.suggestion.length * 3;
  bytesCount += 3 + object.summary.length * 3;
  return bytesCount;
}

void _weeklyReflectionSerialize(
  WeeklyReflection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageBurnoutScore);
  writer.writeDouble(offsets[1], object.averageMoodScore);
  writer.writeString(offsets[2], object.burnoutTrend);
  writer.writeDouble(offsets[3], object.confidence);
  writer.writeDateTime(offsets[4], object.generatedAt);
  writer.writeStringList(offsets[5], object.keyPatterns);
  writer.writeString(offsets[6], object.moodTrend);
  writer.writeStringList(offsets[7], object.negativeIndicators);
  writer.writeStringList(offsets[8], object.positiveIndicators);
  writer.writeString(offsets[9], object.suggestion);
  writer.writeString(offsets[10], object.summary);
  writer.writeDateTime(offsets[11], object.weekEndDate);
  writer.writeDateTime(offsets[12], object.weekStartDate);
}

WeeklyReflection _weeklyReflectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyReflection();
  object.averageBurnoutScore = reader.readDouble(offsets[0]);
  object.averageMoodScore = reader.readDouble(offsets[1]);
  object.burnoutTrend = reader.readString(offsets[2]);
  object.confidence = reader.readDouble(offsets[3]);
  object.generatedAt = reader.readDateTime(offsets[4]);
  object.id = id;
  object.keyPatterns = reader.readStringList(offsets[5]) ?? [];
  object.moodTrend = reader.readString(offsets[6]);
  object.negativeIndicators = reader.readStringList(offsets[7]) ?? [];
  object.positiveIndicators = reader.readStringList(offsets[8]) ?? [];
  object.suggestion = reader.readString(offsets[9]);
  object.summary = reader.readString(offsets[10]);
  object.weekEndDate = reader.readDateTime(offsets[11]);
  object.weekStartDate = reader.readDateTime(offsets[12]);
  return object;
}

P _weeklyReflectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyReflectionGetId(WeeklyReflection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyReflectionGetLinks(WeeklyReflection object) {
  return [];
}

void _weeklyReflectionAttach(
    IsarCollection<dynamic> col, Id id, WeeklyReflection object) {
  object.id = id;
}

extension WeeklyReflectionByIndex on IsarCollection<WeeklyReflection> {
  Future<WeeklyReflection?> getByWeekStartDate(DateTime weekStartDate) {
    return getByIndex(r'weekStartDate', [weekStartDate]);
  }

  WeeklyReflection? getByWeekStartDateSync(DateTime weekStartDate) {
    return getByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<bool> deleteByWeekStartDate(DateTime weekStartDate) {
    return deleteByIndex(r'weekStartDate', [weekStartDate]);
  }

  bool deleteByWeekStartDateSync(DateTime weekStartDate) {
    return deleteByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<List<WeeklyReflection?>> getAllByWeekStartDate(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'weekStartDate', values);
  }

  List<WeeklyReflection?> getAllByWeekStartDateSync(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'weekStartDate', values);
  }

  Future<int> deleteAllByWeekStartDate(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'weekStartDate', values);
  }

  int deleteAllByWeekStartDateSync(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'weekStartDate', values);
  }

  Future<Id> putByWeekStartDate(WeeklyReflection object) {
    return putByIndex(r'weekStartDate', object);
  }

  Id putByWeekStartDateSync(WeeklyReflection object, {bool saveLinks = true}) {
    return putByIndexSync(r'weekStartDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWeekStartDate(List<WeeklyReflection> objects) {
    return putAllByIndex(r'weekStartDate', objects);
  }

  List<Id> putAllByWeekStartDateSync(List<WeeklyReflection> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'weekStartDate', objects, saveLinks: saveLinks);
  }
}

extension WeeklyReflectionQueryWhereSort
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QWhere> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhere>
      anyWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekStartDate'),
      );
    });
  }
}

extension WeeklyReflectionQueryWhere
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QWhereClause> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      weekStartDateEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekStartDate',
        value: [weekStartDate],
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      weekStartDateNotEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      weekStartDateGreaterThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [weekStartDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      weekStartDateLessThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [],
        upper: [weekStartDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterWhereClause>
      weekStartDateBetween(
    DateTime lowerWeekStartDate,
    DateTime upperWeekStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [lowerWeekStartDate],
        includeLower: includeLower,
        upper: [upperWeekStartDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyReflectionQueryFilter
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QFilterCondition> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageBurnoutScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageBurnoutScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageBurnoutScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageBurnoutScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageBurnoutScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageBurnoutScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageBurnoutScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageBurnoutScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageMoodScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageMoodScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageMoodScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageMoodScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageMoodScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageMoodScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      averageMoodScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageMoodScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'burnoutTrend',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'burnoutTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'burnoutTrend',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'burnoutTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutTrendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'burnoutTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keyPatterns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keyPatterns',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keyPatterns',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keyPatterns',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keyPatterns',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      keyPatternsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keyPatterns',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodTrend',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moodTrend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moodTrend',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodTrendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moodTrend',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'negativeIndicators',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'negativeIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'negativeIndicators',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativeIndicators',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'negativeIndicators',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeIndicatorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'negativeIndicators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positiveIndicators',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'positiveIndicators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'positiveIndicators',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positiveIndicators',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'positiveIndicators',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveIndicatorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'positiveIndicators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suggestion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'suggestion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'suggestion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suggestion',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      suggestionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'suggestion',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekEndDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekEndDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekEndDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekEndDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      weekStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyReflectionQueryObject
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QFilterCondition> {}

extension WeeklyReflectionQueryLinks
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QFilterCondition> {}

extension WeeklyReflectionQuerySortBy
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QSortBy> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByAverageBurnoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageBurnoutScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByAverageBurnoutScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageBurnoutScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByAverageMoodScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMoodScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByAverageMoodScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMoodScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByBurnoutTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutTrend', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByBurnoutTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutTrend', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMoodTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMoodTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortBySuggestion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestion', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortBySuggestionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestion', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByWeekEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyReflectionQuerySortThenBy
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QSortThenBy> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByAverageBurnoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageBurnoutScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByAverageBurnoutScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageBurnoutScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByAverageMoodScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMoodScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByAverageMoodScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageMoodScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByBurnoutTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutTrend', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByBurnoutTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutTrend', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMoodTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMoodTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodTrend', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenBySuggestion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestion', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenBySuggestionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suggestion', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByWeekEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyReflectionQueryWhereDistinct
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct> {
  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByAverageBurnoutScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageBurnoutScore');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByAverageMoodScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageMoodScore');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByBurnoutTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'burnoutTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByKeyPatterns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keyPatterns');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByMoodTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByNegativeIndicators() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'negativeIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByPositiveIndicators() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positiveIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctBySuggestion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suggestion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekEndDate');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStartDate');
    });
  }
}

extension WeeklyReflectionQueryProperty
    on QueryBuilder<WeeklyReflection, WeeklyReflection, QQueryProperty> {
  QueryBuilder<WeeklyReflection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      averageBurnoutScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageBurnoutScore');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      averageMoodScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageMoodScore');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      burnoutTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'burnoutTrend');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<WeeklyReflection, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      keyPatternsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keyPatterns');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations> moodTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodTrend');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      negativeIndicatorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'negativeIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      positiveIndicatorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positiveIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      suggestionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suggestion');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<WeeklyReflection, DateTime, QQueryOperations>
      weekEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekEndDate');
    });
  }

  QueryBuilder<WeeklyReflection, DateTime, QQueryOperations>
      weekStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStartDate');
    });
  }
}
