% DataBase

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


B = DataBase{1};
B(B == 255) = 0;    B(B > 0) = 1;

% normalized location
[x, y] = find(B);
[m_new, n_new] = NormLocation(B, x, y);

% coordinate ratio
[m_ratio, n_ratio] = CoordiRatio(B, x, y);

% directions
Angle = Directions(B, 3);



