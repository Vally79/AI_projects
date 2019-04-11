function img1 = adaugaDrumVertical(img,drumuri, numarCrestere)
%elimina drumul vertical din imagine
%input: img - imaginea initiala
%       drum - drumul vertical
%output img1 - imaginea initiala din care s-a eliminat drumul vertical
img1 = zeros(size(img,1),size(img,2)+numarCrestere,size(img,3),'uint8');
originale = zeros(size(img,1),size(img,2),size(img,3),'uint8');

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        img1(i, j, :) = img(i, j, :);
    end
end

disp(size(drumuri, 1));

for j = 1:size(drumuri, 1)
    for i=1:size(img,1)
        drum = drumuri{j};
        coloana = drum(i, 2);
        cate = 0;
        for k = 1:coloana
            if(originale(i, k) == 1)
                cate = cate + 1;
            end
        end
        coloana = coloana + cate; % vedem cu cat trebuie sa ne deplasam la dreapta deja in noua imagine
        originale(i, coloana) = 1;
        
        img_temp = img1;
        
        %adaugam average-ul intre coloana si coloana din stanga si dreapta
        if coloana > 1
            img1(i, coloana,:) = uint8((double(img_temp(i, coloana, :)) + double(img_temp(i, coloana - 1, :))) / 2);
        end
        if coloana < size(img_temp, 2)
            img1(i, coloana + 1, :) = uint8((double(img_temp(i, coloana, :)) + double(img_temp(i, coloana + 1, :))) / 2);
        else
            img1(i, coloana + 1, :) = img_temp(i, coloana, :);
        end
        %copiem partea din dreapta
        img1(i,coloana + 2:size(img, 2) + j,:) = img_temp(i,coloana+1:size(img, 2) + j - 1,:);
        
    end
end
