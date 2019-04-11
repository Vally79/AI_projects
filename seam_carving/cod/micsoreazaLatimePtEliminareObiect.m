function img = micsoreazaLatimePtEliminareObiect(img,numarPixeliLatime,metodaSelectareDrum,ploteazaDrum,culoareDrum, poz)

for i = 1:numarPixeliLatime
    
    disp(['Eliminam drumul vertical numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliLatime)]);
    
    E = calculeazaEnergie(img);
    
    const = -1 * 10^10; % punem un numar mic pentru a forta seam-urile sa fie alese
    
    E(poz(2):(poz(2) + poz(4)), poz(1):(poz(1) + poz(3))) = const;
    poz(3) = poz(3) - 1; %scadem latimea pentru iteratia urmatoare
    
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