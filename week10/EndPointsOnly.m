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
  R = im(:, :, 1); G = im(:, :, 2); B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  
  Y(Y > 220) = 255;
  Y(1, :) = 255; Y(end, :) = 255;
  Y(:, 1) = 255; Y(:, end) = 255;
  
  DataBase{i} = double(Y);
  
  im = double(imread(strcat(path_t, t(i).name)));
  R = im(:, :, 1); G = im(:, :, 2); B = im(:, :, 3);
  Y = 0.299 .* R + 0.587 .* G + 0.114 .* B;
  
  Y(Y > 220) = 255;
  Y(1, :) = 255; Y(end, :) = 255;
  Y(:, 1) = 255; Y(:, end) = 255;
  
  TestCase{i} = double(Y);
end


% Projection feature
kk = k + k;
Features = zeros(kk, 30);   


for i = 1 : k
   
    B = DataBase{i};
    B(B < 255) = 1;
    B(B == 255) = 0;
    
    % Endpoint
    Features(i, 1:30) = EndPoint_Feature(B);

end

for i = k+1 : kk
    
    B = TestCase{i - k};
    B(B < 255) = 1;
    B(B == 255) = 0;
   
    % Endpoint
    Features(i, 1:30) = EndPoint_Feature(B);
end


% Check the validity for features, set 90% zeros columns to all zeros

for i = 1:30
    value = sum(Features(:, i) > 0);
    if(value/kk <= 0.1)
        Features(:, i) = zeros(kk, 1);
    end
end

% data( :, ~any(data,1) ) = []; remove all zero columns
Features(:, ~any(Features, 1)) = [];

% SVM
addpath('/Users/chenqian/Desktop/CharVER/matlab');

% normalization
[m,N] = size(Features);

for i = 1:N
    mf = mean(Features(:, i));
    nrm = diag(1./std(Features(:, i),1));
    Features(:, i) = (Features(:, i) - ones(m,1) * mf) * nrm;
end

% sifted by K value

x1 = 1:1:m/2;
xo = m/2+1:1:m;

for i = 1:N
    mean1 = mean(Features(x1, i));
    meano = mean(Features(xo, i));
    var1 = sqrt(var(Features(x1, i)));
    varo = sqrt(var(Features(xo, i)));
    if abs(mean1 - meano)/sqrt(var1 * varo) < 0.3
        Features(:, i) = zeros(kk, 1);
    end
end
Features(:, ~any(Features, 1)) = [];


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


