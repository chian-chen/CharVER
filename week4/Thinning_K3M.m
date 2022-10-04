% DataBase, TestCase

d = dir('../1/database/*.bmp');
path = '../1/database/';

t = dir('../1/testcase/*.bmp');
path_t = '../1/testcase/';

k = numel(d);

DataBase = cell(1, k);
TestCase = cell(1, k);

for i = 1 : k
  im = double(imread(strcat(path, d(i).name)));
  R = im(:, :, 1);
  G = im(:, :, 2);
  B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  Y(Y > 220) = 255;
  DataBase{i} = double(Y);
  im = double(imread(strcat(path_t, t(i).name)));
  R = im(:, :, 1);
  G = im(:, :, 2);
  B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  Y(Y > 220) = 255;
  TestCase{i} = double(Y);
end

% show one sample of both sets


B = DataBase{1};
B(B == 255) = 0;
B(B > 0) = 1;
ChangePoint = 1;


while ChangePoint ~= 0

% STEP0 Find Edge

NotEdge = conv2(B, [0 1 0; 1 1 1; 0 1 0], 'same');
NotEdge(NotEdge<5) = 0;
NotEdge = NotEdge/5;

Edge = B - NotEdge;
[x, y] = find(Edge);

figure; image(B*255);
colormap(gray(256))

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






