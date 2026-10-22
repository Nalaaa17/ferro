// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eq_preset_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEQPresetEntityCollection on Isar {
  IsarCollection<EQPresetEntity> get eQPresetEntitys => this.collection();
}

const EQPresetEntitySchema = CollectionSchema(
  name: r'EQPresetEntity',
  id: -632779867024707540,
  properties: {
    r'bands': PropertySchema(
      id: 0,
      name: r'bands',
      type: IsarType.doubleList,
    ),
    r'bassBoost': PropertySchema(
      id: 1,
      name: r'bassBoost',
      type: IsarType.double,
    ),
    r'isPresetReadOnly': PropertySchema(
      id: 2,
      name: r'isPresetReadOnly',
      type: IsarType.bool,
    ),
    r'loudnessEnhancer': PropertySchema(
      id: 3,
      name: r'loudnessEnhancer',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'virtualizer': PropertySchema(
      id: 5,
      name: r'virtualizer',
      type: IsarType.double,
    )
  },
  estimateSize: _eQPresetEntityEstimateSize,
  serialize: _eQPresetEntitySerialize,
  deserialize: _eQPresetEntityDeserialize,
  deserializeProp: _eQPresetEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _eQPresetEntityGetId,
  getLinks: _eQPresetEntityGetLinks,
  attach: _eQPresetEntityAttach,
  version: '3.1.0+1',
);

int _eQPresetEntityEstimateSize(
  EQPresetEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bands.length * 8;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _eQPresetEntitySerialize(
  EQPresetEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDoubleList(offsets[0], object.bands);
  writer.writeDouble(offsets[1], object.bassBoost);
  writer.writeBool(offsets[2], object.isPresetReadOnly);
  writer.writeBool(offsets[3], object.loudnessEnhancer);
  writer.writeString(offsets[4], object.name);
  writer.writeDouble(offsets[5], object.virtualizer);
}

EQPresetEntity _eQPresetEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EQPresetEntity();
  object.bands = reader.readDoubleList(offsets[0]) ?? [];
  object.bassBoost = reader.readDouble(offsets[1]);
  object.id = id;
  object.isPresetReadOnly = reader.readBool(offsets[2]);
  object.loudnessEnhancer = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.virtualizer = reader.readDouble(offsets[5]);
  return object;
}

P _eQPresetEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _eQPresetEntityGetId(EQPresetEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _eQPresetEntityGetLinks(EQPresetEntity object) {
  return [];
}

void _eQPresetEntityAttach(
    IsarCollection<dynamic> col, Id id, EQPresetEntity object) {
  object.id = id;
}

extension EQPresetEntityByIndex on IsarCollection<EQPresetEntity> {
  Future<EQPresetEntity?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  EQPresetEntity? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<EQPresetEntity?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<EQPresetEntity?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(EQPresetEntity object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(EQPresetEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<EQPresetEntity> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<EQPresetEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension EQPresetEntityQueryWhereSort
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QWhere> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension EQPresetEntityQueryWhere
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QWhereClause> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterWhereClause>
      nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension EQPresetEntityQueryFilter
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QFilterCondition> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bands',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bands',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bands',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bands',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bandsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bands',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bassBoostEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bassBoost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bassBoostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bassBoost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bassBoostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bassBoost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      bassBoostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bassBoost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
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

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
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

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      isPresetReadOnlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPresetReadOnly',
        value: value,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      loudnessEnhancerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loudnessEnhancer',
        value: value,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      virtualizerEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'virtualizer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      virtualizerGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'virtualizer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      virtualizerLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'virtualizer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterFilterCondition>
      virtualizerBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'virtualizer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension EQPresetEntityQueryObject
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QFilterCondition> {}

extension EQPresetEntityQueryLinks
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QFilterCondition> {}

extension EQPresetEntityQuerySortBy
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QSortBy> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> sortByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByBassBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByIsPresetReadOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPresetReadOnly', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByIsPresetReadOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPresetReadOnly', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByLoudnessEnhancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessEnhancer', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByLoudnessEnhancerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessEnhancer', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      sortByVirtualizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.desc);
    });
  }
}

extension EQPresetEntityQuerySortThenBy
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QSortThenBy> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> thenByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByBassBoostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bassBoost', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByIsPresetReadOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPresetReadOnly', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByIsPresetReadOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPresetReadOnly', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByLoudnessEnhancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessEnhancer', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByLoudnessEnhancerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loudnessEnhancer', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.asc);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QAfterSortBy>
      thenByVirtualizerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'virtualizer', Sort.desc);
    });
  }
}

extension EQPresetEntityQueryWhereDistinct
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct> {
  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct> distinctByBands() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bands');
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct>
      distinctByBassBoost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bassBoost');
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct>
      distinctByIsPresetReadOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPresetReadOnly');
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct>
      distinctByLoudnessEnhancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loudnessEnhancer');
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EQPresetEntity, EQPresetEntity, QDistinct>
      distinctByVirtualizer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'virtualizer');
    });
  }
}

extension EQPresetEntityQueryProperty
    on QueryBuilder<EQPresetEntity, EQPresetEntity, QQueryProperty> {
  QueryBuilder<EQPresetEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EQPresetEntity, List<double>, QQueryOperations> bandsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bands');
    });
  }

  QueryBuilder<EQPresetEntity, double, QQueryOperations> bassBoostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bassBoost');
    });
  }

  QueryBuilder<EQPresetEntity, bool, QQueryOperations>
      isPresetReadOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPresetReadOnly');
    });
  }

  QueryBuilder<EQPresetEntity, bool, QQueryOperations>
      loudnessEnhancerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loudnessEnhancer');
    });
  }

  QueryBuilder<EQPresetEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<EQPresetEntity, double, QQueryOperations> virtualizerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'virtualizer');
    });
  }
}
