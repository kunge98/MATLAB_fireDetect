clear ,clc ,close all
%% ѵ���õ�����ͼ���SIFT����
%% ����230�Ż���ͼѵ��
dir_name1=('C:\Users\Administrator\Desktop\���۴���\firepic');%ѵ������ͼ��·��
dir_name='C:\Users\Administrator\Desktop\���۴���';
% ͼ ������ λ�� �ı���·��
mkdir([dir_name '\����SIFT������'],'IMG');
mkdir([dir_name '\����SIFT������'],'DES');
mkdir([dir_name '\����SIFT������'],'LOC');
% ����sift����
creat_sift_index(dir_name1,dir_name);