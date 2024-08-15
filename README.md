# aquatint
Aquatint image modification using Ising method of Meurice and McKay

This is the initial version of a complete web app to provide "aquatint" services for uploaded images, replacing an earlier version provided by Alan McKay.

See [Alan McKay's blog](https://alanmckay.blog/projects/aquatint/) on the application.

See [Prof Yannick Meurice's journal article](https://pubs.aip.org/aapt/ajp/article-abstract/90/2/87/2819740/Making-digital-aquatint-with-the-Ising-model).

Thanks go to the maintainers of [stb image library](https://github.com/nothings/stb), portions of which are included here.

The web app utilizes the [bottle framework](https://bottlepy.org/docs/dev/tutorial.html), which is extremely lightweight and simple.  This is a dependency, either running on a server utilizing Apache with [mod_wsgi](https://modwsgi.readthedocs.io/en/master/) or the bottle built-in single-threaded server for development and demonstrations.

A version of this app is accessible at [my web server](https://ljg.spacephysics.org/app/aquatint).

## Apache configuration
Install Apache `mod_wsgi`:
```
dnf -y install mod_wsgi
```
or the eqivalent for your platform environment.

Include something similar to this in your main Apache config file:
```
<Directory "/some/place/wsgi">
    Options FollowSymLinks
    Require all granted
</Directory>
<IfModule !wsgi_module>
    LoadModule wsgi_module modules/mod_wsgi_python3.so
</IfModule>
```
The LoadModule may be done for you as part of the package management.

Then in your virtual server config block:
```
WSGIDaemonProcess aquatint display-name='aquatint' lang='en_US.UTF-8' locale='en_US.UTF-8' threads=10 queue-timeout=45 socket-timeout=60 connect-timeout=15 request-timeout=60 inactivity-timeout=0 startup-timeout=15 deadlock-timeout=60 graceful-timeout=15 eviction-timeout=0 restart-interval=0 shutdown-timeout=5 maximum-requests=0
WSGIProcessGroup aquatint
WSGIScriptAlias /aquatint /some/place/wsgi/bottle_apps.py
```
The name "aquatint" can be changed, as can "/some/place/wsgi", plus the exact location of the directives is flexible as well.  Due to a policy of backwards compatibility in the Bottle Framework, the long sequence of timeout specifications is strongly encouraged, but is adjustable as well.

## Tips in lieu of a build system
Read the [Bottle Framework Tutorial](https://bottlepy.org/docs/dev/tutorial.html); it's short and *sweet*.

Read through the `aquatint.c` source for instructions on compiling.

Read through the `wsgi/bottle_apps.py` source for configuration details to adjust, such as the location of the compiled aquatint binary.

Read through the `wsgi/views/aquatint.tpl` template file for configuration details, such as the prefix for the Bottle app.

[Larry Granroth](https://ljg.spacephysics.org)
