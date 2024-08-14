#!/usr/bin/python3
# for local development, just "python3 bottle_apps.py"

# setup to run with apache mod_wsgi

import os
os.chdir(os.path.dirname(__file__))

import bottle
application = bottle.default_app()
bottle.debug(True)

# needed to run external programs

import subprocess

# debugging to stderr

import sys

#### general bottle framework from here on ####

from bottle import route, request, template, static_file

# writable space for files
scratch = "/space/tmp/uploads"

# trivial test target http://localhost:8080/hello
@route('/hello')
def hello():
    return "Hello from bottle number 1!"

# aquatint things
# be sure to set valid scratch variable above and aq_Proc below
# the following variables are global

aq_inImage = ""
aq_outImage = ""
aq_userIP = ""
aq_savePath = "/dev/null"
aq_Proc = "/space/support/ljg/bin/aquatint"


@route('/aquatint', method='POST')
def aquatintProc():
    global aq_inImage, aq_outImage, aq_userIP, aq_savePath, aq_Proc
    global scratch
    aq_userIP = request.remote_addr
    aq_savePath = scratch+"/{0}".format(request.remote_addr)
    if not os.path.exists(aq_savePath):
        os.makedirs(aq_savePath)

    # fetch the new image if there is one
    upload = request.files.get('file')
    if upload and upload.filename != "empty":
        # note that upload.filename is already sanitized
        aq_inImage = upload.filename
        file_path = "{0}/{1}".format(aq_savePath, aq_inImage)
        # need to limit size and type of file here
        upload.save(file_path, overwrite=True)
    
    # get the form data (need to sanitize)
    g = request.forms.get('greycut')
    t = request.forms.get('temperature')
    s = request.forms.get('sweeps')
    # process the file using compiled program
    if aq_inImage != "":
        cmd = "{0} {1} {2} {3} {4}".format(aq_Proc, aq_inImage, g, t, s)
        print("cmd: {0}".format(cmd), file=sys.stderr)
        os.chdir(aq_savePath)
        p = subprocess.run(cmd, shell=True, check=True, encoding='utf-8')
        os.chdir(os.path.dirname(__file__))
        aq_outImage = os.path.splitext(aq_inImage)[0]+"-aq.png"

    print("aq_savePath aq_inImage aq_outImage: {0} {1} {2}".format(aq_savePath,aq_inImage,aq_outImage), file=sys.stderr)
    if aq_inImage != "":
        return template('aquatint', inImage=aq_inImage, outImage=aq_outImage, g=g, t=t, s=s)
    else:
        return "Processing has timed out.  You will have to begin again."


@route('/aquatint', method='GET')
def aquatintForm():
    global aq_inImage, aq_outImage, aq_userIP, aq_savePath, aq_Proc
    return template('aquatint', inImage="", outImage="", g="0.5", t="5", s="3")


@route('/aquatint/images/<filename>')
def aquatintImage(filename):
    global aq_inImage, aq_outImage, aq_userIP, aq_savePath, aq_Proc
    print("fetching aq_savePath/filename {0}/{1}".format(aq_savePath,filename), file=sys.stderr)
    return static_file(filename, root=aq_savePath)


# stand alone server for development testing
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    bottle.run(host='localhost', port=port, debug=True)


