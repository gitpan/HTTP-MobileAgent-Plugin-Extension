package HTTP::MobileAgent::Plugin::Extension::IPCheck;

sub carrier_check
{
  my ($ip,$carrier) = @_;
  $carrier = "E" if (($carrier eq 'A') || ($carrier eq 'T'));
  my @nw_list = @{ip_list()->{$carrier}};

  foreach my $nw (@nw_list)
  {
    return 1 if (ip_network_check($ip,$nw->[0],$nw->[1]));
  }
}

sub ip_network_check
{
  my ($ip,$nw,$bit) = @_;

  my $ip_b = join("", map { unpack("B8",  pack("C", $_)) } split(/\./,$ip));
  my $nw_b = join("", map { unpack("B8",  pack("C", $_)) } split(/\./,$nw));

  return substr($ip_b,0,$bit) eq substr($nw_b,0,$bit);
}

sub ip_list
{
  return 
  {
    I => [
      [ "210.153.84.0",24 ],
      [ "210.136.161.0",24 ]
    ],
    V => [
      ["210.134.83.32",27],
      ["210.146.7.192",26],
      ["210.146.60.128",25],
      ["210.151.9.160",27],
      ["210.169.193.192",26],
      ["210.228.189.0",24],
      ["211.8.49.160",27],
      ["211.8.159.128",25],
      ["211.127.183.0",24],
    ],
    E => [
      ["210.169.40.0",24],
      ["210.196.3.192",26],
      ["210.196.5.192",26],
      ["210.230.128.0",24],
      ["210.230.141.192",26],
      ["210.234.105.32",29],
      ["210.234.108.64",26],
      ["210.251.1.192",26],
      ["210.251.2.0",27],
      ["211.5.1.0",24],
      ["211.5.2.128",25],
      ["211.5.7.0",24],
      ["218.222.1.0",24],
      ["61.117.0.0",24],
      ["61.117.1.0",24],
      ["61.117.2.0",26],
      ["61.202.3.0",24],
      ["219.108.158.0",26],
      ["219.125.148.0",24],
      ["222.7.56.0",24]
    ],
    H => [
      ["61.198.249.0",24],
      ["61.198.250.0",24],
      ["219.108.15.0",24],
      ["221.119.0.0",24],
      ["221.119.1.0",24],
      ["221.119.2.0",24],
      ["221.119.3.0",24],
      ["221.119.8.0",24],
      ["221.119.9.0",24],
      ["61.198.167.0",24],
      ["61.198.253.128",25],
      ["210.168.246.0",24],
      ["210.168.247.0",24],
      ["219.108.14.0",25],
      ["219.108.14.128",25],
      ["222.13.17.0",24],
      ["222.13.18.0",24],
      ["222.13.19.0",24],
      ["222.13.20.0",24],
      ["222.13.21.0",24],
      ["222.13.22.0",24],
      ["222.13.23.0",24],
      ["222.13.32.0",24],
      ["222.13.33.0",24],
      ["222.13.34.0",24],
      ["222.13.35.0",24],
      ["222.13.36.0",24],
      ["222.13.37.0",24],
      ["222.13.38.0",24],
      ["61.198.142.0",24],
      ["61.204.0.0",24],
      ["61.204.4.0",24],
      ["61.204.3.0",25],
      ["61.204.6.0",25],
      ["211.18.238.0",24],
      ["211.18.239.0",24],
    ],
    N => [
      [ "0.0.0.0",0 ]
    ],
  };
}


1;