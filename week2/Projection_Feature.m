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

% Projection feature
kk = k + k;
Proj_features = zeros(kk, 10);

% divide array to 5 parts, in this dataset m == n, so just do the process once
[m, n] = size(DataBase{1});
s1 = floor(m/5 * 1); s2 = floor(m/5 * 2);
s3 = floor(m/5 * 3); s4 = floor(m/5 * 4);

for i = 1 : k
    a = DataBase{i};
    a(a == 255) = 0;
    a(a > 0) = 1;
    Proj_features(i, 1) = sum(sum(a(1:s1, :)));
    Proj_features(i, 2) = sum(sum(a(s1:s2, :)));
    Proj_features(i, 3) = sum(sum(a(s2:s3, :)));
    Proj_features(i, 4) = sum(sum(a(s3:s4, :)));
    Proj_features(i, 5) = sum(sum(a(s4:end, :)));
    Proj_features(i, 6) = sum(sum(a(:, 1:s1)));
    Proj_features(i, 7) = sum(sum(a(:, s1:s2)));
    Proj_features(i, 8) = sum(sum(a(:, s2:s3)));
    Proj_features(i, 9) = sum(sum(a(:, s3:s4)));
    Proj_features(i, 10) = sum(sum(a(:, s4:end)));
end

for i = k + 1 : kk
    a = TestCase{i - k};
    a(a == 255) = 0;
    a(a > 0) = 1;
    Proj_features(i, 1) = sum(sum(a(1:s1, :)));
    Proj_features(i, 2) = sum(sum(a(s1:s2, :)));
    Proj_features(i, 3) = sum(sum(a(s2:s3, :)));
    Proj_features(i, 4) = sum(sum(a(s3:s4, :)));
    Proj_features(i, 5) = sum(sum(a(s4:end, :)));
    Proj_features(i, 6) = sum(sum(a(:, 1:s1)));
    Proj_features(i, 7) = sum(sum(a(:, s1:s2)));
    Proj_features(i, 8) = sum(sum(a(:, s2:s3)));
    Proj_features(i, 9) = sum(sum(a(:, s3:s4)));
    Proj_features(i, 10) = sum(sum(a(:, s4:end)));
end

% Check the validity for features, set 90% zeros columns to all zeros

for i = 1:10
    value = sum(Proj_features(:, i) > 0);
    if(value/kk <= 0.1)
        Proj_features(:, i) = zeros(kk, 1);
    end
end

% data( :, ~any(data,1) ) = []; remove all zero columns
Proj_features(:, ~any(Proj_features, 1)) = [];

% SVM
addpath('/Users/chenqian/Desktop/CharVER/matlab');

% normalization
[m,N] = size(Proj_features);

for i = 1:N
    mf = mean(Proj_features(:, i));
    nrm = diag(1./std(Proj_features(:, i),1));
    Proj_features(:, i) = (Proj_features(:, i) - ones(m,1) * mf) * nrm;
end

sum_check = sum(Proj_features); 
sum_check(sum_check < 10e-10) = 0;  % should be all zeros

% train_set, test_set and labels
% 1: 本人  0: 非本人
one = ones(1, 25);
zero = zeros(1, 25);

train_features = [Proj_features(1:25, :); Proj_features(51:75, :)]; 
train_labels = [one zero].';
test_features = [Proj_features(26:50, :); Proj_features(76:100, :)]; 
test_labels = [one zero].';


% train_features = [Proj_features(1:5, :); Proj_features(51:55, :); Proj_features(6:15, :);
%     Proj_features(56:65, :); Proj_features(16:25, :); Proj_features(66:75, :)]; 
% 
% train_labels = [one zero one one zero zero one one zero zero].';
% 
% test_features = [Proj_features(26:30, :); Proj_features(76:80, :); Proj_features(31:40, :);
%     Proj_features(81:90, :); Proj_features(41:50, :); Proj_features(91:100, :)]; 
% 
% test_labels = [one zero one one zero zero one one zero zero].';


model = svmtrain(train_labels, train_features);
% test
[predicted, accuracy, d_values] = svmpredict(test_labels, test_features, model);
% predicted: the SVM output of the test data







