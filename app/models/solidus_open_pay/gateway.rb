# frozen_string_literal: true

require 'openpay'

module SolidusOpenPay
  class Gateway
    attr_reader :client

    def initialize(options)
      @client = OpenpayApi.new(
        options.fetch(:merchant_id, nil),
        options.fetch(:private_key, nil),
        options.fetch(:country, nil).presence || !options.fetch(:test_mode, nil)
      )
      @options = options
    end

    def authorize(amount_in_cents, source, options = {})
      resource_builder = ::SolidusOpenPay::Builders::Charge.new(
        source: source,
        amount: amount_in_cents,
        options: options.merge({ capture: true })
      )

      response = client.create(:charges).create(
        resource_builder.payload
      )

      source&.update(
        authorization_id: response.try(:[], 'id'),
        redirect_url: response.try(:[], 'payment_method').try(:[], 'url')
      )

      SolidusOpenPay::Response.build(response)
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end

    def capture(_amount_in_cents, authorization_id, options = {})
      response = client.create(:charges).capture(
        authorization_id
      )

      json_response = JSON.parse(response.body)
      source = options[:originator].try(:source)

      source&.update(
        capture_id: json_response.try(:[], 'id'),
        authorization_id: json_response.try(:[], 'authorization')
      )

      SolidusOpenPay::Response.build(json_response)
    rescue ::OpenpayTransactionException,
           ::OpenpayException,
           ::OpenpayConnectionException => e
      SolidusOpenPay::Response.build(e)
    end

    def purchase(amount_in_cents, source, options = {})
      resource_builder = ::SolidusOpenPay::Builders::Charge.new(
        source: source,
        amount: amount_in_cents,
        options: options
      )

      response = client.create(:charges).create(
        resource_builder.payload
      )

      source&.update(
        capture_id: response.try(:[], 'id'),
        authorization_id: response.try(:[], 'authorization'),
        redirect_url: response.try(:[], 'payment_method').try(:[], 'url')
      )

      SolidusOpenPay::Response.build(response)
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

    alias_method :credit, :void
  end
end
