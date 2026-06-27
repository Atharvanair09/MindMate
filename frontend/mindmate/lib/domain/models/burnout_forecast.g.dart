// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'burnout_forecast.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBurnoutForecastCollection on Isar {
  IsarCollection<BurnoutForecast> get burnoutForecasts => this.collection();
}

const BurnoutForecastSchema = CollectionSchema(
  name: r'BurnoutForecast',
  id: -2315436685422916747,
  properties: {
    r'confidence': PropertySchema(
      id: 0,
      name: r'confidence',
      type: IsarType.double,
    ),
    r'contributingSignals': PropertySchema(
      id: 1,
      name: r'contributingSignals',
      type: IsarType.stringList,
    ),
    r'currentBurnout': PropertySchema(
      id: 2,
      name: r'currentBurnout',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'forecast3Days': PropertySchema(
      id: 4,
      name: r'forecast3Days',
      type: IsarType.double,
    ),
    r'forecast7Days': PropertySchema(
      id: 5,
      name: r'forecast7Days',
      type: IsarType.double,
    ),
    r'forecastTomorrow': PropertySchema(
      id: 6,
      name: r'forecastTomorrow',
      type: IsarType.double,
    ),
    r'generatedAt': PropertySchema(
      id: 7,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'historicalScores': PropertySchema(
      id: 8,
      name: r'historicalScores',
      type: IsarType.doubleList,
    ),
    r'isDemoData': PropertySchema(
      id: 9,
      name: r'isDemoData',
      type: IsarType.bool,
    ),
    r'trend': PropertySchema(
      id: 10,
      name: r'trend',
      type: IsarType.string,
    )
  },
  estimateSize: _burnoutForecastEstimateSize,
  serialize: _burnoutForecastSerialize,
  deserialize: _burnoutForecastDeserialize,
  deserializeProp: _burnoutForecastDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
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
  getId: _burnoutForecastGetId,
  getLinks: _burnoutForecastGetLinks,
  attach: _burnoutForecastAttach,
  version: '3.1.0+1',
);

int _burnoutForecastEstimateSize(
  BurnoutForecast object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contributingSignals.length * 3;
  {
    for (var i = 0; i < object.contributingSignals.length; i++) {
      final value = object.contributingSignals[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.historicalScores.length * 8;
  bytesCount += 3 + object.trend.length * 3;
  return bytesCount;
}

void _burnoutForecastSerialize(
  BurnoutForecast object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.confidence);
  writer.writeStringList(offsets[1], object.contributingSignals);
  writer.writeDouble(offsets[2], object.currentBurnout);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeDouble(offsets[4], object.forecast3Days);
  writer.writeDouble(offsets[5], object.forecast7Days);
  writer.writeDouble(offsets[6], object.forecastTomorrow);
  writer.writeDateTime(offsets[7], object.generatedAt);
  writer.writeDoubleList(offsets[8], object.historicalScores);
  writer.writeBool(offsets[9], object.isDemoData);
  writer.writeString(offsets[10], object.trend);
}

BurnoutForecast _burnoutForecastDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BurnoutForecast();
  object.confidence = reader.readDouble(offsets[0]);
  object.contributingSignals = reader.readStringList(offsets[1]) ?? [];
  object.currentBurnout = reader.readDouble(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.forecast3Days = reader.readDouble(offsets[4]);
  object.forecast7Days = reader.readDouble(offsets[5]);
  object.forecastTomorrow = reader.readDouble(offsets[6]);
  object.generatedAt = reader.readDateTime(offsets[7]);
  object.historicalScores = reader.readDoubleList(offsets[8]) ?? [];
  object.id = id;
  object.isDemoData = reader.readBool(offsets[9]);
  object.trend = reader.readString(offsets[10]);
  return object;
}

P _burnoutForecastDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _burnoutForecastGetId(BurnoutForecast object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _burnoutForecastGetLinks(BurnoutForecast object) {
  return [];
}

void _burnoutForecastAttach(
    IsarCollection<dynamic> col, Id id, BurnoutForecast object) {
  object.id = id;
}

extension BurnoutForecastByIndex on IsarCollection<BurnoutForecast> {
  Future<BurnoutForecast?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  BurnoutForecast? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<BurnoutForecast?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<BurnoutForecast?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(BurnoutForecast object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(BurnoutForecast object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<BurnoutForecast> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<BurnoutForecast> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension BurnoutForecastQueryWhereSort
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QWhere> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension BurnoutForecastQueryWhere
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QWhereClause> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause> idBetween(
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterWhereClause> dateBetween(
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

extension BurnoutForecastQueryFilter
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QFilterCondition> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contributingSignals',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contributingSignals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contributingSignals',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contributingSignals',
        value: '',
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contributingSignals',
        value: '',
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      contributingSignalsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'contributingSignals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      currentBurnoutEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      currentBurnoutGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      currentBurnoutLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      currentBurnoutBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentBurnout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast3DaysEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forecast3Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast3DaysGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forecast3Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast3DaysLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forecast3Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast3DaysBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forecast3Days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast7DaysEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forecast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast7DaysGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forecast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast7DaysLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forecast7Days',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecast7DaysBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forecast7Days',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecastTomorrowEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forecastTomorrow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecastTomorrowGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forecastTomorrow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecastTomorrowLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forecastTomorrow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      forecastTomorrowBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forecastTomorrow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'historicalScores',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'historicalScores',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'historicalScores',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'historicalScores',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      historicalScoresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'historicalScores',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
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

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      isDemoDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDemoData',
        value: value,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trend',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trend',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trend',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trend',
        value: '',
      ));
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterFilterCondition>
      trendIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trend',
        value: '',
      ));
    });
  }
}

extension BurnoutForecastQueryObject
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QFilterCondition> {}

extension BurnoutForecastQueryLinks
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QFilterCondition> {}

extension BurnoutForecastQuerySortBy
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QSortBy> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByCurrentBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentBurnout', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByCurrentBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentBurnout', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecast3Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast3Days', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecast3DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast3Days', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast7Days', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecast7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast7Days', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecastTomorrow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecastTomorrow', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByForecastTomorrowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecastTomorrow', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> sortByTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trend', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      sortByTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trend', Sort.desc);
    });
  }
}

extension BurnoutForecastQuerySortThenBy
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QSortThenBy> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByConfidenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidence', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByCurrentBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentBurnout', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByCurrentBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentBurnout', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecast3Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast3Days', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecast3DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast3Days', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast7Days', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecast7DaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecast7Days', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecastTomorrow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecastTomorrow', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByForecastTomorrowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forecastTomorrow', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy> thenByTrend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trend', Sort.asc);
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QAfterSortBy>
      thenByTrendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trend', Sort.desc);
    });
  }
}

extension BurnoutForecastQueryWhereDistinct
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct> {
  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByConfidence() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidence');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByContributingSignals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contributingSignals');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByCurrentBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentBurnout');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByForecast3Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forecast3Days');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByForecast7Days() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forecast7Days');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByForecastTomorrow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forecastTomorrow');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByHistoricalScores() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'historicalScores');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct>
      distinctByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDemoData');
    });
  }

  QueryBuilder<BurnoutForecast, BurnoutForecast, QDistinct> distinctByTrend(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trend', caseSensitive: caseSensitive);
    });
  }
}

extension BurnoutForecastQueryProperty
    on QueryBuilder<BurnoutForecast, BurnoutForecast, QQueryProperty> {
  QueryBuilder<BurnoutForecast, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BurnoutForecast, double, QQueryOperations> confidenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidence');
    });
  }

  QueryBuilder<BurnoutForecast, List<String>, QQueryOperations>
      contributingSignalsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contributingSignals');
    });
  }

  QueryBuilder<BurnoutForecast, double, QQueryOperations>
      currentBurnoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentBurnout');
    });
  }

  QueryBuilder<BurnoutForecast, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<BurnoutForecast, double, QQueryOperations>
      forecast3DaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forecast3Days');
    });
  }

  QueryBuilder<BurnoutForecast, double, QQueryOperations>
      forecast7DaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forecast7Days');
    });
  }

  QueryBuilder<BurnoutForecast, double, QQueryOperations>
      forecastTomorrowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forecastTomorrow');
    });
  }

  QueryBuilder<BurnoutForecast, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<BurnoutForecast, List<double>, QQueryOperations>
      historicalScoresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'historicalScores');
    });
  }

  QueryBuilder<BurnoutForecast, bool, QQueryOperations> isDemoDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDemoData');
    });
  }

  QueryBuilder<BurnoutForecast, String, QQueryOperations> trendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trend');
    });
  }
}
