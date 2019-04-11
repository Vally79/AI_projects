function img = micsoreazaInaltimePtEliminareObiect(img,numarPixeliInaltime,metodaSelectareDrum,ploteazaDrum,culoareDrum, poz)
 
img = permute(img,[2 1 3]);
 
for i = 1:numarPixeliInaltime
   
    disp(['Eliminam drumul orizontal numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliInaltime)]);
   
    E = calculeazaEnergie(img);
    E = E';
    
    
    const = -1 * 10^10; % punem un numar mic pentru a forta seam-urile sa fie alese
    E(poz(2):(poz(2) + poz(4)), poz(1):(poz(1) + poz(3))) = const;
    poz(4) = poz(4) - 1; %scadem inaltimea pentru iteratia urmatoare
    E = E';
    
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
   
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(img,E,drum,culoareDrum);
        pause(1);
        close(gcf);
    end
   
    %elimina drumul din imagine
    img = eliminaDrumVertical(img,drum);
 
end
 
img = permute(img,[2 1 3]);
 
end