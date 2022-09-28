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

% Projection feature
kk = k + k;
Features = zeros(kk, 24);   

% divide array to 5 parts, in this dataset m == n, so just do the process once
[m, n] = size(DataBase{1});
s1 = floor(m/5 * 1); s2 = floor(m/5 * 2);
s3 = floor(m/5 * 3); s4 = floor(m/5 * 4);

for i = 1 : k
    B = DataBase{i};
    B(B == 255) = 0;
    
    % Intensity
    w = sum(sum(B > 0));
    Y_mean = sum(sum(B))/w;
    Y_std = sqrt( sum(sum((B - Y_mean).^2)) / w );
    Features(i, 23) = Y_mean;
    Features(i, 24) = Y_std;
    B(B > 0) = 1;
    
    % Projection
    Features(i, 1) = sum(sum(B(1:s1, :)));
    Features(i, 2) = sum(sum(B(s1:s2, :)));
    Features(i, 3) = sum(sum(B(s2:s3, :)));
    Features(i, 4) = sum(sum(B(s3:s4, :)));
    Features(i, 5) = sum(sum(B(s4:end, :)));
    Features(i, 6) = sum(sum(B(:, 1:s1)));
    Features(i, 7) = sum(sum(B(:, s1:s2)));
    Features(i, 8) = sum(sum(B(:, s2:s3)));
    Features(i, 9) = sum(sum(B(:, s3:s4)));
    Features(i, 10) = sum(sum(B(:, s4:end)));
    
    % Erosion
    B1 = Erosion(B);
    B2 = Erosion(B1);
    B3 = Erosion(B2);
    B_sum = sum(B, 'all');
    B1_sum = sum(B1, 'all');
    B2_sum = sum(B2, 'all');
    B3_sum = sum(B3, 'all');
    Features(i,11) = B1_sum / B_sum;
    Features(i,12) = B2_sum / B_sum;
    Features(i,13) = B3_sum / B_sum;
    
    % Moment
    v10 = Moment(B, 1, 0); v01 = Moment(B, 0, 1); v11 = Moment(B, 1, 1);
    v20 = Moment(B, 2, 0); v02 = Moment(B, 0, 2); v30 = Moment(B, 3, 0);
    v03 = Moment(B, 0, 3); v21 = Moment(B, 2, 1); v12 = Moment(B, 1, 2);
    Features(i, 14) = v10; Features(i, 15) = v01; Features(i, 16) = v11;
    Features(i, 17) = v20; Features(i, 18) = v02; Features(i, 19) = v30;
    Features(i, 20) = v03; Features(i, 21) = v21; Features(i, 22) = v12;
end

for i = k+1 : kk
    B = TestCase{i - k};
    B(B == 255) = 0;
    
    % Intensity
    w = sum(sum(B > 0));
    Y_mean = sum(sum(B))/w;
    Y_std = sqrt( sum(sum((B - Y_mean).^2)) / w );
    Features(i, 23) = Y_mean;
    Features(i, 24) = Y_std;
    B(B > 0) = 1;
    
    % Projection
    Features(i, 1) = sum(sum(B(1:s1, :)));
    Features(i, 2) = sum(sum(B(s1:s2, :)));
    Features(i, 3) = sum(sum(B(s2:s3, :)));
    Features(i, 4) = sum(sum(B(s3:s4, :)));
    Features(i, 5) = sum(sum(B(s4:end, :)));
    Features(i, 6) = sum(sum(B(:, 1:s1)));
    Features(i, 7) = sum(sum(B(:, s1:s2)));
    Features(i, 8) = sum(sum(B(:, s2:s3)));
    Features(i, 9) = sum(sum(B(:, s3:s4)));
    Features(i, 10) = sum(sum(B(:, s4:end)));
    
    % Erosion
    B1 = Erosion(B);
    B2 = Erosion(B1);
    B3 = Erosion(B2);
    B_sum = sum(B, 'all');
    B1_sum = sum(B1, 'all');
    B2_sum = sum(B2, 'all');
    B3_sum = sum(B3, 'all');
    Features(i,11) = B1_sum / B_sum;
    Features(i,12) = B2_sum / B_sum;
    Features(i,13) = B3_sum / B_sum;
    
    % Moment
    v10 = Moment(B, 1, 0); v01 = Moment(B, 0, 1); v11 = Moment(B, 1, 1);
    v20 = Moment(B, 2, 0); v02 = Moment(B, 0, 2); v30 = Moment(B, 3, 0);
    v03 = Moment(B, 0, 3); v21 = Moment(B, 2, 1); v12 = Moment(B, 1, 2);
    Features(i, 14) = v10; Features(i, 15) = v01; Features(i, 16) = v11;
    Features(i, 17) = v20; Features(i, 18) = v02; Features(i, 19) = v30;
    Features(i, 20) = v03; Features(i, 21) = v21; Features(i, 22) = v12;
end


% Check the validity for features, set 90% zeros columns to all zeros

for i = 1:10
    value = sum(Features(:, i) > 0);
    if(value/kk <= 0.1)
        Features(:, i) = zeros(kk, 1);
    end
end

% data( :, ~any(data,1) ) = []; remove all zero columns
Features(:, ~any(Features, 1)) = [];

% SVM
addpath('/Users/chenqian/Desktop/CharVER/week1/matlab');

% normalization
[m,N] = size(Features);

for i = 1:N
    mf = mean(Features(:, i));
    nrm = diag(1./std(Features(:, i),1));
    Features(:, i) = (Features(:, i) - ones(m,1) * mf) * nrm;
end

sum_check = sum(Features); 
sum_check(sum_check < 10e-10) = 0;  % should be all zeros

% train_set, test_set and labels
% 1: 本人  0: 非本人
one = ones(1, 5);
zero = zeros(1, 5);

train_features = [Features(1:5, :); Features(51:55, :); Features(6:15, :);
    Features(56:65, :); Features(16:25, :); Features(66:75, :)]; 

train_labels = [one zero one one zero zero one one zero zero].';

test_features = [Features(26:30, :); Features(76:80, :); Features(31:40, :);
    Features(81:90, :); Features(41:50, :); Features(91:100, :)]; 

test_labels = [one zero one one zero zero one one zero zero].';


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



