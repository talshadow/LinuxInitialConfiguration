#/bin/bash


function print_help()
{
   echo  Display Help
   echo "setup options"
   echo
   echo "Syntax: genGitConfiguration.sh [-g][-u][-m][-h]"
   echo "options:"
   echo "-h  Print this Help."
   echo "-g  setup global git configuration. By default setup local configuration"
   echo "-u  '-u username' - set user name"
   echo "-m  '-m email@mail.com' - set user mail"
   echo "-k  '-k path/to/ssh/key' - set user ssh kay for signing"
   echo
}

function setUpGit() {
    if [ $# -ne 4 ]
    then
        echo "Calling setUpGit with wrong parameter count $#"
        echo "Usage: setUpGit user_name mail_name path_to_user_ssh_key configuration_type"
        return 2
    else
        echo "Arguments:"
        echo "User: ${USER_NAME}"
        echo "User Mail: ${MAIL_NAME}"
        echo "ssh key: ${USER_SSH_KEY}"
        echo "Configuration: ${CONFIGURATION}"
        git config ${CONFIGURATION} user.name "${USER_NAME}"
        git config ${CONFIGURATION} user.email "${MAIL_NAME}"
        #git default editor
        # git config ${CONFIGURATION} core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"
        # git config ${CONFIGURATION} core.editor "nano -w"
        git config ${CONFIGURATION} core.editor "kate"
        git config ${CONFIGURATION} init.defaultBranch main
        git config ${CONFIGURATION} pull.rebase true
        git config ${CONFIGURATION} branch.autosetuprebase always

        git config ${CONFIGURATION} color.ui true

        #git config ${CONFIGURATION} merge.tool kdiff3
        git config ${CONFIGURATION} merge.tool meld
        #git config ${CONFIGURATION} merge.meld.path "C:\Program Files\Meld\Meld.exe"
        git config ${CONFIGURATION} merge.prompt false

        git config ${CONFIGURATION} core.autocrlf input
        #for windows
        # git config ${CONFIGURATION} core.autocrlf true

        #commit sign
        git config ${CONFIGURATION} gpg.format ssh
        git config ${CONFIGURATION} user.signingkey ${USER_SSH_KEY}

        git config ${CONFIGURATION} alias.meld '!git difftool -t meld --dir-diff'
        git config ${CONFIGURATION} alias.kdiff3 '!git difftool -t kdiff3 --dir-diff'
        git config ${CONFIGURATION} alias.rpull '!git pull --tags --recurse-submodules'
        git config ${CONFIGURATION} alias.rfetch '!git fetch --tags --recurse-submodules'
        return 0
    fi
}

CONFIGURATION="--local"
USER_NAME=${USER}
MAIL_NAME=${USER}@$(hostname  -A |sed 's/^[ \t]*//;s/[ \t]*$//').localhost
USER_SSH_KEY=${HOME}/.ssh/${USER_NAME}.pub

while getopts :ghm:u:k: option; do
   case $option in
      h) # display Help
         print_help
         exit 2;;
      g) # set  configuration to global git
         CONFIGURATION="--global";;
      m)
         MAIL_NAME="${OPTARG}";;
      u)
         USER_NAME="${OPTARG}";;
      k)
         USER_SSH_KEY="${OPTARG}"
         if( [ ! -f ${USER_SSH_KEY} ] )
         then
            echo "User key file not exist: ${USER_SSH_KEY}"
            exit 3
         fi;;

     \?) # Invalid option
         echo "Error: Invalid option ${OPTARG}"
         print_help
         exit 2;;
       $OPTARG
   esac
done

setUpGit "${USER_NAME}" "${MAIL_NAME}" "${USER_SSH_KEY}" "${CONFIGURATION}"
result=$?
if [ $result -eq 0 ]
then
    echo "git setup finished"
else
    echo "Error:  ${result}"
fi


