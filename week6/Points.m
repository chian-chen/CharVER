% DataBase, TestCase

d = dir('../1/database/*.bmp');
path = '../1/database/';

k = numel(d);
DataBase = cell(1, k);

for i = 1 : k
  im = double(imread(strcat(path, d(i).name)));
  R = im(:, :, 1);
  G = im(:, :, 2);
  B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  Y(Y > 220) = 255;
  DataBase{i} = double(Y);
end

% Edge

B = DataBase{1};
B(B == 255) = 0;    B(B > 0) = 1;

NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
NotEdge(NotEdge < 5) = 0;   NotEdge = NotEdge / 5;

Edge = B - NotEdge;

figure; image(Edge * 255);
colormap(gray(256))

% Store the point clockwisely, Assume the number of regions < 10
% delete the region s.t. number of points < 30

cases = GenerateCases();
OrderList = cell(1, 10);
sumArea = 0;

points = sum(Edge, 'all');
regionNum = 1;

while points > 0
    [row, col] = find(Edge);
    [Edge, Order, Area] = Trace(Edge, row(1), col(1), cases);
    
    figure; image(Edge * 255);
    colormap(gray(256))
    
    % if the region is too small, it will not provide useful information
    if Area > 30
        OrderList{regionNum} = Order;
        regionNum = regionNum + 1;
        sumArea = sumArea + Area;
    end
    
    points = sum(Edge, 'all');  % update
end

OrderList = OrderList(~cellfun('isempty',OrderList));   % remove empty cell

% classify points

TurnPoints = zeros(sumArea, 2);
EndPoints = zeros(sumArea, 2);
TurnPointIndex = 1; EndPointIndex = 1;
d = 15;

for i = 1:length(OrderList)
    n = length(OrderList{i});
    for j = 1:n
        if j > d && j <= n - d
            a1 = OrderList{i}(j,:);
            a2 = OrderList{i}(j-d,:);
            a3 = OrderList{i}(j+d,:);
            kind = ClassifyPoints(a1, a2, a3);
        elseif j <= d
            a1 = OrderList{i}(j,:);
            a2 = OrderList{i}(n - d + j,:);
            a3 = OrderList{i}(j+d,:);
            kind = ClassifyPoints(a1, a2, a3);
        else
            a1 = OrderList{i}(j,:);
            a2 = OrderList{i}(j-d,:);
            a3 = OrderList{i}(j - n + d,:);
            kind = ClassifyPoints(a1, a2, a3);
        end
        if kind == 1
            EndPoints(EndPointIndex, :) = OrderList{i}(j, :);
            EndPointIndex = EndPointIndex + 1;
        elseif kind == 2
            TurnPoints(TurnPointIndex, :) = OrderList{i}(j, :);
            TurnPointIndex = TurnPointIndex + 1;
        else
        end
    end
end

TurnPoints( ~any(TurnPoints,2), : ) = [];  %delete all zero rows
EndPoints( ~any(EndPoints,2), : ) = [];  %delete all zero rows

B_Turn = zeros(size(Edge));
B_End = zeros(size(Edge));

for i = 1:TurnPointIndex - 1
    B_Turn(TurnPoints(i,1), TurnPoints(i,2)) = 1;
end
for i = 1:EndPointIndex - 1
    B_End(EndPoints(i,1), EndPoints(i,2)) = 1;
end

figure; image(B_Turn * 255);
colormap(gray(256))
figure; image(B_End * 255);
colormap(gray(256))

% =============================== FUNCTIONS ==============================

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


%           1(1) | 2(4) | 3(7)
%           8(2) | o(5) | 4(8)
%           7(3) | 6(6) | 5(9)
%      Indexing: [1 4 7 8 9 6 3 2]
function cases = GenerateCases()
    cases = cell(1, 7);
    cases{1} = [6 3 2 1 4 7 8 9];
    for i = 2 : 8
        a = cases{i - 1};
        cases{i} = [a(2:end) a(1)];
    end
end



function [newB, Order, Area] = Trace(B, row, col, cases)

    newB = B;
    startRow = row; startCol = col;
    
    points = sum(newB, 'all');
    Order = zeros(points, 2);   num = 1;
    Area = 0;
    currentCase = cases{4};
    
    while points > 0
        
        Order(num, 1) = row;
        Order(num, 2) = col;
        num = num + 1;
        newB(row, col) = 0;
        Area = Area + 1;
        
        window = newB(row - 1: row + 1, col - 1: col + 1);
        points = sum(window, 'all');
        
        % Trace Back
        if(points == 0)
            back = num - 1;
            while points == 0 && back > 1
                back = back - 1;
                row = Order(back, 1);
                col = Order(back, 2);
                window = newB(row - 1: row + 1, col - 1: col + 1);
                points = sum(window, 'all');
                if ((row == startRow && col == startCol))
                    break;
                end
            end
            currentCase = cases{4};
        end

        
        for i = 1 : 8
            if window(currentCase(i)) == 1
                [row, col, c] = Update(row, col, currentCase(i));
                currentCase = cases{c};
                break;
            end
        end
        
        if (row == startRow && col == startCol)
            break;
        end
    end
    
    Order( ~any(Order,2), : ) = [];  %delete all zero rows
end


%           1 | 4 | 7
%           2 | o | 8
%           3 | 6 | 9
function [newrow, newcol, c] = Update(row, col, currentcase)
    if currentcase == 1
        newrow = row - 1; newcol = col - 1; c = 1;
    elseif currentcase == 2
        newrow = row; newcol = col - 1; c = 8;
    elseif currentcase == 3
        newrow = row + 1; newcol = col - 1; c = 7;
    elseif currentcase == 4
        newrow = row - 1; newcol = col; c = 2;
    elseif currentcase == 6
        newrow = row + 1; newcol = col; c = 6;
    elseif currentcase == 7
        newrow = row - 1; newcol = col + 1; c = 3;
    elseif currentcase == 8
        newrow = row; newcol = col + 1; c = 4;
    else
        newrow = row + 1; newcol = col + 1; c = 5;
    end
end


