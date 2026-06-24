// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRecoveryEventCollection on Isar {
  IsarCollection<RecoveryEvent> get recoveryEvents => this.collection();
}

const RecoveryEventSchema = CollectionSchema(
  name: r'RecoveryEvent',
  id: -8922398456321797890,
  properties: {
    r'endBurnout': PropertySchema(
      id: 0,
      name: r'endBurnout',
      type: IsarType.double,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'endMood': PropertySchema(
      id: 2,
      name: r'endMood',
      type: IsarType.double,
    ),
    r'generatedAt': PropertySchema(
      id: 3,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'possibleTriggers': PropertySchema(
      id: 4,
      name: r'possibleTriggers',
      type: IsarType.stringList,
    ),
    r'recoveryStrength': PropertySchema(
      id: 5,
      name: r'recoveryStrength',
      type: IsarType.string,
    ),
    r'startBurnout': PropertySchema(
      id: 6,
      name: r'startBurnout',
      type: IsarType.double,
    ),
    r'startDate': PropertySchema(
      id: 7,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'startMood': PropertySchema(
      id: 8,
      name: r'startMood',
      type: IsarType.double,
    ),
    r'summary': PropertySchema(
      id: 9,
      name: r'summary',
      type: IsarType.string,
    )
  },
  estimateSize: _recoveryEventEstimateSize,
  serialize: _recoveryEventSerialize,
  deserialize: _recoveryEventDeserialize,
  deserializeProp: _recoveryEventDeserializeProp,
  idName: r'id',
  indexes: {
    r'startDate': IndexSchema(
      id: 7723980484494730382,
      name: r'startDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'endDate': IndexSchema(
      id: 422088669960424970,
      name: r'endDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'endDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _recoveryEventGetId,
  getLinks: _recoveryEventGetLinks,
  attach: _recoveryEventAttach,
  version: '3.1.0+1',
);

int _recoveryEventEstimateSize(
  RecoveryEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.possibleTriggers.length * 3;
  {
    for (var i = 0; i < object.possibleTriggers.length; i++) {
      final value = object.possibleTriggers[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.recoveryStrength.length * 3;
  bytesCount += 3 + object.summary.length * 3;
  return bytesCount;
}

void _recoveryEventSerialize(
  RecoveryEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.endBurnout);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeDouble(offsets[2], object.endMood);
  writer.writeDateTime(offsets[3], object.generatedAt);
  writer.writeStringList(offsets[4], object.possibleTriggers);
  writer.writeString(offsets[5], object.recoveryStrength);
  writer.writeDouble(offsets[6], object.startBurnout);
  writer.writeDateTime(offsets[7], object.startDate);
  writer.writeDouble(offsets[8], object.startMood);
  writer.writeString(offsets[9], object.summary);
}

RecoveryEvent _recoveryEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecoveryEvent();
  object.endBurnout = reader.readDouble(offsets[0]);
  object.endDate = reader.readDateTime(offsets[1]);
  object.endMood = reader.readDouble(offsets[2]);
  object.generatedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.possibleTriggers = reader.readStringList(offsets[4]) ?? [];
  object.recoveryStrength = reader.readString(offsets[5]);
  object.startBurnout = reader.readDouble(offsets[6]);
  object.startDate = reader.readDateTime(offsets[7]);
  object.startMood = reader.readDouble(offsets[8]);
  object.summary = reader.readString(offsets[9]);
  return object;
}

P _recoveryEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _recoveryEventGetId(RecoveryEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _recoveryEventGetLinks(RecoveryEvent object) {
  return [];
}

void _recoveryEventAttach(
    IsarCollection<dynamic> col, Id id, RecoveryEvent object) {
  object.id = id;
}

extension RecoveryEventQueryWhereSort
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QWhere> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhere> anyStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startDate'),
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhere> anyEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'endDate'),
      );
    });
  }
}

extension RecoveryEventQueryWhere
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QWhereClause> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> idBetween(
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      startDateEqualTo(DateTime startDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startDate',
        value: [startDate],
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      startDateNotEqualTo(DateTime startDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [],
              upper: [startDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [startDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [startDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startDate',
              lower: [],
              upper: [startDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      startDateGreaterThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [startDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      startDateLessThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [],
        upper: [startDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      startDateBetween(
    DateTime lowerStartDate,
    DateTime upperStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startDate',
        lower: [lowerStartDate],
        includeLower: includeLower,
        upper: [upperStartDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> endDateEqualTo(
      DateTime endDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'endDate',
        value: [endDate],
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      endDateNotEqualTo(DateTime endDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [],
              upper: [endDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [endDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [endDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endDate',
              lower: [],
              upper: [endDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause>
      endDateGreaterThan(
    DateTime endDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [endDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> endDateLessThan(
    DateTime endDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [],
        upper: [endDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterWhereClause> endDateBetween(
    DateTime lowerEndDate,
    DateTime upperEndDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endDate',
        lower: [lowerEndDate],
        includeLower: includeLower,
        upper: [upperEndDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecoveryEventQueryFilter
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QFilterCondition> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endBurnoutEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endBurnoutGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endBurnoutLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endBurnoutBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endBurnout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endMoodEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endMoodGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endMoodLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      endMoodBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'possibleTriggers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'possibleTriggers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'possibleTriggers',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'possibleTriggers',
        value: '',
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'possibleTriggers',
        value: '',
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      possibleTriggersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'possibleTriggers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recoveryStrength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recoveryStrength',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recoveryStrength',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recoveryStrength',
        value: '',
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      recoveryStrengthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recoveryStrength',
        value: '',
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startBurnoutEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startBurnoutGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startBurnoutLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startBurnout',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startBurnoutBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startBurnout',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startMoodEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startMoodGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startMoodLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startMood',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      startMoodBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startMood',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
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

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      summaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      summaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterFilterCondition>
      summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }
}

extension RecoveryEventQueryObject
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QFilterCondition> {}

extension RecoveryEventQueryLinks
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QFilterCondition> {}

extension RecoveryEventQuerySortBy
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QSortBy> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByEndBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endBurnout', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByEndBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endBurnout', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByEndMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMood', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByEndMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMood', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByRecoveryStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryStrength', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByRecoveryStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryStrength', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByStartBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startBurnout', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByStartBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startBurnout', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortByStartMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMood', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      sortByStartMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMood', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }
}

extension RecoveryEventQuerySortThenBy
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QSortThenBy> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByEndBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endBurnout', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByEndBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endBurnout', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByEndMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMood', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByEndMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMood', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByRecoveryStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryStrength', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByRecoveryStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recoveryStrength', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByStartBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startBurnout', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByStartBurnoutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startBurnout', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenByStartMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMood', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy>
      thenByStartMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMood', Sort.desc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QAfterSortBy> thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }
}

extension RecoveryEventQueryWhereDistinct
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> {
  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctByEndBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endBurnout');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctByEndMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMood');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct>
      distinctByPossibleTriggers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'possibleTriggers');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct>
      distinctByRecoveryStrength({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recoveryStrength',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct>
      distinctByStartBurnout() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startBurnout');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctByStartMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMood');
    });
  }

  QueryBuilder<RecoveryEvent, RecoveryEvent, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }
}

extension RecoveryEventQueryProperty
    on QueryBuilder<RecoveryEvent, RecoveryEvent, QQueryProperty> {
  QueryBuilder<RecoveryEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RecoveryEvent, double, QQueryOperations> endBurnoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endBurnout');
    });
  }

  QueryBuilder<RecoveryEvent, DateTime, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<RecoveryEvent, double, QQueryOperations> endMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMood');
    });
  }

  QueryBuilder<RecoveryEvent, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<RecoveryEvent, List<String>, QQueryOperations>
      possibleTriggersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'possibleTriggers');
    });
  }

  QueryBuilder<RecoveryEvent, String, QQueryOperations>
      recoveryStrengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recoveryStrength');
    });
  }

  QueryBuilder<RecoveryEvent, double, QQueryOperations> startBurnoutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startBurnout');
    });
  }

  QueryBuilder<RecoveryEvent, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<RecoveryEvent, double, QQueryOperations> startMoodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMood');
    });
  }

  QueryBuilder<RecoveryEvent, String, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }
}
