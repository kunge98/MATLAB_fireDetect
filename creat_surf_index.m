%% ����surf����  
 function creat_surf_index(raw_image_path,index_path)
imglist= dir([raw_image_path '\*.jpg']);
listlength=length(imglist);
setwaitbar=waitbar(0,'��ȴ�>>>>>>>>');

for i1=1:listlength
     
    image=imread([[raw_image_path '\'] imglist(i1).name]);
    image1=image;
    image=res(image);
    clc 
    fprintf('zhezzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz%d',i1);
%�����ǻҶ�ͼת��Ϊ�Ҷ�ͼ   
    if ndims(image)==3
        image = rgb2gray(image);
    end
    Ipts=OpenSurf(image);
    
    descriptor=reshape([Ipts.descriptor],64,[]);
    
    filedir=('C:\Users\Administrator\Desktop\���۴���\����SURF������\DES\');
    savepath=strcat(filedir,num2str(i1),'.mat');
    save(savepath,'descriptor');
    
    listname=imglist(i1).name(1:end);
    imwrite(image1,[index_path,'\����SURF������\IMG\',listname]);
    
    jindu=fix(i1/listlength*100);
    waitbar(jindu/100,setwaitbar,['�Ѿ����' num2str(jindu) '%']);

end
delete(setwaitbar);
clear setwaitbar;