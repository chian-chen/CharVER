function Features = Width_Feature(B)
    
    Origin = B;
    ChangePoint = 1;


    while ChangePoint ~= 0
    % STEP0 Find Edge

        NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
        NotEdge(NotEdge<5) = 0;
        NotEdge = NotEdge/5;

        Edge = B - NotEdge;
        [x, y] = find(Edge);

%         figure; image(B*255);
%         colormap(gray(256))

        ChangePoint = 0;

        % STEP1

        for i = 1 : length(x)
            z = ContinueNeighbor(B, x(i), y(i));
            if(z == 3)
                B(x(i), y(i)) = 0;
                ChangePoint = ChangePoint + 1;
            end
        end

        % STEP2

        for i = 1 : length(x)
            z = ContinueNeighbor(B, x(i), y(i));
            if(z == 3 || z == 4)
                B(x(i), y(i)) = 0;
                ChangePoint = ChangePoint + 1;
            end
        end

        % STEP3

        for i = 1 : length(x)
            z = ContinueNeighbor(B, x(i), y(i));
            if(z == 3 || z == 4 || z == 5)
                B(x(i), y(i)) = 0;
                ChangePoint = ChangePoint + 1;
            end
        end

        % STEP4

        for i = 1 : length(x)
            z = ContinueNeighbor(B, x(i), y(i));
            if(z == 3 || z == 4 || z == 5 || z == 6)
                B(x(i), y(i)) = 0;
                ChangePoint = ChangePoint + 1;
            end
        end

        % STEP5

        for i = 1 : length(x)
            z = ContinueNeighbor(B, x(i), y(i));
            if(z == 3 || z == 4 || z == 5 || z == 6 || z == 7)
                B(x(i), y(i)) = 0;
                ChangePoint = ChangePoint + 1;
            end
        end

        % STEP6
    end
    
    
    num = sum(Origin .* B, 'all');
    time = 0;
    mor = [];

    while num > 0
        Origin = erosion(Origin);
        time = time + 1;
        update = sum(Origin .* B, 'all');
        if update ~= num
            mor = [mor time];
        end
        num = update;
    end
    width = mean(mor) * 2;
    width_variation =  sqrt(mean((mor - mean(mor)).^2)) * 2;
    
    Features = [width width_variation];
end


% return -1 if the region is not continue
function A = ContinueNeighbor(B, x, y)
    w = B(x-1:x+1, y-1:y+1);
    list = [w(1,1) w(1,2) w(1,3) w(2,3) w(3,3) w(3,2) w(3,1) w(2,1)];
    dot = sum(list);

    list = [list list];
    current = 0;
    conti = 0;
    for i = 1:16
        if(list(i) == 1)
            current = current + 1;
        else
            current = 0;
        end
        conti = max(conti, current);
    end

    if(dot == conti)
        A = dot;
    else
        A = -1;
    end
end


function A = erosion(M)
    M_new = M;
    [row,col] = size(M);
    for i = 2:row - 1
        for j =2:col - 1
            M_new(i, j) = M(i, j) && M(i + 1, j) && M(i - 1, j) && M(i, j + 1) && M(i, j - 1);
        end
    end
    A = M_new;
end

