function d = selecteazaDrumVertical(E,metodaSelectareDrum)
%selecteaza drumul vertical ce minimizeaza functia cost calculate pe baza lui E
%
%input: E - energia la fiecare pixel calculata pe baza gradientului
%       metodaSelectareDrum - specifica metoda aleasa pentru selectarea drumului. Valori posibile:
%                           'aleator' - alege un drum aleator
%                           'greedy' - alege un drum utilizand metoda Greedy
%                           'programareDinamica' - alege un drum folosind metoda Programarii Dinamice
%
%output: d - drumul vertical ales

d = zeros(size(E,1),2);

switch metodaSelectareDrum
    case 'aleator'
        %pentru linia 1 alegem primul pixel in mod aleator
        linia = 1;
        %coloana o alegem intre 1 si size(E,2)
        coloana = randi(size(E,2));
        %punem in d linia si coloana coresponzatoare pixelului
        d(1,:) = [linia coloana];
        for i = 2:size(d,1)
            %alege urmatorul pixel pe baza vecinilor
            %linia este i
            linia = i;
            %coloana depinde de coloana pixelului anterior
            if d(i-1,2) == 1%pixelul este localizat la marginea din stanga
                %doua optiuni
                optiune = randi(2)-1;%genereaza 0 sau 1 cu probabilitati egale 
            elseif d(i-1,2) == size(E,2)%pixelul este la marginea din dreapta
                %doua optiuni
                optiune = randi(2) - 2; %genereaza -1 sau 0
            else
                optiune = randi(3)-2; % genereaza -1, 0 sau 1
            end
            coloana = d(i-1,2) + optiune;%adun -1 sau 0 sau 1: 
                                         % merg la stanga, dreapta sau stau pe loc
            d(i,:) = [linia coloana];
        end
    case 'greedy'
        linia = 1;
        [~, coloana] = min(E(linia, :));
        d(1, :) = [linia coloana];
        for i = 2:size(d, 1)
            if d(i-1, 2) == 1
                [~, coloana] = min(E(i, d(i-1, 2): d(i -1, 2) + 1));
            elseif d(i-1, 2) == size(E, 2)
                [~, coloana] = min(E(i, d(i-1, 2) - 1: d(i -1, 2)));
                coloana = coloana + d(i-1, 2) - 2;
            else
                [~, coloana] = min(E(i, d(i-1, 2) - 1: d(i -1, 2) + 1));
                coloana = coloana + d(i-1, 2) - 2;
            end
            d(i,:) = [i coloana];
        end
 
    case 'programareDinamica'
        M = zeros(size(E, 1), size(E, 2));
        for j = 1:size(E, 2)
            M(1, j) = E(1, j);
        end
        for i = 2:size(E, 1)
            for j = 1:size(E, 2)
                if j == size(E, 2)
                    [cat, ~] = min(M(i - 1, j - 1: j));
                elseif j == 1
                    [cat, ~] = min(M(i - 1, j: j + 1));
                else
                    [cat, ~] = min(M(i - 1, j - 1: j + 1));
                end
                M(i, j) = cat + E(i, j);
            end
        end
        [~, care] = min(M(size(E, 1), :));
        d(size(d, 1), :) = [size(d, 1), care];
        for i = size(E, 1) - 1:-1:1
            if care == size(E, 2)
                    [~, care2] = min(M(i + 1, care - 1: care));
                    care2 = care2 + care - 2;
            elseif care == 1
                    [~, care2] = min(M(i + 1, care: care + 1));
            else
                    [~, care2] = min(M(i + 1, care - 1: care + 1));
                    care2 = care2 + care - 2;
            end
            d(i, :) = [i care2];
            care = care2;
        end
    otherwise
        error('Optiune pentru metodaSelectareDrum invalida');
end

end