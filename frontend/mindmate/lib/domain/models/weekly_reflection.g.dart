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
    r'baseConfidence': PropertySchema(
      id: 2,
      name: r'baseConfidence',
      type: IsarType.double,
    ),
    r'burnoutContribution': PropertySchema(
      id: 3,
      name: r'burnoutContribution',
      type: IsarType.double,
    ),
    r'burnoutTrend': PropertySchema(
      id: 4,
      name: r'burnoutTrend',
      type: IsarType.string,
    ),
    r'chatContribution': PropertySchema(
      id: 5,
      name: r'chatContribution',
      type: IsarType.double,
    ),
    r'confidence': PropertySchema(
      id: 6,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'confidenceCap': PropertySchema(
      id: 7,
      name: r'confidenceCap',
      type: IsarType.double,
    ),
    r'daysContribution': PropertySchema(
      id: 8,
      name: r'daysContribution',
      type: IsarType.double,
    ),
    r'followUpContribution': PropertySchema(
      id: 9,
      name: r'followUpContribution',
      type: IsarType.double,
    ),
    r'generatedAt': PropertySchema(
      id: 10,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'historySufficiency': PropertySchema(
      id: 11,
      name: r'historySufficiency',
      type: IsarType.string,
    ),
    r'influenceScores': PropertySchema(
      id: 12,
      name: r'influenceScores',
      type: IsarType.stringList,
    ),
    r'journalContribution': PropertySchema(
      id: 13,
      name: r'journalContribution',
      type: IsarType.double,
    ),
    r'keyPatterns': PropertySchema(
      id: 14,
      name: r'keyPatterns',
      type: IsarType.stringList,
    ),
    r'moodContribution': PropertySchema(
      id: 15,
      name: r'moodContribution',
      type: IsarType.double,
    ),
    r'moodTrend': PropertySchema(
      id: 16,
      name: r'moodTrend',
      type: IsarType.string,
    ),
    r'mostNegativeInfluence': PropertySchema(
      id: 17,
      name: r'mostNegativeInfluence',
      type: IsarType.string,
    ),
    r'mostPositiveInfluence': PropertySchema(
      id: 18,
      name: r'mostPositiveInfluence',
      type: IsarType.string,
    ),
    r'negativeIndicators': PropertySchema(
      id: 19,
      name: r'negativeIndicators',
      type: IsarType.stringList,
    ),
    r'negativeInfluenceReason': PropertySchema(
      id: 20,
      name: r'negativeInfluenceReason',
      type: IsarType.string,
    ),
    r'positiveIndicators': PropertySchema(
      id: 21,
      name: r'positiveIndicators',
      type: IsarType.stringList,
    ),
    r'positiveInfluenceReason': PropertySchema(
      id: 22,
      name: r'positiveInfluenceReason',
      type: IsarType.string,
    ),
    r'rawConfidence': PropertySchema(
      id: 23,
      name: r'rawConfidence',
      type: IsarType.double,
    ),
    r'suggestion': PropertySchema(
      id: 24,
      name: r'suggestion',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(
      id: 25,
      name: r'summary',
      type: IsarType.string,
    ),
    r'topNegativeScore': PropertySchema(
      id: 26,
      name: r'topNegativeScore',
      type: IsarType.double,
    ),
    r'topPositiveScore': PropertySchema(
      id: 27,
      name: r'topPositiveScore',
      type: IsarType.double,
    ),
    r'weekEndDate': PropertySchema(
      id: 28,
      name: r'weekEndDate',
      type: IsarType.dateTime,
    ),
    r'weekStartDate': PropertySchema(
      id: 29,
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
  bytesCount += 3 + object.historySufficiency.length * 3;
  bytesCount += 3 + object.influenceScores.length * 3;
  {
    for (var i = 0; i < object.influenceScores.length; i++) {
      final value = object.influenceScores[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.keyPatterns.length * 3;
  {
    for (var i = 0; i < object.keyPatterns.length; i++) {
      final value = object.keyPatterns[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.moodTrend.length * 3;
  bytesCount += 3 + object.mostNegativeInfluence.length * 3;
  bytesCount += 3 + object.mostPositiveInfluence.length * 3;
  bytesCount += 3 + object.negativeIndicators.length * 3;
  {
    for (var i = 0; i < object.negativeIndicators.length; i++) {
      final value = object.negativeIndicators[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.negativeInfluenceReason.length * 3;
  bytesCount += 3 + object.positiveIndicators.length * 3;
  {
    for (var i = 0; i < object.positiveIndicators.length; i++) {
      final value = object.positiveIndicators[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.positiveInfluenceReason.length * 3;
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
  writer.writeDouble(offsets[2], object.baseConfidence);
  writer.writeDouble(offsets[3], object.burnoutContribution);
  writer.writeString(offsets[4], object.burnoutTrend);
  writer.writeDouble(offsets[5], object.chatContribution);
  writer.writeDouble(offsets[6], object.confidence);
  writer.writeDouble(offsets[7], object.confidenceCap);
  writer.writeDouble(offsets[8], object.daysContribution);
  writer.writeDouble(offsets[9], object.followUpContribution);
  writer.writeDateTime(offsets[10], object.generatedAt);
  writer.writeString(offsets[11], object.historySufficiency);
  writer.writeStringList(offsets[12], object.influenceScores);
  writer.writeDouble(offsets[13], object.journalContribution);
  writer.writeStringList(offsets[14], object.keyPatterns);
  writer.writeDouble(offsets[15], object.moodContribution);
  writer.writeString(offsets[16], object.moodTrend);
  writer.writeString(offsets[17], object.mostNegativeInfluence);
  writer.writeString(offsets[18], object.mostPositiveInfluence);
  writer.writeStringList(offsets[19], object.negativeIndicators);
  writer.writeString(offsets[20], object.negativeInfluenceReason);
  writer.writeStringList(offsets[21], object.positiveIndicators);
  writer.writeString(offsets[22], object.positiveInfluenceReason);
  writer.writeDouble(offsets[23], object.rawConfidence);
  writer.writeString(offsets[24], object.suggestion);
  writer.writeString(offsets[25], object.summary);
  writer.writeDouble(offsets[26], object.topNegativeScore);
  writer.writeDouble(offsets[27], object.topPositiveScore);
  writer.writeDateTime(offsets[28], object.weekEndDate);
  writer.writeDateTime(offsets[29], object.weekStartDate);
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
  object.baseConfidence = reader.readDouble(offsets[2]);
  object.burnoutContribution = reader.readDouble(offsets[3]);
  object.burnoutTrend = reader.readString(offsets[4]);
  object.chatContribution = reader.readDouble(offsets[5]);
  object.confidence = reader.readDouble(offsets[6]);
  object.confidenceCap = reader.readDouble(offsets[7]);
  object.daysContribution = reader.readDouble(offsets[8]);
  object.followUpContribution = reader.readDouble(offsets[9]);
  object.generatedAt = reader.readDateTime(offsets[10]);
  object.historySufficiency = reader.readString(offsets[11]);
  object.id = id;
  object.influenceScores = reader.readStringList(offsets[12]) ?? [];
  object.journalContribution = reader.readDouble(offsets[13]);
  object.keyPatterns = reader.readStringList(offsets[14]) ?? [];
  object.moodContribution = reader.readDouble(offsets[15]);
  object.moodTrend = reader.readString(offsets[16]);
  object.mostNegativeInfluence = reader.readString(offsets[17]);
  object.mostPositiveInfluence = reader.readString(offsets[18]);
  object.negativeIndicators = reader.readStringList(offsets[19]) ?? [];
  object.negativeInfluenceReason = reader.readString(offsets[20]);
  object.positiveIndicators = reader.readStringList(offsets[21]) ?? [];
  object.positiveInfluenceReason = reader.readString(offsets[22]);
  object.rawConfidence = reader.readDouble(offsets[23]);
  object.suggestion = reader.readString(offsets[24]);
  object.summary = reader.readString(offsets[25]);
  object.topNegativeScore = reader.readDouble(offsets[26]);
  object.topPositiveScore = reader.readDouble(offsets[27]);
  object.weekEndDate = reader.readDateTime(offsets[28]);
  object.weekStartDate = reader.readDateTime(offsets[29]);
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringList(offset) ?? []) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readStringList(offset) ?? []) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readStringList(offset) ?? []) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readStringList(offset) ?? []) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    case 28:
      return (reader.readDateTime(offset)) as P;
    case 29:
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
      baseConfidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      baseConfidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      baseConfidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      baseConfidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseConfidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'burnoutContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'burnoutContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'burnoutContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      burnoutContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'burnoutContribution',
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
      chatContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      chatContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      chatContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      chatContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatContribution',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
      confidenceCapEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidenceCap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceCapGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidenceCap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceCapLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidenceCap',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      confidenceCapBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidenceCap',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      daysContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daysContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      daysContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daysContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      daysContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daysContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      daysContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daysContribution',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      followUpContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'followUpContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      followUpContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'followUpContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      followUpContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'followUpContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      followUpContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'followUpContribution',
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
      historySufficiencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'historySufficiency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'historySufficiency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'historySufficiency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'historySufficiency',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      historySufficiencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'historySufficiency',
        value: '',
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
      influenceScoresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'influenceScores',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'influenceScores',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'influenceScores',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'influenceScores',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'influenceScores',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      influenceScoresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'influenceScores',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      journalContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      journalContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      journalContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      journalContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalContribution',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
      moodContributionEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodContributionGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodContributionLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodContribution',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      moodContributionBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodContribution',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
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
      mostNegativeInfluenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostNegativeInfluence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostNegativeInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostNegativeInfluence',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostNegativeInfluence',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostNegativeInfluenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostNegativeInfluence',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostPositiveInfluence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostPositiveInfluence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostPositiveInfluence',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostPositiveInfluence',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      mostPositiveInfluenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostPositiveInfluence',
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
      negativeInfluenceReasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'negativeInfluenceReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'negativeInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'negativeInfluenceReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'negativeInfluenceReason',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      negativeInfluenceReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'negativeInfluenceReason',
        value: '',
      ));
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
      positiveInfluenceReasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positiveInfluenceReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'positiveInfluenceReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'positiveInfluenceReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positiveInfluenceReason',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      positiveInfluenceReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'positiveInfluenceReason',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      rawConfidenceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      rawConfidenceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      rawConfidenceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawConfidence',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      rawConfidenceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawConfidence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
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
      topNegativeScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topNegativeScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topNegativeScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topNegativeScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topNegativeScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topNegativeScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topNegativeScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topNegativeScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topPositiveScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topPositiveScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topPositiveScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topPositiveScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topPositiveScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topPositiveScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterFilterCondition>
      topPositiveScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topPositiveScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
      sortByBaseConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseConfidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByBaseConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseConfidence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByBurnoutContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByBurnoutContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutContribution', Sort.desc);
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
      sortByChatContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByChatContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatContribution', Sort.desc);
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
      sortByConfidenceCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceCap', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByConfidenceCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceCap', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByDaysContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByDaysContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysContribution', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByFollowUpContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByFollowUpContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpContribution', Sort.desc);
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
      sortByHistorySufficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historySufficiency', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByHistorySufficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historySufficiency', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByJournalContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByJournalContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalContribution', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMoodContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMoodContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodContribution', Sort.desc);
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
      sortByMostNegativeInfluence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostNegativeInfluence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMostNegativeInfluenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostNegativeInfluence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMostPositiveInfluence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPositiveInfluence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByMostPositiveInfluenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPositiveInfluence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByNegativeInfluenceReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativeInfluenceReason', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByNegativeInfluenceReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativeInfluenceReason', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByPositiveInfluenceReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveInfluenceReason', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByPositiveInfluenceReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveInfluenceReason', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByRawConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawConfidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByRawConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawConfidence', Sort.desc);
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
      sortByTopNegativeScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topNegativeScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByTopNegativeScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topNegativeScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByTopPositiveScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topPositiveScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      sortByTopPositiveScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topPositiveScore', Sort.desc);
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
      thenByBaseConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseConfidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByBaseConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseConfidence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByBurnoutContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByBurnoutContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutContribution', Sort.desc);
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
      thenByChatContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByChatContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatContribution', Sort.desc);
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
      thenByConfidenceCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceCap', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByConfidenceCapDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceCap', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByDaysContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByDaysContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daysContribution', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByFollowUpContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByFollowUpContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'followUpContribution', Sort.desc);
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

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByHistorySufficiency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historySufficiency', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByHistorySufficiencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'historySufficiency', Sort.desc);
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
      thenByJournalContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByJournalContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalContribution', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMoodContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodContribution', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMoodContributionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodContribution', Sort.desc);
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
      thenByMostNegativeInfluence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostNegativeInfluence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMostNegativeInfluenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostNegativeInfluence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMostPositiveInfluence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPositiveInfluence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByMostPositiveInfluenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostPositiveInfluence', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByNegativeInfluenceReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativeInfluenceReason', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByNegativeInfluenceReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'negativeInfluenceReason', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByPositiveInfluenceReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveInfluenceReason', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByPositiveInfluenceReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positiveInfluenceReason', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByRawConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawConfidence', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByRawConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawConfidence', Sort.desc);
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
      thenByTopNegativeScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topNegativeScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByTopNegativeScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topNegativeScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByTopPositiveScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topPositiveScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QAfterSortBy>
      thenByTopPositiveScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topPositiveScore', Sort.desc);
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
      distinctByBaseConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseConfidence');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByBurnoutContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'burnoutContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByBurnoutTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'burnoutTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByChatContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByConfidenceCap() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidenceCap');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByDaysContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daysContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByFollowUpContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'followUpContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByHistorySufficiency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'historySufficiency',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByInfluenceScores() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'influenceScores');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByJournalContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByKeyPatterns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keyPatterns');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByMoodContribution() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodContribution');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByMoodTrend({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodTrend', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByMostNegativeInfluence({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostNegativeInfluence',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByMostPositiveInfluence({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostPositiveInfluence',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByNegativeIndicators() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'negativeIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByNegativeInfluenceReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'negativeInfluenceReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByPositiveIndicators() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positiveIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByPositiveInfluenceReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positiveInfluenceReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByRawConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawConfidence');
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
      distinctByTopNegativeScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topNegativeScore');
    });
  }

  QueryBuilder<WeeklyReflection, WeeklyReflection, QDistinct>
      distinctByTopPositiveScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topPositiveScore');
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

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      baseConfidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseConfidence');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      burnoutContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'burnoutContribution');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      burnoutTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'burnoutTrend');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      chatContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatContribution');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      confidenceCapProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidenceCap');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      daysContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daysContribution');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      followUpContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'followUpContribution');
    });
  }

  QueryBuilder<WeeklyReflection, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      historySufficiencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'historySufficiency');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      influenceScoresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'influenceScores');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      journalContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalContribution');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      keyPatternsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keyPatterns');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      moodContributionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodContribution');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations> moodTrendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodTrend');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      mostNegativeInfluenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostNegativeInfluence');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      mostPositiveInfluenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostPositiveInfluence');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      negativeIndicatorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'negativeIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      negativeInfluenceReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'negativeInfluenceReason');
    });
  }

  QueryBuilder<WeeklyReflection, List<String>, QQueryOperations>
      positiveIndicatorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positiveIndicators');
    });
  }

  QueryBuilder<WeeklyReflection, String, QQueryOperations>
      positiveInfluenceReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positiveInfluenceReason');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      rawConfidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawConfidence');
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

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      topNegativeScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topNegativeScore');
    });
  }

  QueryBuilder<WeeklyReflection, double, QQueryOperations>
      topPositiveScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topPositiveScore');
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
