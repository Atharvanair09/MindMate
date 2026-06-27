// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'early_warning.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEarlyWarningAlertCollection on Isar {
  IsarCollection<EarlyWarningAlert> get earlyWarningAlerts => this.collection();
}

const EarlyWarningAlertSchema = CollectionSchema(
  name: r'EarlyWarningAlert',
  id: 5230827660449253757,
  properties: {
    r'generatedAt': PropertySchema(
      id: 0,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'level': PropertySchema(
      id: 1,
      name: r'level',
      type: IsarType.string,
    ),
    r'reasons': PropertySchema(
      id: 2,
      name: r'reasons',
      type: IsarType.stringList,
    )
  },
  estimateSize: _earlyWarningAlertEstimateSize,
  serialize: _earlyWarningAlertSerialize,
  deserialize: _earlyWarningAlertDeserialize,
  deserializeProp: _earlyWarningAlertDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _earlyWarningAlertGetId,
  getLinks: _earlyWarningAlertGetLinks,
  attach: _earlyWarningAlertAttach,
  version: '3.1.0+1',
);

int _earlyWarningAlertEstimateSize(
  EarlyWarningAlert object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.level.length * 3;
  bytesCount += 3 + object.reasons.length * 3;
  {
    for (var i = 0; i < object.reasons.length; i++) {
      final value = object.reasons[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _earlyWarningAlertSerialize(
  EarlyWarningAlert object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.generatedAt);
  writer.writeString(offsets[1], object.level);
  writer.writeStringList(offsets[2], object.reasons);
}

EarlyWarningAlert _earlyWarningAlertDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EarlyWarningAlert();
  object.generatedAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.level = reader.readString(offsets[1]);
  object.reasons = reader.readStringList(offsets[2]) ?? [];
  return object;
}

P _earlyWarningAlertDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _earlyWarningAlertGetId(EarlyWarningAlert object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _earlyWarningAlertGetLinks(
    EarlyWarningAlert object) {
  return [];
}

void _earlyWarningAlertAttach(
    IsarCollection<dynamic> col, Id id, EarlyWarningAlert object) {
  object.id = id;
}

extension EarlyWarningAlertQueryWhereSort
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QWhere> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EarlyWarningAlertQueryWhere
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QWhereClause> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhereClause>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterWhereClause>
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
}

extension EarlyWarningAlertQueryFilter
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QFilterCondition> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
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

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'level',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reasons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reasons',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reasons',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reasons',
        value: '',
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reasons',
        value: '',
      ));
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterFilterCondition>
      reasonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'reasons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension EarlyWarningAlertQueryObject
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QFilterCondition> {}

extension EarlyWarningAlertQueryLinks
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QFilterCondition> {}

extension EarlyWarningAlertQuerySortBy
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QSortBy> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }
}

extension EarlyWarningAlertQuerySortThenBy
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QSortThenBy> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QAfterSortBy>
      thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }
}

extension EarlyWarningAlertQueryWhereDistinct
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QDistinct> {
  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QDistinct> distinctByLevel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QDistinct>
      distinctByReasons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reasons');
    });
  }
}

extension EarlyWarningAlertQueryProperty
    on QueryBuilder<EarlyWarningAlert, EarlyWarningAlert, QQueryProperty> {
  QueryBuilder<EarlyWarningAlert, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EarlyWarningAlert, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<EarlyWarningAlert, String, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<EarlyWarningAlert, List<String>, QQueryOperations>
      reasonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reasons');
    });
  }
}
