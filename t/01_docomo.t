use strict;
use Test::More tests => 1837;

BEGIN { use_ok 'HTTP::MobileAgent::Plugin::Extension' }

my @Tests = (
    # ua, version, html_version, model, cache_size, is_foma, vendor, series, options
    [ "DoCoMo/1.0/D501i", '1.0', '1.0', 'D501i', 5, undef, 'D', '501i' ],
    [ "DoCoMo/1.0/D502i", '1.0', '2.0', 'D502i', 5, undef, 'D', '502i' ],
    [ "DoCoMo/1.0/D502i/c10", '1.0', '2.0', 'D502i', 10, undef, 'D', '502i' ],
    [ "DoCoMo/1.0/D210i/c10", '1.0', '3.0', 'D210i', 10, undef, 'D', '210i', { is_utn => 1 } ],
    [ "DoCoMo/1.0/SO503i/c10", '1.0', '3.0', 'SO503i', 10, undef, 'SO', '503i', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/D211i/c10", '1.0', '3.0', 'D211i', 10, undef, 'D', '211i', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/SH251i/c10", '1.0', '3.0', 'SH251i', 10, undef, 'SH', '251i', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/R692i/c10", '1.0', '3.0', 'R692i', 10, undef, 'R', '692i', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 P2101V(c100)", '2.0', '3.0', 'P2101V', 100, 1, 'P', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 N2001(c10)", '2.0', '3.0', 'N2001', 10, 1, 'N', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 N2002(c100)", '2.0', '3.0', 'N2002', 100, 1, 'N', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 D2101V(c100)", '2.0', '3.0', 'D2101V', 100, 1, 'D', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 P2002(c100)", '2.0', '3.0', 'P2002', 100, 1, 'P', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 MST_v_SH2101V(c100)", '2.0', '3.0', 'SH2101V', 100, 1, 'SH', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 T2101V(c100)", '2.0', '3.0', 'T2101V', 100, 1, 'T', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/D504i/c10", '1.0', '4.0', 'D504i', 10, undef, 'D', '504i', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/D504i/c30/TD", '1.0', '4.0', 'D504i', 30, undef, 'D', '504i', { status => 'TD',is_utn => 1 } ],
    [ "DoCoMo/1.0/D504i/c10/TJ", '1.0', '4.0', 'D504i', 10, undef, 'D', '504i', { status => 'TJ',is_utn => 1 } ],
    [ "DoCoMo/1.0/F504i/c10/TB", '1.0', '4.0', 'F504i', 10, undef, 'F', '504i', { status => 'TB',is_utn => 1 } ],
    [ "DoCoMo/1.0/D251i/c10", '1.0', '4.0', 'D251i', 10, undef, 'D', '251i', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/F251i/c10/TB", '1.0', '4.0', 'F251i', 10, undef, 'F', '251i', { status => 'TB',is_utn => 1 } ],
    [ "DoCoMo/1.0/F671iS/c10/TB", '1.0', '4.0', 'F671iS', 10, undef, 'F', '671i', { status => 'TB',is_utn => 1 } ],
    [ "DoCoMo/1.0/P503i/c10/serNMABH200331", '1.0', '3.0', 'P503i', 10, undef, 'P', '503i', { serial_number => 'NMABH200331',is_utn => 1 } ],
    [ "DoCoMo/2.0 N2001(c10;ser0123456789abcde;icc01234567890123456789)",
      '2.0', '3.0', 'N2001', 10, 1, 'N', 'FOMA', { serial_number => '0123456789abcde', card_id => '01234567890123456789',is_utn => 1 } ],
    [ "DoCoMo/1.0/eggy/c300/s32/kPHS-K", '1.0', '3.2', 'eggy', 300, undef, undef, undef, { bandwidth => 32,is_utn => 1 } ],
    [ "DoCoMo/1.0/P751v/c100/s64/kPHS-K", '1.0', '3.2', 'P751v', 100, undef, 'P', undef, { bandwidth => 64,is_utn => 1 } ],
    [ "DoCoMo/1.0/P209is (Google CHTML Proxy/1.0)", '1.0', '2.0', 'P209is', 5, undef, 'P', '209i', { comment => 'Google CHTML Proxy/1.0' } ],
    [ "DoCoMo/1.0/F212i/c10/TB", '1.0', '4.0', 'F212i', 10, undef, 'F', '212i', { is_utn => 1 }  ],
    [ "DoCoMo/2.0 N2051(c100;TB)", '2.0', '4.0', 'N2051', 100, 1, 'N', 'FOMA', { is_utn => 1 }  ],
    [ "DoCoMo/1.0/D505i/c20/TC/W20H10", '1.0', '5.0', 'D505i', 20, undef, 'D', '505i', { status => 'TC',is_utn => 1 ,is_gps => ''} ],
    [ "DoCoMo/1.0/SH505i2/c20/TB/W20H10", '1.0', '5.0', 'SH505i', 20, undef, 'SH', '505i', { status => 'TB',is_utn => 1 ,is_gps => ''} ],
    [ "DoCoMo/1.0/F661i/c10/TB", '1.0', '4.0', 'F661i', 10, undef, 'F', '661i', { is_gps => 1,is_utn => 1 } ],
    [ "DoCoMo/2.0 SH900i(c100;TB;W24H12)", '2.0', '5.0', 'SH900i', 100, 1, 'SH', '900i', { status => 'TB',is_utn => 1,is_gps => ''} ],
    [ "DoCoMo/1.0/F505iGPS/c20/TB/W20H10", 
      '1.0', '5.0', 'F505iGPS', 20, undef, 'F', '505i', { status => 'TB',is_gps => 1,is_utn => 1} ],
    [ "DoCoMo/1.0/SO213i/c10/TB","1.0", '4.0', 'SO213i', 10, undef, 'SO', '213i', { status => 'TB',is_utn => 1,is_gps => ''} ],
    [ "DoCoMo/2.0 F880iES(c100;TB;W20H08)", '2.0', '5.0', 'F880iES', 100, 1, 'F', '880i', { status => 'TB',is_utn => 1,is_gps => ''} ],
);

for (@Tests) {
    my($ua, @data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    isa_ok $agent, 'HTTP::MobileAgent';
    isa_ok $agent, 'HTTP::MobileAgent::DoCoMo';
    ok $agent->is_docomo && ! $agent->is_j_phone && !$agent->is_vodafone && ! $agent->is_ezweb && !$agent->is_airh_phone;
    is $agent->name, 'DoCoMo';
    is $agent->user_agent, $ua,		"ua is $ua";
    is $agent->version, $data[0],	"version is $data[0]";
    is $agent->html_version, $data[1],	"HTML version is $data[1]";
    is $agent->model, $data[2],		"model is $data[2]";
    is $agent->cache_size, $data[3],	"cache size is $data[3]";
    is $agent->is_foma, $data[4],	"is_foma";
    is $agent->vendor, $data[5],	"vendor";
    is $agent->series, $data[6],	"cache size";
    if ($data[7]) {
	is $agent->$_(), $data[7]->{$_},"testing $_" for keys %{$data[7]};
    }
    is $agent->carrier, 'I' , "carrier is I";
    is $agent->carrier_longname, 'DoCoMo' ,  "carrier longname is DoCoMo";

}

while (<DATA>) {
    next if /^#/;
    chomp;
    local $ENV{HTTP_USER_AGENT} = $_;
    my $agent = HTTP::MobileAgent->new;
    isa_ok $agent, 'HTTP::MobileAgent', "$_";
    is $agent->name, 'DoCoMo';
    ok $agent->is_docomo && ! $agent->is_j_phone && ! $agent->is_ezweb && ! $agent->is_airh_phone;
    ok ! $agent->is_station && ! $agent->is_eznavi;
}

__END__
DoCoMo/1.0/633S/c20
DoCoMo/1.0/641P/c10
DoCoMo/1.0/641S/c10
DoCoMo/1.0/642S/c20
DoCoMo/1.0/Agent
DoCoMo/1.0/D209i
DoCoMo/1.0/D209i/c10
DoCoMo/1.0/D210i/c10
DoCoMo/1.0/D211i/c10
DoCoMo/1.0/D251i/c10
DoCoMo/1.0/D501i
DoCoMo/1.0/D501i/c5
DoCoMo/1.0/D502i
DoCoMo/1.0/D502i/c10
DoCoMo/1.0/D503i
DoCoMo/1.0/D503i/c10
DoCoMo/1.0/D503i/c5
DoCoMo/1.0/D503iS/c10
DoCoMo/1.0/D503iS/c5
DoCoMo/1.0/D504i/c10
DoCoMo/1.0/ER209i
DoCoMo/1.0/ER209i/c15
DoCoMo/1.0/F209i
DoCoMo/1.0/F209i/c10
DoCoMo/1.0/F210i/c10
DoCoMo/1.0/F211i/c10
DoCoMo/1.0/F251i/c10/TB
DoCoMo/1.0/F501i
DoCoMo/1.0/F502i
DoCoMo/1.0/F502i/c10
DoCoMo/1.0/F502it
DoCoMo/1.0/F502it/c10
DoCoMo/1.0/F503i
DoCoMo/1.0/F503i/c10
DoCoMo/1.0/F503i/c32
DoCoMo/1.0/F503iS
DoCoMo/1.0/F503iS/c10
DoCoMo/1.0/F504i/c10/TB
DoCoMo/1.0/F504i/c10/TJ
DoCoMo/1.0/F671i/c10
DoCoMo/1.0/GigaCode (http://gigacode.net/)
DoCoMo/1.0/KO209i
DoCoMo/1.0/KO210i
DoCoMo/1.0/KO210i/c10
DoCoMo/1.0/N209i
DoCoMo/1.0/N209i/c08
DoCoMo/1.0/N210i
DoCoMo/1.0/N210i/c10
DoCoMo/1.0/N211i/c10
DoCoMo/1.0/N501i
DoCoMo/1.0/N502i
DoCoMo/1.0/N502i/c08
DoCoMo/1.0/N502it
DoCoMo/1.0/N502it/c10
DoCoMo/1.0/N503i
DoCoMo/1.0/N503i/c10
DoCoMo/1.0/N503i/c30
DoCoMo/1.0/N503i/c5
DoCoMo/1.0/N503i/c5/serNNEBJ608187
DoCoMo/1.0/N503iS
DoCoMo/1.0/N503iS/c10
DoCoMo/1.0/N503iS/c5
DoCoMo/1.0/N504i/c10
DoCoMo/1.0/N504i/c10/TB
DoCoMo/1.0/N504i/c10/TJ
DoCoMo/1.0/N504i/c10/TJ/c0
DoCoMo/1.0/N821i
DoCoMo/1.0/N821i/c08
DoCoMo/1.0/NM502i
DoCoMo/1.0/NM502i/c10
DoCoMo/1.0/P209i
DoCoMo/1.0/P209i/c10
DoCoMo/1.0/P209is
DoCoMo/1.0/P209is (Google CHTML Proxy/1.0)
DoCoMo/1.0/P209is/c10
DoCoMo/1.0/P210i
DoCoMo/1.0/P210i/c10
DoCoMo/1.0/P211i/c10
DoCoMo/1.0/P501i
DoCoMo/1.0/P502i
DoCoMo/1.0/P502i/c10
DoCoMo/1.0/P502i/c10 (Google CHTML Proxy/1.0)
DoCoMo/1.0/P502i_mEB-PD555
DoCoMo/1.0/P503i
DoCoMo/1.0/P503i/c10
DoCoMo/1.0/P503i/c10/
DoCoMo/1.0/P503iS
DoCoMo/1.0/P503iS/c10
DoCoMo/1.0/P503iS/c10/serNMAUA482012
DoCoMo/1.0/P504i/c10
DoCoMo/1.0/P504i/c10/TB
DoCoMo/1.0/P751v/c100/s64/kPHS-K
DoCoMo/1.0/P821i
DoCoMo/1.0/P821i/c08
DoCoMo/1.0/PacketMeter/c10
DoCoMo/1.0/R209i
DoCoMo/1.0/R211i/c10
DoCoMo/1.0/R691i
DoCoMo/1.0/SH251i/c10
DoCoMo/1.0/SH712m/c10
DoCoMo/1.0/SH821i
DoCoMo/1.0/SH821i/c10
DoCoMo/1.0/SO210i/c10
DoCoMo/1.0/SO211i/c10
DoCoMo/1.0/SO502i
DoCoMo/1.0/SO502iWM/c10
DoCoMo/1.0/SO503i
DoCoMo/1.0/SO503i/c10
DoCoMo/1.0/SO503i/c10/serNSOBD506895
DoCoMo/1.0/SO503i/c10/serNSOBD597705
DoCoMo/1.0/SO503iS/c10
DoCoMo/1.0/SO504i/c10
DoCoMo/1.0/SO504i/c10/TB
DoCoMo/1.0/TEST/c10
DoCoMo/1.0/TF502i
DoCoMo/1.0/X503i/c10
DoCoMo/1.0/eggy/c300/s32/kPHS-K
DoCoMo/1.0/eggy/c300/s64/kPHS-K
DoCoMo/1.0/ex_idisplay/c10
DoCoMo/1.0/ex_ps_test00/c10
DoCoMo/1.0/iYappo
DoCoMo/1.0/p503is/c10
DoCoMo/1.0/test
DoCoMo/1.0/test/c10
DoCoMo/1.0/test/c10/TB
DoCoMo/1.1/P711m/c10
DoCoMo/2.0 D2101V(c100)
DoCoMo/2.0 MST_v_P2101V(c100)
DoCoMo/2.0 N2001(c10)
DoCoMo/2.0 N2001(c10;ser350200000307969;icc8981100000200188565F)
DoCoMo/2.0 N2002(c100)
DoCoMo/2.0 P2002(c100)
DoCoMo/2.0 P2101V
DoCoMo/2.0 P2101V(c100)
DoCoMo/2.0/N502i
DoCoMo/2.0/N502it
DoCoMo/2.0/N503i
DoCoMo/3.0/N503
DoCoMo/2.0 SH900i(c100;TB;W24H12)
DoCoMo/1.0/F505iGPS/c20/TB/W20H10
DoCoMo/1.0/D505i/c20/TB/W20H10
DoCoMo/1.0/D505i/c30/TD
DoCoMo/1.0/D505i/c20/T
DoCoMo/1.0/SO505i/c20/TB/W21H09
DoCoMo/1.0/SO505i/c20/TB/W18H08
DoCoMo/1.0/SO505i/c30/TD
DoCoMo/1.0/SO505i/c20/TJ
DoCoMo/1.0/SH505i/c20/TB/W24H12
DoCoMo/1.0/SH505i2/c20/TB/W24H12
DoCoMo/1.0/SH505i/c30/TD
DoCoMo/1.0/SH505i2/c30/TD
DoCoMo/1.0/SH505i/c20/TJ
DoCoMo/1.0/SH505i2/c20/TJ
DoCoMo/1.0/N505i/c20/TB/W20H10
DoCoMo/1.0/N505i/c20/TB/W30H14
DoCoMo/1.0/N505i/c20/TB/W16H08
DoCoMo/1.0/N505i/c30/TD
DoCoMo/1.0/N505i/c20/TJ
DoCoMo/1.0/F505i/c20/TB/W20H10
DoCoMo/1.0/F505i/c20/TB/W24H12
DoCoMo/1.0/F505i/c30/TD
DoCoMo/1.0/F505i/c20/TJ
DoCoMo/1.0/P505i/c20/TB/W20H10
DoCoMo/1.0/P505i/c30/TD
DoCoMo/1.0/P505i/c20/TJ
DoCoMo/1.0/D505iS/c20/TB/W20H10
DoCoMo/1.0/D505iS/c30/TD
DoCoMo/1.0/D505iS/c20/TJ
DoCoMo/1.0/P505iS/c20/TB/W20H10
DoCoMo/1.0/P505iS/c30/TD
DoCoMo/1.0/P505iS/c20/TJ
DoCoMo/1.0/N505iS/c20/TB/W20H10
DoCoMo/1.0/N505iS/c20/TB/W30H14
DoCoMo/1.0/N505iS/c20/TB/W16H08
DoCoMo/1.0/N505iS/c30/TD
DoCoMo/1.0/N505iS/c20/TJ
DoCoMo/1.0/SO505iS/c20/TB/W20H10
DoCoMo/1.0/SO505iS/c20/TB/W40H21
DoCoMo/1.0/SO505iS/c20/TB/W30H16
DoCoMo/1.0/SO505iS/c20/TB/W16H08
DoCoMo/1.0/SO505iS/c30/TD
DoCoMo/1.0/SO505iS/c20/TJ
DoCoMo/1.0/SH505iS/c20/TB/W24H12
DoCoMo/1.0/SH505iS/c30/TD
DoCoMo/1.0/SH505iS/c20/TJ
DoCoMo/1.0/F505iGPS/c20/TB/W20H10
DoCoMo/1.0/F505iGPS/c20/TB/W24H12
DoCoMo/1.0/F505iGPS/c30/TD
DoCoMo/1.0/F505iGPS/c20/TJ
DoCoMo/1.0/D252i/c10/TB/W25H12
DoCoMo/1.0/SH252i/c20/TB/W24H12
DoCoMo/1.0/P252i/c10/TB/W22H10
DoCoMo/1.0/N252i/c10/TB/W22H10
DoCoMo/1.0/N252i/c10/TB/W26H11
DoCoMo/1.0/N252i/c10/TB/W16H07
DoCoMo/1.0/P252iS/c10/TB/W22H10
DoCoMo/1.0/D506i/c20/TB/W20H10
DoCoMo/1.0/D506i/c20/TB/W40H18
DoCoMo/1.0/D506i/c20/TB/W30H14
DoCoMo/1.0/D506i/c20/TB/W16H08
DoCoMo/1.0/D506i/c30/TD
DoCoMo/1.0/D506i/c20/TJ
DoCoMo/1.0/F506i/c20/TB/W20H10
DoCoMo/1.0/F506i/c20/TB/W24H12
DoCoMo/1.0/F506i/c30/TD
DoCoMo/1.0/F506i/c20/TJ
DoCoMo/1.0/N506i/c20/TB/W20H11
DoCoMo/1.0/N506i/c20/TB/W30H15
DoCoMo/1.0/N506i/c20/TB/W16H09
DoCoMo/1.0/N506i/c30/TD
DoCoMo/1.0/N506i/c20/TJ
DoCoMo/2.0 F900i(c100;TB;W22H12)
DoCoMo/2.0 F900i(c100;TB;W18H10)
DoCoMo/2.0 F900i(c100;TB;W28H15)
DoCoMo/2.0 F900i(c100;TD)
DoCoMo/2.0 F900i(c100;TJ)
DoCoMo/2.0 N900i(c100;TB;W24H12)
DoCoMo/2.0 N900i(c100;TB;W20H10)
DoCoMo/2.0 N900i(c100;TB;W30H15)
DoCoMo/2.0 N900i(c100;TD)
DoCoMo/2.0 N900i(c100;TJ)
DoCoMo/2.0 P900i(c100;TB;W24H11)
DoCoMo/2.0 P900i(c100;TB;W20H09)
DoCoMo/2.0 P900i(c100;TB;W30H14)
DoCoMo/2.0 P900i(c100;TD)
DoCoMo/2.0 P900i(c100;TJ)
DoCoMo/2.0 SH900i(c100;TB;W24H12)
DoCoMo/2.0 SH900i(c100;TD)
DoCoMo/2.0 SH900i(c100;TJ)
DoCoMo/2.0 F900iT(c100;TB;W22H12)
DoCoMo/2.0 F900iT(c100;TB;W18H10)
DoCoMo/2.0 F900iT(c100;TB;W28H15)
DoCoMo/2.0 F900iT(c100;TD)
DoCoMo/2.0 F900iT(c100;TJ)
DoCoMo/2.0 P900iV(c100;TB;W24H11)
DoCoMo/2.0 P900iV(c100;TB;W20H09)
DoCoMo/2.0 P900iV(c100;TB;W30H14)
DoCoMo/2.0 P900iV(c100;TD)
DoCoMo/2.0 P900iV(c100;TJ)
DoCoMo/2.0 N900iS(c100;TB;W24H12)
DoCoMo/2.0 N900iS(c100;TB;W20H10)
DoCoMo/2.0 N900iS(c100;TB;W30H15)
DoCoMo/2.0 N900iS(c100;TD)
DoCoMo/2.0 N900iS(c100;TJ)
DoCoMo/2.0 D900i(c100;TB;W20H10)
DoCoMo/2.0 D900i(c100;TD)
DoCoMo/2.0 D900i(c100;TJ)
DoCoMo/1.0/SO213i/c10/TB
DoCoMo/1.0/D251i/c10
DoCoMo/1.0/D251iS/c10/TB
DoCoMo/1.0/D252i/c10/TB/W25H12
DoCoMo/1.0/D505i/c20/TB/W20H10
DoCoMo/1.0/D505iS/c20/TB/W20H10
DoCoMo/1.0/D506i/c20/TB/W20H10
DoCoMo/1.0/F251i/c10/TB
DoCoMo/1.0/F504iS/c10/TB
DoCoMo/1.0/F505i/c20/TB/W20H10
DoCoMo/1.0/F505i/c20/TB/W24H12
DoCoMo/1.0/F505i/c20/TC/W24H12
DoCoMo/1.0/F505iGPS/c20/TB/W20H10
DoCoMo/1.0/F506i
DoCoMo/1.0/F506i/c20/TB/W20H10
DoCoMo/1.0/N211i/c10
DoCoMo/1.0/N251i/c10/TB
DoCoMo/1.0/N251iS/c10/TB
DoCoMo/1.0/N2701/c10/TB
DoCoMo/1.0/N502it/c10
DoCoMo/1.0/N503iS/c10
DoCoMo/1.0/N504i/c10/TB
DoCoMo/1.0/N504iS/c10/TB
DoCoMo/1.0/N505i/c20/TB/W20H10
DoCoMo/1.0/N505i/c20/TB/W30H14
DoCoMo/1.0/N505i/c20/TC/W20H10
DoCoMo/1.0/N505i/c20/TC/W30H14
DoCoMo/1.0/N505iS/c20/TB/W20H10
DoCoMo/1.0/N505iS/c20/TB/W30H14
DoCoMo/1.0/P211i/c10
DoCoMo/1.0/P251iS/c10/TB
DoCoMo/1.0/P252i/c10/TB/W22H10
DoCoMo/1.0/P252iS/c10/TB/W22H10
DoCoMo/1.0/P502i/c10 (Google CHTML Proxy/1.0)
DoCoMo/1.0/P504i/c10/TB
DoCoMo/1.0/P504iS/c10/TB
DoCoMo/1.0/P505i/c20/TB/W20H10
DoCoMo/1.0/P505iS/c20/TB/W20H10
DoCoMo/1.0/P505iS/c20/TC/W20H10
DoCoMo/1.0/SH251i/c10
DoCoMo/1.0/SH251iS/c10
DoCoMo/1.0/SH505i/c20/TB/W24H12
DoCoMo/1.0/SH505i2/c20/TB/W24H12
DoCoMo/1.0/SH505iS/c20/TB/W24H12
DoCoMo/1.0/SO212i/c10/TB
DoCoMo/1.0/SO503iS/c10
DoCoMo/1.0/SO504i/c10/TB
DoCoMo/1.0/SO505i/c20/TB/W18H08
DoCoMo/1.0/SO505i/c20/TB/W21H09
DoCoMo/1.0/SO505i/c20/TC/W21H09
DoCoMo/1.0/SO505iS/c20/TB/W20H10
DoCoMo/1.0/SO505iS/c20/TC/W20H10
DoCoMo/1.0/SO505iS/c20/TC/W30H16
DoCoMo/2.0 D900i(c100;TB;W20H10)
DoCoMo/2.0 F2051(c100;TB)
DoCoMo/2.0 F2102V(c100;TB)
DoCoMo/2.0 F900i(c100;TB;W18H10)
DoCoMo/2.0 F900i(c100;TB;W22H12)
DoCoMo/2.0 F900i(c100;TB;W28H15)
DoCoMo/2.0 N2051(c100;TB)
DoCoMo/2.0 N2102V(c100;TB)
DoCoMo/2.0 N2701(c100;TB)
DoCoMo/2.0 N900i(c100;TB;W20H10)
DoCoMo/2.0 N900i(c100;TB;W24H12)
DoCoMo/2.0 N900i(c100;TB;W30H15)
DoCoMo/2.0 N900iS(c100;TB;W24H12)
DoCoMo/2.0 P2102V(c100;TB)
DoCoMo/2.0 P900i(c100;TB;W24H11)
DoCoMo/2.0 P900i(c100;TB;W30H14)
DoCoMo/2.0 P900iV(c100;TB;W24H11)
DoCoMo/2.0 SH900i(c100;TB;W24H12)
DoCoMo/2.0 SH900i(c100;TC;W24H12)
