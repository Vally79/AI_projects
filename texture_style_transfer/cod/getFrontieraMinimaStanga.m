function img = getFrontieraMinimaStanga(imagine, bloc, dimSuprapunere)
    img = zeros(size(bloc));
    E = (double(imagine) - double(bloc(:, 1:dimSuprapunere, :))) .^ 2;
    M = 0.2126 * E(:, :, 1) + 0.7152 * E(:, :, 2) + 0.0722 * E(:, :, 3);
    R = zeros(size(M));
    R(1, :) = M(1, :);
    for i = 2:size(M, 1)
        for j = 1:size(M, 2)
            if j > 1 && j < size(M, 2)
                R(i, j) = M(i, j) + min([R(i - 1, j - 1), R(i - 1, j), R(i - 1, j + 1)]);
            elseif j == 1
                R(i, j) = M(i, j) + min([R(i - 1, j), R(i - 1, j + 1)]);
            else % if j == size(M, 2)
                R(i, j) = M(i, j) + min([R(i - 1, j - 1), R(i - 1, j)]);
            end
        end
    end
    drum = zeros(size(M, 1), 1);
    [~, drum(size(M, 1))] = min(R(size(M, 1), :));
    j = drum(size(M, 1));
    for i = size(M, 1) - 1: -1 : 1
        if drum(i + 1) > 1 && drum(i + 1) < size(M, 2)
            [~, drum(i)] = min([R(i + 1, j - 1), R(i + 1, j), R(i + 1, j + 1)]);
        elseif drum(i + 1) == 1
            [~, drum(i)] = min([R(i + 1, j), R(i + 1, j + 1)]);
        else % if drum(i + 1) == size(M, 2)
            [~, drum(i)] = min([R(i + 1, j - 1), R(i + 1, j)]);
        end
        j = drum(i);
    end
    for i = 1: size(drum)
        img(i, 1:drum(i), :) = imagine(i, 1:drum(i), :); 
        img(i, drum(i) + 1:end, :) = bloc(i, drum(i) + 1:end, :);
    end
end