# OmniAuth Configure

Centralize OmniAuth strategy configurations on the server. This has a couple 
advantages over storing configuration details (e.g. client secret and urls) in 
source control or the environment for the user running the application server.

* Keeping sensitive information out of source code
* Keeping configurations where they belong (/etc)

## Installation

1. Add the `omniauth_configure` gem to the Gemfile

## Configuration

A configuration contains details about applications and strategies which
use omniauth. Applications are top level keys (e.g. nucats_assist, nitro) 
with the exception of the 'defaults'. The 'defaults' top level key is used to 
keep global options for strategies. When a strategy is configured on a per  
application level, the default options for that strategy are inherited first
and the application specific strategy options are applied on top of them.

```
# /etc/nubic/omniauth/local.yml

defaults:
  nucats_membership:
    client_options:
      site: http://membership-staging.nubic.northwestern.edu
      authorize_url: /auth
      token_url: /token
nucats_assist:
  nucats_membership:
    client_id: abc123
    client_secret: def456
  facebook:
    client_id: asdf213
    client_secret: jimbo
nitro:
  nucats_membership:
    client_id: xyz987
    client_secret: ufw654
```

## Rack

```
# server.ru

OmniauthConfigure.configure {
  app :nucats_assist
  strategies :nucats_membership
  central '/etc/nubic/omniauth/local.yml'
}

OmniauthConfigure::Rack.use_in(self)
```

## Rails

```
# config/environments/development.rb

OmniAuthConfigure.configure {
  app :nucats_assist
  strategies :nucats_membership
  central '/etc/nubic/omniauth/local.yml'
}
```

For Devise configuration see the [Devise wiki page about omniauth](https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview)


