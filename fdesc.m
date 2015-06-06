% Fourier descriptor compression

function [xapprox] = fdesc(x,nb_or_pctg,thr,opt)

if strcmp(nb_or_pctg,'nb')
    nb=thr;
    pctg=nb/length(x(:));
elseif strcmp(nb_or_pctg,'pctg')
    pctg=thr;
    nb=round(pctg*length(x(:)));
end

%close all;
%clear all;

%nb=10000;
%x=load_nii('ICBM_grey_white_csf.nii');
%x=x.img(:,:,81);
linex=edge(x);
[i,j]=find(linex);
s=complex(i,j);
a=fft(s);

if nb>length(a)
    nb=length(a);
end
if strcmp(opt,'ord')
    mask=[ones(nb,1);zeros(length(a)-nb,1)];
    a=a.*mask;
elseif strcmp(opt,'mag')
    cfs=sort(a,'descend');
    cutoff=cfs(nb);
    a=a.*(abs(a)>cutoff);
end

s=ifft(a);
i=round(real(s));
j=round(imag(s));
i=i.*(i>0);
i=i+(i==0);
j=j.*(j>0);
j=j+(j==0);
%mask1=(i>0);
%mask2=(j>0);
%mask3=(round(real(s))<=0);
%mask4=(round(imag(s))<=0);
%s=s.*mask1.*mask2+complex(+mask3,+mask4);

xapprox=zeros(size(x));
for k=1:length(s)
    xapprox(i(k),j(k))=1;
end

%xapprox=sparse(round(real(s)),round(imag(s)),ones(length(s),1),size(x,1),size(x,2));
%xapprox=full(xapprox);

figure;
imagesc(x);
figure;
imagesc(xapprox);
