// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_membership.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommunityMembershipCollection on Isar {
  IsarCollection<CommunityMembership> get communityMemberships =>
      this.collection();
}

const CommunityMembershipSchema = CollectionSchema(
  name: r'CommunityMembership',
  id: -2131223967841814290,
  properties: {
    r'communityName': PropertySchema(
      id: 0,
      name: r'communityName',
      type: IsarType.string,
    ),
    r'joinedAt': PropertySchema(
      id: 1,
      name: r'joinedAt',
      type: IsarType.dateTime,
    ),
    r'lastVisitAt': PropertySchema(
      id: 2,
      name: r'lastVisitAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _communityMembershipEstimateSize,
  serialize: _communityMembershipSerialize,
  deserialize: _communityMembershipDeserialize,
  deserializeProp: _communityMembershipDeserializeProp,
  idName: r'id',
  indexes: {
    r'communityName': IndexSchema(
      id: 3211081976557132380,
      name: r'communityName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'communityName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _communityMembershipGetId,
  getLinks: _communityMembershipGetLinks,
  attach: _communityMembershipAttach,
  version: '3.1.0+1',
);

int _communityMembershipEstimateSize(
  CommunityMembership object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.communityName.length * 3;
  return bytesCount;
}

void _communityMembershipSerialize(
  CommunityMembership object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.communityName);
  writer.writeDateTime(offsets[1], object.joinedAt);
  writer.writeDateTime(offsets[2], object.lastVisitAt);
}

CommunityMembership _communityMembershipDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommunityMembership();
  object.communityName = reader.readString(offsets[0]);
  object.id = id;
  object.joinedAt = reader.readDateTime(offsets[1]);
  object.lastVisitAt = reader.readDateTime(offsets[2]);
  return object;
}

P _communityMembershipDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _communityMembershipGetId(CommunityMembership object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _communityMembershipGetLinks(
    CommunityMembership object) {
  return [];
}

void _communityMembershipAttach(
    IsarCollection<dynamic> col, Id id, CommunityMembership object) {
  object.id = id;
}

extension CommunityMembershipByIndex on IsarCollection<CommunityMembership> {
  Future<CommunityMembership?> getByCommunityName(String communityName) {
    return getByIndex(r'communityName', [communityName]);
  }

  CommunityMembership? getByCommunityNameSync(String communityName) {
    return getByIndexSync(r'communityName', [communityName]);
  }

  Future<bool> deleteByCommunityName(String communityName) {
    return deleteByIndex(r'communityName', [communityName]);
  }

  bool deleteByCommunityNameSync(String communityName) {
    return deleteByIndexSync(r'communityName', [communityName]);
  }

  Future<List<CommunityMembership?>> getAllByCommunityName(
      List<String> communityNameValues) {
    final values = communityNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'communityName', values);
  }

  List<CommunityMembership?> getAllByCommunityNameSync(
      List<String> communityNameValues) {
    final values = communityNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'communityName', values);
  }

  Future<int> deleteAllByCommunityName(List<String> communityNameValues) {
    final values = communityNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'communityName', values);
  }

  int deleteAllByCommunityNameSync(List<String> communityNameValues) {
    final values = communityNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'communityName', values);
  }

  Future<Id> putByCommunityName(CommunityMembership object) {
    return putByIndex(r'communityName', object);
  }

  Id putByCommunityNameSync(CommunityMembership object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'communityName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCommunityName(List<CommunityMembership> objects) {
    return putAllByIndex(r'communityName', objects);
  }

  List<Id> putAllByCommunityNameSync(List<CommunityMembership> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'communityName', objects, saveLinks: saveLinks);
  }
}

extension CommunityMembershipQueryWhereSort
    on QueryBuilder<CommunityMembership, CommunityMembership, QWhere> {
  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommunityMembershipQueryWhere
    on QueryBuilder<CommunityMembership, CommunityMembership, QWhereClause> {
  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
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

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
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

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
      communityNameEqualTo(String communityName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'communityName',
        value: [communityName],
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterWhereClause>
      communityNameNotEqualTo(String communityName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'communityName',
              lower: [],
              upper: [communityName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'communityName',
              lower: [communityName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'communityName',
              lower: [communityName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'communityName',
              lower: [],
              upper: [communityName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CommunityMembershipQueryFilter on QueryBuilder<CommunityMembership,
    CommunityMembership, QFilterCondition> {
  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'communityName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'communityName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'communityName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'communityName',
        value: '',
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      communityNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'communityName',
        value: '',
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
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

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
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

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
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

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      joinedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'joinedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      joinedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'joinedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      joinedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'joinedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      joinedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'joinedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      lastVisitAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVisitAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      lastVisitAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastVisitAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      lastVisitAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastVisitAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterFilterCondition>
      lastVisitAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastVisitAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CommunityMembershipQueryObject on QueryBuilder<CommunityMembership,
    CommunityMembership, QFilterCondition> {}

extension CommunityMembershipQueryLinks on QueryBuilder<CommunityMembership,
    CommunityMembership, QFilterCondition> {}

extension CommunityMembershipQuerySortBy
    on QueryBuilder<CommunityMembership, CommunityMembership, QSortBy> {
  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByCommunityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityName', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByCommunityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityName', Sort.desc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinedAt', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByJoinedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinedAt', Sort.desc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByLastVisitAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitAt', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      sortByLastVisitAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitAt', Sort.desc);
    });
  }
}

extension CommunityMembershipQuerySortThenBy
    on QueryBuilder<CommunityMembership, CommunityMembership, QSortThenBy> {
  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByCommunityName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityName', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByCommunityNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'communityName', Sort.desc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinedAt', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByJoinedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinedAt', Sort.desc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByLastVisitAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitAt', Sort.asc);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QAfterSortBy>
      thenByLastVisitAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitAt', Sort.desc);
    });
  }
}

extension CommunityMembershipQueryWhereDistinct
    on QueryBuilder<CommunityMembership, CommunityMembership, QDistinct> {
  QueryBuilder<CommunityMembership, CommunityMembership, QDistinct>
      distinctByCommunityName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'communityName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QDistinct>
      distinctByJoinedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'joinedAt');
    });
  }

  QueryBuilder<CommunityMembership, CommunityMembership, QDistinct>
      distinctByLastVisitAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVisitAt');
    });
  }
}

extension CommunityMembershipQueryProperty
    on QueryBuilder<CommunityMembership, CommunityMembership, QQueryProperty> {
  QueryBuilder<CommunityMembership, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CommunityMembership, String, QQueryOperations>
      communityNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'communityName');
    });
  }

  QueryBuilder<CommunityMembership, DateTime, QQueryOperations>
      joinedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'joinedAt');
    });
  }

  QueryBuilder<CommunityMembership, DateTime, QQueryOperations>
      lastVisitAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVisitAt');
    });
  }
}
