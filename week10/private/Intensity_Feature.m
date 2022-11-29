function Features = Intensity_Feature(B)
    Features = zeros(1,2);
    w = sum(sum(B > 0));
    Y_mean = sum(sum(B))/w;
    Y_std = sqrt( sum(sum((B - Y_mean).^2)) / w );
    Features(1) = Y_mean;
    Features(2) = Y_std;
end