% 3 Turn points
% 2*C(32) + 6 = 12

function Features = TurnPoint_Feature(B)
    

    Features = zeros(1, 12);
    
    % Read Ref_img
    Ref = double(imread('/Users/chenqian/Desktop/CharVER/1_30pt/song.bmp'));
    Ref = 0.299 .* Ref(:, :, 1) + 0.587 .* Ref(:, :, 2) + 0.114 .* Ref(:, :, 3);
    Ref(Ref > 220) = 255;   Ref(Ref <= 220) = 1;    Ref(Ref == 255) = 0;
    
    % Preprocess
    [~, TurnPoints] = Points(B);
    % sifted by confidence
    TurnPoints = PointConfidence(TurnPoints, Ref);
    Diff = Difference(B, Ref, TurnPoints);
    [~, index] = sort(Diff);
    index = index(1:3);
    
    % Choose 5 min diff EndPoints
    SelectedPoints = TurnPoints(index(:),:);
    
    % NormLocation
    [m_new, n_new] = NormLocation(B, SelectedPoints(:,1), SelectedPoints(:,2));
    Features(1:3) = m_new(:);
    Features(4:6) = n_new(:);
    
    % Distance and Direction
    distance = zeros(1,3);
    direction = zeros(1, 3);
    index = 1;
    
    for i = 1 : 2
        x1 = SelectedPoints(i, 1);
        y1 = SelectedPoints(i, 2);
        
        for j = i + 1 : 2
            x2 = SelectedPoints(j, 1);
            y2 = SelectedPoints(j, 2);
            
            distance(index) = sqrt((x1-y1)^2 + (x2-y2)^2);
            direction(index) = acos((x1*x2 + y1*y2)/sqrt(x1*x1 + y1*y1)/sqrt(x2*x2 + y2*y2));
            index = index + 1;
        end
    end
    
    Features(7:9) = direction(:);
    Features(10:12) = distance(:);
    
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
