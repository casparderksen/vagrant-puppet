# Installs and configures Apache HTTPD.

class profiles::apache::webserver {
    notice("applying profiles::apache")

    class { 'apache': 
        default_vhost  => false,
        service_ensure => false,
    }

    $index_html = @(EOT)
        <!doctype html>
        <html lang=en>
        <head>
        <meta charset=utf-8>
            <title>Welcome</title>
        </head>
        <body>
            <p>Web server is running.</p>
        </body>
        </html>
        |EOT

    file { '/var/www/html/index.html':
        content => $index_html,
    }

    apache::vhost { 'localhost':
        port        => 80,
        docroot     => '/var/www/html',
        directories => [
            {
                path           => '/var/www/html',
                options        => 'Indexes FollowSymLinks MultiViews',
                allow_override => 'None',
                require        => 'all granted',
            },
        ],
    }
}
