# frozen_string_literal: true

module SolidusOpenPay
  class Configuration
    attr_accessor :installment_options, :installment_default

    # def installment_options
    #   @installment_options ||= :installment_options
    # end

    # def installment_default
    #   @installment_default ||= :installment_default
    # end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
