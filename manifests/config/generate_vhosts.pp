# define: nginx::config::generate_vhosts
#
# This definition creates a nginx::vhost from a hash, which is typically
# received from a YAML via hiera.
# It should not be used directly. Use nginx::vhost instead.

define nginx::config::generate_vhosts($config){
  nginx::vhost { $name:
    priority            => $config[$name]['priority'],
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
