require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_4
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  # osx
  osx::recovery_message { 'If this Mac is found, please call 800-606-0477': }

  class { 'osx::global::key_repeat_delay':
    delay => 300
  }

  class { 'osx::global::key_repeat_rate':
    rate => 23
  }

  include zsh
  include keyremap4macbook
  include keyremap4macbook::login_item

  # enable remapping left control to left control + escape
  keyremap4macbook::remap{ 'controlL2controlL_escape': }

  # set the parameter.keyoverlaidmodifier_timeout to 300
  keyremap4macbook::set{ 'parameter.keyoverlaidmodifier_timeout':
    value => '300'
  }

  # set the contents of the private.xml file.
  keyremap4macbook::private_xml{ 'private.xml':
    content => ''
  }

  include iterm2::stable
  include macvim

  include chrome
  include chrome::canary

  include firefox
  include firefox::nightly

  include opera
  include opera::developer
  include opera::mobile

  include btsync
  include viscosity
  include alfred
  include droplr
}
