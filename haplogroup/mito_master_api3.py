#!/usr/bin/env python3
import sys
import requests

try:
       fname = sys.argv[1]
except:
       sys.stderr.write("Usage: ./mito_master_api.py filename > outfile \n")
       sys.exit(1)

try:
    response = requests.post("https://mitomap.org/mitomaster/websrvc.cgi", files={"file": open(fname),'fileType': ('', 'sequences'),'output':('', 'detail')})
    print(str(response.content, 'utf-8'))
except requests.exceptions.HTTPError as err:
    print("HTTP error: " + err)
