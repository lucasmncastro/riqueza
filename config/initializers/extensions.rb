Date::MONTHNAMES = [nil] + %w(Janeiro Fevereiro Março Abril Maio Junho Julho
			  Agosto Setembro Outubro Novembro Dezembro)

Date::DAYNAMES = %w(Domingo Segunda Terça Quarta Quinta Sexta Sabado)
Date::ABBR_DAYNAMES = %w(Dom Seg Ter Qua Qui Sex Sab)

Date::ABBR_MONTHNAMES = [nil] + %w(Jan Fev Mar Abr Mai Jun Jul Ago Set Out Nov Dez)


ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS = {
  :short        => "%e/%b",
  :long         => "%e de  %B,  %Y",
  :rfc822       => "%e %b %Y"
}
