ActiveAdmin.register_page "Mass Mailing" do

  page_action :send_message, method: :post do
    if mailer.send_messages
      redirect_to admin_mass_mailing_path, notice: "Messages sended"
    else
      redirect_to admin_mass_mailing_path, alert: mailer.errors.full_messages.join('  ')
    end
  end

  content do
    render 'index'
  end

  controller do
    helper_method :mailer
    def mailer
      @mailer ||= MassMailer.new(params[:mass_mailer] || {})
    end
  end
end
