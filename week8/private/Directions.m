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