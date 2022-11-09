function kind = ClassifyPoints(a1, a2, a3)
    v1 = a2 - a1;
    v2 = a3 - a1;
    theta = acos(sum(v1 .* v2)/sqrt(sum(v1.^2)*sum(v2.^2)));
    if theta <= pi/6
        kind = 1;
    elseif pi/6 < theta && theta < 5*pi/6
        kind = 2;
    else
        kind = 3;
    end
end