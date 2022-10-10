% DataBase, TestCase

d = dir('../2/database/*.bmp');
path = '../2/database/';

t = dir('../2/testcase/*.bmp');
path_t = '../2/testcase/';

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

a = Thinning_K3M(DataBase{1});
b = Thinning_K3M(DataBase{2});
c = Thinning_K3M(DataBase{3});

aa = Thinning_K3M(TestCase{1});
bb = Thinning_K3M(TestCase{2});
cc = Thinning_K3M(TestCase{3});