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

update_svn() {
  local repo_dir="$MANUAL_DIR/doc-pt_BR"

  echo "Updating svn pt_BR" | colorize_output

  cd $repo_dir
  svn update

  echo "Done." | indent_output
  echo
}

build_inside_container() {
  local repo_dir="$MANUAL_DIR/doc-pt_BR"

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

update_git_web() {
  local repo_dir="$MANUAL_DIR/web-php"

  echo "Updating git web" | colorize_output

  cd $repo_dir
  git clean -df
  git checkout -- .
  git pull
  cd ..
  # pt_BR
  [ -d `pwd`/web-php/manual/pt_BR ] && rm -r `pwd`/web-php/manual/pt_BR || true
  ln -s `pwd`/build/pt_BR/php-web `pwd`/web-php/manual/pt_BR
  # en
  [ -d `pwd`/web-php/manual/en ] && rm -r `pwd`/web-php/manual/en || true
  ln -s `pwd`/build/en/php-web `pwd`/web-php/manual/en
  
  echo "Done." | indent_output
  echo
}

sync_directories() {
  echo "Syncing directories" | colorize_output

  if [ -d $VOLUME_DIR/build ] && [ -d $VOLUME_DIR/doc-pt_BR ] && [ -d $VOLUME_DIR/web-php ]; then
    rsync -avhW --no-compress --update $MANUAL_DIR/ $VOLUME_DIR
  else
    cp -Rv $MANUAL_DIR/ $VOLUME_DIR
  fi

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
  echo "Todas as dependências e repositórios já estão dentro da imagem/container" | indent_output
  echo
  echo "Agora, vamos atualizar os repositórios, sincronizar com sua pasta local e (re)ligar o servidor web" | indent_output
  echo

  update_svn
  build_inside_container
  update_git_web
  sync_directories
  start_web_server
}

if [ "$1" = "build" ] && [ -d $VOLUME_DIR/build ] && [ -d $VOLUME_DIR/doc-pt_BR ] && [ -d $VOLUME_DIR/web-php ]; then
  exec "/scripts/1-build.sh"
  exit 0
else
  main
fi
