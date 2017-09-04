#!/usr/bin/python
#adapted from mitomaster website (https://www.mitomap.org/mitomaster/webservice.cgi)

from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
import sys

try:
       fname = sys.argv[1]
except:
       sys.stderr.write("Usage: ./mito_master_api.py filename > outfile \n")
       sys.exit(1)

register_openers()

#fileType can be sequences or snvlist
datagen, headers = multipart_encode({"file": open(fname),'fileType':'sequences','output':'detail'})

request = urllib2.Request("https://mitomap.org/mitomaster/websrvc.cgi", datagen, headers)
try:
     print urllib2.urlopen(request).read()
except urllib2.HTTPError, e:
     print "HTTP error: %d" % e.code
except urllib2.URLError, e:
     print "Network error: %s" % e.reason.args[1]

