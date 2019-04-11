function imagine_noua = maresteLatime(img,numarPixeliLatime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

imagine_originala = img;

drumuri = cell(numarPixeliLatime);

for i = 1:numarPixeliLatime
    
    disp(['Adaugam drumul vertical numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliLatime)]);
    
    %calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img);
    
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
    
    drumuri{i} = drum;
    
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(img,E,drum,culoareDrum);
        pause(1);
        close(gcf);
    end
    
    %elimina drumul din imagine
    
    % imagine_noua = adaugaDrumVertical(imagine_noua, drum);
    img = eliminaDrumVertical(img,drum);
end
imagine_noua = adaugaDrumVertical(imagine_originala, drumuri, numarPixeliLatime);
