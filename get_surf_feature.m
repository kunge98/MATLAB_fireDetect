clear ,clc ,close all
%% ѵ���õ�����ͼ���SURF����
%% ����230�Ż���ͼѵ��
dir_name1=('C:\Users\Administrator\Desktop\���۴���\firepic');%ѵ������ͼ��·��
dir_name='C:\Users\Administrator\Desktop\���۴���';
% ͼ ������ λ�� �ı���·��
mkdir([dir_name '\����SURF������'],'IMG');
mkdir([dir_name '\����SURF������'],'DES');  % SURF ����������

creat_surf_index(dir_name1,dir_name);
