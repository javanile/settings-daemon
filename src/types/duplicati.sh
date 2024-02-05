
settings_daemon_type_duplicati() {
  local service_name
  local service_config
  local service_files
  local files

  service_name=$1
  service_config=$2
  service_files=$3

  ## Esegue il backup dei settings di duplicati
  ./bin/duc login "http://192.168.144.20:8200/" --password=duplicati
  ./bin/duc export --all --output-path=tmp/duplicati


  echo "Service: ${service_name} - Config: ${service_config} - Files: ${service_files}"

  IFS=','
  for files in $service_files; do
    files=$(echo "$files" | xargs)
    echo "  - $files"
  done
}



