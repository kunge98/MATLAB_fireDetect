clear ,clc ,close all
%% 训练得到火灾图库的SIFT特征
%% 采用230张火灾图训练
dir_name1=('C:\Users\Administrator\Desktop\毕论代码\firepic');%训练火灾图的路径
dir_name='C:\Users\Administrator\Desktop\毕论代码';
% 图 描述子 位置 的保存路径
mkdir([dir_name '\火灾SIFT特征库'],'IMG');
mkdir([dir_name '\火灾SIFT特征库'],'DES');
mkdir([dir_name '\火灾SIFT特征库'],'LOC');
% 生成sift索引
creat_sift_index(dir_name1,dir_name);