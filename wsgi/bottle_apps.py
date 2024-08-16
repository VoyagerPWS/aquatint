#!/usr/bin/python3
# for local development, just "python3 bottle_apps.py"

#### setup to run with apache mod_wsgi ####

import os
os.chdir(os.path.dirname(__file__))

import bottle
application = bottle.default_app()
#bottle.debug(True)

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
aq_savePath = "/dev/null"
aq_Proc = "/space/support/ljg/bin/aquatint"


@route('/aquatint', method='POST')
def aquatintProc():
    e = ""  # error string
    aq = "" # aquatint image
    bw = "" # threshold image
    global aq_inImage, aq_savePath, aq_Proc
    global scratch

    aq_savePath = scratch+"/{0}".format(request.remote_addr)
    if not os.path.exists(aq_savePath):
        os.makedirs(aq_savePath)

    # fetch the new image if there is one
    upload = request.files.get('file')
    if upload and upload.filename != "empty":
        # note that upload.filename is already sanitized
        aq_inImage = upload.filename
        file_path = "{0}/{1}".format(aq_savePath, aq_inImage)
        # limit file type and size here
        #print("upload content_type={0} content_length={1}".format(upload.content_type,upload.content_length), file=sys.stderr)
        # this isn't sufficient because content_length is always -1
        if upload.content_type.startswith('image/') and upload.content_length < 3000001:
            upload.save(file_path, overwrite=True)
            size = os.path.getsize(file_path)
            if size > 3000000:
                os.unlink(file_path)
                e = "Invalid file {0} type {1} size {2} is too big.".format(aq_inImage, upload.content_type, size)
                aq_inImage = ""
        else:
            size = upload.content_length
            if size == -1:
                size = "unknown"
            e = "Invalid file {0} type {1} size {2}.".format(aq_inImage, upload.content_type, size)
            aq_inImage = ""

    # get and sanitize the form data
    g = request.forms.get('greycut')
    t = request.forms.get('temperature')
    s = request.forms.get('sweeps')
    # check for numbers (program will check range)
    if not (g.replace('.','',1).isnumeric() and t.replace('.','',1).isnumeric() and s.isnumeric()):
        e = "Bad parameter:  greycut, temperature, or sweeps.  Resetting to defaults."
        g = 0.5
        t = 5.0
        s = 3

    # process the file using compiled program aq_Proc
    if aq_inImage != "":
        cmd = "{0} {1} {2} {3} {4}".format(aq_Proc, aq_inImage, g, t, s)
        #print("subprocess.run {0}".format(cmd), file=sys.stderr)
        os.chdir(aq_savePath)
        p = subprocess.run(cmd, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE,
            universal_newlines = True, encoding='utf-8')
        os.chdir(os.path.dirname(__file__))
        if p.returncode: # the subprocess returned a non-zero status
            e = p.stderr
            i = e.find(': ') # tidy up "name:  ERROR" type messages
            if i > -1:
                e = e[i+2:].strip()
            aq_inImage = ""
        else:
            aq = os.path.splitext(aq_inImage)[0]+"-aq.png"
            bw = os.path.splitext(aq_inImage)[0]+"-bw.png"

    
    if aq_inImage == "":
        bw = ""
        aq = ""
        g  = 0.5
        t  = 5.0
        s  = 3
        if e == "":
            e  = "Processing has timed out.  You will have to begin again."

    #print("template aquatint im={0} bw={1} aq={2} g={3} t={4} s={5} e={6}".format(im, bw, aq, g, t, s, e), file=sys.stderr)
    return template('aquatint', im=aq_inImage, bw=bw, aq=aq, g=g, t=t, s=s, e=e)


@route('/aquatint', method='GET')
def aquatintForm():
    global aq_inImage, aq_savePath, aq_Proc
    return template('aquatint', im="", bw="", aq="", g="0.5", t="5", s="3", e="")


@route('/aquatint/images/<filename>')
def aquatintImage(filename):
    global aq_inImage, aq_savePath, aq_Proc
    #print("fetching aq_savePath/filename {0}/{1}".format(aq_savePath,filename), file=sys.stderr)
    return static_file(filename, root=aq_savePath)


# stand alone server for development testing
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    bottle.run(host='localhost', port=port, debug=True)

