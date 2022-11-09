Ref = cell(1, 4);
Ref{1} = double(imread('../1_30pt/song.bmp'));
Ref{2} = double(imread('../1_30pt/black.bmp'));
Ref{3} = double(imread('../1_30pt/kai.bmp'));
Ref{4} = double(imread('../1_30pt/wei.bmp'));
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
  Y(Y <= 220) = 1;
  Y(Y > 220) = 0;
  DataBase{i} = double(Y);
end

for i = 1:4
    im = Ref{i};
    R = im(:, :, 1);
    G = im(:, :, 2);
    B = im(:, :, 3);
    Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
    Y(Y > 220) = 255;
    Y(Y <= 220) = 1;
    Y(Y == 255) = 0;
    Ref{i} = Y;
    figure;     image(Y*255);   colormap(gray(256))
end


B = DataBase{1};
figure;
image(B*255);
colormap(gray(256))

[EndPoints, TurnPoints] = Points(B);


Difference1 = Difference(B, Ref{1}, EndPoints);
D1 = sum(Difference1);
Difference2 = Difference(B, Ref{2}, EndPoints);
D2 = sum(Difference2);
Difference3 = Difference(B, Ref{3}, EndPoints);
D3 = sum(Difference3);
Difference4 = Difference(B, Ref{4}, EndPoints);
D4 = sum(Difference4);












