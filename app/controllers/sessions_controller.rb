class SessionsController < ApplicationController
 skip_before_action :ensure_login, only: [:new, :create]

  def new
  end

  def create
    usuario = Usuario.find_by(name: params[:usuario][:name])
    password= params[:usuario][:password]
    if usuario && usuario.authenticate(password)
      session[:usuario_id] = usuario.id
      redirect_to root_path
      systemlog "logged in"
    else
      redirect_to login_path, alert: "Error en login"
    end
  end

  def destroy
    systemlog "logged out"
    reset_session

    redirect_to login_path
  end

  def changeLang
    lang=params[:lang]
    puts lang
    I18n.locale = lang
    session[:locale] =I18n.locale
    render json:{status: 'success', lang: lang}

  end

end
