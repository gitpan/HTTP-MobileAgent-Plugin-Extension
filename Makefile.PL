use ExtUtils::MakeMaker;
WriteMakefile(
  'NAME'      => 'HTTP::MobileAgent::Plugin::Extension',
  'VERSION_FROM' => 'lib/HTTP/MobileAgent/Plugin/Extension.pm', # finds $VERSION
  'PREREQ_PM' => {
    'HTTP::MobileAgent' => 0.22,
  },
);
