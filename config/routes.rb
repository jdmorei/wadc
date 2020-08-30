Rails.application.routes.draw do


  get 'console/new'

  get 'console/input'

  get 'console/new'

  get 'logs/showLogs'

  get 'logs/readLog'

  get 'logs/downloadLog'

  get 'logs/shutdown'

  get 'logs/help'

  post 'telnet/terminal'

  get 'telnet/terminal'


  get 'telnet/input_command'
  get 'telnet/output_command'

  get 'ssh/terminal'

  get 'integra/index'

  post 'integra/create'

  post 'integra/show'

  get 'integra/delete'

  # ssh
  get "/pruebassh" => "ssh#terminal"
  get "/pruebassh/:id" => "ssh#terminal"

  # telnet

 # get "telnet/input_command/:cmd" => "telnet#send_command"



  resources :interfaces do
  end

  post 'interfaces/configure'



  post 'macros/crear'

  get 'macros/crear'


  get 'macros/createShortcut'

  get 'macros/importar'

  post 'macros/importar'

  get 'macros/actualizar'

  post 'macros/actualizar'

  get 'macros/consultar'

  get 'macros/exportar'

  get 'macros/clonar'

  get 'macros/eliminar'

  get 'macros/quick'

  get 'macros/checkMacroName/:name/:macro' =>"macros#checkMacroName"

  #get 'macros/runQuick/:idDev/:namDev/:macro/', to: "macros#runQuick"
  get 'macros/runQuick/:idDev/:nameDev/:macro/' =>  "macros#runQuick"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  resources :usuarios do
    get 'usuarios/index'

    get 'usuarios/new'

    get 'usuarios/create'

    get 'usuarios/update'

    get 'usuarios/show'

    get 'usuarios/destroy'
  end


  resources :dispositivos do
    get 'dispositivos/index'

    get 'dispositivos/new'

    get 'dispositivos/create'

    get 'dispositivos/update'

    get 'dispositivos/show'

    get 'dispositivos/destroy'


  end

  get 'dispositivos/goMacro/:id', to: 'dispositivos#goMacro', as: 'goMacro'
  post 'dispositivos/runMacro'
  post 'dispositivos/macroAvailable'
  get 'dispositivos/macroAvailable/:id', to: 'dispositivos#macroAvailable', as: 'macroAvailable'
  post 'dispositivos/openSSH'
  get 'dispositivos/openSSH/:id', to: 'dispositivos#openSSH', as: 'openSSH'

  get 'dispositivos/realizaBackup'
  get 'dispositivos/recuperaBackup'


  post 'dispositivos/realizaBackup'
  post 'dispositivos/recuperaBackup'


  root 'dispositivos#index'
  resource :sessions, only: [:new, :create, :destroy]
  get "/login" => "sessions#new", as: "login"
  get "/logout" => "sessions#destroy", as: "logout"

  get "/changeLanguage/:lang" => "sessions#changeLang"


end
