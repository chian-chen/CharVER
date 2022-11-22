function Features = Erosion_Feature(B)
    Features = zeros(1,3);
    
    B1 = Erosion(B);
    B2 = Erosion(B1);
    B3 = Erosion(B2);
    B_sum = sum(B, 'all');
    B1_sum = sum(B1, 'all');
    B2_sum = sum(B2, 'all');
    B3_sum = sum(B3, 'all');
    Features(1) = B1_sum / B_sum;
    Features(2) = B2_sum / B_sum;
    Features(3) = B3_sum / B_sum;
end


% Assume the imput M is a 2-D matrix
% ignore the edge case
function A = Erosion(M)
    M_new = M;
    [row,col] = size(M);
    for i = 2:row - 1
        for j =2:col - 1
            M_new(i, j) = M(i, j) && M(i + 1, j) && M(i - 1, j) && M(i, j + 1) && M(i, j - 1);
        end
    end
    A = M_new;
end