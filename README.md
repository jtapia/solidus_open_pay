Solidus Openpay
==============

Add solidus_openpay to your Gemfile:

```ruby
gem 'solidus_openpay', github: 'elliotmx/solidus_openpay', branch: 'master'
```

Then run:

```shell
bundle
bundle exec rails g solidus_openpay:install
```

##Setup Openpay Payments

You need to go to [Openpay](https://www.openpay.mx/), create an account and retrieve your ID, private and public api keys.

On the solidus application admin side go to:

/admin/payment_methods/new

    In the provider box,choose one of the following options depending on your needs (freemium version only works with credit card):

     Spree::BillingIntegration::OpenpayGateway::Card

     Spree::BillingIntegration::OpenpayGateway::Cash

     Spree::BillingIntegration::OpenpayGateway::Bank

     Spree::BillingIntegration::OpenpayGateway::MonthlyPayment

    On the auth token field, add your Openpay private key.

    On the public auth token field, add your Openpay public private key.
    
    On the openpay field, add your Openpay Merchant ID.
    
###Source Methods

Solidus Openpay currently supports:

####Card
>Card method will let you pay using your credit or debit card. More info: More info: [Openpay Card](https://www.openpay.mx/docs/save-card.html)

**Important Note:** If you want to support all source methods, you'll need to create a payment method for each one.

**Important Note:** This extension only works with ruby 2.0+.

**Important Note:** Openpay only supports Credit Cards Payments.

# About the Author

[ELLIOT](http://elliot.mx/)

## Contributors
  * Jonathan Garay
  * Fernando Cuauhtemoc Barajas Chavez
  * Herman Moreno
  * Edwin Cruz
  * Carlos A. Muñiz Moreno
  * Chalo Fernandez
  * Guillermo Siliceo
  * Jaime Victoria
  * Jorge Pardiñas
  * Juan Carlos Rojas
  * Leo Fischer
  * Manuel Vidaurre
  * Marco Medina
  * Mumo Carlos
  * Sergio Morales
  * Steven Barragan
  * Ulices Barajas
  * bishma-stornelli
  * Raul Contreras Arredondo
  * AngelChaos26
