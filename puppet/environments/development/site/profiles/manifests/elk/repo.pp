# Installs local repo.

class profiles::elk::repo {

    include profiles::yumrepo

    # Create local Yum repo
    profiles::yumrepo::local_repo { 'elk.repo': repo_name => 'elk' }
}
