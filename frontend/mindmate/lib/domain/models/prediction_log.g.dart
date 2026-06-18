// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPredictionLogCollection on Isar {
  IsarCollection<PredictionLog> get predictionLogs => this.collection();
}

const PredictionLogSchema = CollectionSchema(
  name: r'PredictionLog',
  id: 727625342338089450,
  properties: {
    r'actualMood': PropertySchema(
      id: 0,
      name: r'actualMood',
      type: IsarType.string,
    ),
    r'confidence': PropertySchema(
      id: 1,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'correctedByUser': PropertySchema(
      id: 2,
      name: r'correctedByUser',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'predictedMood': PropertySchema(
      id: 4,
      name: r'predictedMood',
      type: IsarType.string,
    )
  },
  estimateSize: _predictionLogEstimateSize,
  serialize: _predictionLogSerialize,
  deserialize: _predictionLogDeserialize,
  deserializeProp: _predictionLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _predictionLogGetId,
  getLinks: _predictionLogGetLinks,
  attach: _predictionLogAttach,
  version: '3.1.0+1',
);

int _predictionLogEstimateSize(
  PredictionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actualMood;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.predictedMood.length * 3;
  return bytesCount;
}

void _predictionLogSerialize(
  PredictionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actualMood);
  writer.writeDouble(offsets[1], object.confidence);
  writer.writeBool(offsets[2], object.correctedByUser);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.predictedMood);
}

PredictionLog _predictionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PredictionLog();
  object.actualMood = reader.readStringOrNull(offsets[0]);
  object.confidence = reader.readDouble(offsets[1]);
  object.correctedByUser = reader.readBool(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.predictedMood = reader.readString(offsets[4]);
  return object;
}

P _predictionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _predictionLogGetId(PredictionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _predictionLogGetLinks(PredictionLog object) {
  return [];
}

void _predictionLogAttach(
    IsarCollection<dynamic> col, Id id, PredictionLog object) {
  object.id = id;
}

extension PredictionLogQueryWhereSort
    on QueryBuilder<PredictionLog, PredictionLog, QWhere> {
  QueryBuilder<PredictionLog, PredictionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PredictionLogQueryWhere
    on QueryBuilder<PredictionLog, PredictionLog, QWhereClause> {
  QueryBuilder<PredictionLog, PredictionLog, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterWhereClause> idBetween(
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

extension PredictionLogQueryFilter
    on QueryBuilder<PredictionLog, PredictionLog, QFilterCondition> {
  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualMood',
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualMood',
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actualMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actualMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualMood',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      actualMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actualMood',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      correctedByUserEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctedByUser',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predictedMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'predictedMood',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'predictedMood',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictedMood',
        value: '',
      ));
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterFilterCondition>
      predictedMoodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predictedMood',
        value: '',
      ));
    });
  }
}

extension PredictionLogQueryObject
    on QueryBuilder<PredictionLog, PredictionLog, QFilterCondition> {}

extension PredictionLogQueryLinks
    on QueryBuilder<PredictionLog, PredictionLog, QFilterCondition> {}

extension PredictionLogQuerySortBy
    on QueryBuilder<PredictionLog, PredictionLog, QSortBy> {
  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> sortByActualMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByActualMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByCorrectedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctedByUser', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByCorrectedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctedByUser', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByPredictedMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedMood', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      sortByPredictedMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedMood', Sort.desc);
    });
  }
}

extension PredictionLogQuerySortThenBy
    on QueryBuilder<PredictionLog, PredictionLog, QSortThenBy> {
  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> thenByActualMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByActualMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualMood', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByCorrectedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctedByUser', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByCorrectedByUserDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctedByUser', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByPredictedMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedMood', Sort.asc);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QAfterSortBy>
      thenByPredictedMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictedMood', Sort.desc);
    });
  }
}

extension PredictionLogQueryWhereDistinct
    on QueryBuilder<PredictionLog, PredictionLog, QDistinct> {
  QueryBuilder<PredictionLog, PredictionLog, QDistinct> distinctByActualMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualMood', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QDistinct> distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QDistinct>
      distinctByCorrectedByUser() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctedByUser');
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PredictionLog, PredictionLog, QDistinct> distinctByPredictedMood(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predictedMood',
          caseSensitive: caseSensitive);
    });
  }
}

extension PredictionLogQueryProperty
    on QueryBuilder<PredictionLog, PredictionLog, QQueryProperty> {
  QueryBuilder<PredictionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PredictionLog, String?, QQueryOperations> actualMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualMood');
    });
  }

  QueryBuilder<PredictionLog, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<PredictionLog, bool, QQueryOperations>
      correctedByUserProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctedByUser');
    });
  }

  QueryBuilder<PredictionLog, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PredictionLog, String, QQueryOperations>
      predictedMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predictedMood');
    });
  }
}
