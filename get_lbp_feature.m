clear ,clc ,close all
%% ѵ���õ�����ͼ���LBP����
%% ����230�Ż���ͼѵ��
%% ���ò�������
train_picnum=130;
Feature_num=256;
mydatabase=zeros(train_picnum,Feature_num);
SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
for i=1:train_picnum
   img_filename=sprintf('smoke\\%d.jpg',i);
   %% 
    fprintf('��ȡѵ��ͼ���%d ��ͼ����\n',i);
    img=imread(img_filename);
    img=res(img);% ��ȡ��ȷ���ֲ���
    img=imresize(img,[240,320]);
    [M,N,C]=size(img);
    if C>1
        img=rgb2gray(img);
    end
   T=lbp(img,SP,0,'nh'); 
    mydatabase(i,:)=T;  
end
fprintf('��ȡѵ��ͼ���������\n');
save mydatabase 









