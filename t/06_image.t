use strict;
use Test::More tests => 123;

use HTTP::MobileAgent::Plugin::Extension qw(ah_operaAsMobile);

my @Tests = (
    [ { HTTP_USER_AGENT => 'KDDI-HI31 UP.Browser/6.2.0.5 (GUI) MMP/2.0',
	HTTP_ACCEPT => 'application/octet-stream,application/vnd.phonecom.mmc-xml,application/vnd.wap.wmlc;type=4365,application/vnd.wap.xhtml+xml,application/xhtml+xml;profile="http://www.wapforum.org/xhtml",image/bmp,image/gif,image/jpeg,image/png,image/vnd.wap.wbmp,image/x-up-wpng,multipart/mixed,multipart/related,text/css,text/html,text/plain,text/vnd.wap.wml;type=4365,application/x-smaf,audio/vnd.qcelp,application/x-up-download,text/x-vcard,text/x-vcalendar,application/octet-stream,application/x-mpeg,video/3gpp2,audio/3gpp2,video/3gpp,audio/3gpp,application/x-tar,application/x-kjx,text/x-hdml,*/*' },
      { is_gif => 1, is_jpeg => 1, is_png => 1 } ],
    [ { HTTP_USER_AGENT => 'Mozilla/3.0(DDIPOCKET;KYOCERA/AH-K3001V/1.1.17.65.000001/0.1/C100) Opera 7.0',
	HTTP_ACCEPT => 'text/html, application/xml;q=0.9, application/xhtml+xml;q=0.9, image/png, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1' },
      { is_gif => 1, is_jpeg => 1, is_png => 1 } ],
    [ { HTTP_USER_AGENT => 'J-PHONE/3.0/J-T10',
	HTTP_ACCEPT => '*/*' },
      { is_gif => 0, is_jpeg => 1, is_png => 1 } ],
    [ { HTTP_USER_AGENT => 'J-PHONE/4.2/V601SH/SNJSHH1157880 SH/0004aa Profile/MIDP-1.0 Configuration/CLDC-1.0 Ext-Profile/JSCL-1.2.1',
	HTTP_ACCEPT => '*/*' },
      { is_gif => 0, is_jpeg => 1, is_png => 1 } ],
    [ { HTTP_USER_AGENT => 'J-PHONE/2.0/J-T03',
	HTTP_ACCEPT => '*/*' },
      { is_gif => 0, is_jpeg => 0, is_png => 1 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D210i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SO210i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/F503i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/F503iS/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/P503i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/P503iS/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N503i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N503iS/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SO503i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SO503iS/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D503i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D503iS/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/F211i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D211i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N211i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N211iS/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/P211i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/P211iS/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SO211i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/R211i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SH251i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SH251iS/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/R692i/c10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 N2001(c10)' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 N2002(c100)' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 P2002(c100j' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 D2101V(c100)' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 P2101V(c100)' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 MST_v_SH2101V(c100j' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/2.0 T2101V(c100j' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D502i' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/F502i/c10' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/N502i' },{ is_gif => 1, is_jpeg => 0, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/D505i/c20/TB/W20H10' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SO505i/c20/TB/W21H09' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
    [ { HTTP_USER_AGENT => 'DoCoMo/1.0/SH505i2/c20/TB/W24H12' },{ is_gif => 1, is_jpeg => 1, is_png => 0 } ],
);

for (@Tests) {
    my($env, $values) = @$_;
    local *ENV = $env;
    my $ua = HTTP::MobileAgent->new;
    for my $method (keys %$values) {
	is $ua->$method(), $values->{$method}, "$method = $values->{$method}";
    }
}


