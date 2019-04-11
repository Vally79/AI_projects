function E = calculeazaEnergie(img)

img = rgb2gray(img);
YFilter = fspecial('sobel');
XFilter = YFilter';
XFilter(:, [1 3]) = XFilter(:, [3 1]);

PartialDevX = imfilter(double(img), XFilter);
PartialDevY = imfilter(double(img), YFilter);

E = abs(PartialDevX) + abs(PartialDevY);

end