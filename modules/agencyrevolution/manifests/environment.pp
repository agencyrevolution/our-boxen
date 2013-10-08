class agencyrevolution::environment {
  # osx
  include osx::recovery_message { 'If this Mac is found, please call 800-606-0477': }
  include osx::global::key_repeat_delay

  class { 'osx::global::key_repeat_delay':
    delay => 300
  }

  include osx::global::key_repeat_rate

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
  include chrome::canaryA

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
