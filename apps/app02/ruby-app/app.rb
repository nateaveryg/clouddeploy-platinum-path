# version 1:1
$VERSION = '1.1_20220603'
$interesting_envs = %w{ RICCARDO_KUSTOMIZE_ENV RICCARDO_MESSAGE FAVORITE_COLOR PROJECT_ID RACK_ENV }


class App
  require 'socket'

  def self.call(env)
    fav_color = ENV.fetch("FAVORITE_COLOR", "unknown color, presumably gray?") rescue :UNKNOWN_COLOR

    interesting_infos = {
      :version => $VERSION,
      :hostname =>  Socket.gethostname,
      #:ric_msg => (ENV.fetch("RICCARDO_MESSAGE", "unknown message") rescue :UNKNOWN_MSG),
      #:RICCARDO_KUSTOMIZE_ENV => (ENV["RICCARDO_KUSTOMIZE_ENV"] rescue :_UNKNOWN_RICCARDO_KUSTOMIZE_ENV),
      :interesting_envs => $interesting_envs,
    }

    # populating based on interesting ENVs
    $interesting_envs.each{ |env_name| 
     interesting_infos["ENV_#{env_name}"] = ENV[env_name] rescue :err
    }

    interesting_infos_htmlified = "<h2>Interesting Info</h2> <ul>"
    interesting_infos.each do |k,v| 
      v = '?!?' if v.to_s == ''
      interesting_infos_htmlified << "<li>#{k}: <b>#{v}</b></li>"
    end
    interesting_infos_htmlified << "</ul>"


    return [ 200, {
      "Content-Type" => "text/html"}, 
      ["<h1>Hello Skaffold from Riccardo!</h1>  More exciting stuff coming soon from ENV vars.<br/>
      
      Favorite Color: <b style='background-color:#{fav_color};' >#{fav_color}</b><br/>
      
      #{interesting_infos_htmlified}

      Btw, I really love skaffold!

      <hr/>

      APP $APPNAME v.#{$VERSION}
        
      "]
    ]
  end
end