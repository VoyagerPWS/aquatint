// aquatint.c by L. Granroth, https://ljg.spacephysics.org/, 2024-07-24
// Apply image processing algorithm by Yannick Meurice and Alan McKay
// See https://alanmckay.blog/projects/aquatint/ and
// https://pubs.aip.org/aapt/ajp/article-abstract/90/2/87/2819740/Making-digital-aquatint-with-the-Ising-model

// Image i/o utilizes the stb_image library, https://github.com/nothings/stb.
// Convert the input image to gray, apply algorithm, then write it back to disk.

// Compile with
//   gcc -std=c17 -Wall -pedantic -O aquatint.c -o aquatint -lm

// See usage() below.

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image/stb_image_write.h"

#undef DEBUG

char *myname;

void
usage () {
    fprintf(stderr, "USAGE:  %s input.img greycut temperature sweeps\n"
      "input.img:   image to process in a standard format\n"
      "greycut:     threshold 0.1 (dark) to 0.9 (bright)\n"
      "temperature: 1.0 to 9.0, temperature parameter of Ising model\n"
      "sweeps:      1 to 5, number of iterations over sites\n", myname);
}

int
main(int argc, char *argv[]) {

    int i, len;

    myname = argv[0];
    if (argc != 5) {
        usage();
        exit(1);
    }
    char *infile = argv[1];
    int width, height, channels;
    uint8_t *img = stbi_load(infile, &width, &height, &channels, 0);
    if (img == NULL) {
        fprintf(stderr, "%s:  ERROR loading image file %s\n", myname, infile);
        exit(1);
    }

#ifdef DEBUG
    fprintf(stderr, "%s:  INFO Loaded %s, width %d, height %d, channels %d\n", myname, infile, width, height, channels);
#endif

    double greycut = atof(argv[2]);
    if (greycut < 0.1 || greycut > 0.9) {
        fprintf(stderr, "%s:  ERROR bad greycut value %f\n", myname, greycut);
        usage();
        exit(1);
    }
    int threshold = (1.0 - greycut) * 255;

    double temperature = atof(argv[3]);
    if (temperature < 1.0 || temperature > 9.0) {
        fprintf(stderr, "%s:  ERROR bad temperature value %f\n", myname, temperature);
        usage();
        exit(1);
    }
    double beta = 1.0 / temperature;

    int sweeps = atof(argv[4]);
    if (sweeps < 1 || sweeps > 9) {
        fprintf(stderr, "%s:  ERROR bad sweeps value %d\n", myname, sweeps);
        usage();
        exit(1);
    }

    // Convert the input image to NTSC gray, then threshold to white -1 and black +1
    // with no extra channels
    int nsites = width * height;
    size_t img_size = width * height * channels;

    // memory for white black signed two-state threshold image
    int8_t *bw = malloc((size_t) nsites);
    if (bw == NULL) {
        fprintf(stderr, "%s:  ERROR allocating memory for threshold image, bw[].\n", myname);
        exit(1);
    }

    // populate white black threshold image
    // input image ranges from black 0 to white 255 while output is white -1 and black +1
    // (the pin pout pointers should be declared in the for loop, but my c-foo is weak)
    uint8_t *pin = img;
    int8_t *pout = bw;
    for (; pin != img + img_size; pin += channels, pout++) {
        int gray = *pin * 0.299 + *(pin + 1) * 0.587 + *(pin + 2) * 0.114;
        *pout = gray >= threshold ? -1 : 1;
    }

    // always save the bw greycut image
    // the white value -1 is automatically 255 as an unsigned value
    // but change the black value +1 to 0 for the image write
    for (int i=0; i<nsites; i++) if (bw[i] == 1) bw[i] = 0;
    // build output file name from input file name
    len = strlen(infile);
    for (i=len; i>0; i--) if (infile[i] == '.') break;
    if (i) len = i;
    char outbw[len+7];
    strncpy(outbw, infile, len);
    strcpy(outbw+len, "-bw.png");
    stbi_write_png(outbw, width, height, 1, bw, width);
    // then change white back to +1 again
    for (i=0; i<nsites; i++) if (bw[i] == 0) bw[i] = 1;

    // init random number generator
    srand((unsigned int)time(NULL));

    // allocate width * height signed 8-bit array for Ising model manipulation
    // (yup, that's why we called the size "nsites")
    int8_t *sig = malloc((size_t) nsites);
    if (sig == NULL) {
        fprintf(stderr, "%s:  ERROR allocating Ising state array, sig[].\n", myname);
        exit(1);
    }
    // init to white -1 state
    memset ((void *) sig, -1, (size_t) nsites);

    // sweeps
    for (int n=0; n<sweeps; n++) {
        // elements of Ising state array
        for (i=0; i<nsites; i++) {
            // arbitrary x and y elements
            int x = rand() % width;
            int y = rand() % height;
            // sum of surrounding elements
            double sumsig = sig[((x+1)%width)+width*y] + sig[((x-1)%width)+width*y] +
                            sig[x+width*((y+1)%height)] + sig[x+width*((y-1)%height)];
            // center element
            double local  = sig[x+width*y]*(beta*sumsig+bw[x+width*y]);
            // logic for flipping element should be explained better
            if (local <= 0.0) {
                sig[x+width*y] *= (-1);
            } else {
                double prob = (double)rand() / (double)RAND_MAX;
                double probflip = exp(-2*local);
                if (prob <= probflip) sig[x+width*y] *= (-1);
            }
        }
    }

    // the white value -1 is automatically 255 as an unsigned value
    // but change the black value +1 to 0 for the image write
    for (i=0; i<nsites; i++) if (sig[i] == 1) sig[i] = 0;
    // build output file name from input file name
    len = strlen(infile);
    for (i=len; i>0; i--) if (infile[i] == '.') break;
    if (i) len = i;
    char outaq[len+7];
    strncpy(outaq, infile, len);
    strcpy(outaq+len, "-aq.png");
#ifdef DEBUG
    fprintf(stderr, "%s:  INFO outaq: %s\n", myname, outaq);
#endif
    int success = stbi_write_png(outaq, width, height, 1, sig, width);
    if (! success) {
        fprintf(stderr, "%s:  ERROR writing output aquatint image %s.\n", myname, outaq);
        exit(1);
    }

    // clean up and exit with success status
    stbi_image_free(img);
    free(bw);
    free(sig);
    exit(0);
}

