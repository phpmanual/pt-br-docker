#!/usr/bin/env sh

set -e

MANUAL_DIR="/php-manual-pt-br"
VOLUME_DIR="/volume"

### META:BEGIN ###
indent_output() {
  while read data; do
    echo -e " \033[1;32m|\033[0m  $data"
  done
}
colorize_output() {
  while read data; do
    echo -e "\033[1;32m$data\033[0m"
  done
}
### META:END ###

build_inside_volume() {
  local repo_dir="$VOLUME_DIR/doc-pt_BR"

  echo "Building manual" | colorize_output

  cd $repo_dir
  # pt_BR
  php doc-base/configure.php --enable-xml-details --with-lang=pt_BR
  phd --docbook doc-base/.manual.xml --package PHP --format php --output ../build/pt_BR
  #en
  php doc-base/configure.php --enable-xml-details
  phd --docbook doc-base/.manual.xml --package PHP --format php --output ../build/en

  echo "Done." | indent_output
  echo
}

stop_web_server() {
  echo "Stoping web server" | colorize_output

  killall php || true

  echo "Done." | indent_output
  echo
}

start_web_server() {
  local repo_dir="$VOLUME_DIR/web-php"

  echo "(Re)starting web server" | colorize_output

  php -S 0.0.0.0:4000 -t $repo_dir
}

main() {
  echo "INFO" | colorize_output
  echo "Recompilando" | indent_output
  echo
  echo "Agora, vamos recompilar o manual e (re)ligar o servidor web" | indent_output
  echo

  build_inside_volume
  stop_web_server
  start_web_server  
}

