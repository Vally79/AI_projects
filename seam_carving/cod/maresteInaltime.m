function imagine_noua = maresteInaltime(img,numarPixeliInaltime,metodaSelectareDrum,ploteazaDrum,culoareDrum)

imagine_originala = img;

drumuri = cell(numarPixeliInaltime);

for i = 1:numarPixeliInaltime
    
    disp(['Adaugam drumul orizontal numarul ' num2str(i) ...
        ' dintr-un total de ' num2str(numarPixeliInaltime)]);
    
    %calculeaza energia dupa ecuatia (1) din articol
    E = calculeazaEnergie(img);
    E = E';
    
    %alege drumul vertical care conecteaza sus de jos
    drum = selecteazaDrumVertical(E,metodaSelectareDrum);
    
    drumuri{i} = drum;
    
    %afiseaza drum
    if ploteazaDrum
        ploteazaDrumVertical(permute(img, [2 1 3]),E,drum,culoareDrum);
        pause(1);
        close(gcf);
    end
    
    %elimina drumul din imagine
    
    % imagine_noua = adaugaDrumVertical(imagine_noua, drum);
    img = eliminaDrumVertical(permute(img, [2 1 3]),drum);
    img = permute(img, [2 1 3]);
end

imagine_temp = adaugaDrumVertical(permute(imagine_originala, [2 1 3]), drumuri, numarPixeliInaltime);
imagine_noua = permute(imagine_temp, [2 1 3]);