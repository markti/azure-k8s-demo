application_name     = "fleet-app"
environment_name     = "dev"
service_account_name = "workload"
namespace            = "app"
web_app_image = {
  name    = "fleetops-frontend"
  version = "2023.11.8"
}
web_api_image = {
  name    = "fleetops-backend"
  version = "2023.11.5"
}