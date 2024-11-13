function pic=IntegralImage_IntegralImage(I)%����ͼ��Ԥ����
switch(class(I));
    case 'uint8'
        I=double(I)/255;
    case 'uint16'
        I=double(I)/65535;
    case 'int8'
        I=(double(I)+128)/255;
    case 'int16'
        I=(double(I)+32768)/65535;
    otherwise
        I=double(I);
end
%�Ҷȱ任
if(size(I,3)==3)
	cR = .2989; cG = .5870; cB = .1140;
	I=I(:,:,1)*cR+I(:,:,2)*cG+I(:,:,3)*cB;
end
pic = cumsum(cumsum(I,1),2);%�ۼƺ�
