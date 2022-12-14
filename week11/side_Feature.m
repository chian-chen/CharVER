% ====== Debug ======
% B = double(imread('../3/database/base_1_50_3.bmp'));
% B = 0.299 .* B(:, :, 1) + 0.587 .* B(:, :, 2) + 0.114 .* B(:, :, 3);
% B(B > 220) = 255;   B(B <= 220) = 1;    B(B == 255) = 0;
% 
% Ref = double(imread('/Users/chenqian/Desktop/CharVER/3_30pt/song.png'));
% Ref = 0.299 .* Ref(:, :, 1) + 0.587 .* Ref(:, :, 2) + 0.114 .* Ref(:, :, 3);
% Ref(Ref > 220) = 255;   Ref(Ref <= 220) = 1;    Ref(Ref == 255) = 0;
% ===================


function Features = side_Feature(B, Ref)

Features = zeros(1, 30);
Bo = B;
Refo = Ref;


% divide region
Components = cell(1, 10);
i = 1;

while(sum(B, 'all') ~= 0)
    [Region, B] = region(B, i);
    Components{i} = Region;
    i = i + 1;
end

Components_Ref = cell(1, 10);
i = 1;

while(sum(Ref, 'all') ~= 0)
    [Region, Ref] = region(Ref, i);
    Components_Ref{i} = Region;
    i = i + 1;
end

Components = Components(~cellfun('isempty',Components));
Components_Ref = Components_Ref(~cellfun('isempty',Components_Ref));


% Norm and dilation

inputRegionNumber = size(Components, 2);
refRegionNumber = size(Components_Ref, 2);


NormB = zeros(101, 101);
Normside = cell(1, inputRegionNumber);

for i = 1:inputRegionNumber
    
    [m, n] = find(Components{i});
    [m_new, n_new] = NormLocation(Bo, m, n);
    m_new = round(m_new);
    n_new = round(n_new);
    
    side = zeros(101, 101);

    for j = 1:length(m_new)
        side(m_new(j) + 51, n_new(j) + 51) = i;
    end
    
    Normside{i} = side;
    NormB = NormB + side;
end

NormRef = zeros(101, 101);
for i = 1:refRegionNumber
    [m, n] = find(Components_Ref{i});

    [m_new, n_new] = NormLocation(Refo, m, n);
    m_new = round(m_new);
    n_new = round(n_new);


    for j = 1:length(m_new)
        NormRef(m_new(j) + 51, n_new(j) + 51) = i;
    end
end


NormBRegion = NormB;
NormRefRegion = NormRef;

while sum((NormBRegion == 0), 'all') ~= 0
    NormBRegion = dilation(NormBRegion);
end
while sum((NormRefRegion == 0), 'all') ~= 0
    NormRefRegion = dilation(NormRefRegion);
end


% ====== Debug ======
% figure; image(NormB * 255 / inputRegionNumber);
% colormap(gray(256));
% figure; image(NormBRegion * 255 / inputRegionNumber);
% colormap(gray(256));
% figure; image(NormRef * 255 / refRegionNumber);
% colormap(gray(256));
% figure; image(NormRefRegion * 255 / refRegionNumber);
% colormap(gray(256));
% ===================



% side area

area = zeros(1, 5);
for i = 1: inputRegionNumber
    area(i) = sum((NormBRegion == i), 'all');
end

Features(1:5) = area(1:5);

% input to reference

input_to_ref = zeros(1, 5);

for i = 1: inputRegionNumber
    
    A = (NormBRegion == i);
    maximal = 0;
    
    for j = 1:refRegionNumber
        
        B = (NormRefRegion == j);
        if maximal < sum((A&B), 'all')
            input_to_ref(i) = j;
            maximal = sum((A&B), 'all');
        end
    end
    
end

Features(6:10) = input_to_ref(1:5);

% reference to input

ref_to_input = zeros(1, 5);

for i = 1: refRegionNumber
    
    A = (NormRefRegion == i);
    maximal = 0;
    
    for j = 1:inputRegionNumber
        
        B = (NormBRegion == j);
        
        if maximal < sum((A&B), 'all')
            ref_to_input(i) = j;
            maximal = sum((A&B), 'all');
        end
    end
    
end

Features(11:15) = ref_to_input(1:5);

% side: height/width
% central of the side

h_divide_w = zeros(1, 5);
centerh = zeros(1, 5);
centerw = zeros(1, 5);

for i = 1:inputRegionNumber
    B = Normside{i};
    height = find(sum(B, 2));
    h1 = height(1); h2 = height(end);

    width = find(sum(B));
    w1 = width(1); w2 = width(end);
    
    h_divide_w(i) = (h2-h1)/(w2-w1);
    centerh(i) = (h2 + h1)/2;
    centerw(i) = (w2 + w1)/2;
end


Features(16:20) = h_divide_w(1:5);
Features(21:25) = centerh(1:5);
Features(26:30) = centerw(1:5);

end






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
function newB = dilation(B)
    newB = B;
    [row,col] = size(B);
    
    for i = 2:row - 1
        for j =2:col - 1
            if B(i, j) == 0
                newB(i, j) = max(max(B(i-1:i+1, j-1:j+1)));
            end
        end
    end
    
    for j = 2:col - 1
        if B(1, j) == 0
            newB(1, j) = max(max(B(1:2, j-1:j+1)));
        end
        if B(row, j) == 0
            newB(row, j) = max(max(B(row-1:row, j-1:j+1)));
        end
    end
    
    for i = 2:row - 1
        if B(i, 1) == 0
            newB(i, 1) = max(max(B(i-1:i+1, 1:2)));
        end
        if B(i, col) == 0
            newB(i, col) = max(max(B(i-1:i+1, col-1:col)));
        end
    end
    
    newB(1, 1) = max(max(B(1:2, 1:2)));
    newB(1, col) = max(max(B(1:2, col-1:col)));
    newB(row, 1) = max(max(B(row-1:row, 1:2)));
    newB(row, col) = max(max(B(row-1:row, col-1:col)));
end

