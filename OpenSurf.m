%%   opensurf 
function ipts=OpenSurf(img)
% ��������ʼ��
Options=struct('tresh',0.0001,'octaves',5,'init_sample',2,'upright',true,'extended',false,'verbose',false);
%�����Ȥ��
iimg=IntegralImage_IntegralImage(img);
FastHessianData.thresh = Options.tresh;
FastHessianData.octaves = Options.octaves;
FastHessianData.init_sample = Options.init_sample;
FastHessianData.img = iimg;
ipts = FastHessian_getIpoints(FastHessianData,Options.verbose);
% ������Ȥ��
if(~isempty(ipts))
    ipts = SurfDescriptor_DecribeInterestPoints(ipts,Options.upright, Options.extended, iimg, Options.verbose);
end
end