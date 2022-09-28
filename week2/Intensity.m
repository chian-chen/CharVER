% DataBase, TestCase

d = dir('./1/database/*.bmp');
path = './1/database/';

t = dir('./1/testcase/*.bmp');
path_t = './1/testcase/';

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

figure; image(DataBase{1});
colormap(gray(256))
figure; image(TestCase{1});
colormap(gray(256))

% Intensity

kk = k + k;
Proj_features = zeros(kk, 2);   % 1 for mean, 2 for std



for i = 1 : k
    a = DataBase{i};
    a(a == 255) = 0;
    w = sum(sum(a>0));
    Y_mean = sum(sum(a))/w;
    Y_std = sqrt( sum(sum((a - Y_mean).^2)) / w );
    Proj_features(i, 1) = Y_mean;
    Proj_features(i, 2) = Y_std;
end









