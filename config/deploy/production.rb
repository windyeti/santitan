# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "46.101.162.221", user: "deploy", roles: %w{app db web}, primary: true
set :rails_env, :production


# Global options
# --------------
set :ssh_options, {
  keys: %w(/Users/egorrails/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password)
}
