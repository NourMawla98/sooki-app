/// Minimal Lebanon city → area lookup for the address form.
/// Extend here as coverage grows.
const Map<String, List<String>> lebanonAreas = {
  'Beirut': [
    'Achrafieh',
    'Hamra',
    'Mar Mikhael',
    'Gemmayze',
    'Downtown',
    'Verdun',
    'Badaro',
    'Raouche',
    'Manara',
    'Sodeco',
    'Ras Beirut',
    'Mazraa',
    'Sioufi',
    'Other',
  ],
  'Mount Lebanon': [
    'Jounieh',
    'Maameltein',
    'Kaslik',
    'Zalka',
    'Dbayeh',
    'Antelias',
    'Jal el Dib',
    'Broummana',
    'Baabda',
    'Hazmieh',
    'Sin el Fil',
    'Furn el Chebbak',
    'Other',
  ],
  'Tripoli': [
    'El Mina',
    'Abu Samra',
    'Dam w Farez',
    'Zahrieh',
    'Qobbeh',
    'Other',
  ],
  'Sidon': ['Old Saida', 'Villa', 'Bramieh', 'Ghazieh', 'Other'],
  'Tyre': ['Old Tyre', 'Al Raml', 'Hay el Ramel', 'Other'],
  'Byblos': ['Old Jbeil', 'Jbeil Center', 'Blat', 'Other'],
  'Zahle': ['Haouch el Omara', 'Ksara', 'Maalaka', 'Other'],
  'Baalbek': ['Baalbek Center', 'Ras Baalbek', 'Other'],
  'Nabatieh': ['Nabatieh Center', 'Kfar Roummane', 'Other'],
  'Other': ['Other'],
};

List<String> areasFor(String? city) {
  if (city == null) return const [];
  return lebanonAreas[city] ?? const ['Other'];
}

List<String> get lebanonCities => lebanonAreas.keys.toList();
