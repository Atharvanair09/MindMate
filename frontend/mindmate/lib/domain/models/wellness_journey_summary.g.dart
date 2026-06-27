// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_journey_summary.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWellnessJourneySummaryCollection on Isar {
  IsarCollection<WellnessJourneySummary> get wellnessJourneySummarys =>
      this.collection();
}

const WellnessJourneySummarySchema = CollectionSchema(
  name: r'WellnessJourneySummary',
  id: -1461506156181513576,
  properties: {
    r'endDate': PropertySchema(
      id: 0,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'eventSignatures': PropertySchema(
      id: 1,
      name: r'eventSignatures',
      type: IsarType.stringList,
    ),
    r'generatedAt': PropertySchema(
      id: 2,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'isDemoData': PropertySchema(
      id: 3,
      name: r'isDemoData',
      type: IsarType.bool,
    ),
    r'narrative': PropertySchema(
      id: 4,
      name: r'narrative',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 5,
      name: r'startDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _wellnessJourneySummaryEstimateSize,
  serialize: _wellnessJourneySummarySerialize,
  deserialize: _wellnessJourneySummaryDeserialize,
  deserializeProp: _wellnessJourneySummaryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _wellnessJourneySummaryGetId,
  getLinks: _wellnessJourneySummaryGetLinks,
  attach: _wellnessJourneySummaryAttach,
  version: '3.1.0+1',
);

int _wellnessJourneySummaryEstimateSize(
  WellnessJourneySummary object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.eventSignatures.length * 3;
  {
    for (var i = 0; i < object.eventSignatures.length; i++) {
      final value = object.eventSignatures[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.narrative.length * 3;
  return bytesCount;
}

void _wellnessJourneySummarySerialize(
  WellnessJourneySummary object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endDate);
  writer.writeStringList(offsets[1], object.eventSignatures);
  writer.writeDateTime(offsets[2], object.generatedAt);
  writer.writeBool(offsets[3], object.isDemoData);
  writer.writeString(offsets[4], object.narrative);
  writer.writeDateTime(offsets[5], object.startDate);
}

WellnessJourneySummary _wellnessJourneySummaryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WellnessJourneySummary();
  object.endDate = reader.readDateTime(offsets[0]);
  object.eventSignatures = reader.readStringList(offsets[1]) ?? [];
  object.generatedAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.isDemoData = reader.readBool(offsets[3]);
  object.narrative = reader.readString(offsets[4]);
  object.startDate = reader.readDateTime(offsets[5]);
  return object;
}

P _wellnessJourneySummaryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wellnessJourneySummaryGetId(WellnessJourneySummary object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wellnessJourneySummaryGetLinks(
    WellnessJourneySummary object) {
  return [];
}

void _wellnessJourneySummaryAttach(
    IsarCollection<dynamic> col, Id id, WellnessJourneySummary object) {
  object.id = id;
}

extension WellnessJourneySummaryQueryWhereSort
    on QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QWhere> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WellnessJourneySummaryQueryWhere on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QWhereClause> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterWhereClause> idBetween(
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

extension WellnessJourneySummaryQueryFilter on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QFilterCondition> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> endDateGreaterThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> endDateLessThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> endDateBetween(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventSignatures',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
          QAfterFilterCondition>
      eventSignaturesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventSignatures',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
          QAfterFilterCondition>
      eventSignaturesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventSignatures',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventSignatures',
        value: '',
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventSignatures',
        value: '',
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> eventSignaturesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'eventSignatures',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> generatedAtGreaterThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> generatedAtLessThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> generatedAtBetween(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> isDemoDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDemoData',
        value: value,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'narrative',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
          QAfterFilterCondition>
      narrativeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'narrative',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
          QAfterFilterCondition>
      narrativeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'narrative',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'narrative',
        value: '',
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> narrativeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'narrative',
        value: '',
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> startDateGreaterThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> startDateLessThan(
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

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary,
      QAfterFilterCondition> startDateBetween(
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
}

extension WellnessJourneySummaryQueryObject on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QFilterCondition> {}

extension WellnessJourneySummaryQueryLinks on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QFilterCondition> {}

extension WellnessJourneySummaryQuerySortBy
    on QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QSortBy> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByNarrative() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrative', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByNarrativeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrative', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension WellnessJourneySummaryQuerySortThenBy on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QSortThenBy> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByIsDemoDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDemoData', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByNarrative() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrative', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByNarrativeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'narrative', Sort.desc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }
}

extension WellnessJourneySummaryQueryWhereDistinct
    on QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct> {
  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByEventSignatures() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventSignatures');
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByIsDemoData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDemoData');
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByNarrative({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'narrative', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WellnessJourneySummary, WellnessJourneySummary, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }
}

extension WellnessJourneySummaryQueryProperty on QueryBuilder<
    WellnessJourneySummary, WellnessJourneySummary, QQueryProperty> {
  QueryBuilder<WellnessJourneySummary, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WellnessJourneySummary, DateTime, QQueryOperations>
      endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<WellnessJourneySummary, List<String>, QQueryOperations>
      eventSignaturesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventSignatures');
    });
  }

  QueryBuilder<WellnessJourneySummary, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<WellnessJourneySummary, bool, QQueryOperations>
      isDemoDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDemoData');
    });
  }

  QueryBuilder<WellnessJourneySummary, String, QQueryOperations>
      narrativeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'narrative');
    });
  }

  QueryBuilder<WellnessJourneySummary, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }
}
