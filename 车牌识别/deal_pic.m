%% 对车牌图像作图像预处理
plate_img = imread('车牌图像.jpg');

%% 转换成灰度图像
plate_img1 = rgb2gray(plate_img);    % RGB图像转灰度图像
figure;
subplot(1, 2, 1);
imshow(plate_img1);
title('灰度图像');
subplot(1, 2, 2);
imhist(plate_img1);
title('灰度处理后的灰度直方图');

%% 直方图均衡化
plate_img2 = histeq(plate_img1);
figure('name', '直方图均衡化');
subplot(1,2,1);
imshow(plate_img2);
title('直方图均衡化的图像');
subplot(1,2,2);
imhist(plate_img2);
title('直方图');

%% 二值化处理
plate_img3 = im2bw(plate_img2, 0.76);
figure('name', '二值化处理');
imshow(plate_img3);
title('车牌二值图像');

%% 中值滤波
plate_img4 = medfilt2(plate_img3);
figure('name', '中值滤波');
imshow(plate_img4);
title('中值滤波后的图像');

%% 进行字符识别
plate_img5 = my_imsplit(plate_img4);
[m, n] = size(plate_img5);

s = sum(plate_img5);    %sum(x)就是竖向相加，求每列的和，结果是行向量;
j = 1;
k1 = 1;
k2 = 1;
while j ~= n
    while s(j) == 0
        j = j + 1;
    end
    k1 = j;
    while s(j) ~= 0 && j <= n-1
        j = j + 1;
    end
    k2 = j + 1;
    if k2 - k1 > round(n / 6.5)
        [val, num] = min(sum(plate_img5(:, [k1+5:k2-5])));
        plate_img5(:, k1+num+5) = 0;
    end
end

y1 = 10;
y2 = 0.25;
flag = 0;
word1 = [];
while flag == 0
    [m, n] = size(plate_img5);
    left = 1;
    width = 0;
    while sum(plate_img5(:, width+1)) ~= 0
        width = width + 1;
    end
    if width < y1
        plate_img5(:, [1:width]) = 0;
        plate_img5 = my_imsplit(plate_img5);
    else
        temp = my_imsplit(imcrop(plate_img5, [1,1,width,m]));
        [m, n] = size(temp);
        all = sum(sum(temp));
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
        if two_thirds/all > y2
            flag = 1;
            word1 = temp;
        end
        plate_img5(:, [1:width]) = 0;
        plate_img5 = my_imsplit(plate_img5);
    end
end

figure;
subplot(2,4,1), imshow(plate_img5);

 % 分割出第二个字符
 [word2,plate_img5]=getword(plate_img5);
 subplot(2,4,2), imshow(plate_img5);
 % 分割出第三个字符
 [word3,plate_img5]=getword(plate_img5);
 subplot(2,4,3), imshow(plate_img5);
 % 分割出第四个字符
 [word4,plate_img5]=getword(plate_img5);
 subplot(2,4,4), imshow(plate_img5);
 % 分割出第五个字符
 [word5,plate_img5]=getword(plate_img5);
 subplot(2,3,4), imshow(plate_img5);
 % 分割出第六个字符
 [word6,plate_img5]=getword(plate_img5);
 subplot(2,3,5), imshow(plate_img5);
 % 分割出第七个字符
 [word7,plate_img5]=getword(plate_img5);
 subplot(2,3,6), imshow(plate_img5);

 figure;
 subplot(5,7,1),imshow(word1),title('1');
 subplot(5,7,2),imshow(word2),title('2');
 subplot(5,7,3),imshow(word3),title('3');
 subplot(5,7,4),imshow(word4),title('4');
 subplot(5,7,5),imshow(word5),title('5');
 subplot(5,7,6),imshow(word6),title('6');
 subplot(5,7,7),imshow(word7),title('7');

 word1=imresize(word1,[40 20]);%imresize对图像做缩放处理，常用调用格式为：B=imresize(A,ntimes,method)；其中method可选nearest,bilinear（双线性）,bicubic,box,lanczors2,lanczors3等
 word2=imresize(word2,[40 20]);
 word3=imresize(word3,[40 20]);
 word4=imresize(word4,[40 20]);
 word5=imresize(word5,[40 20]);
 word6=imresize(word6,[40 20]);
 word7=imresize(word7,[40 20]);

 subplot(5,7,15),imshow(word1),title('11');
 subplot(5,7,16),imshow(word2),title('22');
 subplot(5,7,17),imshow(word3),title('33');
 subplot(5,7,18),imshow(word4),title('44');
 subplot(5,7,19),imshow(word5),title('55');
 subplot(5,7,20),imshow(word6),title('66');
 subplot(5,7,21),imshow(word7),title('77');
 
 imwrite(word1,'1.jpg'); % 创建七位车牌字符图像
 imwrite(word2,'2.jpg');
 imwrite(word3,'3.jpg');
 imwrite(word4,'4.jpg');
 imwrite(word5,'5.jpg');
 imwrite(word6,'6.jpg');
 imwrite(word7,'7.jpg');
 
 %% 进行字符识别
 liccode=char(['0':'9' 'A':'Z' '京辽陕苏鲁浙']);
 % 编号：0-9分别为 1-10;A-Z分别为 11-36;
 % 京  津  沪  渝  港  澳  吉  辽  鲁  豫  冀  鄂  湘  晋  青  皖  苏
 % 赣  浙  闽  粤  琼  台  陕  甘  云  川  贵  黑  藏  蒙  桂  新  宁
 % 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 
 % 60 61 62 63 64 65 66 67 68 69 70
 subBw2 = zeros(40, 20);
 num = 1;   
 % 车牌位数
 for i = 1:7
    ii = int2str(i);    % 将整型数据转换为字符串型数据
    word = imread([ii,'.jpg']); % 读取之前分割出的字符的图片
    segBw2 = imresize(word, [40,20], 'nearest');    % 调整图片的大小
    segBw2 = im2bw(segBw2, 0.5);    % 图像二值化
    if i == 1   % 字符第一位为汉字，定位汉字所在字段
        kMin = 37;
        kMax = 42;
    elseif i == 2   % 第二位为英文字母，定位字母所在字段
        kMin = 11;
        kMax = 36;
    elseif i >= 3   % 第三位开始就是数字了，定位数字所在字段
        kMin = 1;
        kMax = 36;
    end
    
    l = 1;
    for k = kMin : kMax
        fname = strcat('namebook/',liccode(k),'.jpg');  % 根据字符库找到图片模板
        samBw2 = imread(fname); % 读取模板库中的图片
        samBw2 = im2bw(samBw2, 0.5);    % 图像二值化
        
        % 将待识别图片与模板图片做差
        for i1 = 1:40
            for j1 = 1:20
                subBw2(i1, j1) = segBw2(i1, j1) - samBw2(i1 ,j1);
            end
        end
        
        % 统计两幅图片不同点的个数，并保存下来
        Dmax = 0;
        for i2 = 1:40
            for j2 = 1:20
                if subBw2(i2, j2) ~= 0
                    Dmax = Dmax + 1;
                end
            end
        end
        error(l) = Dmax;
        l = l + 1;
    end
    
    % 找到图片差别最少的图像
    errorMin = min(error);
    findc = find(error == errorMin);

    % 根据字库，对应到识别的字符
    Code(num*2 - 1) = liccode(findc(1) + kMin - 1);
    Code(num*2) = ' ';
    num = num + 1;
    
    
 end
 
 % 显示识别结果
 disp(Code);
 msgbox(Code,'识别出的车牌号');

