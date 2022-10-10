function A = erosion(M)
    M_new = M;
    [row,col] = size(M);
    for i = 2:row - 1
        for j =2:col - 1
            M_new(i, j) = M(i, j) && M(i + 1, j) && M(i - 1, j) && M(i, j + 1) && M(i, j - 1);
        end
    end
    A = M_new;
end