% SVM Example 2 for LIBSVM 

% 輸入 LIBSVM (Matlab version) 所在的資料夾
addpath('/Users/chenqian/Desktop/CharVER/week1/matlab');

% training data and labels
features_a=[ 25.031, 25.143, 24.996, 24.997, 25.066, 25.093, 24.999, 25.037, 25.277, 25.192, 25.038, 25.125, 25.117, 24.943, 25.027, 24.996;
            121.503,121.439,121.517,121.545,121.586,121.533,121.643,121.451,121.569,121.545,121.564,121.493,121.639,121.540,121.525,121.463]';
% first column: the first feature  (北緯度)
% second column: the second feature (東經度)
label_a = [1,2,2,1,1,1,2,2,2,1,1,1,2,2,1,2]';
% 1: 台北市, 2: 新北市

% test data and labels
features_b=[ 25.046, 24.995, 25.176, 25.068, 25.111;
            121.518,121.485,121.436,121.654,121.560]';
label_b = [1,2,2,2,1]';

% scaling
[m,N] = size(features_a);
[m1,N] = size(features_b);
mf = mean(features_a);
nrm = diag(1./std(features_a,1));
features_1 = (features_a-ones(m,1)*mf)*nrm;
features_2 = (features_b-ones(m1,1)*mf)*nrm;
% SVM
model = svmtrain(label_a, features_1, '-c 1 -g 0.07');
% test
[predicted, accuracy, d_values] = svmpredict(label_b, features_2, model);
% predicted: the SVM output of the test data

