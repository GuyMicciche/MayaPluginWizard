import os
import sys
import telnetlib

port = 20200

if len(sys.argv) > 1:
    port = int(sys.argv[1])

current_folder = os.path.basename(os.path.dirname(os.path.abspath(__file__)))
print(f"Loading plugin: {current_folder}")

try:
    tn = telnetlib.Telnet("localhost", port)
    tn.write(f'catchQuiet(`loadPlugin "{current_folder}"`)'.encode())
    tn.close()
except:
    pass