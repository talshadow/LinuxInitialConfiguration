#/bin/bash

function print_help()
{
   echo  Display Help
   echo "setup options"
   echo
   echo "Syntax: genGitConfiguration.sh [-g][-u][-m][-h]"
   echo "options:"
   echo "-u  '-u username' - set user name"
   echo "-m  '-m email@mail.com' - set user mail"
   echo "-k  '-k path/to/ssh/key' - set user ssh kay for signing"
   echo
}

USER_NAME=${USER}
MAIL_NAME=${USER}@$(hostname  -A |sed 's/^[ \t]*//;s/[ \t]*$//').localhost
USER_KEY=

while getopts :ghm:u:k: option; do
   case $option in
      h) # display Help
         print_help
         exit 2;;
      m)
         MAIL_NAME="${OPTARG}";;
      u)
         USER_NAME="${OPTARG}";;
      k)
         USER_KEY="${OPTARG}"
         if [ ! -z ${USER_KEY} ] && [ ! -f ${USER_KEY} ]
         then
            echo "User key file not exist: ${USER_KEY}"
            exit 2
         fi;;
     \?) # Invalid option
         echo "Error: Invalid option ${OPTARG}"
         print_help
         exit 2;;
   esac
done

echo "USER_NAME=${USER_NAME}"
echo "MAIL_NAME=${MAIL_NAME}"

if [ -z ${USER_KEY} ]
then
   USER_KEY="${HOME}/.ssh/${USER_NAME}"
   if [ -f ${USER_KEY} ]
   then
         echo "Key file already exist: ${USER_KEY}"
         exit 3
   fi
   echo "Generate kay ${USER_KEY}"
   ssh-keygen -t ed25519 -C "${MAIL_NAME}" -f ${HOME}/.ssh/"${USER_NAME}"
   echo "IdentityFile ${HOME}/.ssh/${USER_NAME}">>~/.ssh/config
fi

eval $(ssh-agent -s)
ssh-add "${USER_KEY}"
