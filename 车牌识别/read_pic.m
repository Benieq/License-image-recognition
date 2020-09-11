%%
clc;
clear;
close all;
set(0,'DefaultFigureWindowStyle','docked')


%% 自动弹出提示框读取图像

% [FileName,PathName,FilterIndex] = uigetfile(FilterSpec,DialogTitle,DefaultName)
% FileName：返回的文件名
% PathName：返回的文件的路径名
% FilterIndex：选择的文件类型
% FilterSpec：文件类型设置
% DialogTitle：打开对话框的标题
% DefaultName：默认指向的文件名
[filename filepath] = uigetfile('.jpg', '输入一个需要识别出车牌的图像');   %自动读入图像

file = strcat(filepath, filename);   %strcat函数：连接字符串；把filepath的字符串与filename的连接，即路径/文件名
img = imread(file);
figure;
imshow(img);
title('车牌图像');