// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_feature_vector.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMoodFeatureVectorCollection on Isar {
  IsarCollection<MoodFeatureVector> get moodFeatureVectors => this.collection();
}

const MoodFeatureVectorSchema = CollectionSchema(
  name: r'MoodFeatureVector',
  id: -1194293875997964215,
  properties: {
    r'actualMood': PropertySchema(
      id: 0,
      name: r'actualMood',
      type: IsarType.long,
    ),
    r'chatCount': PropertySchema(
      id: 1,
      name: r'chatCount',
      type: IsarType.long,
    ),
    r'chatEmbeddingAverage': PropertySchema(
      id: 2,
      name: r'chatEmbeddingAverage',
      type: IsarType.doubleList,
    ),
    r'chatSentiment': PropertySchema(
      id: 3,
      name: r'chatSentiment',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentMood': PropertySchema(
      id: 5,
      name: r'currentMood',
      type: IsarType.string,
    ),
    r'currentMoodSource': PropertySchema(
      id: 6,
      name: r'currentMoodSource',
      type: IsarType.string,
    ),
    r'currentMoodValue': PropertySchema(
      id: 7,
      name: r'currentMoodValue',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 8,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dayOfWeek': PropertySchema(
      id: 9,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'featureVersion': PropertySchema(
      id: 10,
      name: r'featureVersion',
      type: IsarType.string,
    ),
    r'hourOfDay': PropertySchema(
      id: 11,
      name: r'hourOfDay',
      type: IsarType.long,
    ),
    r'interventionCount': PropertySchema(
      id: 12,
      name: r'interventionCount',
      type: IsarType.long,
    ),
    r'journalCount': PropertySchema(
      id: 13,
      name: r'journalCount',
      type: IsarType.long,
    ),
    r'journalEmbedding': PropertySchema(
      id: 14,
      name: r'journalEmbedding',
      type: IsarType.doubleList,
    ),
    r'journalEnergyScore': PropertySchema(
      id: 15,
      name: r'journalEnergyScore',
      type: IsarType.double,
    ),
    r'journalSentiment': PropertySchema(
      id: 16,
      name: r'journalSentiment',
      type: IsarType.double,
    ),
    r'journalStressScore': PropertySchema(
      id: 17,
      name: r'journalStressScore',
      type: IsarType.double,
    ),
    r'manualMoodExists': PropertySchema(
      id: 18,
      name: r'manualMoodExists',
      type: IsarType.bool,
    ),
    r'previousMood': PropertySchema(
      id: 19,
      name: r'previousMood',
      type: IsarType.long,
    ),
    r'rollingMoodAverage7Days': PropertySchema(
      id: 20,
      name: r'rollingMoodAverage7Days',
      type: IsarType.double,
    ),
    r'rollingMoodStd7Days': PropertySchema(
      id: 21,
      name: r'rollingMoodStd7Days',
      type: IsarType.double,
    ),
    r'sessionCount': PropertySchema(
      id: 22,
      name: r'sessionCount',
      type: IsarType.long,
    ),
    r'timeSpentMinutes': PropertySchema(
      id: 23,
      name: r'timeSpentMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _moodFeatureVectorEstimateSize,
  serialize: _moodFeatureVectorSerialize,
  deserialize: _moodFeatureVectorDeserialize,
  deserializeProp: _moodFeatureVectorDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _moodFeatureVectorGetId,
  getLinks: _moodFeatureVectorGetLinks,
  attach: _moodFeatureVectorAttach,
  version: '3.1.0+1',
);

int _moodFeatureVectorEstimateSize(
  MoodFeatureVector object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chatEmbeddingAverage;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.currentMood;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currentMoodSource;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.featureVersion.length * 3;
  {
    final value = object.journalEmbedding;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _moodFeatureVectorSerialize(
  MoodFeatureVector object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.actualMood);
  writer.writeLong(offsets[1], object.chatCount);
  writer.writeDoubleList(offsets[2], object.chatEmbeddingAverage);
  writer.writeDouble(offsets[3], object.chatSentiment);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.currentMood);
  writer.writeString(offsets[6], object.currentMoodSource);
  writer.writeDouble(offsets[7], object.currentMoodValue);
  writer.writeDateTime(offsets[8], object.date);
  writer.writeLong(offsets[9], object.dayOfWeek);
  writer.writeString(offsets[10], object.featureVersion);
  writer.writeLong(offsets[11], object.hourOfDay);
  writer.writeLong(offsets[12], object.interventionCount);
  writer.writeLong(offsets[13], object.journalCount);
  writer.writeDoubleList(offsets[14], object.journalEmbedding);
  writer.writeDouble(offsets[15], object.journalEnergyScore);
  writer.writeDouble(offsets[16], object.journalSentiment);
  writer.writeDouble(offsets[17], object.journalStressScore);
  writer.writeBool(offsets[18], object.manualMoodExists);
  writer.writeLong(offsets[19], object.previousMood);
  writer.writeDouble(offsets[20], object.rollingMoodAverage7Days);
  writer.writeDouble(offsets[21], object.rollingMoodStd7Days);
  writer.writeLong(offsets[22], object.sessionCount);
  writer.writeLong(offsets[23], object.timeSpentMinutes);
}

MoodFeatureVector _moodFeatureVectorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MoodFeatureVector();
  object.actualMood = reader.readLongOrNull(offsets[0]);
  object.chatCount = reader.readLong(offsets[1]);
  object.chatEmbeddingAverage = reader.readDoubleList(offsets[2]);
  object.chatSentiment = reader.readDoubleOrNull(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.currentMood = reader.readStringOrNull(offsets[5]);
  object.currentMoodSource = reader.readStringOrNull(offsets[6]);
  object.currentMoodValue = reader.readDoubleOrNull(offsets[7]);
  object.date = reader.readDateTime(offsets[8]);
  object.dayOfWeek = reader.readLong(offsets[9]);
  object.featureVersion = reader.readString(offsets[10]);
  object.hourOfDay = reader.readLong(offsets[11]);
  object.id = id;
  object.interventionCount = reader.readLong(offsets[12]);
  object.journalCount = reader.readLong(offsets[13]);
  object.journalEmbedding = reader.readDoubleList(offsets[14]);
  object.journalEnergyScore = reader.readDoubleOrNull(offsets[15]);
  object.journalSentiment = reader.readDoubleOrNull(offsets[16]);
  object.journalStressScore = reader.readDoubleOrNull(offsets[17]);
  object.manualMoodExists = reader.readBool(offsets[18]);
  object.previousMood = reader.readLongOrNull(offsets[19]);
  object.rollingMoodAverage7Days = reader.readDoubleOrNull(offsets[20]);
  object.rollingMoodStd7Days = reader.readDoubleOrNull(offsets[21]);
  object.sessionCount = reader.readLong(offsets[22]);
  object.timeSpentMinutes = reader.readLong(offsets[23]);
  return object;
}

P _moodFeatureVectorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDoubleList(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readDoubleOrNull(offset)) as P;
    case 17:
      return (reader.readDoubleOrNull(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readDoubleOrNull(offset)) as P;
    case 21:
      return (reader.readDoubleOrNull(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _moodFeatureVectorGetId(MoodFeatureVector object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _moodFeatureVectorGetLinks(
    MoodFeatureVector object) {
  return [];
}

void _moodFeatureVectorAttach(
    IsarCollection<dynamic> col, Id id, MoodFeatureVector object) {
  object.id = id;
}

extension MoodFeatureVectorQueryWhereSort
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QWhere> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension MoodFeatureVectorQueryWhere
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QWhereClause> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
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

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MoodFeatureVectorQueryFilter
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QFilterCondition> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      actualMoodBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatEmbeddingAverage',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatEmbeddingAverage',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatEmbeddingAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatEmbeddingAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatEmbeddingAverage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatEmbeddingAverage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatEmbeddingAverageLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatEmbeddingAverage',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatSentiment',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatSentiment',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      chatSentimentBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatSentiment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMood',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentMood',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentMoodSource',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentMoodSource',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentMoodSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currentMoodSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currentMoodSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMoodSource',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currentMoodSource',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentMoodValue',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentMoodValue',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentMoodValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentMoodValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentMoodValue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      currentMoodValueBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentMoodValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dayOfWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'featureVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'featureVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      featureVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'featureVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      hourOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      hourOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      hourOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hourOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      hourOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hourOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
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

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
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

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
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

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      interventionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interventionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      interventionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interventionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      interventionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interventionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      interventionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interventionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalEmbedding',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalEmbedding',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEmbedding',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalEmbedding',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalEmbedding',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalEmbedding',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEmbeddingLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'journalEmbedding',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalEnergyScore',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalEnergyScore',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEnergyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalEnergyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalEnergyScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalEnergyScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalEnergyScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalSentiment',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalSentiment',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalSentiment',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalSentimentBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalSentiment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalStressScore',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalStressScore',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      journalStressScoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalStressScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      manualMoodExistsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manualMoodExists',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previousMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previousMood',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousMood',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      previousMoodBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rollingMoodAverage7Days',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rollingMoodAverage7Days',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rollingMoodAverage7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rollingMoodAverage7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rollingMoodAverage7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodAverage7DaysBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rollingMoodAverage7Days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rollingMoodStd7Days',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rollingMoodStd7Days',
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rollingMoodStd7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rollingMoodStd7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rollingMoodStd7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      rollingMoodStd7DaysBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rollingMoodStd7Days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      sessionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      sessionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      sessionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      sessionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      timeSpentMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSpentMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      timeSpentMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSpentMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      timeSpentMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSpentMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterFilterCondition>
      timeSpentMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSpentMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MoodFeatureVectorQueryObject
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QFilterCondition> {}

extension MoodFeatureVectorQueryLinks
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QFilterCondition> {}

extension MoodFeatureVectorQuerySortBy
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QSortBy> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByActualMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByActualMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByChatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByChatSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatSentiment', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByChatSentimentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatSentiment', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMoodSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodSource', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMoodSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodSource', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMoodValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodValue', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByCurrentMoodValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodValue', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByFeatureVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureVersion', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByFeatureVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureVersion', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByInterventionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByInterventionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalEnergyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEnergyScore', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalEnergyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEnergyScore', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalSentiment', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalSentimentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalSentiment', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalStressScore', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByJournalStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalStressScore', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByManualMoodExists() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualMoodExists', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByManualMoodExistsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualMoodExists', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByPreviousMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByPreviousMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByRollingMoodAverage7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodAverage7Days', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByRollingMoodAverage7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodAverage7Days', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByRollingMoodStd7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodStd7Days', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByRollingMoodStd7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodStd7Days', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      sortByTimeSpentMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.desc);
    });
  }
}

extension MoodFeatureVectorQuerySortThenBy
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QSortThenBy> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByActualMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByActualMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByChatCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByChatSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatSentiment', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByChatSentimentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatSentiment', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMoodSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodSource', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMoodSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodSource', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMoodValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodValue', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByCurrentMoodValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentMoodValue', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByFeatureVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureVersion', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByFeatureVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureVersion', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByInterventionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByInterventionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interventionCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalEnergyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEnergyScore', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalEnergyScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEnergyScore', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalSentiment', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalSentimentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalSentiment', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalStressScore', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByJournalStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalStressScore', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByManualMoodExists() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualMoodExists', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByManualMoodExistsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manualMoodExists', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByPreviousMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMood', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByPreviousMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousMood', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByRollingMoodAverage7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodAverage7Days', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByRollingMoodAverage7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodAverage7Days', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByRollingMoodStd7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodStd7Days', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByRollingMoodStd7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rollingMoodStd7Days', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.asc);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QAfterSortBy>
      thenByTimeSpentMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.desc);
    });
  }
}

extension MoodFeatureVectorQueryWhereDistinct
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct> {
  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByActualMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualMood');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByChatCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatCount');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByChatEmbeddingAverage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatEmbeddingAverage');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByChatSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatSentiment');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByCurrentMood({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByCurrentMoodSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMoodSource',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByCurrentMoodValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentMoodValue');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOfWeek');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByFeatureVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureVersion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourOfDay');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByInterventionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interventionCount');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByJournalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalCount');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByJournalEmbedding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalEmbedding');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByJournalEnergyScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalEnergyScore');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByJournalSentiment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalSentiment');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByJournalStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalStressScore');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByManualMoodExists() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manualMoodExists');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByPreviousMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousMood');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByRollingMoodAverage7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rollingMoodAverage7Days');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByRollingMoodStd7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rollingMoodStd7Days');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionCount');
    });
  }

  QueryBuilder<MoodFeatureVector, MoodFeatureVector, QDistinct>
      distinctByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSpentMinutes');
    });
  }
}

extension MoodFeatureVectorQueryProperty
    on QueryBuilder<MoodFeatureVector, MoodFeatureVector, QQueryProperty> {
  QueryBuilder<MoodFeatureVector, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MoodFeatureVector, int?, QQueryOperations> actualMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualMood');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations> chatCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatCount');
    });
  }

  QueryBuilder<MoodFeatureVector, List<double>?, QQueryOperations>
      chatEmbeddingAverageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatEmbeddingAverage');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      chatSentimentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatSentiment');
    });
  }

  QueryBuilder<MoodFeatureVector, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MoodFeatureVector, String?, QQueryOperations>
      currentMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMood');
    });
  }

  QueryBuilder<MoodFeatureVector, String?, QQueryOperations>
      currentMoodSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMoodSource');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      currentMoodValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentMoodValue');
    });
  }

  QueryBuilder<MoodFeatureVector, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations> dayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOfWeek');
    });
  }

  QueryBuilder<MoodFeatureVector, String, QQueryOperations>
      featureVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureVersion');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations> hourOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourOfDay');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations>
      interventionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interventionCount');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations>
      journalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalCount');
    });
  }

  QueryBuilder<MoodFeatureVector, List<double>?, QQueryOperations>
      journalEmbeddingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalEmbedding');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      journalEnergyScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalEnergyScore');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      journalSentimentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalSentiment');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      journalStressScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalStressScore');
    });
  }

  QueryBuilder<MoodFeatureVector, bool, QQueryOperations>
      manualMoodExistsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manualMoodExists');
    });
  }

  QueryBuilder<MoodFeatureVector, int?, QQueryOperations>
      previousMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousMood');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      rollingMoodAverage7DaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rollingMoodAverage7Days');
    });
  }

  QueryBuilder<MoodFeatureVector, double?, QQueryOperations>
      rollingMoodStd7DaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rollingMoodStd7Days');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations>
      sessionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionCount');
    });
  }

  QueryBuilder<MoodFeatureVector, int, QQueryOperations>
      timeSpentMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSpentMinutes');
    });
  }
}
