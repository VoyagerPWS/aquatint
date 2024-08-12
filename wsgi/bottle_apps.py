#!/usr/bin/python3

# setup to run with apache mod_wsgi

import os
os.chdir(os.path.dirname(__file__))

import bottle
application = bottle.default_app()

# general bottle framework from here on

from bottle import route, request, template

@route('/hello')
def hello():
    return "Hello from bottle apps!"

# aquatint things
# the following variables are global

aq_inImage = ""
aq_outImage = ""
aq_userIP = ""
aq_savePath = ""

@route('/aquatint', method='POST')
def aquatintProc():
    aq_userIP = request.remote_addr
    upload = request.files.get('file')
    aq_savePath = "/space/tmp/uploads/{0}".format(request.remote_addr)
    if not os.path.exists(aq_savePath):
        os.makedirs(aq_savePath)

    # note that upload.filename is sanitized
    aq_inImage = upload.filename
    file_path = "{path}/{file}".format(path=aq_savePath, file=aq_inImage)
    upload.save(file_path, overwrite=True)
    return "File successfully saved to '{0}'.".format(file_path)

@route('/aquatint', method='GET')
def aquatintForm():
    return template('aquatint')

# stand alone server for development testing
if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    bottle.run(host='localhost', port=port, debug=True)


