function img = micsoreazaInaltime(img,numarPixeliInaltime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

for i = 1:numarPixeliInaltime
    
    disp(['Eliminam drumul orizontal numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliInaltime)]);
    
    %calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img);
    E = E';
    
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
    
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(permute(img, [2 1 3]),E,drum,culoareDrum);
        pause(1);
        close(gcf);
    end
    
    %elimina drumul din imagine
    img = eliminaDrumVertical(permute(img, [2 1 3]),drum);
    img = permute(img, [2 1 3]);

end
