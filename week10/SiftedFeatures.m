function newFeatures = SiftedFeatures(Features)

    [~,N] = size(Features);

    for i = 1:N
        value = sum(Features(:, i) > 0);
        if(value/kk <= 0.1)
            Features(:, i) = zeros(kk, 1);
        end
    end
    Features(:, ~any(Features, 1)) = [];

    % normalization
    [m,N] = size(Features);

    for i = 1:N
        mf = mean(Features(:, i));
        nrm = diag(1./std(Features(:, i),1));
        Features(:, i) = (Features(:, i) - ones(m,1) * mf) * nrm;
    end

    % sifted by K value

    x1 = 1:1:m/2;
    xo = m/2+1:1:m;

    for i = 1:N
        mean1 = mean(Features(x1, i));
        meano = mean(Features(xo, i));
        var1 = sqrt(var(Features(x1, i)));
        varo = sqrt(var(Features(xo, i)));
        if abs(mean1 - meano)/sqrt(var1 * varo) < 0.3
            Features(:, i) = zeros(kk, 1);
        end
    end
    Features(:, ~any(Features, 1)) = [];
    newFeatures = Features;

end