% Histogram binning of 2D Haar, Daubechies, symlet, coifflet, biorthogonal
% spline, and curvelet bases

function result = cha_hist_bin( image,slice,bins,axes )

%close all;
%clear all;

%x=load_nii('ICBM_grey_white_csf.nii');
%x=x.img(:,:,81);
x=load_nii(image);
x=x.img(:,:,slice);
x=shrink3d(x);

n=8;
w={'haar','db8','sym8','coif5','bior5.5'};

%bins=[-3:0.15:3];
f1=figure;

for j=1:length(w)
    
    [c,l]=wavedec2(x,n,w{j});
    
    c(c<bins(1))=[];
    c(c>bins(end))=[];
    
    figure(f1);
    subplot(2,3,j);
    hold all;
    hAx = gca;
    [hnorm(j,:),cbin(j,:)]=histnorm(c,bins,1);
    laplacefit(j)=fit_ML_laplace(c,bins,hAx,1);
    normalfit(j)=fit_ML_normal(c,bins,hAx,2);
    axis(axes);
    xlabel('Coef. Value');
    ylabel('Relative Frequency'); 
    title([w{j}]);
    
    %laplacefit(j)=fit_ML_laplace(hnorm);
    %normalfit(j)=fit_ML_normal(hnorm);
    
    %laplace_est(j,:) = 1/(2*laplacefit(j).b)*exp(-abs(cbin(j,:)-laplacefit(j).u)/laplacefit(j).b);
    %normal_est(j,:) = sqrt(1/2/pi/normalfit(j).sig2)*exp(-((cbin(j,:)-normalfit(j).u).^2)/(2*normalfit(j).sig2));

    %d_KL(:,j) = [KL_distance(laplace_est(j,:),hnorm(j,:)), KL_distance(normal_est(j,:),hnorm(j,:))];
end

result=struct('laplacefit',laplacefit,'normalfit',normalfit);

%tic;
C = fdct_wrapping(x,0);
%toc;

cfs =[];
for s=1:length(C)
    for w=1:length(C{s})
        cfs = [cfs; abs(C{s}{w}(:))]; 
    end    
end

%figure(f1);
%subplot(2,3,6);
%[hnorm(6,:),cbin]=histnorm(cfs,[-20 -2:0.1:2 20],1);
%axis([-3,3,0,.03]);
%xlabel('Coef. Value');
%ylabel('Relative Frequency'); 
%title('curvelet');