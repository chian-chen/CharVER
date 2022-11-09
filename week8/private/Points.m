function [EndPoints, TurnPoints] = Points(B)
    NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
    NotEdge(NotEdge < 5) = 0;   NotEdge = NotEdge / 5;

    Edge = B - NotEdge;
    
    % ===== DEBUG  check Edge =====
%     figure; image(Edge * 255);
%     colormap(gray(256))

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
    
        % ===== DEBUG  check update in each loop =====
%         figure; image(Edge * 255);
%         colormap(gray(256))
    
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
    
    % ====== DEBUG Check Turn and End Point look normal ======
%     B_Turn = zeros(size(Edge));
%     B_End = zeros(size(Edge));
% 
%     for i = 1:TurnPointIndex - 1
%         B_Turn(TurnPoints(i,1), TurnPoints(i,2)) = 1;
%     end
%     for i = 1:EndPointIndex - 1
%         B_End(EndPoints(i,1), EndPoints(i,2)) = 1;
%     end
% 
%     figure; image(B_Turn * 255);
%     colormap(gray(256))
%     figure; image(B_End * 255);
%     colormap(gray(256))

end