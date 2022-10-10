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
Erosion_feat = zeros(kk, 3);   % 1 for mean, 2 for std


for i = 1 : k
    B = DataBase{i};
    B(B == 255) = 0;
    B(B > 0) = 1;
    B1 = Erosion(B);
    B2 = Erosion(B1);
    B3 = Erosion(B2);
    B_sum = sum(B, 'all');
    B1_sum = sum(B1, 'all');
    B2_sum = sum(B2, 'all');
    B3_sum = sum(B3, 'all');
    Erosion_feat(i,1) = B1_sum / B_sum;
    Erosion_feat(i,2) = B2_sum / B_sum;
    Erosion_feat(i,3) = B3_sum / B_sum;
end

for i = k+1 : kk
    B = TestCase{i - k};
    B(B == 255) = 0;
    B(B > 0) = 1;
    B1 = Erosion(B);
    B2 = Erosion(B1);
    B3 = Erosion(B2);
    B_sum = sum(B, 'all');
    B1_sum = sum(B1, 'all');
    B2_sum = sum(B2, 'all');
    B3_sum = sum(B3, 'all');
    Erosion_feat(i,1) = B1_sum / B_sum;
    Erosion_feat(i,2) = B2_sum / B_sum;
    Erosion_feat(i,3) = B3_sum / B_sum;
end

% SVM
addpath('/Users/chenqian/Desktop/CharVER/matlab');

% normalization
[m,N] = size(Erosion_feat);

for i = 1:N
    mf = mean(Erosion_feat(:, i));
    nrm = diag(1./std(Erosion_feat(:, i),1));
    Erosion_feat(:, i) = (Erosion_feat(:, i) - ones(m,1) * mf) * nrm;
end

sum_check = sum(Erosion_feat); 
sum_check(sum_check < 10e-10) = 0;  % should be all zeros

% train_set, test_set and labels
% 1: 本人  0: 非本人
one = ones(1, 25);
zero = zeros(1, 25);

train_features = [Erosion_feat(1:25, :); Erosion_feat(51:75, :)]; 
train_labels = [one zero].';
test_features = [Erosion_feat(26:50, :); Erosion_feat(76:100, :)]; 
test_labels = [one zero].';

model = svmtrain(train_labels, train_features);
% test
[predicted, accuracy, d_values] = svmpredict(test_labels, test_features, model);
% predicted: the SVM output of the test data



% Assume the imput M is a 2-D matrix
% ignore the edge case
function A = Erosion(M)
    M_new = M;
    [row,col] = size(M);
    for i = 2:row - 1
        for j =2:col - 1
            M_new(i, j) = M(i, j) && M(i + 1, j) && M(i - 1, j) && M(i, j + 1) && M(i, j - 1);
        end
    end
    A = M_new;
end


