use strict;
use Test::More tests => 57;

use HTTP::MobileAgent::Plugin::Extension qw(ah_operaAsMobile);

my @Tests = (
    [ { HTTP_X_JPHONE_DISPLAY => '120*117', HTTP_USER_AGENT => 'J-PHONE/2.0/J-DN02',
	HTTP_X_JPHONE_COLOR => 'C256' },
      { width => 120, height => 117, color => 1, depth => 256. } ],
    [ { HTTP_X_UP_DEVCAP_SCREENPIXELS => '90,70',
	HTTP_USER_AGENT => 'KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1',
	HTTP_X_UP_DEVCAP_SCREENDEPTH => '16,RGB565',
	HTTP_X_UP_DEVCAP_ISCOLOR => 1, },
      { width => 90, height => 70, color => 1, depth => 2**16 }, ],
    [ { HTTP_X_UP_DEVCAP_SCREENPIXELS => '90,70',
	HTTP_USER_AGENT => 'KDDI-TS21 UP.Browser/6.0.2.276 (GUI) MMP/1.1',
	HTTP_X_UP_DEVCAP_SCREENDEPTH => '1',
	HTTP_X_UP_DEVCAP_ISCOLOR => 0 },
      { width => 90, height => 70, color => '', depth => 2 }, ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D501i' },
      { width => 96, height => 72, color => '', depth => 2 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D502i' },
      { width => 96, height => 90, color => 1, depth => 256 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N502i' },
      { width => 118, height => 128, color => '', depth => 4 } ],
    [ { HTTP_USER_AGENT => "DoCoMo/1.0/D505i/c20/TC/W20H10" },
      { width_bytes => 20, height_bytes => 10 } ],
    [ { HTTP_USER_AGENT => "DoCoMo/1.0/N505iS/c20/TB/W30H14" },
      { width_bytes => 30, height_bytes => 14 } ],
    [ { HTTP_USER_AGENT => "DoCoMo/2.0 SH900i(c100;TC;W24H12)" },
      { width_bytes => 24, height_bytes => 12 } ],
    [ { HTTP_USER_AGENT => "DoCoMo/2.0 F900i(c100;TB;W18H10)" },
      { width_bytes => 18, height_bytes => 10 } ],
    [ { HTTP_USER_AGENT => 'Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0' },
      { width => 128, height => 130, color => 1, depth => 65536 }, ],
    [ { HTTP_USER_AGENT => 'Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.16.65.000000/0.1/C100) Opera 7.0' },
      { width => 237, height => 241, color => 1, depth => 262144 }, ],
    [ { HTTP_USER_AGENT => 'Mozilla/4.0 (compatible; MSIE 6.0; KYOCERA/AH-K3001V/1.1.17.65.000001/0.1) Opera 7.0  [ja]' },
      { width => 237, height => 241, color => 1, depth => 262144 }, ],
);

for (@Tests) {
    my($env, $values) = @$_;
    local *ENV = $env;
    my $ua = HTTP::MobileAgent->new;
    my $display = $ua->display;
    isa_ok $display, 'HTTP::MobileAgent::Display';
    for my $method (keys %$values) {
	is $display->$method(), $values->{$method}, "$method = $values->{$method}";
    }
}


