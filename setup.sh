#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/iBotPeaches/Apktool/releases/download/v2.6.1/apktool_2.6.1.jar -O $RALPM_TMP_DIR/apktool_2.6.1.jar
  mv $RALPM_TMP_DIR/apktool_2.6.1.jar $RALPM_PKG_INSTALL_DIR/apktool.jar

  wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jre_x64_linux_hotspot_8u345b01.tar.gz -O $RALPM_TMP_DIR/OpenJDK8U-jre_x64_linux_hotspot_8u345b01.tar.gz
  tar xf $RALPM_TMP_DIR/OpenJDK8U-jre_x64_linux_hotspot_8u345b01.tar.gz -C $RALPM_PKG_INSTALL_DIR

  echo "#!/usr/bin/env sh" > $RALPM_PKG_BIN_DIR/apktool
  echo "$RALPM_PKG_INSTALL_DIR/jdk8u345-b01-jre/bin/java -jar $RALPM_PKG_INSTALL_DIR/apktool.jar \"\$@\"" >> $RALPM_PKG_BIN_DIR/apktool
  chmod +x $RALPM_PKG_BIN_DIR/apktool
}

uninstall() {
  rm $RALPM_PKG_BIN_DIR/apktool
  rm $RALPM_PKG_INSTALL_DIR/apktool.jar
  rm -rf $RALPM_PKG_INSTALL_DIR/jdk8u345-b01-jre
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1