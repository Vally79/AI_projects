function img = amplificaContinut(img, factor)

imagine_originala = img;
img = imresize(img, factor);

img = micsoreazaInaltime(img,size(img, 1) - size(imagine_originala, 1),"programareDinamica", 0, [255 0 0]);
img = micsoreazaLatime(img,size(img, 2) - size(imagine_originala, 2),"programareDinamica", 0, [255 0 0]);

