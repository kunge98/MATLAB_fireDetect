clear ,clc ,close all
%% 训练得到火灾图库的LBP特征
%% 采用230张火灾图训练
%% 设置参数部分
train_picnum=130;
Feature_num=256;
mydatabase=zeros(train_picnum,Feature_num);
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
for i=1:train_picnum
   img_filename=sprintf('smoke\\%d.jpg',i);
   %% 
    fprintf('获取训练图库第%d 张图特征\n',i);
    img=imread(img_filename);
    img=res(img);% 获取精确火灾部分
    img=imresize(img,[240,320]);
    [M,N,C]=size(img);
    if C>1
        img=rgb2gray(img);
    end
   T=lbp(img,SP,0,'nh'); 
    mydatabase(i,:)=T;  
end
fprintf('获取训练图库特征完毕\n');
save mydatabase 









