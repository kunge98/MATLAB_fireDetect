%% 获取精确火灾部分
%% 获取230张火灾图的精确火灾部分
picnum=230;
for i=1:picnum
    img_filename=sprintf('firepic\%d.jpg',i);
    fprintf('获取火灾图库第%d 张图特征\n',i);
    img=imread(img_filename);
    img=imresize(img,[240,320]);
    img=res(img); % res的功能：获得hsv+形态学+圆形度过滤后的部分
    imwrite(img,sprintf('respic\%d.jpg',i));
end
fprintf('获取精确火灾部分成功...')