function [EndPoints, TurnPoints] = Points(B)
    NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
    NotEdge(NotEdge < 5) = 0;   NotEdge = NotEdge / 5;

    Edge = B - NotEdge;

    cases = GenerateCases();
    OrderList = cell(1, 10);
    sumArea = 0;

    points = sum(Edge, 'all');
    regionNum = 1;

    while points > 0
        [row, col] = find(Edge);
        [Edge, Order, Area] = Trace(Edge, row(1), col(1), cases);

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
function cases = GenerateCases()
    cases = cell(1, 7);
    cases{1} = [6 3 2 1 4 7 8 9];
    for i = 2 : 8
        a = cases{i - 1};
        cases{i} = [a(2:end) a(1)];
    end
end
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