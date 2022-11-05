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