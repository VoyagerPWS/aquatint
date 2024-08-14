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
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
<meta name="msapplication-TileColor" content="#2b5797">
<meta name="theme-color" content="#ffffff">
<style>
body {
  font-family:Arial,Helvetica,sans-serif;
  background-color:#000000;
  color:#FFFFFF;
}
a { text-decoration:none; }
a:link { color:#FFCD00; }
a:visited { color:#FFDD33; }
a:hover { color:#FFDD00; }
a:active { color:#FFDD00; }
p { margin-left:auto; margin-right:auto; max-width:40rem;line-height:1.5;}
main {display:block;justify-content:center;margin-left:auto:margin-right:auto;max-width:40rem;}
input.upload { width:100%; }
input.slider { height:15px;border-radius:5px;width:100%; }
</style>
</head>
<body>
<main>
<h1>Aquatint Image Processor</h1>
<form action="{{ pre }}/aquatint" method="post" enctype="multipart/form-data" accept-charset="utf-8">
<p>
<label for="file">Select image file to upload</label>
<input class="upload" type="file" id="file" name="file">
</p>
<p>
<label for="greycut">greycut</label> = <output for="greycut" id="greycutValue">{{ g }}</output>
<input class="slider" type="range" min="0.1" max="0.9" step="0.1" value="{{ g }}"
id="greycut" name="greycut" oninput="greycutValue.value=greycut.value">
</p>
<p>
<label for="temperature">temperature</label> = <output for="temperature" id="temperatureValue">{{ t }}</output>
<input class="slider" type="range" min="1.0" max="9.0" step="1.0" value="{{ t }}"
id="temperature" name="temperature" oninput="temperatureValue.value=temperature.value">
</p>
<p>
<label for="sweeps">sweeps</label> = <output for="sweeps" id="sweepsValue">{{ s }}</output>
<input class="slider" type="range" min="1" max="9" step="1" value="{{ s }}"
id="sweeps" name="sweeps" oninput="sweepsValue.value=sweeps.value">
</p>
<p>
<input type="submit" value="Process Image">
</p>
</form>
% if len(inImage) > 0:
<p>
Input image {{ inImage }}.
</p>
<img alt="input image" src="aquatint/images/{{ inImage }}">
<br>
<p>
Processed image {{ outImage }}.  Right-click to save.
</p>
<img alt="output image" src="aquatint/images/{{ outImage }}">
<br>
% end
</main>
</body>
</html>

