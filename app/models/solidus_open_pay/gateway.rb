# frozen_string_literal: true

require 'openpay'

module SolidusOpenPay
  class Gateway
    attr_reader :client

    def initialize(options)
      @client = OpenpayApi.new(
        options.fetch(:merchant_id, nil),
        options.fetch(:private_key, nil),
        options.fetch(:country).presence || !options.fetch(:test_mode)
      )
      @options = options
    end

    def authorize(amount_in_cents, source, options = {})
      resource_builder = ::SolidusOpenPay::Builders::Charge.new(
        source: source,
        amount: amount_in_cents,
        options: options
      )

      response = client.create(:charges).create(
        resource_builder.payload
      )

      source.update(
        authorization_id: response.try(:[], 'id')
      )

      SolidusOpenPay::Response.build(response)
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end

    def capture(_amount_in_cents, authorization_id, _options = {})
      response = client.create(:charges).capture(
        authorization_id
      )

      json_response = JSON.parse(response.body)

      SolidusOpenPay::Response.build(json_response)
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end

    def purchase(_amount_in_cents, _source, _options = {})
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end

    def void(authorization_id, _options = {})
      response = client.create(:charges).refund(
        authorization_id,
        {}
      )

      SolidusOpenPay::Response.build(response)
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end
  end
end
