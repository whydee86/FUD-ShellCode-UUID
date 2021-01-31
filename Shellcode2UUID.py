import uuid
import os
import sys
import shellcode
def convertToUUID(shellcode):
    output = "UUID_list.txt"
    write_file = open(output,"w")
    if len(shellcode) % 16 != 0:
        print("[-] Shellcode's length not multiplies of 16 bytes")
        print("[-] Adding nullbytes at the end of shellcode, this might break your shellcode.")
        print("\n[*] Modified shellcode length: ", len(shellcode)+(16-(len(shellcode)%16)))

        addNullbyte =  b"\x00" * (16-(len(shellcode)%16))
        shellcode += addNullbyte 

    uuids = []
    for i in range(0, len(shellcode), 16):
        uuidString = str(uuid.UUID(bytes_le=shellcode[i:i+16]))
        uuids.append('"'+uuidString+'"')
        write_file.write('"' + uuidString + '"'+","+"\n")
    write_file.close()
    return uuids

def main():
    buf = shellcode.buf
    uuids = convertToUUID(buf)
    #print(*uuids, sep=",\n")
main()