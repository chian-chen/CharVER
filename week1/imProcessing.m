% Pratice img processing

d = dir('../1/database/*.bmp');
path = '../1/database/';
k = numel(d);

im = double(imread(strcat(path ,d(1).name)));
DataBase = cell(1, k);

for i = 1 : k
  im = double(imread(strcat(path, d(i).name)));
  R = im(:, :, 1);
  G = im(:, :, 2);
  B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  Y(Y > 220) = 255;
  Y(Y <= 220) = 0;
  DataBase{i} = double(Y);  
end

figure; image(DataBase{1});
colormap(gray(256))
