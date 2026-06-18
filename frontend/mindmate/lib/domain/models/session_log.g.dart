// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionLogCollection on Isar {
  IsarCollection<SessionLog> get sessionLogs => this.collection();
}

const SessionLogSchema = CollectionSchema(
  name: r'SessionLog',
  id: -2594700486533071519,
  properties: {
    r'appOpenCount': PropertySchema(
      id: 0,
      name: r'appOpenCount',
      type: IsarType.long,
    ),
    r'chatMessages': PropertySchema(
      id: 1,
      name: r'chatMessages',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'journalEntries': PropertySchema(
      id: 3,
      name: r'journalEntries',
      type: IsarType.long,
    ),
    r'timeSpentMinutes': PropertySchema(
      id: 4,
      name: r'timeSpentMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _sessionLogEstimateSize,
  serialize: _sessionLogSerialize,
  deserialize: _sessionLogDeserialize,
  deserializeProp: _sessionLogDeserializeProp,
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
  getId: _sessionLogGetId,
  getLinks: _sessionLogGetLinks,
  attach: _sessionLogAttach,
  version: '3.1.0+1',
);

int _sessionLogEstimateSize(
  SessionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sessionLogSerialize(
  SessionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appOpenCount);
  writer.writeLong(offsets[1], object.chatMessages);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.journalEntries);
  writer.writeLong(offsets[4], object.timeSpentMinutes);
}

SessionLog _sessionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionLog();
  object.appOpenCount = reader.readLong(offsets[0]);
  object.chatMessages = reader.readLong(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.id = id;
  object.journalEntries = reader.readLong(offsets[3]);
  object.timeSpentMinutes = reader.readLong(offsets[4]);
  return object;
}

P _sessionLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionLogGetId(SessionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionLogGetLinks(SessionLog object) {
  return [];
}

void _sessionLogAttach(IsarCollection<dynamic> col, Id id, SessionLog object) {
  object.id = id;
}

extension SessionLogQueryWhereSort
    on QueryBuilder<SessionLog, SessionLog, QWhere> {
  QueryBuilder<SessionLog, SessionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension SessionLogQueryWhere
    on QueryBuilder<SessionLog, SessionLog, QWhereClause> {
  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
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

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterWhereClause> dateBetween(
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

extension SessionLogQueryFilter
    on QueryBuilder<SessionLog, SessionLog, QFilterCondition> {
  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      appOpenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appOpenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      appOpenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appOpenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      appOpenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appOpenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      appOpenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appOpenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      chatMessagesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      chatMessagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      chatMessagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      chatMessagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatMessages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      journalEntriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'journalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      journalEntriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'journalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      journalEntriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'journalEntries',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      journalEntriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'journalEntries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
      timeSpentMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSpentMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
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

  QueryBuilder<SessionLog, SessionLog, QAfterFilterCondition>
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

extension SessionLogQueryObject
    on QueryBuilder<SessionLog, SessionLog, QFilterCondition> {}

extension SessionLogQueryLinks
    on QueryBuilder<SessionLog, SessionLog, QFilterCondition> {}

extension SessionLogQuerySortBy
    on QueryBuilder<SessionLog, SessionLog, QSortBy> {
  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByAppOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appOpenCount', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByAppOpenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appOpenCount', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByChatMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatMessages', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByChatMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatMessages', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntries', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy>
      sortByJournalEntriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntries', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> sortByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy>
      sortByTimeSpentMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.desc);
    });
  }
}

extension SessionLogQuerySortThenBy
    on QueryBuilder<SessionLog, SessionLog, QSortThenBy> {
  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByAppOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appOpenCount', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByAppOpenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appOpenCount', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByChatMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatMessages', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByChatMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatMessages', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntries', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy>
      thenByJournalEntriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'journalEntries', Sort.desc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy> thenByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.asc);
    });
  }

  QueryBuilder<SessionLog, SessionLog, QAfterSortBy>
      thenByTimeSpentMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentMinutes', Sort.desc);
    });
  }
}

extension SessionLogQueryWhereDistinct
    on QueryBuilder<SessionLog, SessionLog, QDistinct> {
  QueryBuilder<SessionLog, SessionLog, QDistinct> distinctByAppOpenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appOpenCount');
    });
  }

  QueryBuilder<SessionLog, SessionLog, QDistinct> distinctByChatMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatMessages');
    });
  }

  QueryBuilder<SessionLog, SessionLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SessionLog, SessionLog, QDistinct> distinctByJournalEntries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'journalEntries');
    });
  }

  QueryBuilder<SessionLog, SessionLog, QDistinct> distinctByTimeSpentMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSpentMinutes');
    });
  }
}

extension SessionLogQueryProperty
    on QueryBuilder<SessionLog, SessionLog, QQueryProperty> {
  QueryBuilder<SessionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionLog, int, QQueryOperations> appOpenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appOpenCount');
    });
  }

  QueryBuilder<SessionLog, int, QQueryOperations> chatMessagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatMessages');
    });
  }

  QueryBuilder<SessionLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SessionLog, int, QQueryOperations> journalEntriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'journalEntries');
    });
  }

  QueryBuilder<SessionLog, int, QQueryOperations> timeSpentMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSpentMinutes');
    });
  }
}
