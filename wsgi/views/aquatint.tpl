<!DOCTYPE html>
% if 0:
This is a bottle framework template.  See https://bottlepy.org/docs/dev/stpl.html
The values in double curly braces are Python variables.  Lines beginning with percent are
Python statements.  The following variable, pre, is set to the base of the wsgi bottle main
application file.  Running under Apache mod_wsgi, this will almost certainly be non-blank.
% end
% pre = "/app" # in Apache mod_wsgi environment
<!-- % pre = "" # in bottle development environment -->
<HTML lang="en-us">
<HEAD>
<META charset="UTF-8">
<TITLE>Aquatint Image Processor</TITLE>
<META NAME="description" CONTENT="Application to apply aquatint effect to uploaded images">
<META name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="canonical" href="https://ljg.spacephysics.org/app/aquatint">
% if 0:
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
<meta name="msapplication-TileColor" content="#2b5797">
<meta name="theme-color" content="#ffffff">
% end
<style>
body { font-family:Arial,Helvetica,sans-serif; background-color:#000000; color:#FFFFFF; }
a { text-decoration:none; }
a:link { color:#FFCD00; }
a:visited { color:#FFDD33; }
a:hover { color:#FFDD00; }
a:active { color:#FFDD00; }
p { margin-left:auto; margin-right:auto; max-width:40rem; line-height:1.5; }
p.error { background-color:red; font-size:1.2em; padding:10px; border-radius:10px; text-shadow: 1px 1px black; }
main {display:block; justify-content:center; margin-left:auto; margin-right:auto; max-width:40rem; }
input[type="file"]::file-selector-button { background-color:#FFCD00; color:black; padding:10px; border-radius:10px; cursor:pointer; }
input[type="file"]::file-selector-button:hover { background-color:#FFDE00; }
input[type="file"]::file-selector-button:focus { background-color:#FFDE00; }
input[type="file"]::file-selector-button:active { background-color:#FFFFFF; }
input.upload { width:100%; }
input.slider { height:20px; border-radius:10px; width:100%; cursor:pointer; }
input.submit { cursor:pointer; background-color:#FFCD00; color:black; padding:10px; border-radius:10px; }
input.submit:hover { background-color:#FFDE00; }
input.submit:focus { background-color:#FFDE00; }
input.submit:active { background-color:#FFFFFF; }
</style>
</head>
<body>
<main>
<h1>Aquatint Image Processor</h1>
% if e != "":
<p class="error">
{{ e }}
</p>
% end
<form action="{{ pre }}/aquatint" method="post" enctype="multipart/form-data" accept-charset="utf-8">
<p>
<label for="file">Select image file to upload (limit 3MB)</label>
<input class="upload" type="file" id="file" name="file">
</p>
<p>
<label for="greycut">greycut</label> = <output for="greycut" id="greycutValue">{{ g }}</output>
<input class="slider" type="range" min="0.1" max="0.9" step="0.01" value="{{ g }}"
id="greycut" name="greycut" oninput="greycutValue.value=greycut.value">
</p>
<p>
<label for="temperature">temperature</label> = <output for="temperature" id="temperatureValue">{{ t }}</output>
<input class="slider" type="range" min="1.0" max="9.0" step="0.1" value="{{ t }}"
id="temperature" name="temperature" oninput="temperatureValue.value=temperature.value">
</p>
<p>
<label for="sweeps">sweeps</label> = <output for="sweeps" id="sweepsValue">{{ s }}</output>
<input class="slider" type="range" min="1" max="9" step="1" value="{{ s }}"
id="sweeps" name="sweeps" oninput="sweepsValue.value=sweeps.value">
</p>
<p>
<input class="submit" type="submit" value="Process Image">
</p>
</form>
% if im != "":
<p>Right-click or control-click to save images.</p>
<h3>Aquatint image: {{ aq }}</h3>
<img alt="aquatint image" src="aquatint/images/{{ aq }}"><br>
<h3>Threshold image: {{ bw }}</h3>
<img alt="threshold image" src="aquatint/images/{{ bw }}"><br>
<h3>Input image: {{ im }}</h3>
<img alt="input image" src="aquatint/images/{{ im }}"><br>
<h3>Description</h3>
% end
<p>
This web app applies an aquatint texture effect to an uploaded image using the Ising method
of <a href="https://physics.uiowa.edu/people/yannick-meurice">Prof Yannick Meurice</a>
described in <a href="https://doi.org/10.1119/10.0006525">"Making digital aquatint with
the Ising model"</a>, and is inspired by the <a href=
"https://alanmckay.blog/projects/aquatint/">work of Alan McKay</a>.
</p>
<p>
The Ising model, in addition to an image texture effect, may describe the magnetization
of a solid state lattice.  We start with a threshold image where pixels are separated into
pure black and white regions at a fractional "greycut".  This represents the initial localized
ferromagnetic field with either up or down spin.  Physical systems have a Boltzmann
probability distribution controlled by temperature, with higher temperature yielding
greater disorder.  The final adjustable parameter, "sweeps", controlls the number of
iterations of importance sampling applied.
</p>
<hr>
<p>
<a href="https://ljg.spacephysics.org/">Larry Granroth</a>
</p>
</main>
</body>
</html>

