use strict;
use Test::More tests => 955;

BEGIN { use_ok 'HTTP::MobileAgent::Plugin::Extension' }

my @Tests = (
    # ua, version, device_id, server, xhtml_compliant, comment, is_wap1, is_wap2
    [ 'UP.Browser/3.01-HI01 UP.Link/3.4.5.2',
      '3.01', 'HI01', 'UP.Link/3.4.5.2', undef, undef, 1, undef, 'C201H' ],
    [ 'KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1',
      '6.0.2.276 (GUI)', 'TS21', 'MMP/1.1', 1, undef, undef, 1, 'C5001T' ],
    [ 'UP.Browser/3.04-TS14 UP.Link/3.4.4 (Google WAP Proxy/1.0)',
      '3.04', 'TS14', 'UP.Link/3.4.4', undef, 'Google WAP Proxy/1.0', 1, undef, 'C415T' ],
    [ 'UP.Browser/3.04-TST4 UP.Link/3.4.5.6',
      '3.04', 'TST4', 'UP.Link/3.4.5.6', undef, undef, 1, undef, 'TT11' ],
    [ 'KDDI-KCU1 UP.Browser/6.2.0.5.1 (GUI) MMP/2.0',
      '6.2.0.5.1 (GUI)', 'KCU1', 'MMP/2.0', 1, undef, undef, 1, 'TK41' ],
);

my @Multimedias = (
	[ '',undef,0 ],
	[ '0033531100000000',0,0 ],
	[ '0133531100000000',1,0 ],
	[ '0133531100000000',1,0 ],
	[ '0233531100000000',2,1 ],
	[ '0223021100000000',2,1 ],
	[ '0223421100000000',2,1 ],
	[ '0223021100000000',2,1 ],
	[ '0222521100000000',2,1 ],
	[ '1240531210000000',2,1 ],
	[ '0222321100000000',2,1 ],
	[ '0223021100000000',2,1 ],
	[ '0223221100000000',2,1 ],
	[ '1223021100000000',2,1 ]
);

# Subscriber ID shown below is picked from real access log,
# but little modified because of privacy reason.
my @Subnos = (
	[ '07201130119500_ae.ezweb.ne.jp','07201130119500' ],
	[ '05101014761250_af.ezweb.ne.jp','05101014761250' ],
	[ '05201014310480_ag.ezweb.ne.jp','05201014310480' ],
	[ '07351060272470_ah.ezweb.ne.jp','07351060272470' ],
	[ '07431040480310_ma.ezweb.ne.jp','07431040480310' ],
	[ '07511021613290_ta.ezweb.ne.jp','07511021613290' ],
	[ '05601011070410_ah.ezweb.ne.jp','05601011070410' ],
	[ '05701031623280_tb.ezweb.ne.jp','05701031623280' ],
	[ '05801031230500_af.ezweb.ne.jp','05801031230500' ],
	[ '07921030089780_ac.ezweb.ne.jp','07921030089780' ],
	[ '07131041810000_mc.ezweb.ne.jp','07131041810000' ],
	[ '05201013373670_mb.ezweb.ne.jp','05201013373670' ]
);

for (@Tests) {
    my($ua, @data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    isa_ok $agent, 'HTTP::MobileAgent';
    isa_ok $agent, 'HTTP::MobileAgent::EZweb';
    is $agent->name, 'UP.Browser';
    is $agent->carrier, 'E';
    is $agent->carrier_longname, 'EZweb';
    ok !$agent->is_docomo && !$agent->is_j_phone && !$agent->is_vodafone && $agent->is_ezweb && !$agent->is_airh_phone;
    is $agent->user_agent, $ua,		"ua is $ua";
    is $agent->version, $data[0];
    is $agent->model, $data[1];
    is $agent->device_id, $data[1];
    is $agent->server, $data[2];
    is $agent->xhtml_compliant, $data[3];
    is $agent->comment, $data[4];
    ok $agent->is_wap1 if $data[5];
    ok $agent->is_wap2 if $data[6];

    if ($ua eq 'UP.Browser/3.04-TST4 UP.Link/3.4.5.6' 
    	or $ua eq 'KDDI-KCU1 UP.Browser/6.2.0.5.1 (GUI) MMP/2.0'){
    	ok $agent->is_tuka;
    } else {
	ok !$agent->is_tuka;
    }
}

$ENV{'HTTP_USER_AGENT'} = 'KDDI-CA21 UP.Browser/6.0.6 (GUI) MMP/1.1';
for (@Multimedias)
{
  my @data = @$_;
  $ENV{'HTTP_X_UP_DEVCAP_MULTIMEDIA'} = $data[0];
  my $agent = HTTP::MobileAgent->new();
  is $agent->is_eznavi,$data[1];
  is $agent->is_gps,$data[2];
}
for (@Subnos)
{
  my @data = @$_;
  $ENV{'HTTP_X_UP_SUBNO'} = $data[0];
  my $agent = HTTP::MobileAgent->new();
  is $agent->serial_number,$data[0];
}

while (<DATA>) {
    next if /^#/;
    chomp;
    local $ENV{HTTP_USER_AGENT} = $_;
    my $agent = HTTP::MobileAgent->new;
    isa_ok $agent, 'HTTP::MobileAgent', "$_";
    is $agent->name, 'UP.Browser';
    ok !$agent->is_docomo && !$agent->is_j_phone && !$agent->is_vodafone && $agent->is_ezweb && !$agent->is_airh_phone;
    ok !$agent->is_station;
}

HTTP::MobileAgent::Plugin::Extension->import(qw(ez_shortSubID ez_realnameAsModel ez_judgeKDDITUKA));

for (@Tests) {
    my($ua, @data) = @$_;
    my $agent = HTTP::MobileAgent->new($ua);
    is $agent->model, $data[7];

    if ($ua eq 'UP.Browser/3.04-TST4 UP.Link/3.4.5.6' 
    	or $ua eq 'KDDI-KCU1 UP.Browser/6.2.0.5.1 (GUI) MMP/2.0'){
    	is $agent->carrier, "T";
    	is $agent->carrier_longname, "TU-KA";
    } else {
    	is $agent->carrier, "A";
	is $agent->carrier_longname, "KDDI";
    }
}
for (@Subnos)
{
  my @data = @$_;
  $ENV{'HTTP_X_UP_SUBNO'} = $data[0];
  my $agent = HTTP::MobileAgent->new();
  is $agent->serial_number,$data[1];
}

__END__
KDDI-CA21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-CA21 UP.Browser/6.0.7.1 (GUI) MMP/1.1
KDDI-HI21 UP.Browser/6.0.2.213 (GUI) MMP/1.1
KDDI-HI21 UP.Browser/6.0.2.273 (GUI) MMP/1.1
KDDI-HI21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-KC21 UP.Browser/6.0.2.273 (GUI) MMP/1.1
KDDI-KC21 UP.Browser/6.0.5 (GUI) MMP/1.1
KDDI-KC21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-MA21 UP.Browser/6.0.2.276 (GUI) MMP/1.1
KDDI-MA21 UP.Browser/6.0.5 (GUI) MMP/1.1
KDDI-MA21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-MA21 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-SA21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-SA21 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-SA21 UP.Browser/6.0.7.1 (GUI) MMP/1.1
KDDI-SA22 UP.Browser/6.0.7.2 (GUI) MMP/1.1
KDDI-SN21 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-SN22 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-TS21 UP.Browser/6.0.2.273 (GUI) MMP/1.1
KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1
KDDI-TS21 UP.Browser/6.0.5.287 (GUI) MMP/1.1
KDDI-TS21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-TS22 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-TS22 UP.Browser/6.0.7.1 (GUI) MMP/1.1
UP.Browser/3.01-HI01 UP.Link/3.4.5.2
UP.Browser/3.01-HI02 UP.Link/3.2.1.2
UP.Browser/3.03-HI11 UP.Link/3.2.2.7c
UP.Browser/3.03-HI11 UP.Link/3.4.4
UP.Browser/3.03-KCT3 UP.Link/3.4.4
UP.Browser/3.03-SYC1 UP.Link/3.4.4
UP.Browser/3.03-TS11 UP.Link/3.2.2.7c
UP.Browser/3.03-TST1 UP.Link/3.2.2.7c
UP.Browser/3.04-CA11 UP.Link/3.2.2.7c
UP.Browser/3.04-CA11 UP.Link/3.3.0.3
UP.Browser/3.04-CA11 UP.Link/3.3.0.5
UP.Browser/3.04-CA11 UP.Link/3.4.4
UP.Browser/3.04-CA12 UP.Link/3.4.4
UP.Browser/3.04-CA13 UP.Link/3.3.0.5
UP.Browser/3.04-CA13 UP.Link/3.4.4
UP.Browser/3.04-CA14 UP.Link/3.4.4
UP.Browser/3.04-DN11 UP.Link/3.3.0.1
UP.Browser/3.04-DN11 UP.Link/3.4.4
UP.Browser/3.04-HI11 UP.Link/3.2.2.7c
UP.Browser/3.04-HI11 UP.Link/3.4.4
UP.Browser/3.04-HI12 UP.Link/3.2.2.7c
UP.Browser/3.04-HI12 UP.Link/3.3.0.3
UP.Browser/3.04-HI12 UP.Link/3.4.4
UP.Browser/3.04-HI12 UP.Link/3.4.4 (Google WAP Proxy/1.0)
UP.Browser/3.04-HI13 UP.Link/3.4.4
UP.Browser/3.04-HI14 UP.Link/3.4.4
UP.Browser/3.04-HI14 UP.Link/3.4.5.2
UP.Browser/3.04-KC11 UP.Link/3.4.4
UP.Browser/3.04-KC12 UP.Link/3.4.4
UP.Browser/3.04-KC13 UP.Link/3.4.4
UP.Browser/3.04-KC14 UP.Link/3.4.4
UP.Browser/3.04-KC15 UP.Link/3.4.4
UP.Browser/3.04-KCT4 UP.Link/3.4.4
UP.Browser/3.04-KCT5 UP.Link/3.4.4
UP.Browser/3.04-KCT6 UP.Link/3.4.4
UP.Browser/3.04-KCT7 UP.Link/3.4.4
UP.Browser/3.04-KCT8 UP.Link/3.4.4
UP.Browser/3.04-KCT9 UP.Link/3.4.4
UP.Browser/3.04-MA11 UP.Link/3.2.2.7c
UP.Browser/3.04-MA11 UP.Link/3.3.0.3
UP.Browser/3.04-MA11 UP.Link/3.3.0.5
UP.Browser/3.04-MA11 UP.Link/3.4.4
UP.Browser/3.04-MA12 UP.Link/3.2.2.7c
UP.Browser/3.04-MA12 UP.Link/3.3.0.5
UP.Browser/3.04-MA12 UP.Link/3.4.4
UP.Browser/3.04-MA12 UP.Link/3.4.4 (Google WAP Proxy/1.0)
UP.Browser/3.04-MA13 UP.Link/3.3.0.5
UP.Browser/3.04-MA13 UP.Link/3.4.4
UP.Browser/3.04-MA13 UP.Link/3.4.4 (Google WAP Proxy/1.0)
UP.Browser/3.04-MA13 UP.Link/3.4.5.2
UP.Browser/3.04-MAC2 UP.Link/3.4.4
UP.Browser/3.04-MAI1 UP.Link/3.2.2.7c
UP.Browser/3.04-MAI2 UP.Link/3.2.2.7c
UP.Browser/3.04-MAI2 UP.Link/3.4.4
UP.Browser/3.04-MAT1 UP.Link/3.3.0.3
UP.Browser/3.04-MAT3 UP.Link/3.4.4
UP.Browser/3.04-MIT1 UP.Link/3.3.0.3
UP.Browser/3.04-MIT1 UP.Link/3.4.4
UP.Browser/3.04-MIT1 UP.Link/3.4.5.2
UP.Browser/3.04-SN11 UP.Link/3.2.2.7c
UP.Browser/3.04-SN11 UP.Link/3.3.0.3
UP.Browser/3.04-SN11 UP.Link/3.4.4
UP.Browser/3.04-SN11 UP.Link/3.4.4 (Google WAP Proxy/1.0)
UP.Browser/3.04-SN12 UP.Link/3.3.0.1
UP.Browser/3.04-SN12 UP.Link/3.3.0.5
UP.Browser/3.04-SN12 UP.Link/3.4.4
UP.Browser/3.04-SN12 UP.Link/3.4.5.2
UP.Browser/3.04-SN13 UP.Link/3.3.0.3
UP.Browser/3.04-SN13 UP.Link/3.3.0.5
UP.Browser/3.04-SN13 UP.Link/3.4.4
UP.Browser/3.04-SN14 UP.Link/3.4.4
UP.Browser/3.04-SN14 UP.Link/3.4.5.2
UP.Browser/3.04-SN15 UP.Link/3.4.4
UP.Browser/3.04-SN15 UP.Link/3.4.5.2
UP.Browser/3.04-SN16 UP.Link/3.4.4
UP.Browser/3.04-SN17 UP.Link/3.4.4
UP.Browser/3.04-SNI1 UP.Link/3.4.4
UP.Browser/3.04-ST11 UP.Link/3.3.0.1
UP.Browser/3.04-ST11 UP.Link/3.3.0.5
UP.Browser/3.04-ST11 UP.Link/3.4.4
UP.Browser/3.04-ST12 UP.Link/3.4.4
UP.Browser/3.04-ST13 UP.Link/3.4.4
UP.Browser/3.04-SY11 UP.Link/3.2.2.7c
UP.Browser/3.04-SY11 UP.Link/3.4.4
UP.Browser/3.04-SY12 UP.Link/3.3.0.1
UP.Browser/3.04-SY12 UP.Link/3.3.0.3
UP.Browser/3.04-SY12 UP.Link/3.3.0.5
UP.Browser/3.04-SY12 UP.Link/3.4.4
UP.Browser/3.04-SY12 UP.Link/3.4.5.2
UP.Browser/3.04-SY12 UP.Link/3.4.5.6
UP.Browser/3.04-SY13 UP.Link/3.4.4
UP.Browser/3.04-SY14 UP.Link/3.4.4
UP.Browser/3.04-SY15 UP.Link/3.4.4
UP.Browser/3.04-SYT3 UP.Link/3.4.4
UP.Browser/3.04-SYT3 UP.Link/3.4.5.2
UP.Browser/3.04-TS11 UP.Link/3.2.2.7c
UP.Browser/3.04-TS11 UP.Link/3.3.0.5
UP.Browser/3.04-TS11 UP.Link/3.4.4
UP.Browser/3.04-TS12 UP.Link/3.2.2.7c
UP.Browser/3.04-TS12 UP.Link/3.3.0.1
UP.Browser/3.04-TS12 UP.Link/3.3.0.3
UP.Browser/3.04-TS12 UP.Link/3.3.0.5
UP.Browser/3.04-TS12 UP.Link/3.4.4
UP.Browser/3.04-TS13 UP.Link/3.4.4
UP.Browser/3.04-TS14 UP.Link/3.4.4
UP.Browser/3.04-TS14 UP.Link/3.4.4 (Google WAP Proxy/1.0)
UP.Browser/3.04-TS14 UP.Link/3.4.5.2
UP.Browser/3.04-TSI1 UP.Link/3.2.2.7c
UP.Browser/3.04-TST3 UP.Link/3.4.4
UP.Browser/3.04-TST4 UP.Link/3.4.4
UP.Browser/3.04-TST4 UP.Link/3.4.5.2
UP.Browser/3.04-TST4 UP.Link/3.4.5.6
UP.Browser/3.04-TST5 UP.Link/3.4.4
UP.Browser/3.1-NT95 UP.Link/3.2
UP.Browser/3.1-SY11 UP.Link/3.2
UP.Browser/3.1-UPG1 UP.Link/3.2
UP.Browser/3.2.9.1-SA12 UP.Link/3.2
UP.Browser/3.2.9.1-UPG1 UP.Link/3.2
KDDI-CA21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-CA21 UP.Browser/6.0.7.1 (GUI) MMP/1.1
KDDI-CA22 UP.Browser/6.0.8.1 (GUI) MMP/1.1
KDDI-CA22 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-CA23 UP.Browser/6.2.0.3.111 (GUI) MMP/2.0
KDDI-CA23 UP.Browser/6.2.0.4 (GUI) MMP/2.0
KDDI-CA23 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-CA24 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-CA26 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-HI21 UP.Browser/6.0.2.273 (GUI) MMP/1.1
KDDI-HI21 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-HI23 UP.Browser/6.0.8.1 (GUI) MMP/1.1
KDDI-HI23 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-HI24 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-HI31 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-HI31 UP.Browser/6.2.0.5.c.1.100 (GUI) MMP/2.0
KDDI-HI32 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-KC21 UP.Browser/6.0.2.273 (GUI) MMP/1.1
KDDI-KC21 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-KC22 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-KC23 UP.Browser/6.2.0.4 (GUI) MMP/2.0
KDDI-KC23 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-KC25 UP.Browser/6.2.0.5.1 (GUI) MMP/2.0
KDDI-KC25 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-KC31 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-KC31 UP.Browser/6.2.0.5.c.1.100 (GUI) MMP/2.0
KDDI-SA21 UP.Browser/6.0.7.2 (GUI) MMP/1.1
KDDI-SA22 UP.Browser/6.0.7.2 (GUI) MMP/1.1
KDDI-SA24 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-SA25 UP.Browser/6.2.0.4 (GUI) MMP/2.0
KDDI-SA25 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-SA26 UP.Browser/6.2.0.5.1 (GUI) MMP/2.0
KDDI-SA27 UP.Browser/6.2.0.6.3 (GUI) MMP/2.0
KDDI-SN21 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-SN22 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-SN23 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-SN24 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-SN25 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-SN26 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-SN26 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-SN31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0
KDDI-ST21 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-ST22 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-ST23 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-ST23 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-TS22 UP.Browser/6.0.6 (GUI) MMP/1.1
KDDI-TS22 UP.Browser/6.0.7 (GUI) MMP/1.1
KDDI-TS23 UP.Browser/6.0.7.2 (GUI) MMP/1.1
KDDI-TS23 UP.Browser/6.0.8.1 (GUI) MMP/1.1
KDDI-TS23 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-TS24 UP.Browser/6.0.8.1 (GUI) MMP/1.1
KDDI-TS24 UP.Browser/6.0.8.2 (GUI) MMP/1.1
KDDI-TS25 UP.Browser/6.0.8.3 (GUI) MMP/1.1
KDDI-TS26 UP.Browser/6.2.0.5 (GUI) MMP/2.0
KDDI-TS26 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-TS27 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
KDDI-TS28 UP.Browser/6.2.0.6.2 (GUI) MMP/2.0
UP.Browser/3.04-CA14 UP.Link/3.4.5.6
UP.Browser/3.04-HI14 UP.Link/3.4.5.6
UP.Browser/3.04-KC15 UP.Link/3.4.5.6
UP.Browser/3.04-SY15 UP.Link/3.4.5.6
