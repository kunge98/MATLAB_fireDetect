%% ��ȡ��ȷ���ֲ���
%% ��ȡ230�Ż���ͼ�ľ�ȷ���ֲ���
picnum=230;
for i=1:picnum
    img_filename=sprintf('firepic\%d.jpg',i);
    fprintf('��ȡ����ͼ���%d ��ͼ����\n',i);
    img=imread(img_filename);
    img=imresize(img,[240,320]);
    img=res(img); % res�Ĺ��ܣ����hsv+��̬ѧ+Բ�ζȹ��˺�Ĳ���
    imwrite(img,sprintf('respic\%d.jpg',i));
end
fprintf('��ȡ��ȷ���ֲ��ֳɹ�...')