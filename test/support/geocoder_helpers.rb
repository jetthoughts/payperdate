Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
    [
        {
            'latitude'     => 40.7143528,
            'longitude'    => -74.0059731,
            'address'      => 'New York, NY, USA',
            'state'        => 'New York',
            'state_code'   => 'NY',
            'country'      => 'United States',
            'country_code' => 'US'
        }
    ]
)

Geocoder::Lookup::Test.add_stub(
  "6456 SW 10th Terrace, Miami, Florida 33144",
  [
    {
      "latitude"=>25.7607207,
      "longitude"=>-80.3009813,
      "address"=>"6456 Southwest 10th Terrace, Miami, FL 33144, USA",
      "state"=>"Florida",
      "state_code"=>"FL",
      "country"=>"United States",
      "country_code"=>"US"
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  "Miami",
  [
    {"latitude"=>25.7889689,
     "longitude"=>-80.2264393,
     "address"=>"Miami, FL, USA",
     "state"=>"Florida",
     "state_code"=>"FL",
     "country"=>"United States",
     "country_code"=>"US"}
  ]
)

Geocoder::Lookup::Test.add_stub(
  "21 SW 59th Ave, Miami, Florida 33144",
  [{"latitude"=>25.770168,
 "longitude"=>-80.291343,
 "address"=>"21 Southwest 59th Avenue, Miami, FL 33144, USA",
 "state"=>"Florida",
 "state_code"=>"FL",
 "country"=>"United States",
 "country_code"=>"US"}]
)


Geocoder::Lookup::Test.add_stub(
  "5th avenue, Fake city, New Yourk 11091",
  []
)


Geocoder::Lookup::Test.add_stub(
  "678 5th Ave, New York, NY 10019",
  [{"latitude"=>40.760848,
 "longitude"=>-73.97626199999999,
 "address"=>"678 5th Avenue, New York, NY 10019, USA",
 "state"=>"New York",
 "state_code"=>"NY",
 "country"=>"United States",
 "country_code"=>"US"}]
)

Geocoder::Lookup::Test.add_stub(
  "8 Rue de Londres, Paris, France 75009",
  [{"latitude"=>48.8769798,
 "longitude"=>2.3300511,
 "address"=>"8 Rue de Londres, 75009 Paris, France",
 "state"=>"Île-de-France",
 "state_code"=>"IDF",
 "country"=>"France",
 "country_code"=>"FR",
 "postal_code"=>"75009"}]
)


Geocoder::Lookup::Test.add_stub(
  "8 Rue de Londres, Paris, france 75109",
  [{"latitude"=>48.8769798,
 "longitude"=>2.3300511,
 "address"=>"8 Rue de Londres, 75009 Paris, France",
 "state"=>"Île-de-France",
 "state_code"=>"IDF",
 "country"=>"France",
 "country_code"=>"FR",
 "postal_code"=>"75009"}]
)


