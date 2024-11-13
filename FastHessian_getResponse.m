function an=FastHessian_getResponse(a,row, column,b)%计算金字塔图像中每层图滤波器的大小
if(nargin<4)%当输入小于4个时
    scale=1;
else
    scale=fix(a.width/b.width);
end
an=a.responses(fix(scale*row) * a.width + fix(scale*column)+1);
