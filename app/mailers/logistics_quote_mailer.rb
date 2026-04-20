class LogisticsQuoteMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_FROM_EMAIL', 'noreply@zelusottomayor.com')

  def quote_request(params)
    @params = params

    mail(
      to: 'max@zelusottomayor.com',
      subject: "Pedido de Cotação ##{SecureRandom.hex(4)}",
      reply_to: params[:email]
    )
  end
end
