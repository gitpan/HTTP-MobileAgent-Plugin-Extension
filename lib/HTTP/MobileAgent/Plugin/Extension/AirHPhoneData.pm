package HTTP::MobileAgent::Plugin::Extension::AirHPhoneData;

use strict;
use vars qw($DisplayMap);

$DisplayMap ||= {
  'AH-J3001V' => {
    'width' => 128,
    'height' => 130,
    'depth' => 65536,
    'color' => 1
  },
  'AH-J3003S' => {
    'width' => 128,
    'height' => 130,
    'depth' => 65536,
    'color' => 1
  },
  'AH-K3001V' => {
    'width' => 237,
    'height' => 241,
    'depth' => 262144,
    'color' => 1
  },
};

1;