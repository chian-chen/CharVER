
% ====== Debug ======
B = double(imread('../3/database/base_1_50_3.bmp'));
B = 0.299 .* B(:, :, 1) + 0.587 .* B(:, :, 2) + 0.114 .* B(:, :, 3);
B(B > 220) = 255;   B(B <= 220) = 1;    B(B == 255) = 0;

Ref = double(imread('/Users/chenqian/Desktop/CharVER/3_30pt/song.png'));
Ref = 0.299 .* Ref(:, :, 1) + 0.587 .* Ref(:, :, 2) + 0.114 .* Ref(:, :, 3);
Ref(Ref > 220) = 255;   Ref(Ref <= 220) = 1;    Ref(Ref == 255) = 0;
% ===================

Bo = B;
Refo = Ref;


figure; image(B * 255);
colormap(gray(256));

figure; image(Ref * 255);
colormap(gray(256));



Components = cell(1, 10);
i = 1;

while(sum(B, 'all') ~= 0)
    [Region, B] = region(B, i);
    Components{i} = Region;
    i = i + 1;
end

Components = Components(~cellfun('isempty',Components));


Components_Ref = cell(1, 10);
i = 1;

while(sum(Ref, 'all') ~= 0)
    [Region, Ref] = region(Ref, i);
    Components_Ref{i} = Region;
    i = i + 1;
end

Components_Ref = Components_Ref(~cellfun('isempty',Components_Ref));


% side area

input = size(Components, 2);
ref = size(Components_Ref, 2);


% input to reference

region1 = Components{1};
[m, n] = find(region1);

[m_new, n_new] = NormLocation(Bo, m, n);
m_new = round(m_new);
n_new = round(n_new);

NormRegion = zeros(101, 101);

for i = 1:length(m_new)
    NormRegion(m_new(i) + 51, n_new(i) + 51) = 1;
end

figure; image(NormRegion * 255);
colormap(gray(256));


% =========================


region2 = Components{2};
[m, n] = find(region2);

[m_new, n_new] = NormLocation(Bo, m, n);
m_new = round(m_new);
n_new = round(n_new);

NormRegion = zeros(101, 101);

f = find(sum(Bo));


for i = 1:length(m_new)
    NormRegion(m_new(i) + 51, n_new(i) + 51) = 1;
end

figure; image(NormRegion * 255);
colormap(gray(256));

% reference to input


% side: height/width


% central of the side









function [Region, B] = region(B, number)

    [x, y] = find(B);
    B(x(1), y(1)) = 100;
    [row,col] = size(B);
    
    
    prevsum = 0; currentsum = 1;
    
    
    while prevsum ~= currentsum
        prevsum = sum(B, 'all');
        for i = 2:row - 1
            for j = 2:col - 1
                if B(i, j) == 1
                    B(i, j) = max(max(B(i-1:i+1, j-1:j+1)));
                end
                if B(j, i) == 1
                    B(j, i) = max(max(B(j-1:j+1, i-1:i+1)));
                end
                if B(row + 1 - i, col + 1 - j) == 1
                    B(row + 1 - i, col + 1 - j) = max(max(B(row - i:row + 2 - i, col - j:col + 2 - j)));
                end
                if B(col + 1 - j, row + 1 - i) == 1
                    B(col + 1 - j, row + 1 - i) = max(max(B(col - j:col + 2 - j, row - i:row + 2 - i)));
                end
            end
        end
        currentsum = sum(B, 'all');
    end
    
    Region = zeros(row, col);
    Region(B == 100) = number;
    
%     figure; image(Region * 255);
%     colormap(gray(256));
    
    B(B == 100) = 0;
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
    d = max(m2-m1, n2-n1) + 1;

    % m_new, n_new

    size = length(m);
    m_new = zeros(1, size);
    n_new = zeros(1, size);

    for i = 1:size
        m_new(i) = (m(i)-m_o)/d*100;
        n_new(i) = (n(i)-n_o)/d*100;
    end
    
end

