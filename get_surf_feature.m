clear ,clc ,close all
%% 训练得到火灾图库的SURF特征
%% 采用230张火灾图训练
dir_name1=('C:\Users\Administrator\Desktop\毕论代码\firepic');%训练火灾图的路径
dir_name='C:\Users\Administrator\Desktop\毕论代码';
% 图 描述子 位置 的保存路径
mkdir([dir_name '\火灾SURF特征库'],'IMG');
mkdir([dir_name '\火灾SURF特征库'],'DES');  % SURF 特征描述子

creat_surf_index(dir_name1,dir_name);
