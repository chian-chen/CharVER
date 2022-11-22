function D = Difference(B1, B2, EndPoints)
    m = EndPoints(:, 1);
    n = EndPoints(:, 2);
    [m_new1, n_new1] = NormLocation(B1, m, n);
    [m_new2, n_new2] = NormLocation(B2, m, n);
    [m_ratio1, n_ratio1] = CoordiRatio(B1, m, n);
    [m_ratio2, n_ratio2] = CoordiRatio(B2, m, n);
    direction1 = Directions(B1, 3, m, n);
    direction2 = Directions(B2, 3, m, n);
    
    w1 = 1; w2 = 1; w3 = 1;
    Diffnew = abs((m_new1 - m_new2 )+ (n_new1 - n_new2));
    Diffratio = abs((m_ratio1 - m_ratio2)+(n_ratio1-n_ratio2));
    Diffdirection = min(abs(direction1 - direction2), 2 * pi -abs(direction1 - direction2));
    D =  w1 * Diffnew + w2 * Diffratio + w3 * Diffdirection;
end

function [m_ratio, n_ratio] = CoordiRatio(B, m, n)

% Total
TotalPoints = sum(B, 'all');

% m_ratio, n_ratio

size = length(m);
m_ratio = zeros(1, size);
n_ratio = zeros(1, size);

for i = 1:size
subM = B(1:m(i), :);
subN = B(:, 1:n(i));
m_ratio(i) = sum(subM, 'all')/TotalPoints;
n_ratio(i) = sum(subN, 'all')/TotalPoints;
end

end
function direction = Directions(B, L, m, n)

    size = 2*L + 1;
    mask = zeros(size, size);

    for x = 1:size
        for y = 1:size
            mask(x, y) = (x - L) + 1i*(y - L);
        end
    end

    Xd = conv2(B, mask, 'same');
    A = angle(Xd);

    direction = zeros(1, length(m));
    for i = 1:length(m)
        direction(i) = A(m(i), n(i));
    end
end
function [m_new, n_new] = NormLocation(B, m, n)

% Find m1, m2

M = find(sum(B));
m1 = M(1); m2 = M(end);

% Find n1, n2

N = find(sum(B, 2));
n1 = N(1); n2 = N(end);

% m_o, n_o

m_o = (m1 + m2)/2;  n_o = (n1 + n2)/2;
d = min(m2-m1, n2-n1);

% m_new, n_new

size = length(m);
m_new = zeros(1, size);
n_new = zeros(1, size);

for i = 1:size
m_new(i) = (m(i)-m_o)/d*100;
n_new(i) = (n(i)-n_o)/d*100;
end

end


