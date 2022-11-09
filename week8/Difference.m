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