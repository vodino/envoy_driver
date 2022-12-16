// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_place.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const PlaceSchema = Schema(
  name: r'Place',
  id: 2865247039579441736,
  properties: {
    r'extent': PropertySchema(
      id: 0,
      name: r'extent',
      type: IsarType.doubleList,
    ),
    r'latitude': PropertySchema(
      id: 1,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 2,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'osmTag': PropertySchema(
      id: 3,
      name: r'osmTag',
      type: IsarType.string,
      enumMap: _PlaceosmTagEnumValueMap,
    ),
    r'subtitle': PropertySchema(
      id: 4,
      name: r'subtitle',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _placeEstimateSize,
  serialize: _placeSerialize,
  deserialize: _placeDeserialize,
  deserializeProp: _placeDeserializeProp,
);

int _placeEstimateSize(
  Place object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.extent;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.osmTag;
    if (value != null) {
      bytesCount += 3 + value.name.length * 3;
    }
  }
  {
    final value = object.subtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _placeSerialize(
  Place object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDoubleList(offsets[0], object.extent);
  writer.writeDouble(offsets[1], object.latitude);
  writer.writeDouble(offsets[2], object.longitude);
  writer.writeString(offsets[3], object.osmTag?.name);
  writer.writeString(offsets[4], object.subtitle);
  writer.writeString(offsets[5], object.title);
}

Place _placeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Place(
    extent: reader.readDoubleList(offsets[0]),
    latitude: reader.readDoubleOrNull(offsets[1]),
    longitude: reader.readDoubleOrNull(offsets[2]),
    osmTag: _PlaceosmTagValueEnumMap[reader.readStringOrNull(offsets[3])],
    subtitle: reader.readStringOrNull(offsets[4]),
    title: reader.readStringOrNull(offsets[5]),
  );
  return object;
}

P _placeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleList(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (_PlaceosmTagValueEnumMap[reader.readStringOrNull(offset)]) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PlaceosmTagEnumValueMap = {
  r'unknown': r'unknown',
  r'neighbourhood': r'neighbourhood',
  r'bridleway': r'bridleway',
  r'busStop': r'busStop',
  r'construction': r'construction',
  r'cycleway': r'cycleway',
  r'distanceMarker': r'distanceMarker',
  r'emergencyAccessPoint': r'emergencyAccessPoint',
  r'footway': r'footway',
  r'gate': r'gate',
  r'motorwayJunction': r'motorwayJunction',
  r'path': r'path',
  r'pedestrian': r'pedestrian',
  r'platform': r'platform',
  r'primary': r'primary',
  r'primaryLink': r'primaryLink',
  r'raceway': r'raceway',
  r'road': r'road',
  r'secondary': r'secondary',
  r'secondaryLink': r'secondaryLink',
  r'services': r'services',
  r'steps': r'steps',
  r'tertiary': r'tertiary',
  r'track': r'track',
  r'trail': r'trail',
  r'trunk': r'trunk',
  r'trunkLink': r'trunkLink',
  r'unsurfaced': r'unsurfaced',
  r'airport': r'airport',
  r'atm': r'atm',
  r'auditorium': r'auditorium',
  r'bank': r'bank',
  r'bar': r'bar',
  r'bench': r'bench',
  r'brothel': r'brothel',
  r'cafe': r'cafe',
  r'casino': r'casino',
  r'cinema': r'cinema',
  r'clinic': r'clinic',
  r'club': r'club',
  r'college': r'college',
  r'courthouse': r'courthouse',
  r'crematorium': r'crematorium',
  r'dentist': r'dentist',
  r'doctors': r'doctors',
  r'dormitory': r'dormitory',
  r'embassy': r'embassy',
  r'fastFood': r'fastFood',
  r'ferryTerminal': r'ferryTerminal',
  r'fountain': r'fountain',
  r'fuel': r'fuel',
  r'hall': r'hall',
  r'hospital': r'hospital',
  r'hotel': r'hotel',
  r'kindergarten': r'kindergarten',
  r'library': r'library',
  r'market': r'market',
  r'marketplace': r'marketplace',
  r'nightclub': r'nightclub',
  r'nursery': r'nursery',
  r'office': r'office',
  r'park': r'park',
  r'parking': r'parking',
  r'pharmacy': r'pharmacy',
  r'police': r'police',
  r'preschool': r'preschool',
  r'prison': r'prison',
  r'pub': r'pub',
  r'publicMarket': r'publicMarket',
  r'restaurant': r'restaurant',
  r'sauna': r'sauna',
  r'school': r'school',
  r'shelter': r'shelter',
  r'shop': r'shop',
  r'shopping': r'shopping',
  r'studio': r'studio',
  r'supermarket': r'supermarket',
  r'taxi': r'taxi',
  r'telephone': r'telephone',
  r'theatre': r'theatre',
  r'toilets': r'toilets',
  r'townhall': r'townhall',
  r'university': r'university',
  r'veterinary': r'veterinary',
  r'wifi': r'wifi',
  r'administrative': r'administrative',
  r'military': r'military',
  r'house': r'house',
  r'education': r'education',
  r'placeOfWorship': r'placeOfWorship',
};
const _PlaceosmTagValueEnumMap = {
  r'unknown': PlaceOsmTag.unknown,
  r'neighbourhood': PlaceOsmTag.neighbourhood,
  r'bridleway': PlaceOsmTag.bridleway,
  r'busStop': PlaceOsmTag.busStop,
  r'construction': PlaceOsmTag.construction,
  r'cycleway': PlaceOsmTag.cycleway,
  r'distanceMarker': PlaceOsmTag.distanceMarker,
  r'emergencyAccessPoint': PlaceOsmTag.emergencyAccessPoint,
  r'footway': PlaceOsmTag.footway,
  r'gate': PlaceOsmTag.gate,
  r'motorwayJunction': PlaceOsmTag.motorwayJunction,
  r'path': PlaceOsmTag.path,
  r'pedestrian': PlaceOsmTag.pedestrian,
  r'platform': PlaceOsmTag.platform,
  r'primary': PlaceOsmTag.primary,
  r'primaryLink': PlaceOsmTag.primaryLink,
  r'raceway': PlaceOsmTag.raceway,
  r'road': PlaceOsmTag.road,
  r'secondary': PlaceOsmTag.secondary,
  r'secondaryLink': PlaceOsmTag.secondaryLink,
  r'services': PlaceOsmTag.services,
  r'steps': PlaceOsmTag.steps,
  r'tertiary': PlaceOsmTag.tertiary,
  r'track': PlaceOsmTag.track,
  r'trail': PlaceOsmTag.trail,
  r'trunk': PlaceOsmTag.trunk,
  r'trunkLink': PlaceOsmTag.trunkLink,
  r'unsurfaced': PlaceOsmTag.unsurfaced,
  r'airport': PlaceOsmTag.airport,
  r'atm': PlaceOsmTag.atm,
  r'auditorium': PlaceOsmTag.auditorium,
  r'bank': PlaceOsmTag.bank,
  r'bar': PlaceOsmTag.bar,
  r'bench': PlaceOsmTag.bench,
  r'brothel': PlaceOsmTag.brothel,
  r'cafe': PlaceOsmTag.cafe,
  r'casino': PlaceOsmTag.casino,
  r'cinema': PlaceOsmTag.cinema,
  r'clinic': PlaceOsmTag.clinic,
  r'club': PlaceOsmTag.club,
  r'college': PlaceOsmTag.college,
  r'courthouse': PlaceOsmTag.courthouse,
  r'crematorium': PlaceOsmTag.crematorium,
  r'dentist': PlaceOsmTag.dentist,
  r'doctors': PlaceOsmTag.doctors,
  r'dormitory': PlaceOsmTag.dormitory,
  r'embassy': PlaceOsmTag.embassy,
  r'fastFood': PlaceOsmTag.fastFood,
  r'ferryTerminal': PlaceOsmTag.ferryTerminal,
  r'fountain': PlaceOsmTag.fountain,
  r'fuel': PlaceOsmTag.fuel,
  r'hall': PlaceOsmTag.hall,
  r'hospital': PlaceOsmTag.hospital,
  r'hotel': PlaceOsmTag.hotel,
  r'kindergarten': PlaceOsmTag.kindergarten,
  r'library': PlaceOsmTag.library,
  r'market': PlaceOsmTag.market,
  r'marketplace': PlaceOsmTag.marketplace,
  r'nightclub': PlaceOsmTag.nightclub,
  r'nursery': PlaceOsmTag.nursery,
  r'office': PlaceOsmTag.office,
  r'park': PlaceOsmTag.park,
  r'parking': PlaceOsmTag.parking,
  r'pharmacy': PlaceOsmTag.pharmacy,
  r'police': PlaceOsmTag.police,
  r'preschool': PlaceOsmTag.preschool,
  r'prison': PlaceOsmTag.prison,
  r'pub': PlaceOsmTag.pub,
  r'publicMarket': PlaceOsmTag.publicMarket,
  r'restaurant': PlaceOsmTag.restaurant,
  r'sauna': PlaceOsmTag.sauna,
  r'school': PlaceOsmTag.school,
  r'shelter': PlaceOsmTag.shelter,
  r'shop': PlaceOsmTag.shop,
  r'shopping': PlaceOsmTag.shopping,
  r'studio': PlaceOsmTag.studio,
  r'supermarket': PlaceOsmTag.supermarket,
  r'taxi': PlaceOsmTag.taxi,
  r'telephone': PlaceOsmTag.telephone,
  r'theatre': PlaceOsmTag.theatre,
  r'toilets': PlaceOsmTag.toilets,
  r'townhall': PlaceOsmTag.townhall,
  r'university': PlaceOsmTag.university,
  r'veterinary': PlaceOsmTag.veterinary,
  r'wifi': PlaceOsmTag.wifi,
  r'administrative': PlaceOsmTag.administrative,
  r'military': PlaceOsmTag.military,
  r'house': PlaceOsmTag.house,
  r'education': PlaceOsmTag.education,
  r'placeOfWorship': PlaceOsmTag.placeOfWorship,
};

extension PlaceQueryFilter on QueryBuilder<Place, Place, QFilterCondition> {
  QueryBuilder<Place, Place, QAfterFilterCondition> extentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extent',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extent',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extent',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> extentLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'extent',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'osmTag',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'osmTag',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagEqualTo(
    PlaceOsmTag? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagGreaterThan(
    PlaceOsmTag? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagLessThan(
    PlaceOsmTag? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagBetween(
    PlaceOsmTag? lower,
    PlaceOsmTag? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'osmTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'osmTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'osmTag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'osmTag',
        value: '',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> osmTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'osmTag',
        value: '',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subtitle',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'subtitle',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subtitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subtitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subtitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> subtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subtitle',
        value: '',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Place, Place, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PlaceQueryObject on QueryBuilder<Place, Place, QFilterCondition> {}
