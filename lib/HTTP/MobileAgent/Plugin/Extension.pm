package HTTP::MobileAgent::Plugin::Extension;

use strict;
no strict 'refs';
no warnings 'redefine';
use vars qw($VERSION);
$VERSION = 0.12022;
use HTTP::MobileAgent;

# Extension for HTTP::MobileAgent: on Aug. 24th, 2004 's data

#######################################################################
# For All Terminal

# Image format checker
*{"HTTP::MobileAgent\::is_gif"} = sub { $_[0]->get_header('Accept') =~ /image\/gif/ ? 1 : 0 };
*{"HTTP::MobileAgent\::is_png"} = sub { $_[0]->get_header('Accept') =~ /image\/png/ ? 1 : 0 };
*{"HTTP::MobileAgent\::is_jpeg"} = sub { $_[0]->get_header('Accept') =~ /image\/jpeg/ ? 1 : 0 };

# Location service checker
*{"HTTP::MobileAgent\::is_gps"} = sub { 0 };
*{"HTTP::MobileAgent\::is_station"} = sub { 0 };
*{"HTTP::MobileAgent\::is_eznavi"} = sub { 0 };

# IP Checker (add from Ver. 0.10022)
*{"HTTP::MobileAgent\::check_network"} = sub {
  require HTTP::MobileAgent::Plugin::Extension::IPCheck;
  my ($self,$ip) = @_;
  return HTTP::MobileAgent::Plugin::Extension::IPCheck::carrier_check($ip,$self->carrier);
};

#######################################################################
# For DoCoMo

# Add New Model's HTML Version ... 900i,506i,213i,etc..
# http://www.nttdocomo.co.jp/p_s/imode/spec/useragent.html
$HTTP::MobileAgent::DoCoMo::HTMLVerMap = [
    # regex => version
    qr/[DFNP]501i/ => '1.0',
    qr/502i|821i|209i|691i|(F|N|P|KO)210i|^F671i$/ => '2.0',
    qr/(D210i|SO210i)|503i|211i|SH251i|692i|200[12]|2101V/ => '3.0',
    qr/504i|251i|^F671iS$|^F661i$|212i|2051|2102V|2701|213i/ => '4.0',
    qr/eggy|P751v/ => '3.2',
    qr/505i|252i|506i|900i|880i/ => '5.0',
];

# Add new DoCoMo's GPS model
$HTTP::MobileAgent::DoCoMo::GPSModels = { map { $_ => 1 } qw(F661i F505iGPS) };

# HTTP::MobileAgent can't parse 900i series: because they contains Dispaly_Bytes data
*{"HTTP::MobileAgent::DoCoMo\::_parse_foma"} = sub {
    my($self, $foma) = @_;

    $foma =~ s/^([^\(]+)// or return $self->no_match;
    $self->{model} = $1;
    $self->{model} = 'SH2101V' if $1 eq 'MST_v_SH2101V'; # Huh?

    if ($foma =~ s/^\((.*?)\)$//) {
	my @options = split /;/, $1;
	for (@options) {
	    /^c(\d+)$/      and $self->{cache_size} = $1, next;
	    /^ser(\w{15})$/ and $self->{serial_number} = $1, next;
	    /^icc(\w{20})$/ and $self->{card_id} = $1, next;
	    /^(T[CDBJ])$/   and $self->{status} = $1, next;
	    /^W(\d+)H(\d+)$/ and $self->{display_bytes} = "$1*$2", next;
	    $self->no_match;
	}
    }
};

# Image format checker
*{"HTTP::MobileAgent::DoCoMo\::is_gif"} = sub { 1 };
*{"HTTP::MobileAgent::DoCoMo\::is_jpeg"} = sub 
{ 
  my $self = shift;
  return 0 if ($self->html_version < 3.0);
  return 1 if ($self->html_version > 3.0);
  return 1 if ($self->model =~ /(N503i)|(P503iS)|(N211i$)|(R211i)|(SO211i)|(SH251i)|(R692i)|(2001)|(2002)|(2101V)/);
  return 0;
};

# Has utn attributes or not
*{"HTTP::MobileAgent::DoCoMo\::is_utn"} = sub { $_[0]->html_version > 2.0 ? 1 : 0};

#######################################################################
# For EZWEB

# Set Multimedia Accessor
*{"HTTP::MobileAgent::EZweb\::multimedia"} = sub 
{
  my $self = shift;
  my @multimedia = split(//,$self->get_header('x-up-devcap-multimedia'));

  return defined($_[0]) ? $multimedia[$_[0]] : wantarray ? @multimedia : \@multimedia;
};

# Location service checker
*{"HTTP::MobileAgent::EZweb\::is_eznavi"} = sub { $_[0]->multimedia(1) };
*{"HTTP::MobileAgent::EZweb\::is_gps"} = sub { ($_[0]->is_eznavi > 1) ? 1 : 0 };

#######################################################################
# For Vodafone

# Image format checker
*{"HTTP::MobileAgent::Vodafone\::is_png"} = sub { 1 };
*{"HTTP::MobileAgent::Vodafone\::is_jpeg"} = sub { $_[0]->version < 3.0 ? 0 : 1 };

# Location service checker
*{"HTTP::MobileAgent::Vodafone\::is_station"} = sub 
  {
    my $self = shift;
    my $version = $self->version;

    return 0 if ($version >= 5.0); 	# VGS is not support Station
    return 1 if ($version > 3.0); 	# Browser version more than 3.0 is support Station
    return 0 if ($version < 3.0); 	# Browser version more than 3.0 is support Station
    return 1 if ($self->get_header('x-jphone-java'));
		# All {browser 3.0 and support Java} are support Station
    my $model = $self->model;
    if ($model =~ /^((J-N03)|(J-SH05)|(J-SH04B)|(J-SH04)|(J-PE03)|(J-D03)|(J-K03))/)
    { return 0; }
    else
    { return 1; }
  };

#######################################################################
# For DDI Pocket

# User-Agent parser
*{"HTTP::MobileAgent::AirHPhone\::parse"} = sub 
{
  my $self = shift;
  my $ua = $self->user_agent;
  $ua =~ m!^Mozilla/\d\.0\s*\(.+;\s?([^\s;]+/AH-\w\d{4}\w[^/]*/[^\)]*)\)! or $self->no_match;
  @{$self}{qw(vendor model model_version browser_version cache_size)} = split m!/!, $1;
  $self->{cache_size} =~ s/^c//i;
  $self->{cache_size} ||= 100;
};

# Display object maker
*{"HTTP::MobileAgent::AirHPhone\::_make_display"} = sub  
{
  require HTTP::MobileAgent::Plugin::Extension::AirHPhoneData;
  my $self = shift;
  my ($model) = split(/,/,$self->model);
  my $display = $HTTP::MobileAgent::Plugin::Extension::AirHPhoneData::DisplayMap->{$model};
  return HTTP::MobileAgent::Display->new(%$display);
};

#######################################################################
# Procedures

sub import
{
  no strict 'vars';
  my $caller = shift;
  foreach my $arg (@_)
  {
    eval "\$$arg = 1";
  }

  #####################################################################
  # For EZWEB

  # Get Subscriber ID for Terminal ID
  *{"HTTP::MobileAgent::EZweb\::serial_number"} = 
    $ez_shortSubID ? 
    sub 
    {
      $_[0]->get_header('x-up-subno') =~ /^(\d{14})/;
      return $1;
    } :
    sub 
    {
      return $_[0]->get_header('x-up-subno');
    };

  # Use Realname as 'model'
  if ($ez_realnameAsModel)
  {
    *{"HTTP::MobileAgent::EZweb\::model"} = sub
    {
      require HTTP::MobileAgent::Plugin::Extension::EZwebData;
      my $self = shift;
      return $HTTP::MobileAgent::Plugin::Extension::EZwebData::Device2model->{$self->device_id};
    };
  }

  # Use Carrier name as 'name'
  if ($ez_judgeKDDITUKA)
  {
    *{"HTTP::MobileAgent::EZweb\::carrier"} = sub
    {
      $_[0]->is_tuka ? "T" : "A";
    };
    *{"HTTP::MobileAgent::EZweb\::carrier_longname"} = sub
    {
      $_[0]->is_tuka ? "TU-KA" : "KDDI";
    };
  }

  #####################################################################
  # For DDIPOCKET

  # If user select that AirH" Phone's Opera mode treat as Nonmobile;
  if ($ah_operaAsMobile)
  {
    $HTTP::MobileAgent::MobileAgentRE = HTTP::MobileAgent::Plugin::Extension::maRE();
  }
}

sub maRE
{
  my $DoCoMoRE = '^DoCoMo/\d\.\d[ /]';
  my $JPhoneRE = '^J-PHONE/\d\.\d';
  my $EZwebRE  = '^(?:KDDI-[A-Z]+\d+ )?UP\.Browser\/';
  my $AirHRE = '^Mozilla/\d\.0\s*\(.+\/AH-\w\d{4}\w';
  return qr/(?:($DoCoMoRE)|($JPhoneRE)|($EZwebRE)|($AirHRE))/;
}

1;