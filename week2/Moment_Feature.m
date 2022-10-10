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
Moment_feat = zeros(kk, 9);   % 1 for mean, 2 for std


for i = 1 : k
    B = DataBase{i};
    B(B == 255) = 0;
    B(B > 0) = 1;
    v10 = Moment(B, 1, 0);     v01 = Moment(B, 0, 1);
    v11 = Moment(B, 1, 1);     v20 = Moment(B, 2, 0);
    v02 = Moment(B, 0, 2);
    v30 = Moment(B, 3, 0);     v03 = Moment(B, 0, 3);
    v21 = Moment(B, 2, 1);     v12 = Moment(B, 1, 2);
    
    Moment_feat(i, 1) = v10; Moment_feat(i, 2) = v01; Moment_feat(i, 3) = v11;
    Moment_feat(i, 4) = v20; Moment_feat(i, 5) = v02; Moment_feat(i, 6) = v30;
    Moment_feat(i, 7) = v03; Moment_feat(i, 8) = v21; Moment_feat(i, 9) = v12;
end


for i = k+1 : kk
    B = TestCase{i - k};
    B(B == 255) = 0;
    B(B > 0) = 1;
    v10 = Moment(B, 1, 0);     v01 = Moment(B, 0, 1);
    v11 = Moment(B, 1, 1);     v20 = Moment(B, 2, 0);
    v02 = Moment(B, 0, 2);
    v30 = Moment(B, 3, 0);     v03 = Moment(B, 0, 3);
    v21 = Moment(B, 2, 1);     v12 = Moment(B, 1, 2);
    
    Moment_feat(i, 1) = v10; Moment_feat(i, 2) = v01; Moment_feat(i, 3) = v11;
    Moment_feat(i, 4) = v20; Moment_feat(i, 5) = v02; Moment_feat(i, 6) = v30;
    Moment_feat(i, 7) = v03; Moment_feat(i, 8) = v21; Moment_feat(i, 9) = v12;
end


% SVM
addpath('/Users/chenqian/Desktop/CharVER/matlab');

% normalization
[m,N] = size(Moment_feat);

for i = 1:N
    mf = mean(Moment_feat(:, i));
    nrm = diag(1./std(Moment_feat(:, i),1));
    Moment_feat(:, i) = (Moment_feat(:, i) - ones(m,1) * mf) * nrm;
end

sum_check = sum(Moment_feat); 
sum_check(sum_check < 10e-10) = 0;  % should be all zeros

% train_set, test_set and labels
% 1: 本人  0: 非本人
one = ones(1, 25);
zero = zeros(1, 25);

train_features = [Moment_feat(1:25, :); Moment_feat(51:75, :)]; 
train_labels = [one zero].';
test_features = [Moment_feat(26:50, :); Moment_feat(76:100, :)]; 
test_labels = [one zero].';

model = svmtrain(train_labels, train_features);
% test
[predicted, accuracy, d_values] = svmpredict(test_labels, test_features, model);
% predicted: the SVM output of the test data



% Assume the imput M is a 2-D matrix
% ignore the edge case
function A = Moment(M, a, b)

    [m, n] = size(M);   sumM = sum(M, 'all');
    m_0 = 1 : m;
    m_0 = sum(sum(M, 2).' .* m_0)./sumM;
    n_0 = 1 : n;
    n_0 = sum(sum(M) .* n_0)./sumM;
    
    
    moment = 0;
    for i = 1 : m
        for j = 1 : n
            moment = (i - m_0).^a * (j - n_0).^b * M(i, j) + moment;
        end
    end
    
    moment = moment/sumM;
    
    if a == 1 && b == 0
        moment = m_0;
    end
    if a == 0 && b == 1
        moment = n_0;
    end
    A = moment;
end


