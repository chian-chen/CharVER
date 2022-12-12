function HighConfidencePoints = PointConfidence(EndPoints, Ref)

    [m_new, n_new] = NormLocation(Ref, EndPoints(:,1), EndPoints(:,2));


    m = m_new;
    n = n_new;
    size = length(m);
    
    % if x or y differs over 2 in normLocation,
    %           it is viewed as two different Endpoints
    threshold = 4;

    Group = cell(1, size);
    index = 1;

    while(sum(find(m)))
        f = find(m, 1);
        m1 = m(f);
        n1 = n(f);
        d = (m_new - m1).^2 + (n_new - n1).^2;
    
        dd = find(d < threshold);
        dd(dd<f) = [];
    
        m(dd) = 0;
        n(dd) = 0;
    
        Group{index} = dd;
        index = index + 1;
    end
    
    index = index - 1;
    newindex = zeros(1, index);

    for i = 1:index
        newindex(i) = Group{i}(1);
    end

    HighConfidencePoints = zeros(index, 2);
    HighConfidencePoints(:, 1) = EndPoints(newindex, 1);
    HighConfidencePoints(:, 2) = EndPoints(newindex, 2);

end

function [m_new, n_new] = NormLocation(B, m, n)
    % Find m1, m2

    M = find(sum(B, 2));
    m1 = M(1); m2 = M(end);

    % Find n1, n2

    N = find(sum(B));
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

% ====== Debug ======
% B = double(imread('../1/database/base_1_48_1.bmp'));
% B = 0.299 .* B(:, :, 1) + 0.587 .* B(:, :, 2) + 0.114 .* B(:, :, 3);
% B(B > 220) = 255;   B(B <= 220) = 1;    B(B == 255) = 0;
% 
% Ref = double(imread('/Users/chenqian/Desktop/CharVER/1_30pt/song.bmp'));
% Ref = 0.299 .* Ref(:, :, 1) + 0.587 .* Ref(:, :, 2) + 0.114 .* Ref(:, :, 3);
% Ref(Ref > 220) = 255;   Ref(Ref <= 220) = 1;    Ref(Ref == 255) = 0;
% 
% [EndPoints, ~] = Points(B);