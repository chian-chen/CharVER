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

figure; image(DataBase{1});
colormap(gray(256))
figure; image(TestCase{1});
colormap(gray(256))

% Intensity

kk = k + k;
intensity_feat = zeros(kk, 2);   % 1 for mean, 2 for std

for i = 1 : k
    a = DataBase{i};
    a(a == 255) = 0;
    w = sum(sum(a > 0));
    Y_mean = sum(sum(a))/w;
    Y_std = sqrt( sum(sum((a - Y_mean).^2)) / w );
    intensity_feat(i, 1) = Y_mean;
    intensity_feat(i, 2) = Y_std;
end

for i = k+1 : kk
    a = TestCase{i - k};
    a(a == 255) = 0;
    w = sum(sum(a>0));
    Y_mean = sum(sum(a))/w;
    Y_std = sqrt( sum(sum((a - Y_mean).^2)) / w );
    intensity_feat(i, 1) = Y_mean;
    intensity_feat(i, 2) = Y_std;
end


% SVM
addpath('/Users/chenqian/Desktop/CharVER/week1/matlab');

% normalization
[m,N] = size(intensity_feat);

for i = 1:N
    mf = mean(intensity_feat(:, i));
    nrm = diag(1./std(intensity_feat(:, i),1));
    intensity_feat(:, i) = (intensity_feat(:, i) - ones(m,1) * mf) * nrm;
end

sum_check = sum(intensity_feat); 
sum_check(sum_check < 10e-10) = 0;  % should be all zeros

% train_set, test_set and labels
% 1: 本人  0: 非本人
one = ones(1, 25);
zero = zeros(1, 25);

train_features = [intensity_feat(1:25, :); intensity_feat(51:75, :)]; 
train_labels = [one zero].';
test_features = [intensity_feat(26:50, :); intensity_feat(76:100, :)]; 
test_labels = [one zero].';

model = svmtrain(train_labels, train_features);
% test
[predicted, accuracy, d_values] = svmpredict(test_labels, test_features, model);
% predicted: the SVM output of the test data





