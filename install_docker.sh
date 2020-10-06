#! /bin/bash

GREEN=$(tput setaf 2)
LIME_YELLOW=$(tput setaf 190)
YELLOW=$(tput setaf 3)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)

# last instal docker compose git repo NEXT SCRIPT
#COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`



do_install(){

if exist docker;then
 docker_version="$(docker -v | cut -d ' ' -f3 | cut -d ',' -f1)"
 echo "${GREEN} Docker ESTA INSTALADO - ${POWDER_BLUE} VERSION: $docker_version"
else
 echo "${CYAN}INSTALANDO DOCKER . . ."
	if [ "$user" != 'root' ]; then
		if exist sudo; then
			sh_c='sudo -E sh -c'
		else
			cat >&2 <<-'EOF'
			${RED} Error: Es necesario usuario root
			EOF
			exit 1
		fi
	fi #check root comands


	## exec comands install
	before_install
	echo "${BLUE} Descargando GPG"
        echo "${GREEN} Descargando ..."
        echo `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -qq - >/dev/null`
        sudo apt-key fingerprint 0EBFCD88

        sudo add-apt-repository \
          "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) \
          stable"

        sudo apt-get update

        sudo apt-get install docker-ce docker-ce-cli containerd.io
        sudo usermod -aG docker $USER

	echo ""
        echo " ${LIME_YELLOW} instalacion correctamente "
        echo ""
        echo "********************************************"
        echo ""
        echo ""
        echo ""
        echo " Docker version  : ${BLUE} $(docker -v | cut -d ' ' -f3 | cut -d ',' -f1)"
        echo ""
        echo ""
        echo "${LIME_YELLOW}"
        echo "*********************************************"

fi #check docker 

}

before_install(){
 # sudo dpkg --configure -a # erro install dpkg
 echo "${BLUE} Actualizando"
 echo "${YELLOW}"
 sudo apt-get update
 #echo $(id -un 2>/dev/null || true)
 echo "${BLUE} Instalando requerisitos"
 echo "${YELLOW}"
 sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
}

exist(){
  command -v "$@" > /dev/null 2>&1
}


#EXEC METHOD  INTALL
do_install
