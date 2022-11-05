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


