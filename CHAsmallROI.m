%Wavelet compression after cropping image to remove zero borders

clear all
close all

x=load_nii('Cor3DFSPGRN4.nii');
x=x.img;
mask=load_nii('Cor3DFSPGRMask.nii');
mask=mask.img;
mask=(mask==1);

x=x.*mask;
x=shrink3d(x);

slicedisp(x);

pctg=0.005:0.005:0.5;
n=8;
perf=zeros(length(pctg),2);

for i=1:length(pctg)
    [WR,nnz]=haar3dcomp(x,'pctg',pctg(i),n);
    %normdiff=arrayfun(@(idx) norm(x(:,:,idx)-WR(:,:,idx), 1:size(x,3)));
    %normx=arrayfun(@(idx) normx(:,:,idx), 1:size(x,3));
    perf(i,:)=[nnz,log10(norm(x(:)-WR(:))/norm(x(:)))];
end

%figsize=[100,100,1000,800];
fsize=16;
lsize=3;
%f1=figure('Position',figsize);
%f2=figure('Position',figsize);
%f1=figure;
%f2=figure;

figure;%(f1);
hold all;
plot(perf(:,1),perf(:,2),'LineWidth',lsize);
%title('hard thresh');
%f1legend=legend('Haar','Daubechies','Symlet','Coiflet','Biorthogonal','Curvelet','Location','southeast');
f1xlabel=xlabel('Number of Non-Zero Coefficients','FontSize',fsize);
f1ylabel=ylabel('Log of Normalized L2 Distance','FontSize',fsize);
%set(f1legend,'FontSize',18);
%set(f1xlabel,'FontSize',18);
%set(f1ylabel,'FontSize',18);
set(gca,'FontSize',fsize);