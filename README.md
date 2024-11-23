# Solidus OpenPay

[![CircleCI](https://circleci.com/gh/jtapia/solidus_open_pay.svg?style=shield)](https://circleci.com/gh/jtapia/solidus_open_pay)

Add solidus_open_pay to your Gemfile:

```ruby
gem 'solidus_open_pay', github: 'jtapia/solidus_open_pay'
```

Then run:

```shell
bundle
bundle exec rails g solidus_open_pay:install
```

## Setup OpenPay Payments

You need to go to [Openpay](https://www.openpay.mx/), create an account and retrieve your ID, private and public api keys.

On the solidus application admin side go to:

- `/admin/payment_methods/new`

```
In the provider box, choose one of the following options depending on your needs (freemium version only works with credit card):

SolidusOpenPay::PaymentMethod
```
    
## Source Methods

Solidus Openpay currently supports:

#### Card
> Card method will let you pay using your credit or debit card. More info: More info: [Openpay Card](https://www.openpay.mx/docs/save-card.html)
