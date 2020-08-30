class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Before work, check login and locale
  before_action :ensure_login
  before_action :set_locale

  ALLOWED_LOCALES = %w( en es ).freeze
  DEFAULT_LOCALE = 'en'.freeze


  helper_method :logged_in?, :current_user

  protected

  def ensure_login
    redirect_to login_path unless session[:usuario_id]
  end

  def logged_in?
    session[:usuario_id] #devuelve el id o nil
  end

  def current_user
    @current_user ||= Usuario.find(session[:usuario_id])
  end

  def systemlog texto

    File.open("#{Rails.root}/public/log/system.log","a") do |f|
        f.puts "#{Time.new};#{current_user.name};#{texto}"
    end
  end

  # Extract the lenguage from the request headers
  def set_locale
    if !session[:locale]

      I18n.locale = extract_locale_from_headers
      session[:locale] =I18n.locale
    end
  end

  private

  def extract_locale_from_headers
    browser_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if ALLOWED_LOCALES.include?(browser_locale)
      browser_locale
    else
      DEFAULT_LOCALE
    end
  end

end
