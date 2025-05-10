# frozen_string_literal: true

module SolidusOpenPay
  class PaymentsController < ::Spree::StoreController
    skip_before_action :verify_authenticity_token, only: :create

    before_action :load_order, only: :create
    before_action :load_payment_method, only: :create

    respond_to :json, :html

    def create
      @payment_source ||= ::SolidusOpenPay::PaymentSource.create(
        payment_params
      )

      @payment = @order.payments.create!({
        amount: @order.total,
        source: @payment_source,
        payment_method: @payment_method
      })

      @order.next
      @payment.purchase!

      respond_to do |format|
        format.json do
          render json: {
            redirect_url: @payment.source.redirect_url
          },
          status: :ok
        end
      end
    rescue => e
      error_message = e.message
      flash[:error] = error_message

      @order.errors.add(:base, error_message)

      respond_to do |format|
        format.json do
          render json: {
            error: error_message,
            redirect_url: '/checkout/payment'
          },
          status: :moved_permanently
        end
      end
    end

    private

    def load_order
      @order ||= current_order || raise(ActiveRecord::RecordNotFound)
    end

    def load_payment_method
      @payment_method ||= ::Spree::PaymentMethod.find(
        payment_params[:payment_method_id]
      )
    end

    def payment_params
      params.require(:payment).permit(
        :authorization_id,
        :brand,
        :card_number,
        :card_type,
        :device_session_id,
        :expiration_month,
        :expiration_year,
        :holder_name,
        :payment_method_id,
        :points_card,
        :points_type,
        :token_id
      )
    end
  end
end
