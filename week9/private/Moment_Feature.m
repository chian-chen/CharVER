function Features = Moment_Feature(B)
    Features = zeros(1, 9);
    Features(1) = Moment(B, 1, 0);
    Features(2) = Moment(B, 0, 1);
    Features(3) = Moment(B, 1, 1);
    Features(4) = Moment(B, 2, 0);
    Features(5) = Moment(B, 0, 2);
    Features(6) = Moment(B, 3, 0);
    Features(7) = Moment(B, 0, 3);
    Features(8) = Moment(B, 2, 1);
    Features(9) = Moment(B, 1, 2);
end



% Assume the imput M is a 2-D matrix
% ignore the edge case
function A = Moment(M, a, b)

    [m, n] = size(M);   sumM = sum(M, 'all');
    m_0 = 1 : m;
    m_0 = sum(sum(M, 2).' .* m_0)./sumM;
    n_0 = 1 : n;
    n_0 = sum(sum(M) .* n_0)./sumM;
    
    
    moment = 0;
    for i = 1 : m
        for j = 1 : n
            moment = (i - m_0).^a * (j - n_0).^b * M(i, j) + moment;
        end
    end
    
    moment = moment/sumM;
    
    if a == 1 && b == 0
        moment = m_0;
    end
    if a == 0 && b == 1
        moment = n_0;
    end
    A = moment;
end



