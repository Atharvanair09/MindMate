// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedding_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEmbeddingRecordCollection on Isar {
  IsarCollection<EmbeddingRecord> get embeddingRecords => this.collection();
}

const EmbeddingRecordSchema = CollectionSchema(
  name: r'EmbeddingRecord',
  id: 6271340597627583283,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'modelVersion': PropertySchema(
      id: 1,
      name: r'modelVersion',
      type: IsarType.string,
    ),
    r'sourceId': PropertySchema(
      id: 2,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'sourceType': PropertySchema(
      id: 3,
      name: r'sourceType',
      type: IsarType.string,
    ),
    r'storedLocally': PropertySchema(
      id: 4,
      name: r'storedLocally',
      type: IsarType.bool,
    ),
    r'vector': PropertySchema(
      id: 5,
      name: r'vector',
      type: IsarType.doubleList,
    ),
    r'vectorDimension': PropertySchema(
      id: 6,
      name: r'vectorDimension',
      type: IsarType.long,
    )
  },
  estimateSize: _embeddingRecordEstimateSize,
  serialize: _embeddingRecordSerialize,
  deserialize: _embeddingRecordDeserialize,
  deserializeProp: _embeddingRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'modelVersion': IndexSchema(
      id: 6216276653294924861,
      name: r'modelVersion',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'modelVersion',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _embeddingRecordGetId,
  getLinks: _embeddingRecordGetLinks,
  attach: _embeddingRecordAttach,
  version: '3.1.0+1',
);

int _embeddingRecordEstimateSize(
  EmbeddingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.modelVersion.length * 3;
  bytesCount += 3 + object.sourceType.length * 3;
  bytesCount += 3 + object.vector.length * 8;
  return bytesCount;
}

void _embeddingRecordSerialize(
  EmbeddingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.modelVersion);
  writer.writeLong(offsets[2], object.sourceId);
  writer.writeString(offsets[3], object.sourceType);
  writer.writeBool(offsets[4], object.storedLocally);
  writer.writeDoubleList(offsets[5], object.vector);
  writer.writeLong(offsets[6], object.vectorDimension);
}

EmbeddingRecord _embeddingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EmbeddingRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.modelVersion = reader.readString(offsets[1]);
  object.sourceId = reader.readLong(offsets[2]);
  object.sourceType = reader.readString(offsets[3]);
  object.storedLocally = reader.readBool(offsets[4]);
  object.vector = reader.readDoubleList(offsets[5]) ?? [];
  object.vectorDimension = reader.readLong(offsets[6]);
  return object;
}

P _embeddingRecordDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _embeddingRecordGetId(EmbeddingRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _embeddingRecordGetLinks(EmbeddingRecord object) {
  return [];
}

void _embeddingRecordAttach(
    IsarCollection<dynamic> col, Id id, EmbeddingRecord object) {
  object.id = id;
}

extension EmbeddingRecordQueryWhereSort
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QWhere> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EmbeddingRecordQueryWhere
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QWhereClause> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause>
      modelVersionEqualTo(String modelVersion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'modelVersion',
        value: [modelVersion],
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterWhereClause>
      modelVersionNotEqualTo(String modelVersion) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelVersion',
              lower: [],
              upper: [modelVersion],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelVersion',
              lower: [modelVersion],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelVersion',
              lower: [modelVersion],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'modelVersion',
              lower: [],
              upper: [modelVersion],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EmbeddingRecordQueryFilter
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QFilterCondition> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
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

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      modelVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      sourceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceType',
        value: '',
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      storedLocallyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'storedLocally',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vector',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vector',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vector',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vector',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vector',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorDimensionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vectorDimension',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorDimensionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vectorDimension',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorDimensionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vectorDimension',
        value: value,
      ));
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterFilterCondition>
      vectorDimensionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vectorDimension',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EmbeddingRecordQueryObject
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QFilterCondition> {}

extension EmbeddingRecordQueryLinks
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QFilterCondition> {}

extension EmbeddingRecordQuerySortBy
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QSortBy> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByModelVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByModelVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByStoredLocally() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storedLocally', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByStoredLocallyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storedLocally', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByVectorDimension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vectorDimension', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      sortByVectorDimensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vectorDimension', Sort.desc);
    });
  }
}

extension EmbeddingRecordQuerySortThenBy
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QSortThenBy> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByModelVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByModelVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelVersion', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenBySourceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenBySourceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceType', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByStoredLocally() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storedLocally', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByStoredLocallyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'storedLocally', Sort.desc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByVectorDimension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vectorDimension', Sort.asc);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QAfterSortBy>
      thenByVectorDimensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vectorDimension', Sort.desc);
    });
  }
}

extension EmbeddingRecordQueryWhereDistinct
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct> {
  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctByModelVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelVersion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctBySourceType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctByStoredLocally() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'storedLocally');
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct> distinctByVector() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vector');
    });
  }

  QueryBuilder<EmbeddingRecord, EmbeddingRecord, QDistinct>
      distinctByVectorDimension() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vectorDimension');
    });
  }
}

extension EmbeddingRecordQueryProperty
    on QueryBuilder<EmbeddingRecord, EmbeddingRecord, QQueryProperty> {
  QueryBuilder<EmbeddingRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EmbeddingRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<EmbeddingRecord, String, QQueryOperations>
      modelVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelVersion');
    });
  }

  QueryBuilder<EmbeddingRecord, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<EmbeddingRecord, String, QQueryOperations> sourceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceType');
    });
  }

  QueryBuilder<EmbeddingRecord, bool, QQueryOperations>
      storedLocallyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'storedLocally');
    });
  }

  QueryBuilder<EmbeddingRecord, List<double>, QQueryOperations>
      vectorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vector');
    });
  }

  QueryBuilder<EmbeddingRecord, int, QQueryOperations>
      vectorDimensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vectorDimension');
    });
  }
}
