function img = getFrontieraMinimaSus(imagine, bloc, dimSuprapunere)
    img = zeros(size(bloc));
    E = (double(imagine) - double(bloc(1:dimSuprapunere, :, :))) .^ 2;
    M = 0.2126 * E(:, :, 1) + 0.7152 * E(:, :, 2) + 0.0722 * E(:, :, 3);
    R = zeros(size(M));
    R(:, 1) = M(:, 1);
    for j = 2:size(M, 2)
        for i = 1:size(M, 1)
            if i > 1 && i < size(M, 1)
                R(i, j) = M(i, j) + min([R(i - 1, j - 1), R(i, j - 1), R(i + 1, j - 1)]);
            elseif i == 1
                R(i, j) = M(i, j) + min([R(i, j - 1), R(i + 1, j - 1)]);
            else % if j == size(M, 2)
                R(i, j) = M(i, j) + min([R(i - 1, j - 1), R(i, j - 1)]);
            end
        end
    end
    drum = zeros(size(M, 2), 1);
    [~, drum(size(M, 2))] = min(R(:, size(M, 2)));
    i = drum(size(M, 2));
    for j = size(M, 2) - 1: -1 : 1
        if drum(j + 1) > 1 && drum(j + 1) < size(M, 1)
            [~, drum(j)] = min([R(i - 1, j + 1), R(i, j + 1), R(i + 1, j + 1)]);
        elseif drum(j + 1) == 1
            [~, drum(j)] = min([R(i, j + 1), R(i + 1, j + 1)]);
        else % if drum(j + 1) == size(M, 1)
            [~, drum(j)] = min([R(i - 1, j + 1), R(i, j + 1)]);
        end
        i = drum(j);
    end
    for j = 1: size(drum)
        img(1:drum(j), j, :) = imagine(1:drum(j), j, :); 
        img(drum(j) + 1:end, j, :) = bloc(drum(j) + 1:end, j, :);
    end
end