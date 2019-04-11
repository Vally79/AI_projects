function imgSintetizata = realizeazaSintezaTexturii(parametri)

dimBloc = parametri.dimensiuneBloc;
nrBlocuri = parametri.nrBlocuri;

[inaltimeTexturaInitiala,latimeTexturaInitiala,nrCanale] = size(parametri.texturaInitiala);
H = inaltimeTexturaInitiala;
W = latimeTexturaInitiala;
c = nrCanale;

H2 = parametri.dimensiuneTexturaSintetizata(1);
W2 = parametri.dimensiuneTexturaSintetizata(2);
overlap = parametri.portiuneSuprapunere;

% o imagine este o matrice cu 3 dimensiuni: inaltime x latime x nrCanale
% variabila blocuri - matrice cu 4 dimensiuni: punem fiecare bloc (portiune din textura initiala) 
% unul peste altul 
dims = [dimBloc dimBloc c nrBlocuri];
blocuri = uint8(zeros(dims(1), dims(2),dims(3),dims(4)));

%selecteaza blocuri aleatoare din textura initiala
%genereaza (in maniera vectoriala) punctul din stanga sus al blocurilor
y = randi(H-dimBloc+1,nrBlocuri,1);
x = randi(W-dimBloc+1,nrBlocuri,1);
%extrage portiunea din textura initiala continand blocul
for i =1:nrBlocuri
    blocuri(:,:,:,i) = parametri.texturaInitiala(y(i):y(i)+dimBloc-1,x(i):x(i)+dimBloc-1,:);
end

imgSintetizata = uint8(zeros(H2,W2,c));
nrBlocuriY = ceil(size(imgSintetizata,1)/dimBloc);
nrBlocuriX = ceil(size(imgSintetizata,2)/dimBloc);
imgSintetizataMaiMare = uint8(zeros(nrBlocuriY * dimBloc,nrBlocuriX * dimBloc,size(parametri.texturaInitiala,3)));

switch parametri.metodaSinteza
    
    case 'blocuriAleatoare'
        %%
        %completeaza imaginea de obtinut cu blocuri aleatoare
        
        % NU SE TINE CONT DE SUPRAPUNERE!
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                indice = randi(nrBlocuri);
                imgSintetizataMaiMare((y-1)*dimBloc+1:y*dimBloc,(x-1)*dimBloc+1:x*dimBloc,:)=blocuri(:,:,:,indice);
            end
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru blocuri selectatate aleator');
        return

    
    case 'eroareSuprapunere'
        %%
        %completeaza imaginea de obtinut cu blocuri alese in functie de eroarea de suprapunere
        dimSuprapunere = ceil(dimBloc * overlap);
        nrBlocuriY = ceil(H2 / (dimBloc - dimSuprapunere)) + 1;
        nrBlocuriX = ceil(W2 / (dimBloc - dimSuprapunere)) + 1;
        imgSintetizataMaiMare = uint8(zeros(nrBlocuriY * (dimBloc - dimSuprapunere) + dimSuprapunere, nrBlocuriX * (dimBloc - dimSuprapunere) + dimSuprapunere, c));
        
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                startXBloc = (x - 1) * (dimBloc - dimSuprapunere) + 1;
                endXBloc = startXBloc + dimBloc - 1;
                startYBloc = (y - 1) * (dimBloc - dimSuprapunere) + 1;
                endYBloc = startYBloc + dimBloc - 1;
                
                if x == 1 && y == 1
                   indice = randi(nrBlocuri);
                elseif y == 1
                   suprapunere = imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:startXBloc + dimSuprapunere - 1,:);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:end, 1:dimSuprapunere, :, i);
                      distanta(i) = sum((double(bloc(:)) - double(suprapunere(:))) .^ 2);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                elseif x == 1
                   suprapunere = imgSintetizataMaiMare(startYBloc:startYBloc + dimSuprapunere - 1,startXBloc:endXBloc,:);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:dimSuprapunere, 1:end, :, i);
                      distanta(i) = sum((double(bloc(:)) - double(suprapunere(:))) .^ 2);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                else
                   suprapunereSus = imgSintetizataMaiMare(startYBloc:startYBloc + dimSuprapunere - 1,startXBloc:endXBloc,:);
                   suprapunereStanga = imgSintetizataMaiMare(startYBloc + dimSuprapunere:endYBloc,startXBloc:startXBloc + dimSuprapunere - 1,:);
                   distantaSus = zeros(nrBlocuri, 1);
                   distantaStanga = zeros(nrBlocuri, 1);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:dimSuprapunere, 1:end, :, i);
                      distantaSus(i) = sum((double(bloc(:)) - double(suprapunereSus(:))) .^ 2);
                      bloc = blocuri(dimSuprapunere+1:end, 1:dimSuprapunere, :, i);
                      distantaStanga(i) = sum((double(bloc(:)) - double(suprapunereStanga(:))) .^ 2);
                      distanta(i) = distantaSus(i) + distantaStanga(i);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                end
                imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:endXBloc,:)=blocuri(:,:,:,indice);
            end
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru eroare de suprapunere');
        return
        
	case 'frontieraCostMinim'
        %
        %completeaza imaginea de obtinut cu blocuri ales in functie de frontiera de cost minim
        dimSuprapunere = ceil(dimBloc * overlap);
        nrBlocuriY = ceil(H2 / (dimBloc - dimSuprapunere)) + 1;
        nrBlocuriX = ceil(W2 / (dimBloc - dimSuprapunere)) + 1;
        imgSintetizataMaiMare = uint8(zeros(nrBlocuriY * (dimBloc - dimSuprapunere) + dimSuprapunere, nrBlocuriX * (dimBloc - dimSuprapunere) + dimSuprapunere, c));
        
        for y=1:nrBlocuriY
            for x=1:nrBlocuriX
                startXBloc = (x - 1) * (dimBloc - dimSuprapunere) + 1;
                endXBloc = startXBloc + dimBloc - 1;
                startYBloc = (y - 1) * (dimBloc - dimSuprapunere) + 1;
                endYBloc = startYBloc + dimBloc - 1;
                
                if x == 1 && y == 1
                   indice = randi(nrBlocuri);
                   imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:endXBloc,:)=blocuri(:,:,:,indice);
                elseif y == 1
                   suprapunere = imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:startXBloc + dimSuprapunere - 1,:);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:end, 1:dimSuprapunere, :, i);
                      distanta(i) = sum((double(bloc(:)) - double(suprapunere(:))) .^ 2);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                   imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:endXBloc,:)=...
                        getFrontieraMinimaStanga(suprapunere, blocuri(:,:,:,indice), dimSuprapunere);
                elseif x == 1
                   suprapunere = imgSintetizataMaiMare(startYBloc:startYBloc + dimSuprapunere - 1,startXBloc:endXBloc,:);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:dimSuprapunere, 1:end, :, i);
                      distanta(i) = sum((double(bloc(:)) - double(suprapunere(:))) .^ 2);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                   imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:endXBloc,:)=...
                        getFrontieraMinimaSus(suprapunere, blocuri(:,:,:,indice), dimSuprapunere);
                else
                   suprapunereSus = imgSintetizataMaiMare(startYBloc:startYBloc + dimSuprapunere - 1,startXBloc:endXBloc,:);
                   suprapunereStanga = imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:startXBloc + dimSuprapunere - 1,:);
                   distantaSus = zeros(nrBlocuri, 1);
                   distantaStanga = zeros(nrBlocuri, 1);
                   distanta = zeros(nrBlocuri, 1);
                   for i = 1:nrBlocuri
                      bloc = blocuri(1:dimSuprapunere, 1:end, :, i);
                      distantaSus(i) = sum((double(bloc(:)) - double(suprapunereSus(:))) .^ 2);
                      bloc = blocuri(1:end, 1:dimSuprapunere, :, i);
                      distantaStanga(i) = sum((double(bloc(:)) - double(suprapunereStanga(:))) .^ 2);
                      distanta(i) = distantaSus(i) + distantaStanga(i);
                   end
                   minim = min(distanta);
                   indiciDistanteTolerate = find(distanta <= minim * (1 + parametri.eroareTolerata));
                   pozitie = randi(size(indiciDistanteTolerate, 1));
                   indice = indiciDistanteTolerate(pozitie);
                   imgSintetizataMaiMare(startYBloc:endYBloc,startXBloc:endXBloc,:)=...
                        getFrontieraMinimaStangaSus(suprapunereStanga, suprapunereSus, blocuri(:,:,:,indice), dimSuprapunere);
                end
            end 
        end
        
        imgSintetizata = imgSintetizataMaiMare(1:size(imgSintetizata,1),1:size(imgSintetizata,2),:);
        
        figure, imshow(parametri.texturaInitiala)
        figure, imshow(imgSintetizata);
        title('Rezultat obtinut pentru frontiera de cost minim');
        return
    case 'transferulTexturii'
         %
        %completeaza imaginea de obtinut cu blocuri ales in functie de eroare de suprapunere + forntiera de cost minim
       
end
       
    
