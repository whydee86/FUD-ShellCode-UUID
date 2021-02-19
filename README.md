# FUD-ShellCode-UUID #
-------------
### Before: ###
![alt text](https://github.com/whydee86/FUD_Malware_Dev/blob/main/MalwareTest/Umv5YbJDEvSG.png?raw=true)
-------------
### After: ###
![alt text](https://github.com/whydee86/FUD_Malware_Dev/blob/main/RunUuid/FUD.png?raw=true)
-------------
## How to Use: ##
1.build your shellcode using Buildshellcode.sh.  
2.run the solution.  
3.go to FUD-ShellCode-UUID\RunUuid\RunUuid.cpp.  
4.copy UUID_list.txt(output of buildshellcode.sh) and replace the uuid char array.  
5.compile and run on the victim machine.   

-------------
#### UUID Shellcode Execution is a technique that I learned from NCCGroup's RIFT article and Sunggwan Choi.  ####
#### Creadit:  ####
https://research.nccgroup.com/2021/01/23/rift-analysing-a-lazarus-shellcode-execution-method/  
https://blog.sunggwanchoi.com/eng-uuid-shellcode-execution/  
