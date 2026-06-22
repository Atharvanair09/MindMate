// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflection_follow_up.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReflectionFollowUpCollection on Isar {
  IsarCollection<ReflectionFollowUp> get reflectionFollowUps =>
      this.collection();
}

const ReflectionFollowUpSchema = CollectionSchema(
  name: r'ReflectionFollowUp',
  id: -7576242151284197939,
  properties: {
    r'burnoutChange': PropertySchema(
      id: 0,
      name: r'burnoutChange',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dismissed': PropertySchema(
      id: 2,
      name: r'dismissed',
      type: IsarType.bool,
    ),
    r'dismissedAt': PropertySchema(
      id: 3,
      name: r'dismissedAt',
      type: IsarType.dateTime,
    ),
    r'journalEntryId': PropertySchema(
      id: 4,
      name: r'journalEntryId',
      type: IsarType.long,
    ),
    r'journalNegativeMoodMismatch': PropertySchema(
      id: 5,
      name: r'journalNegativeMoodMismatch',
      type: IsarType.bool,
    ),
    r'journalPositiveMoodMismatch': PropertySchema(
      id: 6,
      name: r'journalPositiveMoodMismatch',
      type: IsarType.bool,
    ),
    r'message': PropertySchema(
      id: 7,
      name: r'message',
      type: IsarType.string,
    ),
    r'moodCheckInId': PropertySchema(
      id: 8,
      name: r'moodCheckInId',
      type: IsarType.long,
    ),
    r'reason': PropertySchema(
      id: 9,
      name: r'reason',
      type: IsarType.string,
    ),
    r'resolved': PropertySchema(
      id: 10,
      name: r'resolved',
      type: IsarType.bool,
    ),
    r'resolvedAt': PropertySchema(
      id: 11,
      name: r'resolvedAt',
      type: IsarType.dateTime,
    ),
    r'trendChange': PropertySchema(
      id: 12,
      name: r'trendChange',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userResponse': PropertySchema(
      id: 14,
      name: r'userResponse',
      type: IsarType.string,
    )
  },
  estimateSize: _reflectionFollowUpEstimateSize,
  serialize: _reflectionFollowUpSerialize,
  deserialize: _reflectionFollowUpDeserialize,
  deserializeProp: _reflectionFollowUpDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _reflectionFollowUpGetId,
  getLinks: _reflectionFollowUpGetLinks,
  attach: _reflectionFollowUpAttach,
  version: '3.1.0+1',
);

int _reflectionFollowUpEstimateSize(
  ReflectionFollowUp object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.message.length * 3;
  bytesCount += 3 + object.reason.length * 3;
  {
    final value = object.userResponse;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _reflectionFollowUpSerialize(
  ReflectionFollowUp object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.burnoutChange);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.dismissed);
  writer.writeDateTime(offsets[3], object.dismissedAt);
  writer.writeLong(offsets[4], object.journalEntryId);
  writer.writeBool(offsets[5], object.journalNegativeMoodMismatch);
  writer.writeBool(offsets[6], object.journalPositiveMoodMismatch);
  writer.writeString(offsets[7], object.message);
  writer.writeLong(offsets[8], object.moodCheckInId);
  writer.writeString(offsets[9], object.reason);
  writer.writeBool(offsets[10], object.resolved);
  writer.writeDateTime(offsets[11], object.resolvedAt);
  writer.writeBool(offsets[12], object.trendChange);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeString(offsets[14], object.userResponse);
}

ReflectionFollowUp _reflectionFollowUpDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReflectionFollowUp();
  object.burnoutChange = reader.readBool(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.dismissed = reader.readBool(offsets[2]);
  object.dismissedAt = reader.readDateTimeOrNull(offsets[3]);
  object.id = id;
  object.journalEntryId = reader.readLongOrNull(offsets[4]);
  object.journalNegativeMoodMismatch = reader.readBool(offsets[5]);
  object.journalPositiveMoodMismatch = reader.readBool(offsets[6]);
  object.message = reader.readString(offsets[7]);
  object.moodCheckInId = reader.readLongOrNull(offsets[8]);
  object.reason = reader.readString(offsets[9]);
  object.resolved = reader.readBool(offsets[10]);
  object.resolvedAt = reader.readDateTimeOrNull(offsets[11]);
  object.trendChange = reader.readBool(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  object.userResponse = reader.readStringOrNull(offsets[14]);
  return object;
}

P _reflectionFollowUpDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reflectionFollowUpGetId(ReflectionFollowUp object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reflectionFollowUpGetLinks(
    ReflectionFollowUp object) {
  return [];
}

void _reflectionFollowUpAttach(
    IsarCollection<dynamic> col, Id id, ReflectionFollowUp object) {
  object.id = id;
}

extension ReflectionFollowUpQueryWhereSort
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QWhere> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReflectionFollowUpQueryWhere
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QWhereClause> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhereClause>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterWhereClause>
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

extension ReflectionFollowUpQueryFilter
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QFilterCondition> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      burnoutChangeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'burnoutChange',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissed',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      dismissedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dismissedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
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

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'journalEntryId',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'journalEntryId',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEntryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalEntryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalEntryId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalEntryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalEntryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalNegativeMoodMismatchEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalNegativeMoodMismatch',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      journalPositiveMoodMismatchEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalPositiveMoodMismatch',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'moodCheckInId',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'moodCheckInId',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moodCheckInId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moodCheckInId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moodCheckInId',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      moodCheckInIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moodCheckInId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolved',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      resolvedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolvedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      trendChangeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trendChange',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userResponse',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userResponse',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userResponse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userResponse',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userResponse',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userResponse',
        value: '',
      ));
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterFilterCondition>
      userResponseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userResponse',
        value: '',
      ));
    });
  }
}

extension ReflectionFollowUpQueryObject
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QFilterCondition> {}

extension ReflectionFollowUpQueryLinks
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QFilterCondition> {}

extension ReflectionFollowUpQuerySortBy
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QSortBy> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByBurnoutChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutChange', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByBurnoutChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutChange', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissed', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissed', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalNegativeMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalNegativeMoodMismatch', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalNegativeMoodMismatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalNegativeMoodMismatch', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalPositiveMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalPositiveMoodMismatch', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByJournalPositiveMoodMismatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalPositiveMoodMismatch', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByMoodCheckInId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodCheckInId', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByMoodCheckInIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodCheckInId', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolved', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByResolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolved', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByTrendChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trendChange', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByTrendChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trendChange', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByUserResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userResponse', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      sortByUserResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userResponse', Sort.desc);
    });
  }
}

extension ReflectionFollowUpQuerySortThenBy
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QSortThenBy> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByBurnoutChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutChange', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByBurnoutChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'burnoutChange', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissed', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByDismissedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissed', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntryId', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalNegativeMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalNegativeMoodMismatch', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalNegativeMoodMismatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalNegativeMoodMismatch', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalPositiveMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalPositiveMoodMismatch', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByJournalPositiveMoodMismatchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalPositiveMoodMismatch', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'message', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByMoodCheckInId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodCheckInId', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByMoodCheckInIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moodCheckInId', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reason', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolved', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByResolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolved', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByTrendChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trendChange', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByTrendChangeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trendChange', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByUserResponse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userResponse', Sort.asc);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QAfterSortBy>
      thenByUserResponseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userResponse', Sort.desc);
    });
  }
}

extension ReflectionFollowUpQueryWhereDistinct
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct> {
  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByBurnoutChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'burnoutChange');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByDismissed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissed');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByJournalEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalEntryId');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByJournalNegativeMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalNegativeMoodMismatch');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByJournalPositiveMoodMismatch() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalPositiveMoodMismatch');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'message', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByMoodCheckInId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moodCheckInId');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolved');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolvedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByTrendChange() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trendChange');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QDistinct>
      distinctByUserResponse({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userResponse', caseSensitive: caseSensitive);
    });
  }
}

extension ReflectionFollowUpQueryProperty
    on QueryBuilder<ReflectionFollowUp, ReflectionFollowUp, QQueryProperty> {
  QueryBuilder<ReflectionFollowUp, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations>
      burnoutChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'burnoutChange');
    });
  }

  QueryBuilder<ReflectionFollowUp, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations> dismissedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissed');
    });
  }

  QueryBuilder<ReflectionFollowUp, DateTime?, QQueryOperations>
      dismissedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, int?, QQueryOperations>
      journalEntryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalEntryId');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations>
      journalNegativeMoodMismatchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalNegativeMoodMismatch');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations>
      journalPositiveMoodMismatchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalPositiveMoodMismatch');
    });
  }

  QueryBuilder<ReflectionFollowUp, String, QQueryOperations> messageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'message');
    });
  }

  QueryBuilder<ReflectionFollowUp, int?, QQueryOperations>
      moodCheckInIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moodCheckInId');
    });
  }

  QueryBuilder<ReflectionFollowUp, String, QQueryOperations> reasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reason');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations> resolvedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolved');
    });
  }

  QueryBuilder<ReflectionFollowUp, DateTime?, QQueryOperations>
      resolvedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolvedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, bool, QQueryOperations>
      trendChangeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trendChange');
    });
  }

  QueryBuilder<ReflectionFollowUp, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ReflectionFollowUp, String?, QQueryOperations>
      userResponseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userResponse');
    });
  }
}
