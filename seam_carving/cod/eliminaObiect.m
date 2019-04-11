function img = eliminaObiect(img, parametri)
 
figure(1);
imshow(img);
poz = getrect; % selectare dreptunghi
close(1);

poz = round(poz);

if poz(3) > poz(4) %latime dreptunghi > inaltime
    disp('Eliminare pe orizontala');
    parametri.numarPixeliInaltime = poz(4);
 
    img = micsoreazaInaltimePtEliminareObiect(img,parametri.numarPixeliInaltime,parametri.metodaSelectareDrum,...
                            parametri.ploteazaDrum,parametri.culoareDrum, poz);
    
else
    disp('Eliminare pe verticala');
    parametri.numarPixeliLatime = poz(3);
 
    img = micsoreazaLatimePtEliminareObiect(img,parametri.numarPixeliLatime,parametri.metodaSelectareDrum,...
                            parametri.ploteazaDrum,parametri.culoareDrum, poz);
    
end
