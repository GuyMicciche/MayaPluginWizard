import os
import sys
import telnetlib

port = 20200

if len(sys.argv) > 1:
    port = int(sys.argv[1])

current_folder = os.path.basename(os.path.dirname(os.path.abspath(__file__)))
print(f"Unloading plugin: {current_folder}")

try:
    tn = telnetlib.Telnet("localhost", port)
    tn.write('file -newFile -force;'.encode())
    tn.write(f'catchQuiet(`unloadPlugin "{current_folder}"`)'.encode())
    tn.close()
except:
    pass