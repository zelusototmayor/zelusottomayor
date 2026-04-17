class LogisticsQuotesController < ApplicationController
  def create
    quote_params = params.require(:logistics_quote).permit(
      :email, :origin, :destination, :weight, :pallets, :cargo_type, :desired_date, :extra_info
    )

    begin
      LogisticsQuoteMailer.quote_request(quote_params.to_h.symbolize_keys).deliver_now
      Rails.logger.info "Logistics quote email sent successfully (from=#{quote_params[:email]} origin=#{quote_params[:origin]} destination=#{quote_params[:destination]})"
      redirect_back fallback_location: logistics_eng_path, notice: "Quote request sent! You'll receive a response by email shortly."
    rescue => e
      Rails.logger.error "Failed to send logistics quote email: #{e.class}: #{e.message}\n#{e.backtrace&.first(5)&.join("\n")}"
      redirect_back fallback_location: logistics_eng_path, alert: "Something went wrong. Please try again."
    end
  end
end
