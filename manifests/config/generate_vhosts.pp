define nginx::config::generate_vhosts($config){
  nginx::vhost { $name:
    altnames            => $config[$name]['altnames'],
    strictname          => $config[$name]['strictname'],
    forcehttps          => $config[$name]['forcehttps'],
    root                => $config[$name]['root'],
    listen              => $config[$name]['listen'],
    ssllisten           => $config[$name]['ssllisten'],
    ssl_certificate     => $config[$name]['ssl_certificate'],
    ssl_certificate_key => $config[$name]['ssl_certificate_key'],
  }
}
