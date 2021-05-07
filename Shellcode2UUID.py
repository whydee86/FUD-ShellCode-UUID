
I forked this repo and made this change
import uuid
import os
import sys
import shellcode
def convertToUUID(shellcode):
    output = "UUID_list.txt"
    write_file = open(output,"w")
    if len(shellcode) % 16 != 0:
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
    convertToUUID(buf)
main()
