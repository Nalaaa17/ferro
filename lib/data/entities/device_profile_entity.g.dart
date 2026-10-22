// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_profile_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDeviceProfileEntityCollection on Isar {
  IsarCollection<DeviceProfileEntity> get deviceProfileEntitys =>
      this.collection();
}

const DeviceProfileEntitySchema = CollectionSchema(
  name: r'DeviceProfileEntity',
  id: 3641626473379294541,
  properties: {
    r'autoApply': PropertySchema(
      id: 0,
      name: r'autoApply',
      type: IsarType.bool,
    ),
    r'connectionType': PropertySchema(
      id: 1,
      name: r'connectionType',
      type: IsarType.string,
    ),
    r'deviceIdentifier': PropertySchema(
      id: 2,
      name: r'deviceIdentifier',
      type: IsarType.string,
    ),
    r'eqPresetId': PropertySchema(
      id: 3,
      name: r'eqPresetId',
      type: IsarType.long,
    ),
    r'lastConnected': PropertySchema(
      id: 4,
      name: r'lastConnected',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    ),
    r'targetVolume': PropertySchema(
      id: 6,
      name: r'targetVolume',
      type: IsarType.double,
    )
  },
  estimateSize: _deviceProfileEntityEstimateSize,
  serialize: _deviceProfileEntitySerialize,
  deserialize: _deviceProfileEntityDeserialize,
  deserializeProp: _deviceProfileEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'deviceIdentifier': IndexSchema(
      id: 8570335694319598033,
      name: r'deviceIdentifier',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'deviceIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _deviceProfileEntityGetId,
  getLinks: _deviceProfileEntityGetLinks,
  attach: _deviceProfileEntityAttach,
  version: '3.1.0+1',
);

int _deviceProfileEntityEstimateSize(
  DeviceProfileEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.connectionType.length * 3;
  bytesCount += 3 + object.deviceIdentifier.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _deviceProfileEntitySerialize(
  DeviceProfileEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoApply);
  writer.writeString(offsets[1], object.connectionType);
  writer.writeString(offsets[2], object.deviceIdentifier);
  writer.writeLong(offsets[3], object.eqPresetId);
  writer.writeDateTime(offsets[4], object.lastConnected);
  writer.writeString(offsets[5], object.name);
  writer.writeDouble(offsets[6], object.targetVolume);
}

DeviceProfileEntity _deviceProfileEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DeviceProfileEntity();
  object.autoApply = reader.readBool(offsets[0]);
  object.connectionType = reader.readString(offsets[1]);
  object.deviceIdentifier = reader.readString(offsets[2]);
  object.eqPresetId = reader.readLong(offsets[3]);
  object.id = id;
  object.lastConnected = reader.readDateTime(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.targetVolume = reader.readDouble(offsets[6]);
  return object;
}

P _deviceProfileEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _deviceProfileEntityGetId(DeviceProfileEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _deviceProfileEntityGetLinks(
    DeviceProfileEntity object) {
  return [];
}

void _deviceProfileEntityAttach(
    IsarCollection<dynamic> col, Id id, DeviceProfileEntity object) {
  object.id = id;
}

extension DeviceProfileEntityByIndex on IsarCollection<DeviceProfileEntity> {
  Future<DeviceProfileEntity?> getByDeviceIdentifier(String deviceIdentifier) {
    return getByIndex(r'deviceIdentifier', [deviceIdentifier]);
  }

  DeviceProfileEntity? getByDeviceIdentifierSync(String deviceIdentifier) {
    return getByIndexSync(r'deviceIdentifier', [deviceIdentifier]);
  }

  Future<bool> deleteByDeviceIdentifier(String deviceIdentifier) {
    return deleteByIndex(r'deviceIdentifier', [deviceIdentifier]);
  }

  bool deleteByDeviceIdentifierSync(String deviceIdentifier) {
    return deleteByIndexSync(r'deviceIdentifier', [deviceIdentifier]);
  }

  Future<List<DeviceProfileEntity?>> getAllByDeviceIdentifier(
      List<String> deviceIdentifierValues) {
    final values = deviceIdentifierValues.map((e) => [e]).toList();
    return getAllByIndex(r'deviceIdentifier', values);
  }

  List<DeviceProfileEntity?> getAllByDeviceIdentifierSync(
      List<String> deviceIdentifierValues) {
    final values = deviceIdentifierValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'deviceIdentifier', values);
  }

  Future<int> deleteAllByDeviceIdentifier(List<String> deviceIdentifierValues) {
    final values = deviceIdentifierValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'deviceIdentifier', values);
  }

  int deleteAllByDeviceIdentifierSync(List<String> deviceIdentifierValues) {
    final values = deviceIdentifierValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'deviceIdentifier', values);
  }

  Future<Id> putByDeviceIdentifier(DeviceProfileEntity object) {
    return putByIndex(r'deviceIdentifier', object);
  }

  Id putByDeviceIdentifierSync(DeviceProfileEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'deviceIdentifier', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDeviceIdentifier(List<DeviceProfileEntity> objects) {
    return putAllByIndex(r'deviceIdentifier', objects);
  }

  List<Id> putAllByDeviceIdentifierSync(List<DeviceProfileEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'deviceIdentifier', objects,
        saveLinks: saveLinks);
  }
}

extension DeviceProfileEntityQueryWhereSort
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QWhere> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DeviceProfileEntityQueryWhere
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QWhereClause> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
      deviceIdentifierEqualTo(String deviceIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deviceIdentifier',
        value: [deviceIdentifier],
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterWhereClause>
      deviceIdentifierNotEqualTo(String deviceIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceIdentifier',
              lower: [],
              upper: [deviceIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceIdentifier',
              lower: [deviceIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceIdentifier',
              lower: [deviceIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceIdentifier',
              lower: [],
              upper: [deviceIdentifier],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DeviceProfileEntityQueryFilter on QueryBuilder<DeviceProfileEntity,
    DeviceProfileEntity, QFilterCondition> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      autoApplyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoApply',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectionType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'connectionType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'connectionType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectionType',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      connectionTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'connectionType',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      deviceIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      eqPresetIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eqPresetId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      eqPresetIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eqPresetId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      eqPresetIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eqPresetId',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      eqPresetIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eqPresetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      lastConnectedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastConnected',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      lastConnectedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastConnected',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      lastConnectedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastConnected',
        value: value,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      lastConnectedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastConnected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
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

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      targetVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      targetVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      targetVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterFilterCondition>
      targetVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension DeviceProfileEntityQueryObject on QueryBuilder<DeviceProfileEntity,
    DeviceProfileEntity, QFilterCondition> {}

extension DeviceProfileEntityQueryLinks on QueryBuilder<DeviceProfileEntity,
    DeviceProfileEntity, QFilterCondition> {}

extension DeviceProfileEntityQuerySortBy
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QSortBy> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByAutoApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoApply', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByAutoApplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoApply', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByDeviceIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdentifier', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByDeviceIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdentifier', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByEqPresetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eqPresetId', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByEqPresetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eqPresetId', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByLastConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConnected', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByLastConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConnected', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByTargetVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetVolume', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      sortByTargetVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetVolume', Sort.desc);
    });
  }
}

extension DeviceProfileEntityQuerySortThenBy
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QSortThenBy> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByAutoApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoApply', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByAutoApplyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoApply', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByConnectionType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByConnectionTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'connectionType', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByDeviceIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdentifier', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByDeviceIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceIdentifier', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByEqPresetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eqPresetId', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByEqPresetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eqPresetId', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByLastConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConnected', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByLastConnectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastConnected', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByTargetVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetVolume', Sort.asc);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QAfterSortBy>
      thenByTargetVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetVolume', Sort.desc);
    });
  }
}

extension DeviceProfileEntityQueryWhereDistinct
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct> {
  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByAutoApply() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoApply');
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByConnectionType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'connectionType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByDeviceIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByEqPresetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eqPresetId');
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByLastConnected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastConnected');
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QDistinct>
      distinctByTargetVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetVolume');
    });
  }
}

extension DeviceProfileEntityQueryProperty
    on QueryBuilder<DeviceProfileEntity, DeviceProfileEntity, QQueryProperty> {
  QueryBuilder<DeviceProfileEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DeviceProfileEntity, bool, QQueryOperations>
      autoApplyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoApply');
    });
  }

  QueryBuilder<DeviceProfileEntity, String, QQueryOperations>
      connectionTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'connectionType');
    });
  }

  QueryBuilder<DeviceProfileEntity, String, QQueryOperations>
      deviceIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceIdentifier');
    });
  }

  QueryBuilder<DeviceProfileEntity, int, QQueryOperations>
      eqPresetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eqPresetId');
    });
  }

  QueryBuilder<DeviceProfileEntity, DateTime, QQueryOperations>
      lastConnectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastConnected');
    });
  }

  QueryBuilder<DeviceProfileEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DeviceProfileEntity, double, QQueryOperations>
      targetVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetVolume');
    });
  }
}
