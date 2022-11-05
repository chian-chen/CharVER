function angle = Directions(B, L)

size = 2*L + 1;
mask = zeros(size, size);

for m = 1:size
    for n = 1:size
        mask(m, n) = (m - L) + 1i*(n - L);
    end
end

Xd = conv2(B, mask, 'same');
angle = Xd; % ?
end