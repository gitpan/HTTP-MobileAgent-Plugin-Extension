use strict;

use strict;
use Test::More tests => 116;

BEGIN { use_ok 'HTTP::MobileAgent::Plugin::Extension' }

my @Tests = (
    # ua, method_hash
    [ "Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0",
      name => 'DDIPOCKET', vendor => 'JRC', model => 'AH-J3001V,AH-J3002V',
      model_version => '1.0', browser_version => '0100', cache_size => 50 ],
    [ "Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.16.65.000000/0.1/C100) Opera 7.0",
      name => 'DDIPOCKET', vendor => 'KYOCERA', model => 'AH-K3001V',
      model_version => '1.1.16.65.000000', browser_version => '0.1', cache_size => 100 ],
    [ "Mozilla/3.0(DDIPOCKET;JRC/AH-J3003S/1.0/0100/c50)CNF/2.0",
      name => 'DDIPOCKET', vendor => 'JRC', model => 'AH-J3003S',
      model_version => '1.0', browser_version => '0100', cache_size => 50 ],
    [ "Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.1.17.65.000001/0.1) Opera 7.0 [ja]",
      name => 'DDIPOCKET', vendor => 'KYOCERA', model => 'AH-K3001V',
      model_version => '1.1.17.65.000001', browser_version => '0.1', cache_size => 100, opera => 1 ],

);

for (@Tests) {
    my($ua, %data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    isa_ok $agent, 'HTTP::MobileAgent';

    if ($data{opera})
    {
      isa_ok $agent, 'HTTP::MobileAgent::NonMobile';
      ok $agent->is_non_mobile && !$agent->is_airh_phone && !$agent->is_docomo && !$agent->is_ezweb && !$agent->is_j_phone && !$agent->is_vodafone;
      is $agent->name(), 'Mozilla';
    }
    else
    {
      isa_ok $agent, 'HTTP::MobileAgent::AirHPhone';
      ok $agent->is_airh_phone && !$agent->is_docomo && !$agent->is_ezweb && !$agent->is_j_phone && !$agent->is_vodafone;
      is $agent->carrier, 'H';
      is $agent->carrier_longname, 'AirH';
      for my $key (keys %data) 
      {
        is $agent->$key(), $data{$key}, "$key is $data{$key}";
      }
    }
}

HTTP::MobileAgent::Plugin::Extension->import(qw(ah_operaAsMobile));

for (@Tests) {
    my($ua, %data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    isa_ok $agent, 'HTTP::MobileAgent';
    isa_ok $agent, 'HTTP::MobileAgent::AirHPhone';
    ok $agent->is_airh_phone && !$agent->is_docomo && !$agent->is_ezweb && !$agent->is_j_phone && !$agent->is_vodafone;
    for my $key (keys %data) 
    {
        next if ($key eq 'opera');
        is $agent->$key(), $data{$key}, "$key is $data{$key}";
    }
}

while (<DATA>) {
    next if /^#/;
    chomp;
    local $ENV{HTTP_USER_AGENT} = $_;
    my $agent = HTTP::MobileAgent->new;
    isa_ok $agent, 'HTTP::MobileAgent', "$_";
    ok $agent->is_airh_phone && !$agent->is_docomo && !$agent->is_ezweb && !$agent->is_j_phone && !$agent->is_vodafone;
    ok !$agent->is_gps && !$agent->is_eznavi && !$agent->is_station;
}

__END__
Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0
Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0
Mozilla/3.0(DDIPOCKET;JRC/AH-J3003S/1.0/0100/c50)CNF/2.0
Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.16.65.000000/0.1/C100) Opera 7.0
Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.17.65.000001/0.1/C100) Opera 7.0
Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.2.1.65.000000/0.1/C100) Opera 7.0
Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.4.1.67.000000/0.1/C100) Opera 7.0
Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.4.1.67.000001/0.1/C100) Opera 7.0
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.1.17.65.000001/0.1) Opera 7.0  [ja]
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.1.17.65.000001/0.1) Opera 7.0 [ja]
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.2.1.65.000000/0.1) Opera 7.0  [ja]
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.4.1.65.000000/0.1) Opera 7.0  [ja]
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.4.1.67.000000/0.1) Opera 7.0  [ja]
Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.4.1.67.000001/0.1) Opera 7.0  [ja]
