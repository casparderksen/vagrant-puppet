# Installs Node 8 LTS, NPM, and web devopment tools.

class profiles::node::node8 {
    notice("applying profiles::node")

    class { 'nodejs':
        repo_url_suffix => '8.x',
    }
}
