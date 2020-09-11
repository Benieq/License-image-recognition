%旨在定位图片中的车牌，并将车牌图片保存在本地

%% 灰度处理
img1 = rgb2gray(img);    % RGB图像转灰度图像
figure;
subplot(1, 2, 1);
imshow(img1);
title('灰度图像');
subplot(1, 2, 2);
imhist(img1);
title('灰度处理后的灰度直方图');

%% 直方图均衡化
img2 = histeq(img1);    %直方图均衡化
figure;
subplot(1, 2, 1);
imshow(img2);
title('灰度图像');
subplot(1, 2, 2);
imhist(img2);
title('灰度处理后的灰度直方图');

%% 中值滤波
img3 = medfilt2(img2);
figure;
imshow(img3);
title('中值滤波');

%% 边缘提取
% img4 = edge(img3, 'roberts', 0.15, 'both');
% figure('name','边缘检测');
% imshow(img4);
% title('roberts算子边缘检测');

img4 = edge(img3, 'sobel', 0.2);
figure('name','边缘检测');
imshow(img4);
title('sobel算子边缘检测');

%% 图像腐蚀
se=[1;1;1];
img5 = imerode(img4, se);
figure('name','图像腐蚀');
imshow(img5);
title('图像腐蚀后的图像');

%% 平滑图像，图像膨胀
se = strel('rectangle', [20, 20]);
img6 = imclose(img5, se);
figure('name','平滑处理');
imshow(img6);
title('平滑图像的轮廓');

%% 从图像中删除所有少于1000像素8邻接
img7 = bwareaopen(img6, 1000);
figure('name', '移除小对象');
imshow(img7);
title('从图像中移除小对象');

%% 切割出图像
[y, x, z] = size(img7);
img8 = double(img7);    % 转成双精度浮点型

% 车牌的蓝色区域
% Y方向
blue_Y = zeros(y, 1);
for i = 1:y
    for j = 1:x
        if(img8(i, j) == 1) % 判断车牌位置区域
            blue_Y(i, 1) = blue_Y(i, 1) + 1;    % 像素点统计
        end
    end
end

% 找到Y坐标的最小值
img_Y1 = 1;
while (blue_Y(img_Y1) < 5) && (img_Y1 < y)
    img_Y1 = img_Y1 + 1;
end

% 找到Y坐标的最大值
img_Y2 = y;
while (blue_Y(img_Y2) < 5) && (img_Y2 > img_Y1)
    img_Y2 = img_Y2 - 1;
end

% x方向
blue_X = zeros(1, x);
for j = 1:x
    for i = 1:y
        if(img8(i, j) == 1) % 判断车牌位置区域
            blue_X(1, j) = blue_X(1, j) + 1;
        end
    end
end

% 找到x坐标的最小值
img_X1 = 1;
while (blue_X(1, img_X1) < 5) && (img_X1 < x)
    img_X1 = img_X1 + 1;
end

% 找到x坐标的最小值
img_X2 = x;
while (blue_X(1, img_X2) < 5) && (img_X2 > img_X1)
    img_X2 = img_X2 - 1;
end

% 对图像进行裁剪
img9 = img(img_Y1:img_Y2, img_X1:img_X2, :);
figure('name', '定位剪切图像');
imshow(img9);
title('定位剪切后的彩色车牌图像')


% 保存提取出来的车牌图像
imwrite(img9, '车牌图像.jpg');

