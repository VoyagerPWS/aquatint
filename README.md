# aquatint
Aquatint image modification using Ising method of Meurice and McKay

This eventually will become a complete web app to provide "aquatint" services for uploaded images, replacing an earlier version provided by Alan McKay.

See [Alan McKay's blog](https://alanmckay.blog/projects/aquatint/) on the application.

See [Prof Yannick Meurice's journal article](https://pubs.aip.org/aapt/ajp/article-abstract/90/2/87/2819740/Making-digital-aquatint-with-the-Ising-model).

Thanks go to the maintainers of [stb image library](https://github.com/nothings/stb), portions of which are included here.

The web app will utilize the [bottle framework](https://bottlepy.org/docs/dev/tutorial.html), which is extremely lightweight and simple.  This is a dependency, either running on a server utilizing Apache with [mod_wsgi](https://modwsgi.readthedocs.io/en/master/) or the bottle built-in single-threaded server for development and demonstrations.

[Larry Granroth](https://ljg.spacephysics.org)
