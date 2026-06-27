// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_post.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAnonymousPostCollection on Isar {
  IsarCollection<AnonymousPost> get anonymousPosts => this.collection();
}

const AnonymousPostSchema = CollectionSchema(
  name: r'AnonymousPost',
  id: 5103201448957173553,
  properties: {
    r'aliasMappingMetadata': PropertySchema(
      id: 0,
      name: r'aliasMappingMetadata',
      type: IsarType.string,
    ),
    r'conversationId': PropertySchema(
      id: 1,
      name: r'conversationId',
      type: IsarType.string,
    ),
    r'isMock': PropertySchema(
      id: 2,
      name: r'isMock',
      type: IsarType.bool,
    ),
    r'originalText': PropertySchema(
      id: 3,
      name: r'originalText',
      type: IsarType.string,
    ),
    r'parentPostId': PropertySchema(
      id: 4,
      name: r'parentPostId',
      type: IsarType.long,
    ),
    r'replyCount': PropertySchema(
      id: 5,
      name: r'replyCount',
      type: IsarType.long,
    ),
    r'sanitizedText': PropertySchema(
      id: 6,
      name: r'sanitizedText',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 7,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'upvotes': PropertySchema(
      id: 8,
      name: r'upvotes',
      type: IsarType.long,
    )
  },
  estimateSize: _anonymousPostEstimateSize,
  serialize: _anonymousPostSerialize,
  deserialize: _anonymousPostDeserialize,
  deserializeProp: _anonymousPostDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _anonymousPostGetId,
  getLinks: _anonymousPostGetLinks,
  attach: _anonymousPostAttach,
  version: '3.1.0+1',
);

int _anonymousPostEstimateSize(
  AnonymousPost object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.aliasMappingMetadata.length * 3;
  bytesCount += 3 + object.conversationId.length * 3;
  bytesCount += 3 + object.originalText.length * 3;
  bytesCount += 3 + object.sanitizedText.length * 3;
  return bytesCount;
}

void _anonymousPostSerialize(
  AnonymousPost object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aliasMappingMetadata);
  writer.writeString(offsets[1], object.conversationId);
  writer.writeBool(offsets[2], object.isMock);
  writer.writeString(offsets[3], object.originalText);
  writer.writeLong(offsets[4], object.parentPostId);
  writer.writeLong(offsets[5], object.replyCount);
  writer.writeString(offsets[6], object.sanitizedText);
  writer.writeDateTime(offsets[7], object.timestamp);
  writer.writeLong(offsets[8], object.upvotes);
}

AnonymousPost _anonymousPostDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AnonymousPost();
  object.aliasMappingMetadata = reader.readString(offsets[0]);
  object.conversationId = reader.readString(offsets[1]);
  object.id = id;
  object.isMock = reader.readBool(offsets[2]);
  object.originalText = reader.readString(offsets[3]);
  object.parentPostId = reader.readLongOrNull(offsets[4]);
  object.replyCount = reader.readLong(offsets[5]);
  object.sanitizedText = reader.readString(offsets[6]);
  object.timestamp = reader.readDateTime(offsets[7]);
  object.upvotes = reader.readLong(offsets[8]);
  return object;
}

P _anonymousPostDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _anonymousPostGetId(AnonymousPost object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _anonymousPostGetLinks(AnonymousPost object) {
  return [];
}

void _anonymousPostAttach(
    IsarCollection<dynamic> col, Id id, AnonymousPost object) {
  object.id = id;
}

extension AnonymousPostQueryWhereSort
    on QueryBuilder<AnonymousPost, AnonymousPost, QWhere> {
  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AnonymousPostQueryWhere
    on QueryBuilder<AnonymousPost, AnonymousPost, QWhereClause> {
  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterWhereClause> idBetween(
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

extension AnonymousPostQueryFilter
    on QueryBuilder<AnonymousPost, AnonymousPost, QFilterCondition> {
  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aliasMappingMetadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aliasMappingMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aliasMappingMetadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aliasMappingMetadata',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      aliasMappingMetadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aliasMappingMetadata',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'conversationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'conversationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'conversationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'conversationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      conversationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'conversationId',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
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

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      isMockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMock',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalText',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      originalTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalText',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentPostId',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentPostId',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentPostId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentPostId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentPostId',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      parentPostIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentPostId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      replyCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      replyCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      replyCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'replyCount',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      replyCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'replyCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sanitizedText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sanitizedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sanitizedText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sanitizedText',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      sanitizedTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sanitizedText',
        value: '',
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      upvotesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upvotes',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      upvotesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upvotes',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      upvotesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upvotes',
        value: value,
      ));
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterFilterCondition>
      upvotesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upvotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AnonymousPostQueryObject
    on QueryBuilder<AnonymousPost, AnonymousPost, QFilterCondition> {}

extension AnonymousPostQueryLinks
    on QueryBuilder<AnonymousPost, AnonymousPost, QFilterCondition> {}

extension AnonymousPostQuerySortBy
    on QueryBuilder<AnonymousPost, AnonymousPost, QSortBy> {
  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByAliasMappingMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasMappingMetadata', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByAliasMappingMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasMappingMetadata', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByConversationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conversationId', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByConversationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conversationId', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByIsMock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMock', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByIsMockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMock', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByOriginalText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalText', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByOriginalTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalText', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByParentPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentPostId', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByParentPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentPostId', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByReplyCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortBySanitizedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanitizedText', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortBySanitizedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanitizedText', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByUpvotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upvotes', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> sortByUpvotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upvotes', Sort.desc);
    });
  }
}

extension AnonymousPostQuerySortThenBy
    on QueryBuilder<AnonymousPost, AnonymousPost, QSortThenBy> {
  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByAliasMappingMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasMappingMetadata', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByAliasMappingMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aliasMappingMetadata', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByConversationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conversationId', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByConversationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'conversationId', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByIsMock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMock', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByIsMockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMock', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByOriginalText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalText', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByOriginalTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalText', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByParentPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentPostId', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByParentPostIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentPostId', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByReplyCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'replyCount', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenBySanitizedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanitizedText', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenBySanitizedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sanitizedText', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByUpvotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upvotes', Sort.asc);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QAfterSortBy> thenByUpvotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upvotes', Sort.desc);
    });
  }
}

extension AnonymousPostQueryWhereDistinct
    on QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> {
  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct>
      distinctByAliasMappingMetadata({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aliasMappingMetadata',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct>
      distinctByConversationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'conversationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctByIsMock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMock');
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctByOriginalText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct>
      distinctByParentPostId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentPostId');
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctByReplyCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'replyCount');
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctBySanitizedText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sanitizedText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<AnonymousPost, AnonymousPost, QDistinct> distinctByUpvotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upvotes');
    });
  }
}

extension AnonymousPostQueryProperty
    on QueryBuilder<AnonymousPost, AnonymousPost, QQueryProperty> {
  QueryBuilder<AnonymousPost, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AnonymousPost, String, QQueryOperations>
      aliasMappingMetadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aliasMappingMetadata');
    });
  }

  QueryBuilder<AnonymousPost, String, QQueryOperations>
      conversationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'conversationId');
    });
  }

  QueryBuilder<AnonymousPost, bool, QQueryOperations> isMockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMock');
    });
  }

  QueryBuilder<AnonymousPost, String, QQueryOperations> originalTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalText');
    });
  }

  QueryBuilder<AnonymousPost, int?, QQueryOperations> parentPostIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentPostId');
    });
  }

  QueryBuilder<AnonymousPost, int, QQueryOperations> replyCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'replyCount');
    });
  }

  QueryBuilder<AnonymousPost, String, QQueryOperations>
      sanitizedTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sanitizedText');
    });
  }

  QueryBuilder<AnonymousPost, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<AnonymousPost, int, QQueryOperations> upvotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upvotes');
    });
  }
}
