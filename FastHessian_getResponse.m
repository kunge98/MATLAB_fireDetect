function an=FastHessian_getResponse(a,row, column,b)%���������ͼ����ÿ��ͼ�˲����Ĵ�С
if(nargin<4)%������С��4��ʱ
    scale=1;
else
    scale=fix(a.width/b.width);
end
an=a.responses(fix(scale*row) * a.width + fix(scale*column)+1);
