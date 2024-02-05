
settings_daemon_type_files() {
  local service_name
  local service_config
  local service_files
  local files

  service_name=$1
  service_files=$3

  echo "Service: ${service_name} - Config: ${service_config} - Files: ${service_files}"

  IFS=','
  for files in $service_files; do
    files=$(echo "$files" | xargs)
    echo "  - $files"
  done
}
