use strict;
use Test::More tests => 599;

BEGIN { use_ok 'HTTP::MobileAgent::Plugin::Extension' }

my @Tests = (
  # ua, version, model, packet_compliant, serial_number, vendor, vendor_version, java_infos
  [ 'J-PHONE/2.0/J-DN02', '2.0', 'J-DN02', undef ],
  [ 'J-PHONE/3.0/J-PE03_a', '3.0', 'J-PE03_a', undef ],
  [ 
    'J-PHONE/4.0/J-SH51/SNJSHA3029293 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0',
    '4.0', 'J-SH51', 1, 'JSHA3029293', 'SH', '0001aa', 
    {
      Profile =>'MIDP-1.0',
      Configuration => 'CLDC-1.0',
      'Ext-Profile' => 'JSCL-1.1.0',
    } 
  ],
  [ 
    'J-PHONE/4.0/J-SH51/SNXXXXXXXXX SH/0001a Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0',
    '4.0', 'J-SH51', 1, 'XXXXXXXXX', 'SH', '0001a', 
    {
      Profile => 'MIDP-1.0',
      Configuration => 'CLDC-1.0',
      'Ext-Profile' => 'JSCL-1.1.0',
    }
  ],
  [
    'J-PHONE/4.3/V602SH/SNJSHK5024251 SH/0006aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.2',
    '4.3', 'V602SH', 1, 'JSHK5024251', 'SH', '0006aa',
    {
      Profile => 'MIDP-1.0',
      Configuration => 'CLDC-1.0',
      'Ext-Profile' => 'JSCL-1.2.2',
    }
  ],
  [ 'J-PHONE/5.0/V801SA', '5.0', 'V801SA', undef ],
);

for (@Tests) {
    my($ua, @data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    isa_ok $agent, 'HTTP::MobileAgent';
    isa_ok $agent, 'HTTP::MobileAgent::JPhone';
    ok !$agent->is_docomo && $agent->is_j_phone && $agent->is_vodafone && !$agent->is_ezweb && !$agent->is_airh_phone;
    is $agent->name, 'J-PHONE';
    is $agent->user_agent, $ua,		"ua is $ua";

    is $agent->version, $data[0],	"version is $data[0]";
    is $agent->model, $data[1],		"model is $data[1]";
    is $agent->packet_compliant, $data[2], "packet compliant?";
    if (@data > 3) {
	is $agent->serial_number, $data[3],	"serial is $data[3]";
	is $agent->vendor, $data[4],		"vendor is $data[4]";
	is $agent->vendor_version, $data[5],	"vendor version is $data[5]";
	is_deeply $agent->java_info, $data[6];
    }

    if($ua eq 'J-PHONE/2.0/J-DN02'){
	    ok $agent->is_type_c && ! $agent->is_type_p && ! $agent->is_type_w;
	    ok ! $agent->is_station;
    }
    if($ua eq 'J-PHONE/3.0/J-PE03_a'){
	    ok $agent->is_type_c && ! $agent->is_type_p && ! $agent->is_type_w;
	    ok ! $agent->is_station;
    }
    if($ua eq 'J-PHONE/4.0/J-SH51/SNJSHA3029293 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0') {
	    ok !$agent->is_type_c && $agent->is_type_p && !$agent->is_type_w;
	    ok $agent->is_station;
    }
    if($ua eq 'J-PHONE/4.3/V602SH/SNJSHK5024251 SH/0006aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.2') {
	    ok !$agent->is_type_c && $agent->is_type_p && !$agent->is_type_w;
	    ok $agent->is_station;
    }
    if($ua eq 'J-PHONE/5.0/V801SA'){
	    ok !$agent->is_type_c && !$agent->is_type_p && $agent->is_type_w;
	    ok ! $agent->is_station;
    }
    is $agent->carrier, 'V' , "carrier is V";
    is $agent->carrier_longname, 'Vodafone' ,  "carrier longname is Vodafone";
}

while (<DATA>) {
    next if /^#/;
    chomp;
    local $ENV{HTTP_USER_AGENT} = $_;
    my $agent = HTTP::MobileAgent->new;
    isa_ok $agent, 'HTTP::MobileAgent', "$_";
    is $agent->name, 'J-PHONE';
    ok !$agent->is_docomo && $agent->is_j_phone && !$agent->is_ezweb && ! $agent->is_airh_phone;
    ok ! $agent->is_gps && ! $agent->is_eznavi ;
}

__END__
# Some User-Agents pick up from real access log, but Serial number is all modified, 
# because of privacy reason.
J-PHONE/1.0
J-PHONE/2.0/J-DN02
J-PHONE/2.0/J-P02
J-PHONE/2.0/J-P03
J-PHONE/2.0/J-SA02
J-PHONE/2.0/J-SH02
J-PHONE/2.0/J-SH03
J-PHONE/2.0/J-SH03_a
J-PHONE/2.0/J-SH04
J-PHONE/2.0/J-T04
J-PHONE/2.0/J-T05
J-PHONE/3.0/J-D03
J-PHONE/3.0/J-D04
J-PHONE/3.0/J-D05
J-PHONE/3.0/J-DN03
J-PHONE/3.0/J-K03
J-PHONE/3.0/J-K04
J-PHONE/3.0/J-K05
J-PHONE/3.0/J-N03
J-PHONE/3.0/J-N03B
J-PHONE/3.0/J-N04
J-PHONE/3.0/J-N05
J-PHONE/3.0/J-NM01_a
J-PHONE/3.0/J-NM02
J-PHONE/3.0/J-PE03
J-PHONE/3.0/J-PE03_a
J-PHONE/3.0/J-SA03_a
J-PHONE/3.0/J-SA04
J-PHONE/3.0/J-SA04_a
J-PHONE/3.0/J-SH04
J-PHONE/3.0/J-SH04_a
J-PHONE/3.0/J-SH04_b
J-PHONE/3.0/J-SH04_c
J-PHONE/3.0/J-SH05
J-PHONE/3.0/J-SH05_a
J-PHONE/3.0/J-SH06
J-PHONE/3.0/J-SH07
J-PHONE/3.0/J-SH08
J-PHONE/3.0/J-T05
J-PHONE/3.0/J-T06
J-PHONE/3.0/J-T06_a
J-PHONE/3.0/J-T07
J-PHONE/4.0/J-K51/SNJKWA3041061 KW/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-K51/SNJKWA3030744 KW/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-P51/SNJMAA1076146 MA/JDP51A36 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA1232366 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA1141639 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA2601949 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA3808160 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA3516183 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNJSHA3929293 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51/SNXXXXXXXXX SH/0001a Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA1875575 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA1562487 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA1346956 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA3233881 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA5891372 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA1077671 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA1082675 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA3001561 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/3.0/J-D05
J-PHONE/3.0/J-D08
J-PHONE/3.0/J-N04
J-PHONE/3.0/J-SA04_a
J-PHONE/3.0/J-SA05
J-PHONE/3.0/J-SA06
J-PHONE/3.0/J-SH06
J-PHONE/3.0/J-SH09_a
J-PHONE/3.0/J-SH10_a
J-PHONE/3.0/J-T10
J-PHONE/3.0/V301D
J-PHONE/3.0/V302T
J-PHONE/3.0/V401SH
J-PHONE/4.0/J-K51/SNJKWA3077098 KW/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-P51/SNJMAA1166856 MA/JDP51A40 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-P51/SNJMAA3077679 MA/JDP51A36 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-SH51_a/SNJSHA1888070 SH/0001aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA1118801 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA3187762 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.0/J-T51/SNJTSA5069911 TS/1.00 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/4.1/J-SA51_a/SNJSAA1166327 SA/0001JP Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.1/J-SH52/SNJSHD1231554 SH/0002aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.1/J-SH52/SNJSHD3055259 SH/0002aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.1/J-SH52/SNJSHD3099090 SH/0002aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/J-N51/SNJNEB1077783 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/J-N51/SNJNEB1159935 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/J-N51/SNJNEB1193331 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/J-N51/SNJNEB3128974 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/J-SH53_a SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF6705146 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF1045903 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF1134268 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF1190917 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF3021918 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF3034607 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF5067099 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF5098927 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/J-SH53_a/SNJSHF5134421 SH/0003aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601N/SNJNEC1035427 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC1058628 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC1143452 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC1175605 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC3017833 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC3019056 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC3025626 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC3043281 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC5024582 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601N/SNJNEC5036751 N/01000100 Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.1
J-PHONE/4.2/V601SH/SNJSHH1032748 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1012181 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1045823 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1067310 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1089890 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1101815 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH1223870 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3045117 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3067178 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3089200 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3001330 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3023328 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH3145736 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH5067855 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH5089337 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH5101661 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/4.2/V601SH/SNJSHH5123211 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1
J-PHONE/5.0/V801SA/SN350222451084157 SA/0001JP Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/5.0/V801SA/SN350222671337837 SA/0001JP Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0
J-PHONE/5.0/V801SH/SN350228890353881 SH/0005aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.1.0